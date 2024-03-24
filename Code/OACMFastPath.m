function outputCellArray = OACMFastPath(width,height,squareSize,overlap,P,Q)

    startPointRows = []; startPointCols = [];
    for i = 1:height-squareSize
     if mod(i-1,squareSize-overlap)==0
        startPointRows(end+1) = i;
     end
    end
    startPointRows(end+1)=height-squareSize+1;
    for i = 1:width-squareSize
     if mod(i-1,squareSize-overlap)==0
        startPointCols(end+1) = i;
     end
    end
    startPointCols(end+1)=width-squareSize+1;
    
    outputCellArray = cell(height,width);
    initial = zeros(height,width);
    checkedAlreadyTable = initial;
    index = 1;
    
    for col = 1:width
        for row = 1:height
            initial(row,col) = index;
            index = index + 1;
        end
    end
    picture = initial;
    
    for rowIndex = 1:size(startPointRows,2)
        for colIndex = 1:size(startPointCols,2)
            row = startPointRows(rowIndex);
            col = startPointCols(colIndex);
            picture(row:row+squareSize-1,col:col+squareSize-1)=ACMGenOperator2(picture(row:row+squareSize-1,col:col+squareSize-1),P,Q);
        end
    end
    
    for row = 1:height
        for col = 1:width
             currentPixel = picture(row,col);
             if checkedAlreadyTable(row,col) == 1
                continue
             end
             checkedAlreadyTable(currentPixel) = 1;
             outputCellArray{row,col} = [outputCellArray{row,col},currentPixel];
             while currentPixel ~= initial(row,col)
                currentPixel=picture(currentPixel);
                checkedAlreadyTable(currentPixel) = 1;
                outputCellArray{row,col} = [outputCellArray{row,col},currentPixel];
             end
        end
    end

return