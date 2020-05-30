function vl= VUMF(YLWA, H)

% Provide the LMF Gaussian function value corresponding to value on x-axis
% Input: 
%       YLWA: Gaussian IT2FS  (example:  [mean1 mean2 std category])
%          H: X-axis split between range (mean1-1.19, mean2+1.19) at some regular intervals 
% Output:
%       vu: LMF function value corresponding to the value given in H

[tmp,s]= size(H);
u1= YLWA(1);
u2= YLWA(2);
cat= YLWA(4);

if cat==0
    for i=1:s
        if H(i)<= u1
            vl(i)=1;
        elseif u1< H(i)&& H(i)< (u1+1.19)
            vl(i)= exp(-pi*(H(i)-u1)^2);
        else
            vl(i)= 0;
        end
    end
elseif cat==1
    for i=1:s
        if H(i)<(u1+u2)/2 - 1.19
            vl(i)=0;
        elseif (u1+u2)/2 - 1.19 <= H(i) && H(i) <= (u1+u2)/2
            vl(i)= exp(-pi*(H(i)-u2)^2);
        elseif (u1+u2)/2 < H(i) && H(i) <= (u1+u2)/2 + 1.19
            vl(i)= exp(-pi*(H(i)-u1)^2);
        else
            vl(i)= 0;
        end
    end
elseif cat==2
    for i=1:s
        if H(i)< (u2-1.19)
            vl(i)=0;
        elseif  (u2-1.19)<= H(i) && H(i)< u2
            vl(i)= exp(-pi*(H(i)-u2)^2);
        else
            vl(i)= 1;
        end
    end
end

            
