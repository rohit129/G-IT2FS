function [gauss_x, gauss_y, len_alpha_cut ] = lmf_gauss(X,n)

% Generate the LMF for intersection of two Type-1 Gaussian fuzzy function (with uncertain means)
%
% Inputs: 
% X: [g1_mean1 g1_mean2  std; g2_mean1 g2_mean2  std; ... ]  where
%     g1, g2,... are different gaussian functions with uncertain means
% n: Number of slices to be made in Y-axis (number of alpha-cuts needed)

% Outputs:
% gauss_x : Matrix where every row is a List of values of x for the gaussian at each valid alpha-cut (otherwise filled with 0) 
% gauss_y : Matrix where every row is a List of values of y (membership value) for the gaussian at each alpha-cut (otherwise filled with 0)  
% len_alpha_cut : List having the Last index of valid "twice of alpha-cut" (needed for plotting whole curve)
% (Note: len_alpha_cut represent the column index of last non-zero entry in gauss_x )

[N,M]=size(X);


mean_x = [X(:,1) X(:,2)] ;
std_x = X(:,3);
mu=[0:1/(n-1):1 1:-1/(n-1):0]; %% List of Alpha-cut taken in ascending then in descending.
% lmu=zeros(1,N)
lmu=zeros(N,2*n);
ly= zeros(N,2*n);

for j=1:N
    a=zeros(1,N);
    b=zeros(1,N);
    if X(j,4)==0
        for i=1:n
            a(i) = 0;
            b(i) = mean_x(j,1)+sqrt(2*std_x(j)*std_x(j)*log( 1/mu(i) ));
            if isinf(b(i))
                b(i)=0;
            end
            ly(j,i)= a(i);
            ly(j,2*n+1-i)= b(i);
            count(j)=i;
        end
        lmu(j,:)=mu;
    elseif X(j,4)==2
        for i=1:n
            a(i) = mean_x(j,2)-sqrt(2*std_x(j)*std_x(j)*log( 1/mu(i)));
            if isinf(a(i))
                a(i)=0;
            end
            b(i) = 10;
            ly(j,i)= a(i);
            ly(j,2*n+1-i)= b(i);
            count(j)=i;
        end        
        lmu(j,:)=mu;
    else
        mid_x= (mean_x(:,1)+mean_x(:,2))/2;
        mid_y= exp(-((mid_x-mean_x(:,1)).^2)*pi);
        for i=1:n
            if mu(i)<=mid_y(j)
                lmu(j,i)=mu(i);
                count(j)=i;
            end
        end
        lmu(j,:)=[lmu(j,1:1:count(j)) lmu(j,count(j):-1:1) zeros(1,2*(n-count(j)))];
        for i=1:count(j)
            a(i) = mean_x(j,2)-sqrt(2*std_x(j)*std_x(j)*log( 1/lmu(j,i) ));
            if isinf(a(i))
                a(i)=0;
            end
            b(i) = mean_x(j,1)+sqrt(2*std_x(j)*std_x(j)*log( 1/lmu(j,i) ));
            if isinf(b(i))
                b(i)=0;
            end
            ly(j,i)=a(i);
            ly(j,2*count(j)+1-i)=b(i);
        end                   
        
    end
end


gauss_x= ly;
gauss_y= lmu;
len_alpha_cut=2*count;
