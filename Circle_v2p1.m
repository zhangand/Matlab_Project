clc;
close all;

script_path = mfilename('fullpath');
i=strfind(script_path,'\');
script_path=script_path(1:i(end));
cd(script_path);

maindir = uigetdir('Select Picture Dictionary to Open' );
if(maindir==0)
    msgbox('No Folder Selected, Exit Program');
    return;
end

cd(maindir);

if ~exist('ok','dir')
  mkdir('ok');
end
if ~exist('ng','dir')
  mkdir('ng');
end

ok_path = fullfile( maindir, '\ok' );
ng_path = fullfile( maindir, '\ng' );
log_path= fullfile(maindir,'\log.txt');

fullpath = fullfile( maindir, '*.tif' );
dat = dir( fullpath );              
fileID = fopen(log_path,'w','n','UTF-8');
if(~isempty(dat))
    for j = 1 : length( dat )
        datpath = fullfile( maindir,  dat( j ).name);
        img=imread(datpath);
        img_crop=imcrop(img,[0 0 520 480]);
%         imshow(img_crop)
        img_fft_shift=fftshift(fft2(img_crop));  
        magnitude=log(1+abs(img_fft_shift));
        R_img_fft=real(img_fft_shift);                    
        I_img_fft=imag(img_fft_shift);                    
        Amp_img=sqrt(R_img_fft.^2+I_img_fft.^2);  
        Amp_img=(Amp_img-min(min(Amp_img)))/(max(max(Amp_img))-min(min(Amp_img)))*255;%???
        Amp_img_sum = sum(sum(im2bw(Amp_img, 50/255)));
        if(Amp_img_sum>1044)
           movefile(datpath,ng_path); 
           fprintf(fileID,'file %s, detect as ng\n',dat( j ).name);
           %%fprintf(fileID,'file %s, Amp is %.3f, threshold is %.3f, detect as ng\n',dat( j ).name,Amp_img_sum,0);
        else
            img_crop=edge(img_crop,'Roberts');
            fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
            fltr4img = fltr4img / sum(fltr4img(:));
            imgfltrd = filter2( fltr4img , img_crop );
            Img_flt = bwareaopen(imgfltrd,500);
            Img_flt = imclose(Img_flt,strel('disk',3));
            Img_fillhole = imfill(Img_flt,'hole');
%             imshowpair(Img_fillhole,img_crop,'montage');
            status = regionprops(Img_fillhole,'Area','Centroid');
            if(isempty(status)||length(status)>1)
                movefile(datpath,ng_path); 
                fprintf(fileID,'file %s, detect as ng\n',dat( j ).name);
                %%fprintf(fileID,'file %s, Amp is %.3f, threshold is %.3f, detect as ng\n',dat( j ).name,Amp_img_sum,0);
                continue;  
            else if(status.Area<45000)
                    movefile(datpath,ng_path);
                    fprintf(fileID,'file %s, detect as ng\n',dat( j ).name);
                    %%fprintf(fileID,'file %s, Amp is %.3f, threshold is %.3f, detect as ng\n',dat( j ).name,Amp_img_sum,0);
                    continue;      
                end
            end

            UImg = edge(Img_fillhole,'Sobel');
            UImg = imclose(UImg,strel('disk',3));
            UImg = imclearborder(UImg);
            %imshow(UImg);
            [R]=max_inscribed_circle(UImg,0);
            threshold =status.Area/(pi*R^2);
            if(threshold<1.2)
               movefile(datpath,ok_path); 
               fprintf(fileID,'file %s,detect as ok\n',dat( j ).name);
            else
               movefile(datpath,ng_path); 
               fprintf(fileID,'file %s, detect as ng\n',dat( j ).name);
               %%fprintf(fileID,'file %s, Amp is %.3f, threshold is %.3f, detect as ng\n',dat( j ).name,Amp_img_sum,threshold);
            end
        end
    end
end
fclose('all');
msgbox('Image Processing Finished');