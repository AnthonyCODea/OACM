function outputImage = FastACMAsScan(fastPathCellArray,inputImage,numIters)
    outputImage = inputImage;
    
    for col = 1:size(fastPathCellArray,2)
        for row = 1:size(fastPathCellArray,1)
            cellSize = size(fastPathCellArray{row,col},2);
            if cellSize == 0
                continue;
            else
                currentLocs = fastPathCellArray{row,col};
                indeces = linspace(1,cellSize,cellSize);
                newIndeces = indeces(1+mod((-1+numIters+indeces),cellSize));
                futureLocs = fastPathCellArray{row,col}(newIndeces);
                outputImage(futureLocs) = inputImage(currentLocs);
            end
        end
    end

end