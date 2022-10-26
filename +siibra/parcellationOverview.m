function overviewTable = parcellationOverview()
parcellations = siibra.viewParcellations();
overviewTable = table([parcellations.Name].', arrayfun(@(a) a.Name, [parcellations.Atlas]).', [parcellations.Modality].', [cellfun(@numel, {parcellations.Spaces})].', 'VariableNames', ["Parcellation", "Atlas", "Modality", "Number of Spaces"]);
end

