clear;clc;
close all;
step1=16;tf=17;

s1=importdata(['~\PIV_track\PIV_t','1-3','.txt']);
[xq2,yq2,tt2]=meshgrid(24:step1:1240,24:step1:1816,1:tf); %resolution of interpolation  
vqx2=xq2-xq2;vqy2=xq2-xq2;
for t2=2:tf
  
for t1=2:t2 %t1=5,8,12 for t=20s,35s, and 55s
s2=importdata(['~\PIV_track\PIV_t',num2str(t1-1),'-',num2str(t1+1),'.txt']);
s1(:,3:4)=s1(:,3:4)+s2(:,3:4);
end

%%%%% interporate to get the velocity field
x1=s1(:,1);y1=s1(:,2);u1=s1(:,3);v1=s1(:,4);%SS1=s1(:,8);
um1=mean(u1);uvar1=var(u1);vm1=mean(v1);vvar1=var(v1);


[xq1,yq1]=meshgrid(min(x1):step1:max(x1),min(y1):step1:max(y1)); %resolution of interpolation
vqx1=griddata(x1,y1,u1,xq1,yq1,'linear');vqy1=griddata(x1,y1,v1,xq1,yq1,'linear');
vqx1(vqx1>(um1+3*uvar1))=0;vqx1(vqx1<(um1-3*uvar1))=0;
vqy1(vqy1>(vm1+3*vvar1))=0;vqy1(vqy1<(vm1-3*vvar1))=0;
%smooth
vqx1=imgaussfilt(vqx1,1);%for curl
vqy1=imgaussfilt(vqy1,1);%for curl
vqx2(:,:,t2)=vqx1;vqy2(:,:,t2)=vqy1;


%figure(2)

%hold on
%axis square
%pbaspect([max(x1) max(y1) 1])
%set(gca,'YDir','reverse')
%xlim([0 1266])
%ylim([0 1849]

%%%%%%%%%%%
[curlz1,cav1] = curl(xq1,yq1,vqx1,vqy1);
%figure(2)
%hold on
%smooth data
%curlz2=smoothdata(curlz1,2,'movmean',20);

%colormap("jet")
step2=5;
%[xq2,yq2]=meshgrid(min(x1):step2:max(x1),min(y1):step2:max(y1)); %resolution of interpolation
%curlz2=griddata(xq1,yq1,-curlz1,xq2,yq2,'linear');
%curlz3=imgaussfilt(curlz2,5);%for curl
%h1=pcolor(xq2,yq2,curlz3);

colorscheme=othercolor('PRGn7',101);
%set(gcf,'Colormap',colorscheme);

%streamline field
%h_slice=streamslice(xq1,yq1,vqx1,vqy1,30,'arrows');%local
%set(h_slice,'Color','k','LineWidth',1);
%set(gca,'YDir','reverse')
%set(h1,'Edgecolor','none')
%xlim([600 800])
%ylim([350 550])
%axis square
%caxis([-0.5 0.5])
%axis off
end

%+1/2 position: (723.8,436.4) (715.2 513.3)
%-1/2 position: (688.4, 481.9) (754.7,469.5)
figure(2)
view(3)
hold on;
m1=5;m2=1;
x1=723.8;y1=436.4;x2=688.4;y2=481.9;x3=715.2;y3=513.3;x4=754.7;y4=469.5;
%1st +1/2
[stx1,sty1,stz1]=meshgrid((x1-m2*m1):m1:(x1+m2*m1),(y1-m2*m1):m1:(y1+m2*m1),2);
vqz2=vqx2-vqx2+1;
h1=streamline(xq2,yq2,tt2,vqx2,vqy2,vqz2,stx1,sty1,stz1);
for i=1:size(h1,1)
h1(i).Color = 'r';
h1(i).LineWidth = 1;
end

%1st -1/2
[stx2,sty2,stz2]=meshgrid((x2-m2*m1):m1:(x2+m2*m1),(y2-m2*m1):m1:(y2+m2*m1),2);
vqz2=vqx2-vqx2+1;
h2=streamline(xq2,yq2,tt2,vqx2,vqy2,vqz2,stx2,sty2,stz2);
for i=1:size(h2,1)
h2(i).Color = 'b';
h2(i).LineWidth = 1;
end

%2nd +1/2
[stx3,sty3,stz3]=meshgrid((x3-m2*m1):m1:(x3+m2*m1),(y3-m2*m1):m1:(y3+m2*m1),2);
vqz2=vqx2-vqx2+1;
h3=streamline(xq2,yq2,tt2,vqx2,vqy2,vqz2,stx3,sty3,stz3);
for i=1:size(h3,1)
h3(i).Color = 'r';
h3(i).LineWidth = 1;
end

%2nd -1/2
[stx4,sty4,stz4]=meshgrid((x4-m2*m1):m1:(x4+m2*m1),(y4-m2*m1):m1:(y4+m2*m1),2);
vqz2=vqx2-vqx2+1;
h4=streamline(xq2,yq2,tt2,vqx2,vqy2,vqz2,stx4,sty4,stz4);
for i=1:size(h4,1)
h4(i).Color = 'b';
h4(i).LineWidth = 1;
end

set(gca, 'YDir','reverse')
set(gca, 'XDir','normal')
pbaspect([1 1 1.5])
xlabel('x');ylabel('y');