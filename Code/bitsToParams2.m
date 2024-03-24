function [numIters,sqSize,overlap,p,q] = bitsToParams2(bitString,numRows,numCols)
    smallerDim = min(numRows,numCols);
    %numIters = bin2dec(extractBetween(bitString,1,216));
   % numIters = cell2mat(bin2num(quantizer([216 0]),bitxor(convertStringsToChars(extractBetween(bitString,161,208))=='1',convertStringsToChars(extractBetween(bitString,209,256))=='1')));
    numIters = (bin2num(quantizer([216 0]),bitxor(convertStringsToChars(extractBetween(bitString,161,208))=='1',convertStringsToChars(extractBetween(bitString,209,256))=='1')));
   numIters = bin2dec(strjoin(string(double(numIters))));
    FS = bitxor(bitxor(bitxor(convertStringsToChars(extractBetween(bitString,1,10))=='1',convertStringsToChars(extractBetween(bitString,11,20))=='1'),convertStringsToChars(extractBetween(bitString,21,30))=='1'),convertStringsToChars(extractBetween(bitString,31,40))=='1');
    FS = double(bin2dec(strjoin(string(double(FS)))))/1023;
    FP = bitxor(bitxor(bitxor(convertStringsToChars(extractBetween(bitString,41,50))=='1',convertStringsToChars(extractBetween(bitString,51,60))=='1'),convertStringsToChars(extractBetween(bitString,61,70))=='1'),convertStringsToChars(extractBetween(bitString,71,80))=='1');
    FP = double(bin2dec(strjoin(string(double(FP)))))/1023;
    FQ = bitxor(bitxor(bitxor(convertStringsToChars(extractBetween(bitString,81,90))=='1',convertStringsToChars(extractBetween(bitString,91,100))=='1'),convertStringsToChars(extractBetween(bitString,101,110))=='1'),convertStringsToChars(extractBetween(bitString,111,120))=='1');
    FQ = double(bin2dec(strjoin(string(double(FQ)))))/1023;
    FO = bitxor(bitxor(bitxor(convertStringsToChars(extractBetween(bitString,121,130))=='1',convertStringsToChars(extractBetween(bitString,131,140))=='1'),convertStringsToChars(extractBetween(bitString,141,150))=='1'),convertStringsToChars(extractBetween(bitString,151,160))=='1');
    FO = double(bin2dec(strjoin(string(double(FO)))))/1023;
    sqSize = floor(FS*(smallerDim-10))+10;
    q = floor(FQ*(sqSize-1))+1;
    p = floor(FP*(sqSize-1))+1;
    higherMin=max(1,2*sqSize-smallerDim);
    overlap=floor(FO*(sqSize-higherMin))+higherMin-1;
    %valsArray = [numIters sqSize overlap p q];
   
return