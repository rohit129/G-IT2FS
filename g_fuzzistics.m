function [MF, nums] = g_fuzzistics(L,R)
%
% to compute an IT2 FS model from interval survey data. It implements the
% Interval Approach proposed in [1] and is called in getFOUs.m.
%
% [1] Feilong Liu and Jerry M. Mendel, "Encoding words into interval type-2
% fuzzy sets using an Interval Approach," submitted to IEEE Trans. on Fuzzy 
% Systems, 2007.
%
%  Dongrui WU (dongruiw@usc.edu), 5/12/2008
%
% L: left end-points of the intervals from survey
% R: right end-points of the intervals from survey
% MFs: MFs of the word model defined by 9 parameters (see Fig. 1 in
% Readme.doc)
% nums: number of remaining intervals after each precessing steps

%% Bad data processing, see Equation (1) in paper
for i=length(L):-1:1
    if L(i)<0 | L(i)>10 | R(i)<0 | R(i)>10 |  R(i)<L(i)
        L(i) = [];
        R(i) = [];
    end
end
nums=[];
nums=[nums length(L)];

%% Outlier processing, see Equation (2) in paper
intLeng = R-L;
left = sort(L);
right = sort(R);
leng = sort(intLeng);
n=length(L);

NN1 = floor(n * 0.25 + 0.5);
NN2 = floor(n * 0.75 + 0.5);

% Compute Q(0.25), Q(0.75) and IQR for left-ends
QL25 = (0.5 - n * 0.25 + NN1) * left(NN1) + (n * 0.25 + 0.5 - NN1) * left(NN1+1);
QL75 = (0.5 - n * 0.75 + NN2) * left(NN2) + (n * 0.75 + 0.5 - NN2) * left(NN2+1);
LIQR = QL75 - QL25;

% Compute Q(0.25), Q(0.75) and IQR for right-ends.
QR25 = (0.5 - n * 0.25 + NN1) * right(NN1) + (n * 0.25 + 0.5 - NN1) * right(NN1+1);
QR75 = (0.5 - n * 0.75 + NN2) * right(NN2) + (n * 0.75 + 0.5 - NN2) * right(NN2+1);
RIQR = QR75 - QR25;

% Compute Q(0.25), Q(0.75) and IQR for interval length.
QLeng25 = (0.5 - n * 0.25 + NN1) * leng(NN1) + (n * 0.25 + 0.5 - NN1) * leng(NN1+1);
QLeng75 = (0.5 - n * 0.75 + NN2) * leng(NN2) + (n * 0.75 + 0.5 - NN2) * leng(NN2+1);
lengIQR = QLeng75 - QLeng25;
bound=.25;

% outlier processing
for i=n:-1:1
    if (LIQR>bound & (L(i)<QL25-1.5*LIQR | L(i)>QL75+1.5*LIQR))...
            |(RIQR>bound & (R(i)<QR25-1.5*RIQR | R(i)>QR75+1.5*RIQR))...
            |(lengIQR>bound & (intLeng(i)<QLeng25-1.5*lengIQR | intLeng(i)>QLeng75+1.5*lengIQR))
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
nums=[nums length(L)];

%% Tolerance limit processing, see Equation (3) in paper 
n1 = length(L);
NN = 2000;
rand('state', 22331);
AA = floor(n1*rand(n1, NN))+1;
resampleL = L(AA);
resampleR = R(AA);
resampleLeng = intLeng(AA);

tempMeanL = mean(resampleL);
tempMeanR = mean(resampleR);
tempMeanLeng = mean(resampleLeng);

meanL = mean(tempMeanL);
stdL = sqrt(n1)* std(tempMeanL);
meanR = mean(tempMeanR) ;
stdR = sqrt(n1)* std(tempMeanR);
meanLeng = mean(tempMeanLeng);
stdLeng = sqrt(n1)* std(tempMeanLeng);

% K=[32.019 32.019 8.380 5.369 4.275 3.712 3.369 3.136 2.967 2.839...
%     2.737 2.655 2.587 2.529 2.48 2.437 2.4 2.366 2.337 2.31...
%     2.31 2.31 2.31 2.31 2.208];

% k=K(min(length(L),25));

k= 1.960

for i=length(L):-1:1
    if (stdL>bound & (L(i)<meanL-k*stdL | L(i)>meanL + k*stdL))...
          | (stdR>bound & (R(i)<meanR-k*stdR | R(i)>meanR + k*stdR))...
          | (stdLeng>bound & (intLeng(i)<meanLeng-k*stdLeng| intLeng(i)>meanLeng + k*stdLeng))
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
nums=[nums length(L)];

%% Reasonable interval processing, see Equation (4)-(6) in paper
n1 = length(L);
NN = 2000;
rand('state', 231);
AA = floor(n1*rand(n1, NN))+1;
resampleL = L(AA);
resampleR = R(AA);

tempMeanL = mean(resampleL);
tempMeanR = mean(resampleR);

meanL = mean(tempMeanL);
stdL = sqrt(n1)* std(tempMeanL);
meanR = mean(tempMeanR) ;
stdR = sqrt(n1)* std(tempMeanR);

% Determine sigma*, see formula (5) in paper
if stdL+stdR==0
    barrier = (meanL + meanR)/2;
elseif stdL==0
    barrier = meanL+0.01;
elseif stdR==0
    barrier = meanR-0.01;
else
    barrier1 =(-(meanL*stdR^2-meanR*stdL^2) + stdL*stdR*sqrt((meanL-meanR)^2+2*(stdR^2-stdL^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
    barrier2 =(-(meanL*stdR^2-meanR*stdL^2) - stdL*stdR*sqrt((meanL-meanR)^2+2*(stdR^2-stdL^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
    if  barrier1>=meanL & barrier1<=meanR
        barrier = barrier1;
    else
        barrier = barrier2;
    end
end

% Reasonable interval processing 
for i=length(L):-1:1
    if L(i)>barrier | R(i)< barrier
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
nums=[nums length(L)];

%% Compute the IT2FS

meanL = mean(L);
meanR= mean(R);
std_MF= 1/sqrt(2*pi);

if meanL<1.19
    classIT2FS=0;
elseif meanR > (10-1.19)
    classIT2FS=2;
else
    classIT2FS=1;
end

MF=[meanL meanR std_MF classIT2FS];



% %%  Admissible region determination 
% tTable=[6.314 2.920 2.353 2.132 2.015 1.943 1.895 1.860 1.833 1.812 1.796 1.782...
%     1.771 1.761 1.753 1.746 1.740 1.734 1.729 1.725 1.721 1.717 1.714 1.711...
%     1.708 1.706 1.703 1.701 1.699 1.697 1.684]; % alpha = 0.05;
% tAlpha=tTable(min(n,31));
% meanL = mean(L);
% meanR = mean(R) ;
% C = R - 5.831*L;
% D = R - 0.171*L - 8.29;
% shift1 = tAlpha * std(C)/sqrt(n);
% shift2 = tAlpha * std(D)/sqrt(n);
% 
% % Establish nature of FOU, see Equation (19) in paper
% if meanR<5.831*meanL -shift1 & meanR<8.29+0.171*meanL-shift2
%     for i=length(L):-1:1
%         %% internal embedded T1 FS
%         FSL(i) = 0.5*(L(i)+R(i)) - sqrt(2)*(R(i)-L(i))/2;
%         FSR(i) = 0.5*(L(i)+R(i)) + sqrt(2)*(R(i)-L(i))/2;
% 
%         % Delete inadmissible T1 FSs
%         if FSL(i)< 0 | FSR(i)>10
%             FSL(i)= [];
%             FSR(i)= [];
%         end
%     end
%     FSC=(FSL+FSR)/2;
%     % Compute the mathematical model for FOU(A~)
%     L1 = min(FSL);
%     L2 = max(FSL);
%     R1 = min(FSR);
%     R2 = max(FSR);
%     C1 = min(FSC);
%     C2 = max(FSC);
% 
%     temp = (R1-C1)/(C2-L2);
%     apex = (R1+temp*L2)/(1+temp);
%     height = (R1-apex)/(R1-C1);
%     UMF =[L1, C1, C2, R2];
%     LMF = [L2, apex, apex, R1, height];
% 
% elseif (meanR>5.831*meanL-shift1)
%     for i=length(L):-1:1
%         % left shoulder embedded T1 FS
%         FSL(i) = 0.5*(L(i)+R(i)) - (R(i)-L(i))/sqrt(6);
%         FSR(i) = 0.5*(L(i)+R(i)) + sqrt(6)*(R(i)-L(i))/3;
% 
%         % Delete inadmissible T1 FSs
%         if FSL(i)<0 | FSR(i)>10
%             FSL(i)=[];
%             FSR(i)=[];
%         end
%     end
%     % Compute the mathematical model for FOU(A~)
%     UMF =[0,  0, max(FSL), max(FSR)];
%     LMF = [0, 0, min(FSL), min(FSR), 1];
% else
%     for i=length(L):-1:1
%         % right shoulder embedded T1 FS
%         FSL(i) = 0.5*(L(i)+R(i)) - sqrt(6)*(R(i)-L(i))/3;
%         FSR(i) = 0.5*(L(i)+R(i)) + (R(i)-L(i))/sqrt(6);
%         % Delete inadmissible T1 FSs
%         if FSL(i)<0 | FSR(i)>10
%             FSL(i)=[];
%             FSR(i)=[];
%         end
%     end
%     % Compute the mathematical model for FOU(A~)
%     UMF =[min(FSL), min(FSR), 10, 10];
%     LMF = [max(FSL), max(FSR), 10, 10, 1];
% end
% 
% MF=[UMF LMF];
% nums=[nums length(FSL)];



