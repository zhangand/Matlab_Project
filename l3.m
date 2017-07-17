clear all;clc;
IOrig1=imread('D:\SourceImage\mixed\good-20160901-104830.tif');
IOrig2=imread('test.jpg');
imshowpair(IOrig1,IOrig2,'montage');

Igray1=IOrig1;
Igray2=rgb2gray(IOrig2);
imshowpair(Igray1,Igray2,'montage');

[accum1, circen1, cirrad1] = CircularHough_Grd(Igray1, [50 150]);
[accum2, circen2, cirrad2] = CircularHough_Grd(Igray2, [50 150]);

imshowpair(circen1,circen2,'montage');

imshow(Igray);
hold on;
plot(circen(:,1), circen(:,2), 'w+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'w-');
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