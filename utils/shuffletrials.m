function [out] = shuffletrials(N,blocks)

out = [];
for i=1:blocks
	out = cat(2,out,randperm(N));
end

