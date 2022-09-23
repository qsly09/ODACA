function rands = randpermDynamic(totalnum, randnum)
%RANDPERMDYNAMIC is 
% If you want to avoid repeating the same random number arrays when MATLAB restarts, then execute the command,
rng('shuffle');
rands = randperm(totalnum, min(totalnum, randnum));
end

