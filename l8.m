clear all;clc;
IOrig=imread('ok_test.tif');
Igray=imcomplement(imcrop(IOrig,[0 0 520 480]));

 fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
 fltr4img = fltr4img / sum(fltr4img(:));
 imgfltrd = filter2( fltr4img , Igray );

 [accum, circen, cirrad] = CircularHough_Grd(imgfltrd, [120 130], 8, 10);

imshow(imgfltrd);
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
Igray(find(Iedg))=255;
disp('???????????');
[R cx cy]=max_inscribed_circle(Igray)