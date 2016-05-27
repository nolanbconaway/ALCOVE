function [out] = shuffletrials(N,blocks)
% -------------------------------------------------------------------------
% this script concatenates random permutations of items 1:N. Imagining 
% N to be the total unique trials within a block, and blocks to be the
% number of times each trial is repeated in the experiment, this script
% generates a random trial order such that each trial is completed before
% any are repeated.
% 
% INPUT ARGUMENTS:
%	N: number of unique trials
%	blocks: number of times each trial is repeated
% 
% USAGE:
% shuffletrials(4,2)
% 
% ans =
%      4     3     1     2     3     4     1     2
% 
% shuffletrials(5,2)
% 
% % ans =
%      4     2     3     5     1     1     3     4     2     5
% -------------------------------------------------------------------------

out = [];
for i=1:blocks
	out = cat(2,out,randperm(N));
end

end