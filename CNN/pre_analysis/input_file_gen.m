clear;clc;

tic
name1='example';

a1=importdata(['~\example\',name1,'\',name1,'_aster.mat']);
linke=['~\example\',name1,'\'];
filename=[num2str(name1),'_theta'];
folder1=['~\example\\'];%folder for inputs

img_k1 = imread([linke,filename,'.tif'], 1); % read theta
img4=double(img_k1)/18000;

sx=256;sy=256;step=4;
s1=64;

%
[xq1,yq1]=meshgrid(1:1:size(img4,2),1:1:size(img4,1)); %resolution of interpolation
[xq2,yq2]=meshgrid(1:1:sx/step,1:1:sy/step); %resolution of interpolation

%


ir1=1;sx1=round(sy/2*1.42);
for iy=sx1+1:step:(size(img_k1,1)-sx1-1)
    for ix=sx1+1:step:(size(img_k1,2)-sx1-1)
     
     %if aster in the middle
     rd1=((ix-a1(:,5)).^2+(iy-a1(:,6)).^2)*pi-a1(:,1);
     
     if rand(1)>0.75 % 75 percent of data to train, rest to validation
        folder2='validation\';
     else
        folder2='train\';
     end
     
     if min(rd1)<0
        folder3='aster\';
     else
        folder3='noaster\';
        if rand(1)<0.9,continue;end %cases with noaster is much more than cases with asters
     end
     
     %flip
     dr1=rand(1);     
     if dr1>0.6667
         img4f=1-img4;
         img4f=flip(img4f,1); %flip y with x-axis as the axis
     elseif dr1>0.3333
         img4f=1-img4;
         img4f=flip(img4f,2); %flip x
     else
         img4f=img4;
     end
     
     %rotate
     dthe1=rand(1)*pi-pi/2;
     img4x=cos(img4f*pi+dthe1);
     img4y=sin(img4f*pi+dthe1);

     %img4n1=acos(img4x)/pi;
     img4n1=(atan(img4y./img4x)+pi/2)/pi;

     %dthe1=0;
     ix2=ix+cos(dthe1)*(xq2*step-0.5*sx)+sin(dthe1)*(-yq2*step+0.5*sy);
     iy2=iy+sin(dthe1)*(xq2*step-0.5*sx)+cos(dthe1)*(yq2*step-0.5*sy);
     [xq1,yq1]=meshgrid((ix-sx1):1:(ix+sx1),(iy-sx1):1:(iy+sx1)); %resolution of interpolation
     %tic
     img6=griddata(xq1,yq1,img4n1((iy-sx1):(iy+sx1),(ix-sx1):(ix+sx1)),ix2,iy2,'linear');
     %toc
     img6(isnan(img6))=0;
     %img6=img6+dthe1/pi;   

     %RESIZE
     %R = reshape(img6, 4, 64, 4, 64);
     %S = sum(sum(R, 1), 3) * 1/4^2;
     %img7 = reshape(S, 64, 64);
     
     %img7=img6;
     imwrite(img6, [folder1,folder2,folder3,name1,'_',num2str(ir1),'.png']);
     ir1=ir1+1;
     
    end
end

toc