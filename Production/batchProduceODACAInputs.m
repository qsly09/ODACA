function batchProduceODACAInputs(jobid, jobnum)
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
% batchCreateODACAInput(jobid, jobnum, {'odacainput'}, ARDTiles); % Change input for ODACA
% batchCreateODACAInput(jobid, jobnum, {'downsample'}, ARDTiles); % Change downsampling objects for ODACA, 100G
batchCreateODACAInput(jobid, jobnum, {'downsamplepixel'}, ARDTiles); % Change downsampling pixels for ODACA, 20G


end
