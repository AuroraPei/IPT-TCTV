function recImg = reconstruct_patch_ten(patchTen, img, patchSize, slideStep)
    [imgHei, imgWid] = size(img);  

    %% 
    rowPatchNum = ceil((imgHei - patchSize) / slideStep) + 1;  
    colPatchNum = ceil((imgWid - patchSize) / slideStep) + 1;
    rowPosArr = [1 : slideStep : (rowPatchNum * slideStep)];  
    colPosArr = [1 : slideStep : (colPatchNum * slideStep)];  

    %% for-loop version
    accImg = zeros(imgHei, imgWid);
    k = 0;
    % onesMat = ones(patchSize, patchSize);  

    for row = rowPosArr
        for col = colPosArr
            k = k + 1;
            tmpPatch = reshape(patchTen(:, :, k), [patchSize, patchSize]);       
            accImg(row : row + patchSize - 1, col : col + patchSize - 1) = tmpPatch;  
        end
    end
    recImg = accImg(1:imgHei, 1:imgWid);  
end
