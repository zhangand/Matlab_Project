clear all;
close all;
clc;

maindir = uigetdir( 'Select Dictionary to Open' );
fullpath = fullfile( maindir, '*.tif' );
dat = dir( fullpath );               % ?????????tif???
if(~isempty(dat))
    for j = 1 : length( dat )
        datpath = fullfile( maindir,  dat( j ).name);
        img=imread(datpath);
        img_crop=imcrop(img,[0 0 520 480]);
        img_fft=fft2(img_crop);                       %?????????
        img_fft_shift=fftshift(img_fft);              %??????????
        R_img_fft=real(img_fft_shift);                    %?????????
        I_img_fft=imag(img_fft_shift);                    %?????????
        Amp_img=sqrt(R_img_fft.^2+I_img_fft.^2);             %??????
        Amp_img=(Amp_img-min(min(Amp_img)))/(max(max(Amp_img))-min(min(Amp_img)))*225;%???
        Amp_img_sum = sum(sum(im2bw(Amp_img, 50/255)));
% % %         imshow(img);
% %         BImg = im2bw(img, 100/255);
% % %         imshow(BImg);
% %         BImg = bwareaopen(BImg, 2000);
% % %         imshow(BImg);
% %         BImg = imclearborder(BImg);
% % %         imshow(BImg);
% %         status = regionprops(BImg,'Area','Centroid');
% %         if(isempty(status))
% %             movefile(datpath,'maindir\ng');
% %             continue;  
% %         else if(status.Area<10000)
% %                movefile(datpath,'maindir\ng');
% %                continue;      
% %             end
% %         end
% %         UImg=edge(BImg,'Canny');
% %         UImg = imclose(UImg,strel('disk', 10));         
% % %         imshowpair(BImg,UImg,'montage');
% % 
% %         [R cx cy]=max_inscribed_circle(im2uint8(UImg));
% %         threshold =status.Area/(pi*R^2);
% %         if(threshold<1.3)
% %            movefile(datpath,'D:\SourceImage\test\ok'); 
% %         else
% %            movefile(datpath,'D:\SourceImage\test\ng'); 
% %         end
        imshow(img);
        imshow(im2bw(Amp_img, 50/255));
        if(Amp_img_sum<1200)
           movefile(datpath,'D:\SourceImage\test\ok'); 
        else
           movefile(datpath,'D:\SourceImage\test\ng'); 
        end
    end
end
