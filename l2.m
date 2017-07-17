clc;
IOrig=imread('D:\SourceImage\ng\ng-20160906-173711.tif');
% % Igray=rgb2gray(IOrig);
Igray=IOrig;

% %middle value filter
Igray = medfilt2(Igray, [3, 3]);
Igray = im2bw(Igray, graythresh(Igray));

% fill a gap in the pen's cap
Igray = imclose(Igray,strel('disk', 5));
Igray = bwareaopen(Igray, 5000);
Igray = imclearborder(Igray);
Igray = imfill(Igray,'holes');

[accum, circen, cirrad] = CircularHough_Grd(IOrig, [80 150]);
imshowpair(IOrig,accum,'montage');
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'y-');
end
hold off;
disp('??????????');
cirrad;
circen(:,1)
circen(:,2)
[m,n]=size(Igray);
Ibin=im2bw(Igray,graythresh(Igray));
Iedg=edge(Ibin,'canny');
Igray(:,:)=0;
Igray(Iedg)=255;
disp('???????????');
[R, cx, cy]=max_inscribed_circle(Igray);


