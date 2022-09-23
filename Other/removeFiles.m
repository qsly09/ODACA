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
    

    folerpath_old = fullfile(odacasets.pathResultODACA, tile, 'TrainingData', 'TrainingSampleObjects');
    folerpath_old = fullfile(odacasets.pathResultODACA, tile, 'TrainingData', 'TrainingSamplePixels');
%     folerpath_old = fullfile(odacasets.pathResultODACA, tile, 'TrainingData', 'TrainingSampleModelReady');
    files = dir(fullfile(folerpath_old, 'record_samples_other*.mat')); % record_samples_other_2004_0000013901_0000015634_0000000002.mat
    for j = 1: length(files)
        folerpath_old = fullfile(files(j).folder, files(j).name);
                    delete(folerpath_old);
                    fprintf('Finished deleting %s\r', folerpath_old);
    end
    
end