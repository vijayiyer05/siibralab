classdef API
    % The API class holds all the api calls in one place
    
    properties (Constant=true)
        Endpoint = "https://siibra-api-stable.apps.hbp.eu/v1_0/"
    end

    methods (Static)
        function link = absoluteLink(relativeLink)
            link = siibra.internal.API.Endpoint + relativeLink;
        end
        function result = doWebreadWithLongTimeout(absoluteLink)
            options = weboptions;
            options.Timeout = 30;
            result = webread( ...
                absoluteLink, ...
                options);
        end
        function result = doWebsaveWithLongTimeout(path, absoluteLink)
            options = weboptions;
            options.Timeout = 30;
            result = websave( ...
                path, ...
                absoluteLink, ...
                options);
        end
        function atlases = atlases()
            absoluteLink = siibra.internal.API.absoluteLink("atlases"); 
            atlases = siibra.internal.API.doWebreadWithLongTimeout( ...
                absoluteLink);
        end
        function absoluteLink = regionInfoForSpace(atlasId, parcellationId, regionName, spaceId)
            relativeLink = strcat( ...
            "atlases/", atlasId, ...
            "/parcellations/", parcellationId, ...
            "/regions/", regionName, ...
            "?space_id=", spaceId ...
            );
            absoluteLink = siibra.internal.API.absoluteLink(relativeLink);
        end
        
        function absoluteLink = regionMap(atlasId, parcellationId, regionName, spaceId, mapOrInfo, mapType)
            relativeLink = strcat( ...
                "atlases/", atlasId, ...
                "/parcellations/", parcellationId,...
                "/regions/", regionName, ...
                "/regional_map/", mapOrInfo, ...
                "?space_id=", spaceId, ...
                "&map_type=", mapType);
            absoluteLink = siibra.internal.API.absoluteLink(relativeLink);
        end
        
        function absoluteLink = parcellationMap(atlasId, spaceId, parcellationId)
            relativeLink = strcat( ...
                "atlases/", atlasId, ...
                "/spaces/", spaceId, ...
                "/parcellation_maps?parcellation_id=", parcellationId);
            absoluteLink = siibra.internal.API.absoluteLink(relativeLink); 
        end
    end
    
end

