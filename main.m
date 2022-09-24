clc;
clear all;
close all;

[filename pathname]=uigetfile('*.jpg;*.bmp','Select ref Image'); 
Background=imread(filename);
Background=imresize(Background,[187 340]);

[filename1 pathname]=uigetfile('*.jpg;*.bmp','Select Image'); 
CurrentFrame=imread(filename1);
CurrentFrame=imresize(CurrentFrame,[187 340]);
figure;
subplot(1,2,1);imshow(Background);title('ref');
subplot(1,2,2);imshow(CurrentFrame);title('Current Frame');

[Background_hsv]=round(rgb2hsv(Background));
[CurrentFrame_hsv]=round(rgb2hsv(CurrentFrame));
Out = bitxor(Background_hsv,CurrentFrame_hsv);
data=CurrentFrame;
Out=rgb2gray(Out);
grayimage=rgb2gray(data);
figure;
imshow(grayimage);

[rows columns]=size(Out);

for i=1:rows
for j=1:columns

if Out(i,j) >0

BinaryImage(i,j)=1;

else

BinaryImage(i,j)=0;

end

end
end
FilteredImage=medfilt2(BinaryImage,[5 5]);
figure;
imshow(FilteredImage);
title('filtered out')

[L num]=bwlabel(FilteredImage);

 K    = 8;                  
            bw   = 0.2;               
        SI   = 5;                  
        SX   = 6;                  
        r    = 1.5;                
        seg_Norm_cut = 0.21; 
        I=Background;
        seg_Area = 80;                
     cform = makecform('srgb2lab');
lab_he = applycform(CurrentFrame,cform);
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx, cluster_center] = hirear_clus(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
cluster_datq = cell(1,3);
rgb_label = repmat(pixel_labels,[1,1,3]);
for k = 1:nColors
    colors = data;
    colors(rgb_label ~= k) = 0;
    cluster_datq{k} = colors;
end
figure;
subplot(131);imshow(cluster_datq{1});title('Cluster 1');
subplot(132);imshow(cluster_datq{2});title('Cluster 2');
subplot(133);imshow(cluster_datq{3});title('Cluster 3');
STATS=regionprops(L,'all');
cc=[];
removed=0;

%Remove the noisy regions
for i=1:num
    
dd=STATS(i).Area;

if (dd < 500)

L(L==i)=0;
removed = removed + 1;
num=num-1;

else

end

end

[L2 num2]=bwlabel(L);

[B,L,N,A] = bwboundaries(L2);
figure;
subplot(1,2,1),  imshow(L2);title('BackGround Detected');
subplot(1,2,2),  imshow(L2);title('Blob Detected');

hold on;

for k=1:length(B),

if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);

for l=find(A(:,k))
boundary = B{l};
plot(boundary(:,2), boundary(:,1),'g','LineWidth',2);
end

end

end
BW2 = bwmorph(L2,'remove');
figure;
imshow(BW2);
title('boundary scaling');
BW1 = bwmorph(BW2,'skel',Inf);
figure;
imshow(BW1);
title('Skeleteon extraxt');
B = bwboundaries(BW1);
aaa=cluster_datq{:,1};
xx=match_features(aaa);
 BWl=complx_neurall(xx);

figure;
imshow(BW1)
text(10,10,strcat('\color{green}Objects Found:',num2str(length(B))))
hold on

for k = 1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 0.2)
end
title('Objects count');
 
