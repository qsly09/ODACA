%% Add code paths
pathpackage = fileparts(fileparts(mfilename('fullpath'))); 
addpath(pathpackage); % add ODACA's parent folder
addpath(fullfile(pathpackage, 'Shared')); % add the <Shared>
addpath(fullfile(pathpackage, 'Other')); % add the <Other>


%% ARD tiles' list
ARDTiles = odacasets.ARDTiles; % to read central tiles
ARDTiles = getAdjacentARDTiles(ARDTiles); % to add neighbor tiles

%% Loop ARD tile
for iard = 1: length(ARDTiles)
    tile = ARDTiles{iard};
    folderpath_old = fullfile(odacasets.pathResultODACA, tile, odacasets.folderTrainingData, 'TrainingLandFire/');
    if isfolder(folderpath_old)
        folderpath_new = fullfile(odacasets.pathResultODACA, tile, odacasets.folderTrainingData, [odacasets.folderTrainingDataLF, '/']);
        movefile(folderpath_old, folderpath_new);
    end
end