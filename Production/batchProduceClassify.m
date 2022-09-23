function batchProduceClassify(jobid, jobnum)
%batchProduce is to produce land disturbance agent product for CONUS

%% Add code paths
pathpackage = fileparts(fileparts(mfilename('fullpath'))); 
addpath(pathpackage); % add ODACA's parent folder
addpath(fullfile(pathpackage, 'Shared')); % add the <Shared>
addpath(fullfile(pathpackage, 'Classification')); % add the <Classification>

if ~exist('jobid', 'var')
    jobid = 1;
end

if ~exist('jobnum', 'var')
    jobnum = 1;
end

ARDTiles = odacasets.ARDTiles;

objtasks = [];

for iARD = 1: length(ARDTiles) % loop ARD to assign different tile to different cores, that will fully use all the computing resources
    ic = length(objtasks) + 1;
    objtasks(ic).tile = ARDTiles{iARD}; 
end
rng(1);
objtasks = objtasks(randperm(length(objtasks)));
[taskids] = assignTasks(objtasks, jobid, jobnum);
    
%% Process each task
for itask = taskids
    taskobj = objtasks(itask);
    tile = taskobj.tile;
  
    batchClassify(1, 1, tile, false); %50G for safe
end




end
