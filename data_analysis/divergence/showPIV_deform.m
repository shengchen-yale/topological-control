clear;clc;
s1=importdata(['~\PIV_track\PIV_t','1-3','.txt']);
for t1=2:15 %t1=5,8,12 for t=20s,35s, and 55s
s2=importdata(['~\PIV_track\PIV_t',num2str(t1-1),'-',num2str(t1+1),'.txt']);
s1(:,3:4)=s1(:,3:4)+s2(:,3:4);
end

%%%%% interporate to get the velocity field
x1=s1(:,1);y1=s1(:,2);u1=s1(:,3);v1=s1(:,4);%SS1=s1(:,8);
um1=mean(u1);uvar1=var(u1);vm1=mean(v1);vvar1=var(v1);

step1=16;
[xq1,yq1]=meshgrid(min(x1):step1:max(x1),min(y1):step1:max(y1)); %resolution of interpolation

vqx1=griddata(x1,y1,u1,xq1,yq1,'linear');vqy1=griddata(x1,y1,v1,xq1,yq1,'linear');
vqx1(vqx1>(um1+3*uvar1))=0;vqx1(vqx1<(um1-3*uvar1))=0;
vqy1(vqy1>(vm1+3*vvar1))=0;vqy1(vqy1<(vm1-3*vvar1))=0;


figure(2)

hold on
%axis square
%pbaspect([max(x1) max(y1) 1])
%set(gca,'YDir','reverse')
%xlim([0 1266])
%ylim([0 1849])

%%%%%%%%%%%
div1 = divergence(xq1,yq1,vqx1,vqy1);
figure(2)

%smooth data
%div2=smoothdata(div1,2,'movmean',20);

%colormap("jet")
step2=5;
[xq2,yq2]=meshgrid(min(x1):step2:max(x1),min(y1):step2:max(y1)); %resolution of interpolation
div2=griddata(xq1,yq1,div1,xq2,yq2,'linear');
div3=imgaussfilt(div2,2);
h1=pcolor(xq2,yq2,div3);

colorscheme=othercolor('BuDRd_12',101);
set(gcf,'Colormap',colorscheme);

%vector field
mag=4e-1;
%mag=40e-1;%for t1=8
quiver(xq1-vqx1*mag,yq1-vqy1*mag,vqx1*mag,vqy1*mag,'color',[0 0 0],'linewidth',1.5,'ShowArrowHead','on','AutoScale','off')
%quiver(xq1,yq1,vqx1*mag,vqy1*mag,'color',[0 0 0],'linewidth',1.5,'ShowArrowHead','on','AutoScale','off')

%pcolor(xq1,yq1,div1)
pbaspect([max(x1) max(y1) 1])
set(gca,'YDir','reverse')
set(h1,'Edgecolor','none')
%xlim([50 850])
%ylim([400 1200])
%+1/2 & -1/2
%xlim([650 850])
%ylim([550 750])
%two +1/2
%xlim([200 400])
%ylim([450 650])
%defect quad
xlim([600 800])
ylim([350 550])
axis square
caxis([-1 1])
axis off