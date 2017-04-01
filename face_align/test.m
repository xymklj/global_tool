img=imread('/home/scw4750/github/IJCB2017/liangjie/croped/enlarge_mulitpie_vis_with_pts/gallery/001/001_01_01_051_06.png');
fid=fopen('/home/scw4750/github/IJCB2017/liangjie/croped/enlarge_mulitpie_vis_with_pts/gallery/001/001_01_01_051_06..5pt');
res=textscan(fid,'%f %f');
pts=[res{1} res{2}];
imshow(img);hold on;
index=1;
plot(pts(index,1),pts(index,2),'.g');