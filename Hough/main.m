clc,clear all  
circleParaXYR=[];  
I = imread('ok_test.tif'); 
I=imcomplement(imcrop(I,[0 0 520 480]));
[m,n,l] = size(I);  
if l>1  
    I = rgb2gray(I);  
end  
BW = edge(I,'sobel');  
  
step_r = 3;  
step_angle = 1;  
minr = 120  
maxr = 150;  
thresh = 0.1;  
  
[hough_space,hough_circle,para] = hough_circle(BW,step_r,step_angle,minr,maxr,thresh);  
% figure(1),imshow(I),title('Source Image')  
% figure(2),imshow(BW),title('Boundary')  
figure(3),imshow(hough_circle),title('Hough Result')  
  
circleParaXYR=para;  
  
%Êä³ö  
fprintf(1,'\n---------------Circle Count----------------\n');  
[r,c]=size(circleParaXYR);
fprintf(1,'  Detect %d circle\n',r); 
fprintf(1,'  Center     Radius\n');  
for n=1:r  
fprintf(1,'%d (%d,%d)  %d\n',n,floor(circleParaXYR(n,1)),floor(circleParaXYR(n,2)),floor(circleParaXYR(n,3)));  
end  
  
%figure out circle 
figure(4),imshow(I),title('circle in the source image')  
hold on;  
 plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');  
 for k = 1 : size(circleParaXYR, 1)  
  t=0:0.01*pi:2*pi;  
  x=cos(t).*circleParaXYR(k,3)+circleParaXYR(k,2);y=sin(t).*circleParaXYR(k,3)+circleParaXYR(k,1);  
  plot(x,y,'r-');  
 end  
   
  
R_max=maxr;  
acu=zeros(R_max);  
stor =[];  
for j=1:R_max  
  for n=1:r  
   if  j == floor(circleParaXYR(n,3))  
       acu(j)= acu(j)+1;  
   end  
  end  
   stor=[stor;j,acu(j)];  
end  
 