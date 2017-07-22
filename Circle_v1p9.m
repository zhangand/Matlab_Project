clear all;
close all;
clc;

% % maindir = uigetdir( 'Select Dictionary to Open' );
maindir='D:\SourceImage\test';
fullpath = fullfile( maindir, '*.tif' );
dat = dir( fullpath );              
fileID = fopen('D:\SourceImage\test\log.txt','w');
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
        if(Amp_img_sum)>1100)getfield
           movefile(datpath,'D:\SourceImage\test\ng'); 
           fprintf(fileID,'file %s,Amp is %s, threshold is %s, detect as ng\n',dat( j ).name,Amp_img_sum,0);
        else
            img_crop=edge(img_crop,'Sobel');
            fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
            fltr4img = fltr4img / sum(fltr4img(:));
            imgfltrd = filter2( fltr4img , img_crop );
            Img_flt = bwareaopen(imgfltrd,500);
            Img_flt = imclose(Img_flt,strel('disk',3));
            Img_fillhole = imfill(Img_flt,'hole');
%             imshow(Img_fillhole);
            status = regionprops(Img_fillhole,'Area','Centroid');
            if(isempty(status)||length(status)>1)
                movefile(datpath,'D:\SourceImage\test\ng'); 
                fprintf(fileID,'file %s,Amp is %s, threshold is %s, detect as ng\n',dat( j ).name,Amp_img_sum,0);
                continue;  
            else if(status.Area<45000)
                    movefile(datpath,'D:\SourceImage\test\ng');
                    fprintf(fileID,'file %s,Amp is %s, threshold is %s, detect as ng\n',dat( j ).name,Amp_img_sum,0);
                    continue;      
                end
            end

            UImg = edge(Img_fillhole,'Sobel');
            %imshow(UImg);
            [R]=max_inscribed_circle(UImg,0);
            threshold =status.Area/(pi*R^2);
            if(threshold<1.2)
               movefile(datpath,'D:\SourceImage\test\ok'); 
               fprintf(fileID,'file %s,Amp is %s, threshold is %s, detect as ok\n',dat( j ).name,Amp_img_sum,threshold);
            else
               movefile(datpath,'D:\SourceImage\test\ng'); 
               fprintf(fileID,'file %s,Amp is %s, threshold is %s, detect as ng\n',dat( j ).name,Amp_img_sum,threshold);
            end
        end
    end
end
fclose(fileID);