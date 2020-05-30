function vu= VUMF(YLWA, H)

% Provide the UMF Gaussian function value corresponding to value on x-axis
% Input: 
%       YLWA: Gaussian IT2FS  (example:  [mean1 mean2 std category])
%          H: X-axis split between range (mean1-1.19, mean2+1.19) at some regular intervals 
% Output:
%       vu: UMF function value corresponding to the value given in H

[tmp,s]= size(H);
u1= YLWA(1) ;          % u1: mean1
u2= YLWA(2) ;          % u2: mean2
cat= YLWA(4) ;         % cat: category(0: Left Shoulder, 1: Interior, 2: Right Shoulder)

if cat==0
    for i=1:s
        if H(i)<= u2;
            vu(i)=1;
        else
            vu(i)= exp(-pi*(H(i)-u2)^2);
        end
    end
elseif cat==1
    for i=1:s
        if H(i)< u1
            vu(i)= exp(-pi*(H(i)-u1)^2);
        elseif u1<= H(i) && H(i)< u2
            vu(i)= 1;
        elseif H(i)>u2
            vu(i)= exp(-pi*(H(i)-u2)^2);
        else
            vu(i)=0;
        end
    end
elseif cat==2
    for i=1:s
        if H(i)<= u1
            vu(i)=exp(-pi*(H(i)-u1)^2);
        else
            vu(i)=1;
        end
    end
end
