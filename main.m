%% Written by Liu Pei 
addpath('functions\');  
addpath('tools\');
imgDir = '.\images\';  
resDirT= '.\results\T\';  
resDirB= '.\results\B\';

if ~exist(resDirT)  || ~exist(resDirB)
    mkdir(resDirT);
    mkdir(resDirB);
end

%% parameters
patchSize = 60;
slideStep = 60;
L =   1.2;
opts.lambdaL = 12; 
opts.betaL   = 3;
opts.tol = 1e-2;       %迭代终止的误差门限
opts.max_iter = 500;   %最大迭代次数
opts.tau = 3;          %截断参数
opts.rho = 1.05;       %mu的系数
opts.mu =  1e-3;       %mu是正则项的惩罚参数    
opts.max_mu = 1e10;    
opts.ratio = 0;        
opts.DEBUG = 0;        
DISP = 1;              
p = 2;                 %前后帧数量

if ~exist('params', 'var')  
    params = [];
end  
time = [];

%% Load Image
img_path_list = dir([imgDir, '*.bmp']);
imgName = sort_nat({img_path_list.name});
imgNum = length(img_path_list);

for i = 1:imgNum  
    newname = fullfile(imgDir, imgName{i});  
    img = imread(newname);  

% rgb2gray
    nn = ndims(img); 
    if nn == 3 
       img = rgb2gray(img);   
    end
    D(:,:,i) = double(img); 
end    
[m,n,~] = size(D);

groupNum=2*p+1;
%% Main Loop
for i = 1:groupNum:imgNum
    tic; 
%% construct spatial-temporal tensor
    gNum = min(groupNum, imgNum-i+1); 
    tarSave = zeros(m,n,gNum);  
    disp(['Loading Image：' num2str(i) '.bmp' ' ~ ' num2str(i+gNum-1) '.bmp ']);
    
    Dpart = D(:,:,i:(i+gNum-1));    
    pad_D = padd(Dpart, slideStep);  
    
    tenD = gen_patch_ten(pad_D, patchSize, slideStep, gNum);     %3-D sliding window 
%% low-rank and sparse recovery
    Nway = size(tenD);
    temp_tenB_k = zeros(patchSize,patchSize,Nway(4),gNum);  
    temp_tenT_k = zeros(patchSize,patchSize,Nway(4),gNum); 
    
    for k = 1:Nway(4)      
        tenD_k = tenD(:,:,:,k);  

        %% The proposed model
        lambda = L / sqrt(max(Nway(1),Nway(2)) * Nway(3));     
        [tenB,tenT] = TCTV_TRPCA3_E_l21(tenD_k, opts);     
        
        for t=1:gNum
            temp_tenB_k(:,:,k,t) = tenB(patchSize+1:patchSize*2, patchSize+1:patchSize*2, t); 
            temp_tenT_k(:,:,k,t) = tenT(patchSize+1:patchSize*2, patchSize+1:patchSize*2, t); 
        end          
    end     
 
    for jj=1:gNum
        tenB_k = temp_tenB_k(:,:,:,jj);  
        tenT_k = temp_tenT_k(:,:,:,jj);  
       
       %% Recover the target and background image
        backImg = reconstruct_patch_ten(tenB_k, Dpart(:,:,jj), patchSize, slideStep); 
        tarImg  = reconstruct_patch_ten(tenT_k, Dpart(:,:,jj), patchSize, slideStep);      
       
        tempImg = Dpart(:,:,jj);  
        maxv = max(tempImg(:));  
        Background = uint8( mat2gray(backImg)*maxv );  
        Target = uint8( mat2gray(tarImg)*maxv );
             
        %% Disp
        if DISP
            figure;
            subplot(131), imshow(Dpart(:,:,jj),[]),  title('Original image');    
            subplot(132), imshow(Background,[]),     title('Background image');  
            subplot(133), imshow(Target,[]),         title('Target image');                 

            % 3D map display
            [X, Y] = meshgrid(1:n, 1:m);
            figure;
            dTarget = double(Target);
            dTarget = dTarget .* (dTarget>0);  
            Target_3D = mesh(X, Y, dTarget);
            xlim([1, n]),ylim([1, m]);
            grid on            
        end

        %% Save the results
        imwrite(Target, fullfile(resDirT,imgName{i+jj-1}));  
        imwrite(Background, fullfile(resDirB,imgName{i+jj-1}));
    end
    
    toc;
    time(end +1)=toc;  
end
timeAvg = time/groupNum;
disp(['平均处理每帧图像的计算时间：' num2str(timeAvg) '秒']);
% params = struct('patchSize',patchSize, 'slideStep',slideStep, 'tol',opts.tol, 'mu',opts.mu, 'max_mu',opts.max_mu, 'max_iter',opts.max_iter, 'rho',opts.rho, 'time',time);  
% save([matDir, 'params.mat'])  