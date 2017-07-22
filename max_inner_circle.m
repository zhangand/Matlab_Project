
function [R cx cy]=max_inner_circle(ContourImage,display)

% get the contour
sz=size(ContourImage);
Img_dist=bwdist(logical(ContourImage));
[Mx, My]=meshgrid(100:sz(2), 100:sz(1));

[B,L] = bwboundaries(ContourImage,'holes');
% % [Y,X]=find(ContourImage==255,1, 'first');
% % contour = bwtraceboundary(ContourImage, [Y(1), X(1)], 'W', 8);
% % X=contour(:,2);
% % Y=contour(:,1);
for k = 1:length(B)
    boundary = B{k};
    [Vin Von]=inpoly([Mx(:),My(:)],[boundary(:,2),boundary(:,1)]);
    ind=sub2ind(sz, My(Vin),Mx(Vin));
    [R RInd]=max(Img_dist(ind)); 
    [cy cx]=ind2sub(sz, ind(RInd));
    
end
% find the maximum inscribed circle:
% The point that has the maximum distance inside the given contour is the
% center. The distance of to the closest edge (tangent edge) is the radius.
% % % % display result
if (~exist('display','var'))
    display=1;
end
if (display)
    Img_dist(cy,cx)=R+20; % to emphasize the center
    figure,imshow(Img_dist,[]);
    hold on
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    theta = [linspace(0,2*pi) 0];
    hold on
    plot(cos(theta)*R+cx,sin(theta)*R+cy,'color','g','LineWidth', 2);
end

end
