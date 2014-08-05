function blockaccuracy= returnblocks(trainingvector,blocksize)

if any(size(trainingvector)==1)
    blockaccuracy = mean(reshape(trainingvector,blocksize,[]));
else error('attempting to block aggregate a matrix')
end

