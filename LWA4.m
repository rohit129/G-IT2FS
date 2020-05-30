function YLWA = LWA4(XL,WL,n)

[UMFgauss_x, UMFgauss_y] = umf_gauss(XL,n);
[LMFgauss_x, LMFgauss_y,len_alpha_cut] = lmf_gauss(XL,n);
X_it2fs_umf = [UMFgauss_x ; UMFgauss_y];
X_it2fs_lmf = [LMFgauss_x ; LMFgauss_y];
X_it2fs_alpha_cut_lmf= len_alpha_cut;

[wUMFgauss_x, wUMFgauss_y] = umf_gauss(WL,n);
[wLMFgauss_x, wLMFgauss_y,wlen_alpha_cut] = lmf_gauss(WL,n);
W_it2fs_umf = [wUMFgauss_x; wUMFgauss_y];
W_it2fs_lmf = [wLMFgauss_x; wLMFgauss_y];
W_it2fs_alpha_cut_lmf= wlen_alpha_cut;

[YLWA,yUMF,muUMF, yLMF,muLMF]= g_LWA(X_it2fs_umf,X_it2fs_lmf, X_it2fs_alpha_cut_lmf,  W_it2fs_umf, W_it2fs_lmf, W_it2fs_alpha_cut_lmf, n);
