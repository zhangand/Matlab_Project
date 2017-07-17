clear all;
close all;
clc;
img=imread('ng.tif');
BImg = im2bw(img, 100/255);
BImg = bwareaopen(BImg, 2000);
BImg = imclearborder(BImg);
J=edge(BImg,'Canny');
J = imclose(J,strel('disk', 5));
imshowpair(img,J);

[R cx cy]=max_inscribed_circle(im2uint8(J)); 
