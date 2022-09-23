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
    
%     path_obj = fullfile(path_result_odaca, hv_name, odacasets.YearlyODACAInputs);
%     path_mat = fullfile(path_obj, ['record_objs_', num2str(yr), '_%010d_%010d.mat']);
    
%     folderpath_old = fullfile(odacasets.pathResultODACA, tile, odacasets.YearlyODACAInputs, 'record_objs_*.mat');
%     filepath = dir(folderpath_old);
%     for ifile = 1: length(filepath)
%         % conditions to exclude files
%         if length(filepath(ifile).name) > 20
%             continue;
%         end
%         % start to delete the file
%         pathdele = fullfile(filepath(ifile).folder, filepath(ifile).name);
%         delete(pathdele);
%         fprintf('Finished deleting %s\r', pathdele);
%     end
     try
%             folderTrainingSamples = 'TrainingSampleObjects'; % sample objects saved in MATLAB format, version 01
%             folderTrainingSamplePixel = 'TrainingSamplePixels';
%             folderTrainingSampleModelReady = 'TrainingSampleModelReady'

%         folerpath_old = fullfile(odacasets.pathResultODACA, tile, 'TrainingData', 'Harvest_LandCoverTrends');
%         for ifolder = 1:1 % 28
%             try
                folerpath_old = fullfile(odacasets.pathResultODACA, tile, ...
                    'TrainingData', ...
                    'RandomForestModel');
                folerpath_old = fullfile(odacasets.pathResultODACA, tile, 'ChangeCoeffs');
%     
% %             folerpath_old = fullfile(odacasets.pathResultODACA, tile, 'TrainingData', ['TrainingSampleObjects_NoPlanting', num2str(ifolder)]);
%         %     folerpath_old = fullfile(odacasets.pathResultODACA, tile, odacasets.folderYearlyCOLDDisturbanceMapObject);
            rmdir(folerpath_old, 's');
            fprintf('Finished deleting %s\r', folerpath_old);
%             catch
%             end
%         end
     catch
     end
    
end