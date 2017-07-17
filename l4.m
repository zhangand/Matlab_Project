RawImage=imread('ng.tif');
% RawImage=imread('hand_contour1.png');

% get the contour
sz=size(RawImage);

IbImg = medfilt2(RawImage, [3, 3]);
IbImg = im2bw(IbImg, graythresh(IbImg));

% fill a gap in the pen's cap
IbImg = imclose(IbImg,strel('disk', 5));
IbImg = bwareaopen(IbImg, 5000);
IbImg = imclearborder(IbImg);

IbImg1=~imclearborder(IbImg,8);
IbImg1=IbImg1+IbImg;
imshowpair(IbImg,IbImg1,'montage');

% imshowpair(RawImage,IbImg,'montage');

GImg =255 * uint8(IbImg);
imshowpair(RawImage,GImg,'montage');

[R cx cy]=max_inscribed_circle(GImg);