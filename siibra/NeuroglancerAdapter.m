%% STEP 1: INHERIT FROM ADAPTER CLASS
classdef NeuroglancerAdapter < images.blocked.Adapter
    
    properties
        uri (1,1) string
        Info (1,1) struct
        level_key string
    end    
    
%% STEP 2: DEFINE REQUIRED METHODS
    methods
        
        % Define the openToRead method
        function openToRead(obj,source)
            obj.uri = source;
        end

        % Define the getInfo method      
        function info = getInfo(obj)
            
            % Read  info
            import matlab.net.*
            import matlab.net.http.*
            import matlab.net.http.io.*
            json_accept = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField([json_accept]);
            header = [acceptField];
            method = matlab.net.http.RequestMethod.GET;
            request = matlab.net.http.RequestMessage(method,header);
            options = HTTPOptions;
            consumer = JSONConsumer;
            resp = send(request,URI(append(obj.uri, "info")), options, consumer);
            fetched_info = resp.Body.Data;
            
            levels = numel(fetched_info.scales);
            obj.level_key = strings(levels, 1);
            for level = 1:levels
                obj.Info.Size(level, :) = fetched_info.scales(level).size([2 1 3]);
                obj.Info.IOBlockSize(level, :) = fetched_info.scales(level).chunk_sizes([2 1 3]);
                obj.level_key(level) = string(fetched_info.scales(level).key);
            end
            obj.Info.Datatype = strings(levels, 1);
            obj.Info.Datatype(:) = fetched_info.data_type;
            obj.Info.InitialValue = cast(0,obj.Info.Datatype(1));
            info = obj.Info;
        end

        
        function block = getIOBlock(obj,ioblockSub,level)
            import matlab.net.*
            import matlab.net.http.*
            level_str = obj.level_key(level);
            pixel_start_offset = (ioblockSub - 1) .* obj.Info.IOBlockSize(level);
            pixel_end_offset = min(ioblockSub .* obj.Info.IOBlockSize(level), obj.Info.Size(level));
            offsets = [pixel_start_offset; pixel_end_offset];
            offsets = offsets(:).';
            
            block_str = sprintf("%d-%d_%d-%d_%d-%d", offsets);
            uri = URI(append(obj.uri,level_str, "/", block_str));
            %disp(uri.EncodedPath);
            % request data
            r = RequestMessage;
            resp = send(r,uri);
            chunk_size = obj.Info.IOBlockSize(level, :);
            
            reshaped_data = reshape(resp.Body.Data, chunk_size);
            block = reshaped_data;
        end

    end
end