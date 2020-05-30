function [LWAc,LWACl,LWACr]=g_centroidIT2(YLWA) 

% Provide the centroid with centroid range for Gaussian IT2FS (uncertain mean)
% Input: YLWA: Gaussian IT2FS  (example:  [mean1 mean2 std category])
%        category: 0-Left Shoulder , 1-Inner gaussian 1, 2-Right Shoulder
% Output: LWACl- Left boundary of Centroid , LWACl- Right boundary of Centroid, LWAc- Centroid ) 

n_v_split= 100;   % no. of .vertical split 
cat= YLWA(4);

if cat== 0
    left_boundary= 0;
    right_boundary= YLWA(2)+1.19;
elseif cat==1
    left_boundary=  YLWA(1)-1.19;
    right_boundary= YLWA(2)+1.19;
elseif cat==2
    left_boundary=  YLWA(1)-1.19;
    right_boundary= 10;
end 

h_split = linspace(left_boundary, right_boundary, n_v_split)  ;   % X-axis split

vu= VUMF(YLWA, h_split);
vl= VLMF(YLWA, h_split);

LWACl= EKM_modified(h_split, vl, vu, -1);
LWACr= EKM_modified(h_split, vl, vu,  1);

LWAc= (LWACl+LWACr)/2;
