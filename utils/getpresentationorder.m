function [stimnumbers,categorylabs] = getpresentationorder(numStim,numBlocks,labels)


stimnumbers = [];
for i=1:numBlocks
    stimnumbers = cat(2,stimnumbers,randperm(numStim));
end

categorylabs = labels(stimnumbers,:);

