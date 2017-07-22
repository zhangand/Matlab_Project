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
        else
            img_crop=edge(img_crop,'Sobel');
            fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
            fltr4img = fltr4img / sum(fltr4img(:));
            imgfltrd = filter2( fltr4img , img_crop );
            Img_flt = bwareaopen(imgfltrd,500);
            Img_flt = imclose(Img_flt,strel('disk',3));
            Img_fillhole = imfill(Img_flt,'hole');
            imshowpair(img_crop,Img_fillhole,'montage');
            status = regionprops(Img_fillhole,'Area','Centroid');
            if(isempty(status))
                movefile(datpath,'D:\SourceImage\test\ng'); 
                continue;  
            else if(status.Area<45000)
                   movefile(datpath,'D:\SourceImage\test\ng');
                   continue;      
                end
            end      
            [R]=max_inscribed_circle(Img_fillhole);
            threshold =status.Area/(pi*R^2);
            if(threshold<1.255)
               movefile(datpath,'D:\SourceImage\test\ok'); 
            else
               movefile(datpath,'D:\SourceImage\test\ng'); 
            end
        end
    end
end
