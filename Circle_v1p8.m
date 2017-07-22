clear all;
close all;
clc;

% % maindir = uigetdir( 'Select Dictionary to Open' );
maindir='D:\SourceImage\test';
fullpath = fullfile( maindir, '*.tif' );
dat = dir( fullpath );               % ?????????tif???
fileID = fopen('D:\SourceImage\test\log.txt','w');
if(~isempty(dat))
    for j = 1 : length( dat )
        datpath = fullfile( maindir,  dat( j ).name);
        img=imread(datpath);
        img_crop=imcomplement(imcrop(img,[0 0 520 480]));
%         imshow(img_crop);
        img_fft=fft2(img_crop);                     
        img_fft_shift=fftshift(img_fft);              
        R_img_fft=real(img_fft_shift);                    
        I_img_fft=imag(img_fft_shift);                    
        Amp_img=sqrt(R_img_fft.^2+I_img_fft.^2);  
        Amp_img=(Amp_img-min(min(Amp_img)))/(max(max(Amp_img))-min(min(Amp_img)))*255;%???
        Amp_img_sum = sum(sum(im2bw(Amp_img, 50/255)));
        if(Amp_img_sum>1150)
           movefile(datpath,'D:\SourceImage\test\ng'); 
           threshold =0;
        else
%             BImg = im2bw(img_crop, 100/255);
            BImg = bwareaopen(img_crop, 2000);
            BImg = imclearborder(BImg);
%           imshow(BImg);
            status = regionprops(BImg,'Area','Centroid');
            if(isempty(status)|length(status)>1)
                movefile(datpath,'D:\SourceImage\test\ng'); 
                fprintf(fileID,'file %s,Amp is %s, threshold is %s\n',datpath,0,0);
                continue;  
            else if(status.Area<45000)
                   movefile(datpath,'D:\SourceImage\test\ng');
                   fprintf(fileID,'file %s,Amp is %s, threshold is %s\n',datpath,0,0);
                   continue;      
                end
            end
            UImg=edge(BImg,'Canny');
            UImg = imclose(UImg,strel('disk', 10));         
            [R]=max_inscribed_circle(im2uint8(UImg),0);
            threshold =status.Area/(pi*R^2);
            if(threshold<1.2)
               movefile(datpath,'D:\SourceImage\test\ok'); 
            else
               movefile(datpath,'D:\SourceImage\test\ng'); 
            end
        end
        fprintf(fileID,'file %s,Amp is %s, threshold is %s\n',datpath,Amp_img_sum,threshold);
    end
end
fclose(fileID);