

function outImg = subfun(inImg, peaks, window, groups)

s = size(inImg);

para_data = peaks * peaks * peaks;
divis = 256 / peaks ;

s=size(inImg);
N=window;

n=(N-1)/2;
r=s(1)+2*n;
c=s(2)+2*n;
double residual_data(r,c,3);
residual_data=zeros(r,c,3);out=zeros(r,c,3);
coarseImg = zeros(r,c);
TabLabel = zeros(1,para_data);
inrImg = rgb2gray(inImg);

residual_data((n+1):(end-n),(n+1):(end-n),1)=inImg(:,:,1);
residual_data((n+1):(end-n),(n+1):(end-n),2)=inImg(:,:,2);
residual_data((n+1):(end-n),(n+1):(end-n),3)=inImg(:,:,3);

residual_data_color = residual_data;
for x=n+1:s(1)+n
    for y=n+1:s(2)+n
        e=1;
        for k=x-n:x+n
            f=1;
            for l=y-n:y+n
                mat(e,f,1)=residual_data(k,l,1);
                mat(e,f,2)=residual_data(k,l,2);
                mat(e,f,3)=residual_data(k,l,3);
                f=f+1;
            end
            e=e+1;
        end

        sum_lab = 0;
        for i = 1 : window
            for j = 1 : window
                lab = floor(mat(i,j,1)/divis)*(peaks*peaks);
                lab = lab + floor(mat(i,j,2)/divis)*(peaks);
                lab = lab + floor(mat(i,j,3)/divis);
                lab = lab + 1;
                TabLabel(lab) = TabLabel(lab) + 1;
                sum_lab = sum_lab + lab;
            end
        end
        coarseImg(x,y) = floor(sum_lab / (window * window));

    end
end
trunCoarseImg(:,:) = coarseImg((n+1):(end-n),(n+1):(end-n));

residual_dataVar = trunCoarseImg(:,:);
inImg_1D = double(residual_dataVar(:));
fusedMap = kmeans(inImg_1D,groups, 'EmptyAction', 'singleton');
fusedMapShow = uint8(fusedMap.*(255/groups));
outImg = reshape(fusedMapShow,s(1),s(2));