clear;
%notices: 1. the five points should be  left-eye,right-eye,nose,left,mouse,rightmouse  in order;
%        the format in pts should be left-eye-x left-eye-y \n      a   
%                                    right-eye-x right-eye-y \n
%                                    ...
%         2. the resized image must be square
%         3. the images should be stored as  root_dir/class/image
%Jun Hu
%2017-4
face_dir='/home/scw4750/github/IJCB2017/liufeng/evaluation_v2/with_3d/probe/still';
ffp_dir=face_dir;
save_dir='/home/scw4750/github/IJCB2017/liufeng/evaluation_v2/with_3d/probe_alignment/video/vgg';
% save_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/enlarge_mulitpie_croped_by_liang_with_pts/gallery';
pts_format='5pt';
output_format='jpg';
filter='*.jpg';
eccv_align(face_dir, ffp_dir, save_dir,'*.jpg',output_format,pts_format);


