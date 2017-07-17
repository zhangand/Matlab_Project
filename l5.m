clear all;
close all;
clc;
img=imread('ng.tif');
[m n]=size(img);
BImg = im2bw(img, 100/255);
tic();
% fill a gap in the pen's cap
%create the circle with 5
% BImg = imclose(BImg,strel('disk', 3));
% BImg = bwareaopen(BImg, 2000);
% BImg = imclearborder(BImg);

J=edge(BImg,'Canny');
J = imclose(J,strel('disk', 3));
BImg = bwareaopen(BImg, 2000);
BImg = imclearborder(BImg);

% % imgn=zeros(m,n);        %??????
% % ed=[-1 -1;0 -1;1 -1;1 0;1 1;0 1;-1 1;-1 0]; %????????
% % for i=2:m-1
% %     for j=2:n-1
% %         if BImg(i,j)==1      %???????????
% %             for k=1:8
% %                 ii=i+ed(k,1);
% %                 jj=j+ed(k,2);
% %                 if BImg(ii,jj)==0    %????????????????????????
% %                     imgn(ii,jj)=1;
% %                 end
% %             end
% %             
% %         end
% %     end
% % end
% % 
% % 
% % imshowpair(imgn,J);


[R cx cy]=max_inscribed_circle(im2uint8(J)); 
