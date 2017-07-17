clear all;
close all;
clc;
img=imread('ok_test.tif');
BImg = im2bw(img, 100/255);
BImg = bwareaopen(BImg, 2000);
BImg = imclearborder(BImg);
J=edge(BImg,'Canny');
J = imclose(J,strel('disk', 5));
% imshowpair(img,J);
imshowpair(BImg,J,'montage');
[R cx cy]=max_inscribed_circle(im2uint8(J)); 

status = regionprops(BImg,'Area','Centroid');

threshold =status.Area/(pi*R^2);
disp(threshold);
