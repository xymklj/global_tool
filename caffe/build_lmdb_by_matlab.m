%just build lmdb in matlab by calling executable program wrote by c++.
%the reason I write this code is I can tolerate using  shell command and scripts.

tools='/home/scw4750/github/caffe/build/tools/convert_imageset';
merge_txt='cylindrical_map_merge.txt';
ori_data_root='/home/scw4750/github/IJCB2017/liufeng/evaluation/with_3d/gallery_lightcnn_alignment';
pair_data_root='/home/scw4750/github/IJCB2017/liufeng/evaluation/with_3d/probe_lightcnn_alignment';
resize_height=128;
resize_width=128;
gray='true';
ori_data_list='cylindrical_map_merge.txt-ori';
pair_data_list='cylindrical_map_merge.txt-pair';
ori_output_name='ori_lmdb';
pair_output_name='pair_lmdb';


if exist(ori_output_name,'dir')
   rmdir(ori_output_name,'s'); 
end
if exist(pair_output_name,'dir')
   rmdir(pair_output_name,'s'); 
end

system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
    num2str(resize_width) ' --gray=' gray ' ' ori_data_root filesep ' ' ...
    ori_data_list ' ' ori_output_name]);
system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
    num2str(resize_width) ' --gray=' gray ' ' pair_data_root filesep ' ' ...
    pair_data_list ' ' pair_output_name]);


