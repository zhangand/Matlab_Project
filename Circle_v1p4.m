clear all;
close all;
clc;
% % img=imread('ok_test.tif');
% % BImg = im2bw(img, 100/255);
% % BImg = bwareaopen(BImg, 2000);
% % BImg = imclearborder(BImg);
% % J=edge(BImg,'Canny');
% % J = imclose(J,strel('disk', 5));
% % % imshowpair(img,J);
% % imshowpair(BImg,J,'montage');
% % [R cx cy]=max_inscribed_circle(im2uint8(J)); 
% % 
% % status = regionprops(BImg,'Area','Centroid');
% % 
% % threshold =status.Area/(pi*R^2);
% % disp(threshold);


maindir = uigetdir( 'Select Dictionary to Open' );

tic();
fullpath = fullfile( maindir, '*.tif' );
dat = dir( fullpath );               % ?????????tif???
if(~isempty(dat))
    for j = 1 : length( dat )
        datpath = fullfile( maindir,  dat( j ).name);
        img=imread(datpath);
%         imshow(img);
        BImg = im2bw(img, 100/255);
%         imshow(BImg);
        BImg = bwareaopen(BImg, 2000);
%         imshow(BImg);
        BImg = imclearborder(BImg);
%         imshow(BImg);
        status = regionprops(BImg,'Area','Centroid');
        if(isempty(status))
            movefile(datpath,'maindir\ng');
            continue;  
        else if(status.Area<10000)
               movefile(datpath,'maindir\ng');
               continue;      
            end
        end
        UImg=edge(BImg,'Canny');
        UImg = imclose(UImg,strel('disk', 10));         
%         imshowpair(BImg,UImg,'montage');

        [R cx cy]=max_inscribed_circle(im2uint8(UImg));
        threshold =status.Area/(pi*R^2);
        if(threshold<1.3)
           movefile(datpath,'D:\SourceImage\test\ok'); 
        else
           movefile(datpath,'D:\SourceImage\test\ng'); 
        end
    end
end

toc();