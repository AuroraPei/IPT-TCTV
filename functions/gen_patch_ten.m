%---- spatial-temporal model construction by a 3D sliding window ----
function tenD = gen_patch_ten(img, patchSize, slideStep, gNum)
if ~exist('patchSize', 'var')
    patchSize = 50;
end

if ~exist('slideStep', 'var')
    slideStep = 10;
end

%% Part One --  Calculate
[imgHei, imgWid,n3] = size(img); 

rowPatchNum = ceil((imgHei - patchSize) / slideStep) + 1;  
colPatchNum = ceil((imgWid - patchSize) / slideStep) + 1;

rowPosArr = [1 : slideStep : (rowPatchNum - 1) * slideStep, imgHei - patchSize + 1]; 
colPosArr = [1 : slideStep : (colPatchNum - 1) * slideStep, imgWid - patchSize + 1];

%% Part Two --Generate patchTen
patchTen = zeros(patchSize, patchSize, rowPatchNum * colPatchNum,n3);  
for i=1:n3  
     k = 0;
     for row = rowPosArr
         for col = colPosArr
             k = k + 1;
             tmp_patch = img(row : row + patchSize - 1, col : col + patchSize - 1,i);  
             patchTen(:, :, k,i) = tmp_patch;  
         end
     end
end

%% Part Three -- Generate Patch Center
square_arr=[];  
for i=1:rowPatchNum-2  
    centerNumberList=i*colPatchNum+2:(i+1)*colPatchNum-1;  
    square_arr=[square_arr centerNumberList]; 
end

%% Part Four -- Generate Spatial-Temporal: tenD
kk=1;  
% total=9*gNum;
for k=square_arr   
    for jj=1:n3   
        D1=patchTen(:,:,k-colPatchNum-1,jj);
        D2=patchTen(:,:,k-colPatchNum,jj);
        D3=patchTen(:,:,k-colPatchNum+1,jj);
        D4=patchTen(:,:,k-1,jj);
        D5=patchTen(:,:,k,jj);
        D6=patchTen(:,:,k+1,jj);
        D7=patchTen(:,:,k+colPatchNum-1,jj);
        D8=patchTen(:,:,k+colPatchNum,jj);
        D9=patchTen(:,:,k+colPatchNum+1,jj);
        
        D(:,:,jj)=[D1 D2 D3; D4 D5 D6; D7 D8 D9];  
    end

    tenD(:,:,:,kk)=D;  %output   
    kk=kk+1;  
end   
