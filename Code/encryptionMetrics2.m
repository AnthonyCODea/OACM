function [UACIMatrix,NPCRMatrix,horVertArray,hashParams,hashParamsBitOff,greyImHash,greyImBitOffHash] = encryptionMetrics2(fileName,P,Q,sqSize,overlap,iters,saveHeader)
%greyIm,cipherIm,cipherImBitOff,cipherImPOff,cipherImOverOff,cipherImSizeOff,decImIterOff,decImPOff,decImOverOff,decImSizeOff,decImNormal,
%"C:\Users\antho\Desktop\Source Images\256SquareSquirrel.jpg"
%"C:\Users\antho\Desktop\Source Images\Rabbit384to256.png"
%"C:\Users\antho\Desktop\Source Images\mandrill.png"

image = imread(fileName);
filePath = "C:\Users\antho\Desktop\ACM\Actual Figures\"+saveHeader;
greyIm = uint8(mean(image,3)); 
numRows=size(greyIm,1);
numCols=size(greyIm,2);
numPix=numRows*numCols;
origin = greyIm(1,1);
if origin ~= 255
    bitOffOrigin=origin+1;
else 
    bitOffOrigin=origin-1;
end

greyImBitOff = greyIm;
greyImBitOff(1,1) = bitOffOrigin;

tic
greyImBits = imageToBinaryString(greyIm);
greyImBitOffBits = imageToBinaryString(greyImBitOff);
greyImHash = sha256BitsToBits(greyImBits);
greyImBitOffHash = sha256BitsToBits(greyImBitOffBits);
toc
tic

[hashIters,hashSqSize,hashOverlap,hashP,hashQ] = bitsToParams2(convertCharsToStrings(greyImHash),numRows,numCols);
hashParams = [hashIters hashSqSize hashOverlap hashP hashQ];
[hashItersBitOff,hashSqSizeBitOff,hashOverlapBitOff,hashPBitOff,hashQBitOff] = bitsToParams2(convertCharsToStrings(greyImBitOffHash),numRows,numCols);
hashParamsBitOff = [hashItersBitOff hashSqSizeBitOff hashOverlapBitOff hashPBitOff hashQBitOff];
toc

tic
cipherIm = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImIterOff = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters+1,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImPOff = fullEncryption4(greyIm,P+1,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImQOff = fullEncryption4(greyIm,P,Q+1,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImOverOff = fullEncryption4(greyIm,P,Q,sqSize,overlap+1,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImSizeOff = fullEncryption4(greyIm,P,Q,sqSize+1,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImBitOff = fullEncryption4(greyImBitOff,P,Q,sqSize,overlap,iters,hashPBitOff,hashQBitOff,hashSqSizeBitOff,hashOverlapBitOff,hashItersBitOff);
toc 
tic
decImIterOff = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters+1,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
decImPOff = fullDecryption4(cipherIm,P+1,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
decImQOff = fullDecryption4(cipherIm,P,Q+1,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
decImOverOff = fullDecryption4(cipherIm,P,Q,sqSize,overlap+1,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
decImSizeOff = fullDecryption4(cipherIm,P,Q,sqSize+1,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
decImNormal = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters);
toc
isequal(greyIm,uint8(decImNormal))

tic
cipherImIterOffHash = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters+1);
cipherImPOffHash = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters,hashP+1,hashQ,hashSqSize,hashOverlap,hashIters);
cipherImQOffHash = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters,hashP,hashQ+1,hashSqSize,hashOverlap,hashIters);
cipherImOverOffHash = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap+1,hashIters);
cipherImSizeOffHash = fullEncryption4(greyIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize+1,hashOverlap,hashIters);
toc 
tic
decImIterOffHash = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap,hashIters+1);
decImPOffHash = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters,hashP+1,hashQ,hashSqSize,hashOverlap,hashIters);
decImQOffHash = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters,hashP,hashQ+1,hashSqSize,hashOverlap,hashIters);
decImOverOffHash = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize,hashOverlap+1,hashIters);
decImSizeOffHash = fullDecryption4(cipherIm,P,Q,sqSize,overlap,iters,hashP,hashQ,hashSqSize+1,hashOverlap,hashIters);
toc

doubleCheck = isequal(decImIterOffHash,cipherImIterOffHash)
imwrite(decImIterOffHash,"C:\Users\antho\Desktop\Source Images\test1.png")
imwrite(cipherImIterOffHash,"C:\Users\antho\Desktop\Source Images\test1.png")

figure(1)
imhist(greyIm,256);
set(gcf,'Units','inches','Position',[2 2 5 5])
axis([0 255 0 inf])
saveas(gcf,filePath+"PlainHist.png");
saveas(gcf,filePath+"PlainHist.fig");
figure(2)
imhist(uint8(cipherIm),256);
set(gcf,'Units','inches','Position',[2 2 5 5])
xlim([0 inf])
saveas(gcf,filePath+"CiphHist.png");
saveas(gcf,filePath+"CiphHist.fig");

NPCR = sum(~(cipherImBitOff==cipherIm),'all')/(numRows*numCols);
UACI = sum(abs(cipherIm-cipherImBitOff),"all")/(255*numCols*numRows);
NPCRIterOff = sum(~(cipherImIterOff==cipherIm),'all')/(numRows*numCols);
UACIIterOff = sum(abs(cipherIm-cipherImIterOff),"all")/(255*numCols*numRows);
NPCRPOff = sum(~(cipherImPOff==cipherIm),'all')/(numRows*numCols);
UACIPOff = sum(abs(cipherIm-cipherImPOff),"all")/(255*numCols*numRows);
NPCRQOff = sum(~(cipherImQOff==cipherIm),'all')/(numRows*numCols);
UACIQOff = sum(abs(cipherIm-cipherImQOff),"all")/(255*numCols*numRows);
NPCROverOff = sum(~(cipherImOverOff==cipherIm),'all')/(numRows*numCols);
UACIOverOff = sum(abs(cipherIm-cipherImOverOff),"all")/(255*numCols*numRows);
NPCRSizeOff = sum(~(cipherImSizeOff==cipherIm),'all')/(numRows*numCols);
UACISizeOff = sum(abs(cipherIm-cipherImSizeOff),"all")/(255*numCols*numRows);

NPCRIterOffHash = sum(~(cipherImIterOffHash==cipherIm),'all')/(numRows*numCols);
UACIIterOffHash = sum(abs(cipherIm-cipherImIterOffHash),"all")/(255*numCols*numRows);
NPCRPOffHash = sum(~(cipherImPOffHash==cipherIm),'all')/(numRows*numCols);
UACIPOffHash = sum(abs(cipherIm-cipherImPOffHash),"all")/(255*numCols*numRows);
NPCRQOffHash = sum(~(cipherImQOffHash==cipherIm),'all')/(numRows*numCols);
UACIQOffHash = sum(abs(cipherIm-cipherImQOffHash),"all")/(255*numCols*numRows);
NPCROverOffHash = sum(~(cipherImOverOffHash==cipherIm),'all')/(numRows*numCols);
UACIOverOffHash = sum(abs(cipherIm-cipherImOverOffHash),"all")/(255*numCols*numRows);
NPCRSizeOffHash = sum(~(cipherImSizeOffHash==cipherIm),'all')/(numRows*numCols);
UACISizeOffHash = sum(abs(cipherIm-cipherImSizeOffHash),"all")/(255*numCols*numRows);

NPCRIterOffDec = sum(~(decImIterOff==greyIm),'all')/(numRows*numCols);
UACIIterOffDec = sum(abs(double(greyIm)-decImIterOff),"all")/(255*numCols*numRows);
NPCRPOffDec = sum(~(decImPOff==greyIm),'all')/(numRows*numCols);
UACIPOffDec = sum(abs(double(greyIm)-decImPOff),"all")/(255*numCols*numRows);
NPCRQOffDec = sum(~(decImQOff==greyIm),'all')/(numRows*numCols);
UACIQOffDec = sum(abs(double(greyIm)-decImQOff),"all")/(255*numCols*numRows);
NPCROverOffDec = sum(~(decImOverOff==greyIm),'all')/(numRows*numCols);
UACIOverOffDec = sum(abs(double(greyIm)-decImOverOff),"all")/(255*numCols*numRows);
NPCRSizeOffDec = sum(~(decImSizeOff==greyIm),'all')/(numRows*numCols);
UACISizeOffDec = sum(abs(double(greyIm)-decImSizeOff),"all")/(255*numCols*numRows);

NPCRIterOffDecHash = sum(~(decImIterOffHash==greyIm),'all')/(numRows*numCols);
UACIIterOffDecHash = sum(abs(double(greyIm)-decImIterOffHash),"all")/(255*numCols*numRows);
NPCRPOffDecHash = sum(~(decImPOffHash==greyIm),'all')/(numRows*numCols);
UACIPOffDecHash = sum(abs(double(greyIm)-decImPOffHash),"all")/(255*numCols*numRows);
NPCRQOffDecHash = sum(~(decImQOffHash==greyIm),'all')/(numRows*numCols);
UACIQOffDecHash = sum(abs(double(greyIm)-decImQOffHash),"all")/(255*numCols*numRows);
NPCROverOffDecHash = sum(~(decImOverOffHash==greyIm),'all')/(numRows*numCols);
UACIOverOffDecHash = sum(abs(double(greyIm)-decImOverOffHash),"all")/(255*numCols*numRows);
NPCRSizeOffDecHash = sum(~(decImSizeOffHash==greyIm),'all')/(numRows*numCols);
UACISizeOffDecHash = sum(abs(double(greyIm)-decImSizeOffHash),"all")/(255*numCols*numRows);

NPCRMatrix = [NPCR NPCRIterOff NPCRPOff NPCRQOff NPCROverOff NPCRSizeOff NPCRIterOffDec NPCRPOffDec NPCRQOffDec  NPCROverOffDec NPCRSizeOffDec NPCRIterOffHash NPCRPOffHash NPCRQOffHash NPCROverOffHash NPCRSizeOffHash NPCRIterOffDecHash  NPCRPOffDecHash NPCRQOffDecHash NPCROverOffDecHash NPCRSizeOffDecHash];
UACIMatrix = [UACI UACIIterOff UACIPOff UACIQOff UACIOverOff UACISizeOff UACIIterOffDec UACIPOffDec UACIQOffDec UACIOverOffDec UACISizeOffDec UACIIterOffHash UACIPOffHash UACIQOffHash UACIOverOffHash UACISizeOffHash UACIIterOffDecHash UACIPOffDecHash  UACIQOffDecHash UACIOverOffDecHash UACISizeOffDecHash];

plainPix1 = greyIm(1:numRows-1,1:numCols); plainMean1=mean(double(plainPix1),'all'); plainDif1 = plainPix1-plainMean1;
plainPix2 = greyIm(2:numRows,1:numCols); plainMean2=mean(double(plainPix2),'all'); plainDif2 = plainPix2-plainMean2;
plainPix3 = greyIm(1:numRows,1:numCols-1); plainMean3=mean(double(plainPix3),'all'); plainDif3 = plainPix3-plainMean3;
plainPix4 = greyIm(1:numRows,2:numCols); plainMean4=mean(double(plainPix4),'all'); plainDif4 = plainPix4-plainMean4;

plainVert = sum(plainDif1.*plainDif2,'all')/((numPix)*sqrt(sum(plainDif1.^2,'all')*sum(plainDif2.^2,'all')*(1/(numPix)^2)));
plainHor = sum(plainDif3.*plainDif4,'all')/((numPix)*sqrt(sum(plainDif3.^2,'all')*sum(plainDif4.^2,'all')*(1/(numPix)^2)));
%plainHor2 = sum(plainDif1.*plainDif2,'all')/(sqrt(sum(plainDif1.^2,'all')*sum(plainDif2.^2,'all')));
%plainVert2 = sum(plainDif3.*plainDif4,'all')/(sqrt(sum(plainDif3.^2,'all')*sum(plainDif4.^2,'all')));

ciphPix1 = cipherIm(1:numRows-1,1:numCols); ciphMean1=mean(double(ciphPix1),'all'); ciphDif1 = ciphPix1-ciphMean1;
ciphPix2 = cipherIm(2:numRows,1:numCols); ciphMean2=mean(double(ciphPix2),'all'); ciphDif2 = ciphPix2-ciphMean2;
ciphPix3 = cipherIm(1:numRows,1:numCols-1); ciphMean3=mean(double(ciphPix3),'all'); ciphDif3 = ciphPix3-ciphMean3;
ciphPix4 = cipherIm(1:numRows,2:numCols); ciphMean4=mean(double(ciphPix4),'all'); ciphDif4 = ciphPix4-ciphMean4;

ciphVert = sum(ciphDif1.*ciphDif2,'all')/((numPix)*sqrt(sum(ciphDif1.^2,'all')*sum(ciphDif2.^2,'all')*(1/(numPix)^2)));
ciphHor = sum(ciphDif3.*ciphDif4,'all')/((numPix)*sqrt(sum(ciphDif3.^2,'all')*sum(ciphDif4.^2,'all')*(1/(numPix)^2)));

horVertArray = [plainHor plainVert ciphHor ciphVert];

rand7 = randperm(size(plainPix1,1)*size(plainPix1,2),5000);
figure(7) %vert
scatter(plainPix1(rand7),plainPix2(rand7),'filled')
set(gcf,'Units','inches','Position',[2 2 5 5])
xlim([0 255])
ylim([0 255])
saveas(gcf,filePath+"PlainVert.png");
saveas(gcf,filePath+"PlainVert.fig");
figure(8) %hor
rand8 = randperm(size(plainPix3,1)*size(plainPix3,2),5000);
scatter(plainPix3(rand8),plainPix4(rand8),'filled')
set(gcf,'Units','inches','Position',[2 2 5 5])
xlim([0 255])
ylim([0 255])
saveas(gcf,filePath+"PlainHor.png");
saveas(gcf,filePath+"PlainHor.fig");

figure(9)
scatter(ciphPix1(rand7),ciphPix2(rand7),'filled')
set(gcf,'Units','inches','Position',[2 2 5 5])
xlim([0 255])
ylim([0 255])
saveas(gcf,filePath+"CiphVert.png");
saveas(gcf,filePath+"CiphVert.fig");
figure(10)
scatter(ciphPix3(rand8),ciphPix4(rand8),'filled')
set(gcf,'Units','inches','Position',[2 2 5 5])
xlim([0 255])
ylim([0 255])
saveas(gcf,filePath+"CiphHor.png");
saveas(gcf,filePath+"CiphHor.fig");

imwrite(uint8(greyIm),filePath+"GreyIm.png")
imwrite(uint8(cipherIm),filePath+"CipherIm.png")
imwrite(uint8(cipherImBitOff),filePath+"CipherImBitOff.png")
imwrite(uint8(cipherImPOff),filePath+"CipherImPOff.png")
imwrite(uint8(cipherImOverOff),filePath+"CipherImOverOff.png")
imwrite(uint8(cipherImSizeOff),filePath+"CipherImSizeOff.png")
imwrite(uint8(decImIterOff),filePath+"DecImIterOff.png")
imwrite(uint8(decImPOff),filePath+"DecImPOff.png")
imwrite(uint8(decImOverOff),filePath+"DecImOverOff.png")
imwrite(uint8(decImSizeOff),filePath+"DecImSizeOff.png")
imwrite(uint8(decImNormal),filePath+"DecImNormal.png")

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
mappingMatrix = mod(mappingMatrix,256);
imwrite(uint8(mappingMatrix),filePath+"mappingMatrix.png")

pathCellArray = OACMFastPath(numCols,numRows,sqSize,overlap,P,Q);
permutedIm = FastACMAsScan(pathCellArray,greyIm,iters);
imwrite(uint8(permutedIm),filePath+"permutedIm.png")

% randVec1=randperm(numCols*numRows-numRows,5000);
% randVec2=randVec1+numRows;
% randVec3=randperm(numCols*numRows,5000);
% randVec4=randVec3;
% for i = 1:5000
%     if mod(randVec3(i),numRows)==0
%         randVec3(i)=randVec3(i)-1;
%     else
%         randVec4(i)=randVec4(i)+1;
%     end
% end
% 
% plainValueVec1 = greyIm(randVec1);
% plainValueVec2 = greyIm(randVec2);
% plainValueVec3 = greyIm(randVec3);
% plainValueVec4 = greyIm(randVec4);
% 
% plainAve1 = mean(double(plainValueVec1));
% plainAve2 = mean(double(plainValueVec2));
% plainAve3 = mean(double(plainValueVec3));
% plainAve4 = mean(double(plainValueVec4));
% 
% plainDifVec1 = plainValueVec1-plainAve1;
% plainDifVec2 = plainValueVec2-plainAve2;
% plainDifVec3 = plainValueVec3-plainAve3;
% plainDifVec4 = plainValueVec4-plainAve4;
% 
% plainRelationHor = sum(plainDifVec1.*plainDifVec2)/((numRows*numCols)*sqrt(sum(plainDifVec1.^2)*sum(plainDifVec2.^2)*(1/(numRows*numCols)^2)));
% plainRelationVert = sum(plainDifVec3.*plainDifVec4)/((numRows*numCols)*sqrt(sum(plainDifVec3.^2)*sum(plainDifVec4.^2)*(1/(numRows*numCols)^2)));
% 
% figure(3)
% scatter(plainValueVec1,plainValueVec2,'filled')
% set(gcf,'Units','inches','Position',[2 2 5 5])
% xlim([0 255])
% ylim([0 255])
% figure(4)
% scatter(plainValueVec3,plainValueVec4,'filled')
% set(gcf,'Units','inches','Position',[2 2 5 5])
% xlim([0 255])
% ylim([0 255])
% 
% ciphValueVec1 = cipherIm(randVec1);
% ciphValueVec2 = cipherIm(randVec2);
% ciphValueVec3 = cipherIm(randVec3);
% ciphValueVec4 = cipherIm(randVec4);
% 
% ciphAve1 = mean(double(ciphValueVec1));
% ciphAve2 = mean(double(ciphValueVec2));
% ciphAve3 = mean(double(ciphValueVec3));
% ciphAve4 = mean(double(ciphValueVec4));
% 
% ciphDifVec1 = ciphValueVec1-ciphAve1;
% ciphDifVec2 = ciphValueVec2-ciphAve2;
% ciphDifVec3 = ciphValueVec3-ciphAve3;
% ciphDifVec4 = ciphValueVec4-ciphAve4;
% 
% ciphRelationHor = sum(ciphDifVec1.*ciphDifVec2)/((numRows*numCols)*sqrt(sum(ciphDifVec1.^2)*sum(ciphDifVec2.^2)*(1/(numRows*numCols)^2)));
% ciphRelationVert = sum(ciphDifVec3.*ciphDifVec4)/((numRows*numCols)*sqrt(sum(ciphDifVec3.^2)*sum(ciphDifVec4.^2)*(1/(numRows*numCols)^2)));
% 
% figure(5)
% scatter(ciphValueVec1,ciphValueVec2,'filled')
% set(gcf,'Units','inches','Position',[2 2 5 5])
% xlim([0 255])
% ylim([0 255])
% figure(6)
% scatter(ciphValueVec3,ciphValueVec4,'filled')
% set(gcf,'Units','inches','Position',[2 2 5 5])
% xlim([0 255])
% ylim([0 255])

end