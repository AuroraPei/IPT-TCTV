function ImgPadd= padd(img,patchSize)
%UNTITLED3 此处显示有关此函数的摘要
%padd作用：扩充图像
%输入：5帧图像，[imgHei, imgWid, 5]
%输出：5帧图像，[imgHei+2ps, imgWid+2ps, 5]

%% 图像扩充
ImgPadd=padarray(img,[patchSize patchSize],'symmetric','both');  %以数据对称的形式，分别对第一、二个维度（即行、列）扩充patchSize大小的数值，默认填充0，此处填充对称copy的值。tensor每层都要扩充。
%disp(ImgPadd);  %disp
%{
[n1,n2,n3]=size(ImgPadd);
disp(['Size of ImgPadd：' 'n1=' num2str(n1) '  n2=' num2str(n2) '  n3=' num2str(n3)]);  %disp
for i = 1:n3
    I1=ImgPadd(:,1:patchSize,i);
    I1=flip(I1,2);  %原图像的垂直镜像（左右翻转），在第二个维度上对前patchSize列的全部元素进行对称翻转
    I2=ImgPadd(:,n2-patchSize+1:n2,i);  
    I2=flip(I2,2);  %原图像的垂直镜像（左右翻转），在第二个维度上对后patchSize列的全部元素进行对称翻转
    I3=ImgPadd(1:patchSize,:,i);
    I3=flip(I3,1);  %原图像的水平镜像（上下翻转），在第一个维度上对前patchSize行的全部元素进行对称翻转
    I4=ImgPadd(n1-patchSize+1:n1,:,i);
    I4=flip(I4,1);  %原图像的水平镜像（上下翻转），在第一个维度上对后patchSize行的全部元素进行对称翻转
    
    %把翻转后的元素放回原位置
    ImgPadd(:,1:patchSize,i)=I1;  
    ImgPadd(:,n2-patchSize+1:n2,i)=I2;
    ImgPadd(1:patchSize,:,i)=I3;
    ImgPadd(n1-patchSize+1:n1,:,i)=I4;
end
%}

%Old code for backup
[n1,n2,n3]=size(ImgPadd);
disp(['Size of ImgPadd：' 'n1=' num2str(n1) '  n2=' num2str(n2) '  n3=' num2str(n3)]);  %disp
I1=ImgPadd(:,1:patchSize);
I1=flip(I1,2);  %原图像的垂直镜像，在第二个维度上对前patchSize列的全部元素进行对称翻转
I2=ImgPadd(:,n2-patchSize+1:n2);  
I2=flip(I2,2);  %原图像的垂直镜像，在第二个维度上对后patchSize列的全部元素进行对称翻转
I3=ImgPadd(1:patchSize,:);
I3=flip(I3,1);  %原图像的水平镜像，在第一个维度上对前patchSize行的全部元素进行对称翻转
I4=ImgPadd(n1-patchSize+1:n1,:);
I4=flip(I4,1);  %原图像的水平镜像，在第一个维度上对后patchSize行的全部元素进行对称翻转
%把镜像后的元素放回原位置
ImgPadd(:,1:patchSize)=I1;  
ImgPadd(:,n2-patchSize+1:n2)=I2;
ImgPadd(1:patchSize,:)=I3;
ImgPadd(n1-patchSize+1:n1,:)=I4;

end

