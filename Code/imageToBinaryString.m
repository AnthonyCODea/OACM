function binaryString = imageToBinaryString(im)
%     binaryString="";
%     numRows = size(im,1);
%     numCols = size(im,2);
%     numLayers = size(im,3);
%     
%     for row = 1:numRows
%         for col = 1:numCols
%             for layer = 1:numLayers
%                 %binaryString=strcat(binaryString,strrep(num2str(bitget(im(row,col,layer),8:-1:1,"uint8")),' ',''));
%                 binaryString=strcat(binaryString,dec2bin(im(row,col,layer),8));
%             end
%         end
%     end
% 
    binaryString= strjoin(string(dec2bin(im,8)),'');
end 