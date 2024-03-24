function outPutMatrix = fullEncryption4(im,setP,setQ,setSqSize,setOverlap,setIters,hashP,hashQ,hashSqSize,hashOverlap,hashIters)
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

%arrayfun(@(x) sum(bitget(x,1:8)),[1 2 7 6])

pathCellArray = OACMFastPath(numCols,numRows,setSqSize,setOverlap,setP,setQ);
outPutMatrix = FastACMAsScan(pathCellArray,im,setIters);

pathCellArray = OACMFastPath(numCols,numRows,hashSqSize,hashOverlap,hashP,hashQ);
mappingMatrix = FastACMAsScan(pathCellArray,indexMatrix,hashIters);
mappingMatrix = mod(mappingMatrix,256);
%mappingBinary = dec2bin(mappingMatrix,8);
%outPutBinary = dec2bin(outPutMatrix,8);
mappingBinary = arrayfun(@(x) bitget(x,8:-1:1),mappingMatrix,'UniformOutput',false);
outPutBinary = arrayfun(@(x) bitget(x,8:-1:1),outPutMatrix,'UniformOutput',false);
outPutBinary = cellfun(@xor,mappingBinary,outPutBinary,'UniformOutput',false);
outPutMatrix = cell2mat(cellfun(@(x) bit2int(x',8),outPutBinary,'UniformOutput',false));
%outPutBinary = xor(mappingBinary,outPutBinary);
%outPutMatrix = reshape(bin2dec(outPutBinary),numRows,numCols);

return