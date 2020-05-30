function [Y,yUMF,muUMF, yLMF,muLMF] = g_LWA(X_u,X_l, X_h, W_u, W_l, W_h, n)

[N,M]=size(X_u);
N=N-1;

mu=X_u(N+1,:);

% Compute UMF
for i=1:n
    y(i)= EKM_modified(X_u(1:1:N,i)', W_u(1:1:N,i)', W_u(1:1:N,2*n+1-i)',-1);
    y(2*n+1-i)= EKM_modified(X_u(1:1:N,2*n+1-i)', W_u(1:1:N,i)', W_u(1:1:N,2*n+1-i)',1);
end

y;
std_y= 1/sqrt(2*pi);
Y=[y([n n+1]) std_y];
muUMF= mu;


if Y(1)< 1.19
    Y(4)=0
    for i=1:n
        a(i)= 0;
        b(i)= Y(2)+sqrt(2*std_y*std_y*log( 1/mu(i) ));
        y(i)=a(i);
        y(2*n+1-i)=b(i);
    end
elseif Y(2) > (10-1.19)
    Y(4)=2
    for i=1:n
        a(i)= Y(1)-sqrt(2*std_y*std_y*log( 1/mu(i) ));
        b(i)= 10;
        y(i)=a(i);
        y(2*n+1-i)=b(i);
    end
else
    Y(4)=1
    for i=1:n
        a(i)= Y(1)-sqrt(2*std_y*std_y*log( 1/mu(i) ));
        b(i)= Y(2)+sqrt(2*std_y*std_y*log( 1/mu(i) ));
        y(i)=a(i);
        y(2*n+1-i)=b(i);
    end    
    
end

yUMF= y;

%--------------------------------

%% Compute the LMF 

a=zeros(1,N);
b=zeros(1,N);
mean_Y = [Y(1) Y(2)] ;
std_Y = Y(3);
std_x = 1/sqrt(2*pi);
mu=[0:1/(n-1):1 1:-1/(n-1):0];

if Y(4)==0   % Left 
    for i=1:n
        a(i) = 0
        b(i) = mean_Y(1)+sqrt(2*std_x*std_x*log( 1/mu(i) ));
        ly(i)= a(i);
        ly(2*n+1-i)=b(i);        
    end
    lmu=mu    
elseif Y(4)==2   % Right
    for i=1:n
        a(i) = mean_Y(2)-sqrt(2*std_x*std_x*log( 1/mu(i) ));
        b(i) = 10
        ly(i)= a(i);
        ly(2*n+1-i)=b(i); 
    end
    lmu=mu
else            % Interior
    mid_x= (mean_Y(1)+mean_Y(2))/2;
    mid_Y= exp(-((mid_x-mean_Y(1)).^2)*pi);

    for i=1:n
        if mu(i)<=mid_Y
            lmu(i)=mu(i);
        end
    end

    lmu= [lmu lmu(end:-1:1)];

    [tmp,len] = size(lmu);
    ly=zeros(1,len);

    for i=1:len/2
        a(i) = mean_Y(2)-sqrt(2*std_x*std_x*log( 1/lmu(i) ));
        b(i) = mean_Y(1)+sqrt(2*std_x*std_x*log( 1/lmu(i) ));
        ly(i)= a(i);
        ly(len+1-i)=b(i);
    end
end

yLMF= ly;
muLMF= lmu;

%%

