function S=g_Jaccard(A,B)

n=100;   % number of vertical partition of x-axis
left= 0;
right=10;

u1_A= A(1);
u2_A= A(2);
std_A = A(3);

u1_B= B(1);
u2_B= B(2);
std_B=B(3);

class_A=A(4);
class_B=B(4);

dx=(right-left)/n;

% Compute the UMF for A value at x 
for i=1:n
    x= left + i*dx;
    if class_A ==0
        if x< u2_A
            uA(i)=1;
        elseif u2_A <= x && x<= (u2_A+1.19)
            uA(i)= exp(-pi*(x-u2_A)^2);
        else
            uA(i)=0;
        end
    elseif class_A==1
        if x< u1_A-1.19
            uA(i)=0;
        elseif u1_A-1.19 <= x && x< u1_A
            uA(i)= exp(-pi*(x-u1_A)^2);
        elseif u1_A<= x &&  x< u2_A
            uA(i)= 1;
        elseif u2_A<= x && x>u2_A +1.19
            uA(i)= exp(-pi*(x-u2_A)^2);
        else
            uA(i)=0;
        end
    elseif class_A ==2
        if x< u1_A -1.19
            uA(i)=0;
        elseif u1_A-1.19 <= x && x< u2_A
            uA(i)= exp(-pi*(x-u1_A)^2);
        else
            uA(i)=1;
        end
    end
end

% Compute the UMF for B value at x 
for i=1:n
    x= left + i*dx;
    if class_B ==0
        if x< u2_B
            uB(i)=1;
        elseif u2_B <= x && x<= (u2_B+1.19)
            uB(i)= exp(-pi*(x-u2_B)^2);
        else
            uB(i)=0;
        end
    elseif class_B==1
        if x< u1_B-1.19
            uB(i)=0;
        elseif u1_B-1.19 <= x && x< u1_B
            uB(i)= exp(-pi*(x-u1_B)^2);
        elseif u1_B<= x &&  x< u2_B
            uB(i)= 1;
        elseif u2_B<= x && x>u2_B +1.19
            uB(i)= exp(-pi*(x-u2_B)^2);
        else
            uB(i)=0;
        end
    elseif class_B ==2
        if x< u1_B -1.19
            uB(i)=0;
        elseif u1_B-1.19 <= x && x< u2_B
            uB(i)= exp(-pi*(x-u1_B)^2);
        else
            uB(i)=1;
        end
    end
end
        
% Compute the LMF for A at value of x 
for i=1:n
    x= left + i*dx;
    if class_A ==0
        if x < u1_A
            lA(i)=1;
        elseif u1_A<=x && x<(u1_A+1.19)
            lA(i)= exp(-pi*(x-u1_A)^2);
        else
            lA(i)= 0;
        end
    elseif class_A==1
        if x<((u1_A+u1_B)/2-1.19)
            lA(i)= 0;
        elseif ((u1_A+u1_B)/2 -1.19)<=x && x<(u1_A+u1_B)/2 
            lA(i)= exp(-pi*(x-u2_A)^2);
        elseif (u1_A+u1_B)/2 <= x && x<(u1_A+u1_B)/2 +1.19
            lA(i)= exp(-pi*(x-u1_A)^2);
        else
            lA(i)= 0;
        end
    elseif class_A==2
        if x<(u2_A -1.19)
            lA(i)=0;
        elseif (u2_A-1.19)<x && x<=u2_A
            lA(i)= exp(-pi*(x-u2_A)^2);
        else
            lA(i)= 1;
        end
    end
end

% Compute the LMF for B at value of x 
for i=1:n
    x= left + i*dx;
    if class_B ==0
        if x < u1_B
            lB(i)=1;
        elseif u1_B<=x && x<(u1_B+1.19)
            lB(i)= exp(-pi*(x-u1_B)^2);
        else
            lB(i)= 0;
        end
    elseif class_B==1
        if x<((u1_A+u1_B)/2-1.19)
            lB(i)= 0;
        elseif ((u1_A+u1_B)/2 -1.19)<=x && x<(u1_A+u1_B)/2 
            lB(i)= exp(-pi*(x-u2_B)^2);
        elseif (u1_A+u1_B)/2 <= x && x<(u1_A+u1_B)/2 +1.19
            lB(i)= exp(-pi*(x-u1_B)^2);
        else
            lB(i)= 0;
        end
    elseif class_B==2
        if x<(u2_B -1.19)
            lB(i)=0;
        elseif (u2_B-1.19)<x && x<=u2_B
            lB(i)= exp(-pi*(x-u2_B)^2);
        else
            lB(i)= 1;
        end
    end
end
        
 S=sum([min([uA;uB]), min([lA;lB])])/sum([max([uA;uB]), max([lA;lB])]);
 
        
        
        
        
        
        
        
        