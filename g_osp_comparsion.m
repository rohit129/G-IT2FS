% to create an example of the LWA using FOUs from the survey.
% Rohit Mishra (rohit129iiita@gmail.com), 15/3/2020

clear all;
close all;
clc;

%% get the FOUs
[words,MFs]=g_getFOUs();

[w_words,w_MFs ]= g_linguistic_weight_getFOUs();

% Negated FOU calculation
for i=1:17
    neg_MFs(i,:) = g_antonym(MFs(i,:));
end

% Append the Negated FOU at the last of initial FOUs
for i=1:17
    MFs(i+17,:) = neg_MFs(i,:);
end

n=101;  % No. of Alpha-cuts

%% -------- Create Interval type-2 word models of Linguistic Ratings ----

[UMFgauss_x, UMFgauss_y] = umf_gauss(MFs,n);
[LMFgauss_x, LMFgauss_y,len_alpha_cut] = lmf_gauss(MFs,n);

%% -------- Create Interval type-2 word models of Linguistic Weights ----

[wUMFgauss_x, wUMFgauss_y] = umf_gauss(w_MFs,n);
[wLMFgauss_x, wLMFgauss_y,wlen_alpha_cut] = lmf_gauss(w_MFs,n);

%% ------------------------------------------------------------------------

% Index of Linguistic Terms for Linguistic Rating in "Decision Table" ******
R1_Xs = [17, 2, 11];  % For R1 -->(OSP-1)    [ Cost , Time ,  Quality ] -> [VE , L , VG]
R2_Xs = [16, 3, 10];  % For R2 -->(OSP-2)    [ Cost , Time ,  Quality ] -> [E  , M  , G ]
R3_Xs = [ 3, 3,  9];  % For R3 -->(OSP-3)    [ Cost , Time ,  Quality ] -> [M , M , M ]
R4_Xs = [12, 2,  7];  % For R4 -->(OSP-4)    [ Cost , Time ,  Quality ] -> [VC , L  , P ]

% WEIGHT INPUT *****
% R_Ws = [1,4,5] %  Weights for (Student-1)     [U  , I, VI ]
%      = [4,3,4] %              (Student-2)     [I,   MI,  I]
%      = [5,1,2] %              (Student-3)     [VI , U  , MLU]

R_Ws = [1,4,5];
%*********************



%%
%  Computing the Centroid for an IT2FS 
% [cent_vl, left_cent_vl, right_cent_vl] = g_centroidIT2(MFs(20,:));
%  End of computing

%%

% Cost and Time are 'Negative Conotated' therefore corresponding MF is negated
for i=1:2
    R1_Xs(i)=R1_Xs(i)+17;
    R2_Xs(i)=R2_Xs(i)+17;
    R3_Xs(i)=R3_Xs(i)+17;
    R4_Xs(i)=R4_Xs(i)+17;
end

%% --------------Computing LWA and Similarity -----------------------------

R1_R_LWA=LWA4(MFs(R1_Xs,:),w_MFs(R_Ws,:),n); %% LWA
R2_R_LWA=LWA4(MFs(R2_Xs,:),w_MFs(R_Ws,:),n); %% LWA
R3_R_LWA=LWA4(MFs(R3_Xs,:),w_MFs(R_Ws,:),n); %% LWA
R4_R_LWA=LWA4(MFs(R4_Xs,:),w_MFs(R_Ws,:),n); %% LWA

% Computing the Centroid for an LWA 
[cent_vl, left_cent_vl, right_cent_vl] = g_centroidIT2(R1_R_LWA);
tmp(1,:)= [left_cent_vl, cent_vl, right_cent_vl]
[cent_vl, left_cent_vl, right_cent_vl] = g_centroidIT2(R2_R_LWA);
tmp(2,:)= [left_cent_vl, cent_vl, right_cent_vl]
[cent_vl, left_cent_vl, right_cent_vl] = g_centroidIT2(R3_R_LWA);
tmp(3,:)= [left_cent_vl, cent_vl, right_cent_vl]
[cent_vl, left_cent_vl, right_cent_vl] = g_centroidIT2(R4_R_LWA);
tmp(4,:)= [left_cent_vl, cent_vl, right_cent_vl]
%  End of computing

[out_words,out_MFs]=g_output_terms_FOU();
[out_UMFgauss_x, out_UMFgauss_y] = umf_gauss(out_MFs,n);
[out_LMFgauss_x, out_LMFgauss_y,out_len_alpha_cut] = lmf_gauss(out_MFs,n);

for i=1:size(out_words,1)
    R1_R_S(i)=g_Jaccard(R1_R_LWA,out_MFs(i,:));
    R2_R_S(i)=g_Jaccard(R2_R_LWA,out_MFs(i,:));
    R3_R_S(i)=g_Jaccard(R3_R_LWA,out_MFs(i,:));
    R4_R_S(i)=g_Jaccard(R4_R_LWA,out_MFs(i,:));
end

combine_all_similarity=[R1_R_S; R2_R_S; R3_R_S; R4_R_S]

[maxR1_R_S,R1_R_index]=max(R1_R_S);
[maxR2_R_S,R2_R_index]=max(R2_R_S);
[maxR3_R_S,R3_R_index]=max(R3_R_S);
[maxR4_R_S,R4_R_index]=max(R4_R_S);


R1_R_decode=out_words(R1_R_index,:)  %% decoding
R2_R_decode=out_words(R2_R_index,:)  %% decoding
R3_R_decode=out_words(R3_R_index,:)  %% decoding
R4_R_decode=out_words(R4_R_index,:)  %% decoding

maxR1_R_S
maxR2_R_S
maxR3_R_S
maxR4_R_S



%% --------  FIGURE FOR THE Memberships on the [0-10] Scale   --------------- %%
figure('NumberTitle', 'on', 'Name', 'Codebook Memberships functions')
% ------- R1: (OSP-1)-----------%
%figure('NumberTitle', 'on', 'Name', 'Linguistic Ratings of (OSP-1)')
set(gcf,'DefaulttextFontName','times new roman');
set(gcf,'DefaultaxesFontName','times new roman');
set(gcf,'DefaulttextFontAngle','italic');
set(gcf,'DefaulttextFontSize',12);
set(gcf,'DefaultlineLineWidth',1);
set(gcf,'DefaultaxesLineWidth',1);


subplot(5,1,1)
Cost_MF=[12:17];
N=length(Cost_MF);
for i=1:N
    fill([UMFgauss_x(Cost_MF(i),2:1:end-1) LMFgauss_x(Cost_MF(i),len_alpha_cut(Cost_MF(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(Cost_MF(i),len_alpha_cut(Cost_MF(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end
for i=1:N
    pattern='-';
    plot([UMFgauss_x(Cost_MF(i),2:1:end-1) LMFgauss_x(Cost_MF(i),len_alpha_cut(Cost_MF(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(Cost_MF(i),len_alpha_cut(Cost_MF(i))-1:-1:2)],pattern, 'linewidth',1.5)
    if Cost_MF(i) > 17
        text(MFs(Cost_MF(i),2)-0.2,1.20,  words(Cost_MF(i)-17,:));    % For Negated connotation
    else
        text(MFs(Cost_MF(i),2)-0.2,1.20,  words(Cost_MF(i),:));    % For Positive connotation   
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'Cost');
text(0.1,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');

subplot(5,1,2)
Time_MF=[1:6];
N=length(Time_MF);
for i=1:N
    fill([UMFgauss_x(Time_MF(i),2:1:end-1) LMFgauss_x(Time_MF(i),len_alpha_cut(Time_MF(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(Time_MF(i),len_alpha_cut(Time_MF(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end
for i=1:N
    pattern='-';
    plot([UMFgauss_x(Time_MF(i),2:1:end-1) LMFgauss_x(Time_MF(i),len_alpha_cut(Time_MF(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(Time_MF(i),len_alpha_cut(Time_MF(i))-1:-1:2)],pattern, 'linewidth',1.5)
    if Time_MF(i) > 17
        text(MFs(Time_MF(i),2),1.20,  words(Time_MF(i)-17,:));    % For Negated connotation
    else
        text(MFs(Time_MF(i),2),1.20,  words(Time_MF(i),:));    % For Positive connotation   
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'Time');
text(0.1,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');

subplot(5,1,3)
Quality_MF=[7:11];
N=length(Quality_MF);
for i=1:N
    fill([UMFgauss_x(Quality_MF(i),2:1:end-1) LMFgauss_x(Quality_MF(i),len_alpha_cut(Quality_MF(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(Quality_MF(i),len_alpha_cut(Quality_MF(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end
for i=1:N
    pattern='-';
    plot([UMFgauss_x(Quality_MF(i),2:1:end-1) LMFgauss_x(Quality_MF(i),len_alpha_cut(Quality_MF(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(Quality_MF(i),len_alpha_cut(Quality_MF(i))-1:-1:2)],pattern, 'linewidth',1.5)
    if Quality_MF(i) > 17
        text(MFs(Quality_MF(i),2),1.20,  words(Quality_MF(i)-17,:));    % For Negated connotation
    else
        text(MFs(Quality_MF(i),2),1.20,  words(Quality_MF(i),:));    % For Positive connotation   
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.1,0,'Quality');
text(0.1,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');

subplot(5,1,4)
wMF=[1:5];
N=length(wMF);
for i=1:N
    fill([wUMFgauss_x(wMF(i),2:1:end-1) wLMFgauss_x(wMF(i),wlen_alpha_cut(wMF(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(wMF(i),wlen_alpha_cut(wMF(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on
end
for i=1:N
    pattern='-';
    plot([wUMFgauss_x(wMF(i),2:1:end-1) wLMFgauss_x(wMF(i),wlen_alpha_cut(wMF(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(wMF(i),wlen_alpha_cut(wMF(i))-1:-1:2)],pattern, 'linewidth',1.5)
    if wMF(i) > 17
        text(mean([w_MFs(wMF(i),1) w_MFs(wMF(i),2)]),1.20,  w_words(wMF(i)-17,:));    % For Negated connotation
    else
        text(mean([w_MFs(wMF(i),1) w_MFs(wMF(i),2)]),1.20,  w_words(wMF(i),:));    % For Positive connotation   
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.1,0,'Weight');
text(0.1,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');


subplot(5,1,5)
OUTPUT_MF=[1:8];
N=length(OUTPUT_MF);
for i=1:N
    fill([out_UMFgauss_x(OUTPUT_MF(i),2:1:end-1) out_LMFgauss_x(OUTPUT_MF(i),out_len_alpha_cut(OUTPUT_MF(i))-1:-1:2)], [out_UMFgauss_y(2:1:end-1) out_LMFgauss_y(OUTPUT_MF(i),out_len_alpha_cut(OUTPUT_MF(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end
for i=1:N
    pattern='-';
    plot([out_UMFgauss_x(OUTPUT_MF(i),2:1:end-1) out_LMFgauss_x(OUTPUT_MF(i),out_len_alpha_cut(OUTPUT_MF(i))-1:-1:2)], [out_UMFgauss_y(2:1:end-1) out_LMFgauss_y(OUTPUT_MF(i),out_len_alpha_cut(OUTPUT_MF(i))-1:-1:2)],pattern, 'linewidth',1.5)
    if OUTPUT_MF(i) > 17
        text(mean([out_MFs(OUTPUT_MF(i),1) out_MFs(OUTPUT_MF(i),2)]),1.20,  out_words(OUTPUT_MF(i)-17,:));    % For Negated connotation
    else
        text(mean([out_MFs(OUTPUT_MF(i),1) out_MFs(OUTPUT_MF(i),2)]),1.20,  out_words(OUTPUT_MF(i),:));    % For Positive connotation   
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(9.5,-0.5,'Recommendation');
text(0.1,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
saveas(gcf,'Codebook_Membership_functions.eps');


%% --------  FIGURE FOR THE Linguistic Ratings corresponding to each OSP --------------- %%
figure('NumberTitle', 'on', 'Name', 'Linguistic Ratings of Different OSPs ')
% ------- R1: OSP-1 -----------%
set(gcf,'DefaulttextFontName','times new roman');
set(gcf,'DefaultaxesFontName','times new roman');
set(gcf,'DefaulttextFontAngle','italic');
set(gcf,'DefaulttextFontSize',12);
set(gcf,'DefaultlineLineWidth',1);
set(gcf,'DefaultaxesLineWidth',1);
subplot(4,1,1)
N=length(R1_Xs);
for i=1:N
    fill([UMFgauss_x(R1_Xs(i),2:1:end-1) LMFgauss_x(R1_Xs(i),len_alpha_cut(R1_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R1_Xs(i),len_alpha_cut(R1_Xs(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end

p=[];
for i=1:N
    if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end
    p(i)=plot([UMFgauss_x(R1_Xs(i),2:1:end-1) LMFgauss_x(R1_Xs(i),len_alpha_cut(R1_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R1_Xs(i),len_alpha_cut(R1_Xs(i))-1:-1:2)],pattern, 'linewidth',1.5);
    if R1_Xs(i) > 17
        text(MFs(R1_Xs(i),2)-0.3,1.2,  words(R1_Xs(i)-17,:));    % For Negated connotation  
    else
        text(MFs(R1_Xs(i),2)-0.3,1.2,  words(R1_Xs(i),:));    % For Positive connotation
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'x');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-1")

hL1= legend([p(1), p(2), p(3) ],'Cost','Time', 'Quality');
set(hL1,'Position', [0.9 0.94 0.02 0.02]);

% ------- R2 : (OSP-2) -----------%
subplot(4,1,2)
N=length(R2_Xs);
for i=1:N
    fill([UMFgauss_x(R2_Xs(i),2:1:end-1) LMFgauss_x(R2_Xs(i),len_alpha_cut(R2_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R2_Xs(i),len_alpha_cut(R2_Xs(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end
for i=1:N
    if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end
    plot([UMFgauss_x(R2_Xs(i),2:1:end-1) LMFgauss_x(R2_Xs(i),len_alpha_cut(R2_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R2_Xs(i),len_alpha_cut(R2_Xs(i))-1:-1:2)],pattern, 'linewidth',1.5)
    if R2_Xs(i) > 17
        text(MFs(R2_Xs(i),1), 1.2,  words(R2_Xs(i)-17,:));    % For Negated connotation
    else
        text(MFs(R2_Xs(i),1), 1.2, words(R2_Xs(i),:));   % For Positive connotation
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'x');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-2")

% ------- R3 : (OSP-3) -----------%
subplot(4,1,3)
N=length(R3_Xs);
for i=1:N
    fill([UMFgauss_x(R3_Xs(i),2:1:end-1) LMFgauss_x(R3_Xs(i),len_alpha_cut(R3_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R3_Xs(i),len_alpha_cut(R3_Xs(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on;
end
for i=1:N
    if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end    
    plot([UMFgauss_x(R3_Xs(i),2:1:end-1) LMFgauss_x(R3_Xs(i),len_alpha_cut(R3_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R3_Xs(i),len_alpha_cut(R3_Xs(i))-1:-1:2)], pattern, 'linewidth',1.5)
    if R3_Xs(i) > 17
        text(MFs(R3_Xs(i),1), 1.2, words(R3_Xs(i)-17,:));   % For Negated connotation
    else
        text(MFs(R3_Xs(i),1), 1.2, words(R3_Xs(i),:));   % For Positive connotation
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'x');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-3")

% ------- R4 : (OSP-4) -----------%
subplot(4,1,4)
N=length(R4_Xs);
for i=1:N
    fill([UMFgauss_x(R4_Xs(i),2:1:end-1) LMFgauss_x(R4_Xs(i),len_alpha_cut(R4_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R4_Xs(i),len_alpha_cut(R4_Xs(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on
end
for i=1:N
    if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end    
    plot([UMFgauss_x(R4_Xs(i),2:1:end-1) LMFgauss_x(R4_Xs(i),len_alpha_cut(R4_Xs(i))-1:-1:2)], [UMFgauss_y(2:1:end-1) LMFgauss_y(R4_Xs(i),len_alpha_cut(R4_Xs(i))-1:-1:2)], pattern, 'linewidth',1.5)
    if R4_Xs(i) > 17
        text(MFs(R4_Xs(i),1), 1.15, words(R4_Xs(i)-17,:));   % For Negated connotation
    else
        if i==1
            text(MFs(R4_Xs(i),2), 1.15, words(R4_Xs(i),:));  % Proper text display in graph
        else
            text(MFs(R4_Xs(i),1)+0.3, 1.15, words(R4_Xs(i),:));   % For Positive connotation
        end
    end
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'x');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-4")
saveas(gcf,'Linguistic_Ratings of Different OSPs.eps');
% --------------------------------------------------------------- %

%% --------- FIGURE FOR Students SUBJECTIVE WEIGHTS ------------------ %%
figure('NumberTitle', 'on', 'Name', 'Linguistic Weights of Students')
set(gcf,'DefaulttextFontName','times new roman');
set(gcf,'DefaultaxesFontName','times new roman');
set(gcf,'DefaulttextFontAngle','italic');
set(gcf,'DefaulttextFontSize',12);
set(gcf,'DefaultlineLineWidth',1);
set(gcf,'DefaultaxesLineWidth',1);

% For Student-1
subplot(3,1,1)
for i=1:N
    fill([wUMFgauss_x(R_Ws(i),2:1:end-1) wLMFgauss_x(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on
end
p=[];
for i=1:N
     if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end       
    p(i)=plot([wUMFgauss_x(R_Ws(i),2:1:end-1) wLMFgauss_x(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)],pattern, 'linewidth',1.5);
    text(w_MFs(R_Ws(i),1), 1.15, w_words(R_Ws(i),:));
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'w');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title('Student-1')

hL1= legend([p(1), p(2), p(3) ],'Cost','Time', 'Quality');
set(hL1,'Position', [0.9 0.93 0.02 0.02]);

%%%%%%%% For Displaying all other student's Linguistic Weights 
subplot(3,1,2)
R_Ws = [4,3,4];
for i=1:N
    fill([wUMFgauss_x(R_Ws(i),2:1:end-1) wLMFgauss_x(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on
end
for i=1:N
    if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end        
    plot([wUMFgauss_x(R_Ws(i),2:1:end-1) wLMFgauss_x(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)],pattern, 'linewidth',1.5)
    text(mean(w_MFs(R_Ws(i),1:2)), 1.15, w_words(R_Ws(i),:));
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'w');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title('Student-2')

subplot(3,1,3)
R_Ws = [5,1,2];
for i=1:N
    fill([wUMFgauss_x(R_Ws(i),2:1:end-1) wLMFgauss_x(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [0.9,0.9,0.9])
    hold on
end
for i=1:N
    if i==2
        pattern='--';
    elseif i==3
        pattern=':';
    else
        pattern='-';
    end        
    plot([wUMFgauss_x(R_Ws(i),2:1:end-1) wLMFgauss_x(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)], [wUMFgauss_y(2:1:end-1) wLMFgauss_y(R_Ws(i),wlen_alpha_cut(R_Ws(i))-1:-1:2)],pattern, 'linewidth',1.5)
    text(mean(w_MFs(R_Ws(i),1:2)), 1.15, w_words(R_Ws(i),:));
end
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'w');
text(-0.4,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title('Student-3')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveas(gcf,'Linguistic_Weights_for_students.eps');
% -------------------------------------------------------------------%



%% ------------- FIGURE LWA OUTPUT for a Student to different OSPs ------------------- %%

figure('NumberTitle', 'on', 'Name','LWA Output for a Student to different OSPs')

set(gcf,'DefaulttextFontName','times new roman');
set(gcf,'DefaultaxesFontName','times new roman');
set(gcf,'DefaulttextFontAngle','italic');
set(gcf,'DefaulttextFontSize',12);
set(gcf,'DefaultlineLineWidth',1);
set(gcf,'DefaultaxesLineWidth',1);

% For Student-1 LWA Ouput for R1 (OSP-1)
subplot(4,1,1)

[UMF_R1_R_LWA_x, UMF_R1_R_LWA_y] = umf_gauss(R1_R_LWA,n);
[LMF_R1_R_LWA_x, LMF_R1_R_LWA_y,len_R1_R_LWA_alpha_cut] = lmf_gauss(R1_R_LWA,n);

fill([UMF_R1_R_LWA_x(2:1:end-1) LMF_R1_R_LWA_x(len_R1_R_LWA_alpha_cut-1:-1:2)], [UMF_R1_R_LWA_y(2:1:end-1) LMF_R1_R_LWA_y(len_R1_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
plot([UMF_R1_R_LWA_x(2:1:end-1) LMF_R1_R_LWA_x(len_R1_R_LWA_alpha_cut-1:-1:2)], [UMF_R1_R_LWA_y(2:1:end-1) LMF_R1_R_LWA_y(len_R1_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5)
axis([0, 11, 0, 1.4]);
text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R1_R_LWA(1)+.3,1.2]);
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.3,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/10,0.5,[0 0 0],'-');
hold on
[R1_R_centroid, R1_R_left_centroid, R1_R_right_centroid] =g_centroidIT2(R1_R_LWA)  
plot([R1_R_left_centroid, R1_R_right_centroid], [0,0], 'linewidth', 3)            % Plot Centroid range
hold on
scatter([R1_R_centroid],[0], 'red', 'filled')   % Plot Centroid Point
title("OSP-1")

% For Student's LWA Ouput for R2 (OSP-2)
subplot(4,1,2)

[UMF_R2_R_LWA_x, UMF_R2_R_LWA_y] = umf_gauss(R2_R_LWA,n);
[LMF_R2_R_LWA_x, LMF_R2_R_LWA_y,len_R2_R_LWA_alpha_cut] = lmf_gauss(R2_R_LWA,n);

fill([UMF_R2_R_LWA_x(2:1:end-1) LMF_R2_R_LWA_x(len_R2_R_LWA_alpha_cut-1:-1:2)], [UMF_R2_R_LWA_y(2:1:end-1) LMF_R2_R_LWA_y(len_R2_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
plot([UMF_R2_R_LWA_x(2:1:end-1) LMF_R2_R_LWA_x(len_R2_R_LWA_alpha_cut-1:-1:2)], [UMF_R2_R_LWA_y(2:1:end-1) LMF_R2_R_LWA_y(len_R2_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5)
axis([0, 11, 0, 1.4]);
text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R2_R_LWA(1)+.2,1.2]);
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.3,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/10,0.5,[0 0 0],'-');
hold on
[R2_R_centroid, R2_R_left_centroid, R2_R_right_centroid] =g_centroidIT2(R2_R_LWA)  
plot([R2_R_left_centroid, R2_R_right_centroid], [0,0], 'linewidth', 3)            % Plot Centroid range
hold on
scatter([ R2_R_centroid],[0], 'red', 'filled')   % Plot Centroid End Points
title("OSP-2")

% For Student's LWA Ouput for R3 (OSP-3)
subplot(4,1,3)
[UMF_R3_R_LWA_x, UMF_R3_R_LWA_y] = umf_gauss(R3_R_LWA,n);
[LMF_R3_R_LWA_x, LMF_R3_R_LWA_y,len_R3_R_LWA_alpha_cut] = lmf_gauss(R3_R_LWA,n);

fill([UMF_R3_R_LWA_x(2:1:end-1) LMF_R3_R_LWA_x(len_R3_R_LWA_alpha_cut-1:-1:2)], [UMF_R3_R_LWA_y(2:1:end-1) LMF_R3_R_LWA_y(len_R3_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
plot([UMF_R3_R_LWA_x(2:1:end-1) LMF_R3_R_LWA_x(len_R3_R_LWA_alpha_cut-1:-1:2)], [UMF_R3_R_LWA_y(2:1:end-1) LMF_R3_R_LWA_y(len_R3_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5)
axis([0, 11, 0, 1.4]);
text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R3_R_LWA(2)+.2,1.2]);
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.3,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/10,0.5,[0 0 0],'-');
hold on
[R3_R_centroid, R3_R_left_centroid, R3_R_right_centroid] =g_centroidIT2(R3_R_LWA)  
plot([R3_R_left_centroid, R3_R_right_centroid], [0,0], 'linewidth', 3)            % Plot Centroid range
hold on
scatter([ R3_R_centroid],[0], 'red', 'filled')   % Plot Centroid End Points
title("OSP-3")

% For Student's LWA Ouput for OSP-4
subplot(4,1,4)
[UMF_R4_R_LWA_x, UMF_R4_R_LWA_y] = umf_gauss(R4_R_LWA,n);
[LMF_R4_R_LWA_x, LMF_R4_R_LWA_y,len_R4_R_LWA_alpha_cut] = lmf_gauss(R4_R_LWA,n);

fill([UMF_R4_R_LWA_x(2:1:end-1) LMF_R4_R_LWA_x(len_R4_R_LWA_alpha_cut-1:-1:2)], [UMF_R4_R_LWA_y(2:1:end-1) LMF_R4_R_LWA_y(len_R4_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
plot([UMF_R4_R_LWA_x(2:1:end-1) LMF_R4_R_LWA_x(len_R4_R_LWA_alpha_cut-1:-1:2)], [UMF_R4_R_LWA_y(2:1:end-1) LMF_R4_R_LWA_y(len_R4_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5)
axis([0, 11, 0, 1.4]);
text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R4_R_LWA(2)+.2,1.2]);
axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.3,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/10,0.5,[0 0 0],'-');
hold on
[R4_R_centroid, R4_R_left_centroid, R4_R_right_centroid] =g_centroidIT2(R4_R_LWA)  
plot([R4_R_left_centroid, R4_R_right_centroid], [0,0], 'linewidth', 3)            % Plot Centroid range
hold on
scatter([ R4_R_centroid],[0], 'red', 'filled')   % Plot Centroid End Points
title("OSP-4")

saveas(gcf,'LWA_Ouput_of_student_for_different_OSPs.eps');

cumulative_set_output= [R1_R_LWA, R1_R_left_centroid, R1_R_right_centroid, R1_R_centroid; R2_R_LWA, R2_R_left_centroid, R2_R_right_centroid, R2_R_centroid; R3_R_LWA, R3_R_left_centroid, R3_R_right_centroid, R3_R_centroid; R4_R_LWA, R4_R_left_centroid, R4_R_right_centroid, R4_R_centroid] 

%% JACCARD SIMILARITY Graph Plot 

figure('NumberTitle', 'on', 'Name','Best Recommended word overlap to LWA for a student ')
set(gcf,'DefaulttextFontName','times new roman');
set(gcf,'DefaultaxesFontName','times new roman');
set(gcf,'DefaulttextFontAngle','italic');
set(gcf,'DefaulttextFontSize',12);
set(gcf,'DefaultlineLineWidth',1);
set(gcf,'DefaultaxesLineWidth',1);

% Plotting student's best matching word with R1 (OSP-1)
subplot(4,1,1)
fill([UMF_R1_R_LWA_x(2:1:end-1) LMF_R1_R_LWA_x(len_R1_R_LWA_alpha_cut-1:-1:2)], [UMF_R1_R_LWA_y(2:1:end-1) LMF_R1_R_LWA_y(len_R1_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
[UMF_R1_R_max_x, UMF_R1_R_max_y] = umf_gauss(out_MFs(R1_R_index,:),n);
[LMF_R1_R_max_x, LMF_R1_R_max_y,len_R1_R_max_alpha_cut] = lmf_gauss(out_MFs(R1_R_index,:),n);
fill([UMF_R1_R_max_x(2:1:end-1) LMF_R1_R_max_x(len_R1_R_max_alpha_cut-1:-1:2)], [UMF_R1_R_max_y(2:1:end-1) LMF_R1_R_max_y(len_R1_R_max_alpha_cut-1:-1:2)], [0.9,0.9,0.9])

actual= plot([UMF_R1_R_LWA_x(2:1:end-1) LMF_R1_R_LWA_x(len_R1_R_LWA_alpha_cut-1:-1:2)], [UMF_R1_R_LWA_y(2:1:end-1) LMF_R1_R_LWA_y(len_R1_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5);
match=  plot([UMF_R1_R_max_x(2:1:end-1) LMF_R1_R_max_x(len_R1_R_max_alpha_cut-1:-1:2)], [UMF_R1_R_max_y(2:1:end-1) LMF_R1_R_max_y(len_R1_R_max_alpha_cut-1:-1:2)], '--', 'linewidth',2);

text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R1_R_LWA(2)+.5,1.2]); 
text(out_MFs(R1_R_index,1)-1.2,1.2 , R1_R_decode ) 

axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-1")

hL= legend([actual, match],'LWA Output','Best Recommended-Word');
set(hL,'Position', [0.8 0.94 0.02 0.02]);


% Plotting student's best matching word with R2 (OSP-2)
subplot(4,1,2)
fill([UMF_R2_R_LWA_x(2:1:end-1) LMF_R2_R_LWA_x(len_R2_R_LWA_alpha_cut-1:-1:2)], [UMF_R2_R_LWA_y(2:1:end-1) LMF_R2_R_LWA_y(len_R2_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
[UMF_R2_R_max_x, UMF_R2_R_max_y] = umf_gauss(out_MFs(R2_R_index,:),n);
[LMF_R2_R_max_x, LMF_R2_R_max_y,len_R2_R_max_alpha_cut] = lmf_gauss(out_MFs(R2_R_index,:),n);
fill([UMF_R2_R_max_x(2:1:end-1) LMF_R2_R_max_x(len_R2_R_max_alpha_cut-1:-1:2)], [UMF_R2_R_max_y(2:1:end-1) LMF_R2_R_max_y(len_R2_R_max_alpha_cut-1:-1:2)], [0.9,0.9,0.9])

actual= plot([UMF_R2_R_LWA_x(2:1:end-1) LMF_R2_R_LWA_x(len_R2_R_LWA_alpha_cut-1:-1:2)], [UMF_R2_R_LWA_y(2:1:end-1) LMF_R2_R_LWA_y(len_R2_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5);
match=  plot([UMF_R2_R_max_x(2:1:end-1) LMF_R2_R_max_x(len_R2_R_max_alpha_cut-1:-1:2)], [UMF_R2_R_max_y(2:1:end-1) LMF_R2_R_max_y(len_R2_R_max_alpha_cut-1:-1:2)],'--', 'linewidth',2);

text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R2_R_LWA(2)+.5,1.2]); 
text(out_MFs(R2_R_index,1)-1.2,1.2 , R2_R_decode ) 

axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-2")

% Plotting student's best matching word with R3 (OSP-3)
subplot(4,1,3)
fill([UMF_R3_R_LWA_x(2:1:end-1) LMF_R3_R_LWA_x(len_R3_R_LWA_alpha_cut-1:-1:2)], [UMF_R3_R_LWA_y(2:1:end-1) LMF_R3_R_LWA_y(len_R3_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
[UMF_R3_R_max_x, UMF_R3_R_max_y] = umf_gauss(out_MFs(R3_R_index,:),n);
[LMF_R3_R_max_x, LMF_R3_R_max_y,len_R3_R_max_alpha_cut] = lmf_gauss(out_MFs(R3_R_index,:),n);
fill([UMF_R3_R_max_x(2:1:end-1) LMF_R3_R_max_x(len_R3_R_max_alpha_cut-1:-1:2)], [UMF_R3_R_max_y(2:1:end-1) LMF_R3_R_max_y(len_R3_R_max_alpha_cut-1:-1:2)], [0.9,0.9,0.9])

actual= plot([UMF_R3_R_LWA_x(2:1:end-1) LMF_R3_R_LWA_x(len_R3_R_LWA_alpha_cut-1:-1:2)], [UMF_R3_R_LWA_y(2:1:end-1) LMF_R3_R_LWA_y(len_R3_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5);
match=  plot([UMF_R3_R_max_x(2:1:end-1) LMF_R3_R_max_x(len_R3_R_max_alpha_cut-1:-1:2)], [UMF_R3_R_max_y(2:1:end-1) LMF_R3_R_max_y(len_R3_R_max_alpha_cut-1:-1:2)],'--', 'linewidth',2);

text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R3_R_LWA(2)+.5,1.2]); 
text(out_MFs(R3_R_index,1)-1.2,1.2 , R3_R_decode ) 

axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-3")

% Plotting student's best matching word with R4 (OSP-4)
subplot(4,1,4)
fill([UMF_R4_R_LWA_x(2:1:end-1) LMF_R4_R_LWA_x(len_R4_R_LWA_alpha_cut-1:-1:2)], [UMF_R4_R_LWA_y(2:1:end-1) LMF_R4_R_LWA_y(len_R4_R_LWA_alpha_cut-1:-1:2)], [0.9,0.9,0.9])
hold on
[UMF_R4_R_max_x, UMF_R4_R_max_y] = umf_gauss(out_MFs(R4_R_index,:),n);
[LMF_R4_R_max_x, LMF_R4_R_max_y,len_R4_R_max_alpha_cut] = lmf_gauss(out_MFs(R4_R_index,:),n);
fill([UMF_R4_R_max_x(2:1:end-1) LMF_R4_R_max_x(len_R4_R_max_alpha_cut-1:-1:2)], [UMF_R4_R_max_y(2:1:end-1) LMF_R4_R_max_y(len_R4_R_max_alpha_cut-1:-1:2)], [0.9,0.9,0.9])

actual= plot([UMF_R4_R_LWA_x(2:1:end-1) LMF_R4_R_LWA_x(len_R4_R_LWA_alpha_cut-1:-1:2)], [UMF_R4_R_LWA_y(2:1:end-1) LMF_R4_R_LWA_y(len_R4_R_LWA_alpha_cut-1:-1:2)], 'linewidth',1.5);
match=  plot([UMF_R4_R_max_x(2:1:end-1) LMF_R4_R_max_x(len_R4_R_max_alpha_cut-1:-1:2)], [UMF_R4_R_max_y(2:1:end-1) LMF_R4_R_max_y(len_R4_R_max_alpha_cut-1:-1:2)],'--', 'linewidth',2);

text('Interpreter','latex','String','$$\widetilde{Y}_{LWA}$$','Position',[R4_R_LWA(2)+.5,1.2]); 
text(out_MFs(R4_R_index,1)-1.2,1.2 , R4_R_decode ) 

axis([0,11,0,1.4]);
set(gca,'xtick',[0:10]);
box off
text(11.2,0,'y');
text(0.2,1.33,'u');
arrow([0,0],[11,0],0.1,pi/10,0.5,[0 0 0],'-');
arrow([0,0.8],[0,1.4],0.1,pi/9,0.5,[0 0 0],'-');
title("OSP-4")

saveas(gcf,'Output_similarity.eps');


