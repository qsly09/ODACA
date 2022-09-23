function [taskids] = assignTasks(tasks, jobID, jobNum)
%ASSIGNTASKS is to assign tasks, according to the number of jobs
    taskids = [];
    for i = jobID: jobNum: length(tasks)
        taskids = [taskids, i];
    end
end

