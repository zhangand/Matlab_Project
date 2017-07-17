clear all;
close all;
clc;

% % maindir = uigetdir( 'Select Dictionary to Open' );
maindir='D:\SourceImage\test';
fullpath = fullfile( maindir, '*.tif' );
dat = dir( fullpath );               % ?????????tif???
if(~isempty(dat))
    for j = 1 : length( dat )
        datpath = fullfile( maindir,  dat( j ).name);
        img=imread(datpath);
        img_crop=imcrop(img,[0 0 520 480]);
%         imshow(img_crop)
        img_fft=fft2(img_crop);                     
        img_fft_shift=fftshift(img_fft);              
        R_img_fft=real(img_fft_shift);                    
        I_img_fft=imag(img_fft_shift);                    
        Amp_img=sqrt(R_img_fft.^2+I_img_fft.^2);  
        Amp_img=(Amp_img-min(min(Amp_img)))/(max(max(Amp_img))-min(min(Amp_img)))*255;%???
        Amp_img_sum = sum(sum(im2bw(Amp_img, 50/255)));
        if(Amp_img_sum>1200)
           movefile(datpath,'D:\SourceImage\test\ng'); 
        else
            BImg = im2bw(img_crop, 100/255);
            BImg = bwareaopen(BImg, 2000);
            BImg = imclearborder(BImg);
%             imshow(BImg);
            status = regionprops(BImg,'Area','Centroid');
            if(isempty(status))
                movefile(datpath,'D:\SourceImage\test\ng'); 
                continue;  
            else if(status.Area<45000)
                   movefile(datpath,'D:\SourceImage\test\ng');
                   continue;      
                end
            end
            UImg=edge(BImg,'Canny');
            UImg = imclose(UImg,strel('disk', 10));         
            [R cx cy]=max_inscribed_circle(im2uint8(UImg));
            threshold =status.Area/(pi*R^2);
            if(threshold<1.3)
               movefile(datpath,'D:\SourceImage\test\ok'); 
            else
               movefile(datpath,'D:\SourceImage\test\ng'); 
            end
        end
    end
end
