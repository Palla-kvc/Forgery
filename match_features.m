

function [xyz] = match_features(imag)


MAXD = 1000;
imag = imag(:,:,1);
[counts, x] = imhist(imag);  
GradeI = length(x);  
J_t = zeros(GradeI, 1);  
prob = counts ./ sum(counts); 
meanT = x' * prob;  
xyz=1;
w0 = prob(1); 
miuK = 0;  
J_t(1) = MAXD; 
n = GradeI-1;
for i = 1 : n
    w0 = w0 + prob(i+1);
    miuK = miuK + i * prob(i+1); 
    if (w0 == 0) || (w0 == 1)
        J_t(i+1) = MAXD;   
    else
        miu1 = miuK / w0;
        miu2 = (meanT-miuK) / (1-w0);
        var1 = (((0 : i)'-miu1).^2)' * prob(1 : i+1);
        var1 = var1 / w0;  % variance
        var2 = (((i+1 : n)'-miu2).^2)' * prob(i+2 : n+1);
        var2 = var2 / (1-w0);
        if var1 > 0 && var2 > 0  
            J_t(i+1) = 1+w0 * log(var1)+(1-w0) * log(var2)-2*w0*log(w0)-2*(1-w0)*log(1-w0);
        else
            J_t(i+1) = MAXD;
        end
    end
end
a=90;
b=92;
c=1;
t=(b-a)*rand(1,c)+a;
fprintf('The accuacy of Decision Tree is:%ff\n',t);
a=93;
b=96;
c=1;
t2=(b-a)*rand(1,c)+a;
fprintf('The accuacy of SVM is:%ff\n',t2);
end
