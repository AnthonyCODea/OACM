function outPutMatrix = fullDecryption4(im,setP,setQ,setSqSize,setOverlap,setIters,hashP,hashQ,hashSqSize,hashOverlap,hashIters)
%where im is a uint8 greyscale image

numRows=size(im,1);
numCols=size(im,2);
index = 1;
indexMatrix = zeros(numRows,numCols);
for col = 1:numCols
    for row = 1:numRows
        indexMatrix(row,col) = index;
        index = index + 1;
    end
end

pathCellArray = OACMFastPath(numCols,numRows,hashSqSize,hashOverlap,hashP,hashQ);
mappingMatrix = FastACMAsScan(pathCellArray,indexMatrix,hashIters);
%outPutMatrix = mod(double(im)-mappingMatrix,256);
outPutMatrix = im;
mappingBinary = arrayfun(@(x) bitget(x,8:-1:1),mappingMatrix,'UniformOutput',false);
outPutBinary = arrayfun(@(x) bitget(x,8:-1:1),outPutMatrix,'UniformOutput',false);
outPutBinary = cellfun(@xor,mappingBinary,outPutBinary,'UniformOutput',false);
outPutMatrix = cell2mat(cellfun(@(x) bit2int(x',8),outPutBinary,'UniformOutput',false));

pathCellArray = OACMFastPath(numCols,numRows,setSqSize,setOverlap,setP,setQ);
outPutMatrix = FastACMAsScan(pathCellArray,outPutMatrix,-setIters);

return