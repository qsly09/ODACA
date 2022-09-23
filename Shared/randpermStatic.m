function rands = randpermStatic(totalnum, randnum)
%RANDPERMSTATIC Summary of this function goes here
%   Detailed explanation goes here
rng(1);
rands = randperm(totalnum, min(totalnum, randnum));
end

