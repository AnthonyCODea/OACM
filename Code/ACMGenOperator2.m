function output = ACMGenOperator2(inputMatrix,p,q)
% Generalized ACM operator where p and q can be directly set.
% Normal/forward ACM
    width = size(inputMatrix,2);
    height = size(inputMatrix,1);
    output = zeros(height,width);
    for row = 1:height
        for col = 1:width
            output(mod((1+p*q)*row+q*col-q-1-p*q,height)+1,mod(p*row+col-1-p,width)+1) = inputMatrix(row,col);
        end
    end
end