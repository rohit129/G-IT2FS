function [gauss_x, gauss_y] = umf_gauss(X,n)

% Generate the UMF Type-1 Gaussian fuzzy function (with uncertain means)
%
% Inputs: 
% X: [g1_mean1 g1_mean2  std; g2_mean1 g2_mean2  std; ... ]  where
%     g1, g2,... are different gaussian functions with uncertain means
% n: Number of slices to be made in Y-axis (number of alpha-cuts needed)

% Outputs:
% gauss_x : Matrix where every row is a List of values of x for the gaussian at each alpha-cut
% gauss_y : Matrix where every row is a List of values of y (membership value) for the gaussian at each
%           alpha-cut

[N,M]=size(X);


y=zeros(1,2*n);

mu= [0:1/(n-1):1 1:-1/(n-1):0];
gauss_y= mu;

gauss_x= zeros(N,2*n);

for j=1:N
    a=zeros(1,n);
    b=zeros(1,n);
    for i=1:n
        mean_x = [X(j,1) X(j,2)] ;
        std_x = X(j,3);        
        if X(j,4)==0
            a(i) = 0;
            b(i) = mean_x(2)+sqrt(2*std_x*std_x*log( 1/mu(i) ));
            if isinf(b(i))
                b(i)=0;
            end
        elseif X(j,4)==2
            a(i) = mean_x(1)-sqrt(2*std_x*std_x*log( 1/mu(i) ));
            if isinf(a(i))
                a(i)=0;
            end
            b(i) = 10;
        else
            a(i) = mean_x(1)-sqrt(2*std_x*std_x*log( 1/mu(i) ));
            b(i) = mean_x(2)+sqrt(2*std_x*std_x*log( 1/mu(i) ));
            if isinf(a(i))
                a(i)=0;
            end
            if isinf(b(i))
                b(i)=0;
            end
        end
        gauss_x(j,i)=a(i);
        gauss_x(j,2*n+1-i)=b(i);
    end
end

    


