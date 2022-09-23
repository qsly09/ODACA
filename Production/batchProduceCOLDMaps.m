function batchProduceCOLDMaps(jobid, jobnum)
%batchProduce is to produce land disturbance agent product for CONUS

%% Add code paths
pathpackage = fileparts(fileparts(mfilename('fullpath'))); 
addpath(pathpackage); % add ODACA's parent folder
addpath(fullfile(pathpackage, 'Shared')); % add the <Shared>
addpath(fullfile(pathpackage, 'CreateODACAInput')); % add the <CreateODACAInput>

if ~exist('jobid', 'var')
    jobid = 1;
end

if ~exist('jobnum', 'var')
    jobnum = 1;
end

ARDTiles = odacasets.ARDTiles;

%% Create inputs of ODACA
batchCreateODACAInput(jobid, jobnum, {'dem'}, ARDTiles); % DEM
batchCreateODACAInput(jobid, jobnum, {'changeobject'}, ARDTiles); % Object map
batchCreateODACAInput(jobid, jobnum, {'changefrequency'}, ARDTiles); % Frequency map
% batchCreateODACAInput(jobid, jobnum, {'odacainput'}, ARDTiles); % Change objects for ODACA


end
