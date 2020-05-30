function [words, MFs, Cs, Cls, Crs]=g_getFOUs()

% to compute the 32 word FOUs from interval survey data (datacopy.xls)
% using the Interval Approach [1] so that they can be used in example4.m.
%
% [1] Feilong Liu and Jerry M. Mendel, "Encoding words into interval type-2
% fuzzy sets using an Interval Approach," submitted to IEEE Trans. on Fuzzy 
% Systems, 2007.
%
% Dongrui Wu (dongruiw@usc.edu), 5/12/2008
%
% words: names of the 32 words
% MFs: MFs of the 32 words, each described by 9 parameters (see Fig. 1 in
% Readme.doc)
% Cs: centers of centroids of the 32 words
% Cls: left-bounds of the centroids
% Crs: right-bounds of the centroids

%% Read Data
[A,words] = xlsread('linguistic_ratings_new.xlsx');
A(1,:)=[];
words=words(1,1:2:end);
words= transpose(words)

[row, col] = size(A);

%% Names of the 32 words
MFs=zeros(col/2,4);
%%  Compute the FOUs and centroids
for i=1:col/2
    L = A(1:row, 2*i-1);  %% Left end-points for interval data.
    R = A(1:row, 2*i);    %% Right end-points for interval data.
    MFs(i,:) = g_fuzzistics(L,R); %% Map into an IT2 FS
    [Cs(i),Cls(i),Crs(i)]=g_centroidIT2(MFs(i,:)); %% Compute the centroid
end

c=[Cls' Crs' Cs'];

