clear all;clc;
IOrig=imread('hand_contour.png')
Igray=rgb2gray(IOrig);
[accum, circen, cirrad] = CircularHough_Grd(Igray, [250 300]);
imshow(Igray);
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'y-');
end
hold off;
disp('??????????');
cirrad
circen(:,1)
circen(:,2)
[m,n]=size(Igray);
Ibin=im2bw(Igray,graythresh(Igray));
Iedg=edge(Ibin,'canny');
Igray(:,:)=0;
Igray(find(Iedg))=255;
disp('???????????');
[R cx cy]=max_inscribed_circle(Igray)