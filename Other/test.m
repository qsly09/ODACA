%% Below codes to check the change object inputs of ODACA

folder_input = '/lustre/scratch/qiu25856/ProjectCONUSDisturbanceAgent/CONUS_DisturbanceAgent_Version1/h022v014/ChangeOjbectInput';
filename = 'record_objs_1989';

fileobj = dir(fullfile(folder_input, [filename, '*']));

data_v1 = [];
data_v2 = [];
for ifile = 1: length(fileobj)
    load(fullfile(folder_input, fileobj(ifile).name));
    if length(fileobj(ifile).name) == 20 % old version, one .mat, all data inputs
        data_v1 = record_objs;
    else % new version, multiple .mat files to store the inputs
        data_v2 = [data_v2, record_objs];
    end
end