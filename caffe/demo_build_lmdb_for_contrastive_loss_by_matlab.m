%just build lmdb in matlab by calling executable program wrote by c++.
%the reason I write this code is I can tolerate using  shell command and scripts.

tools='/home/scw4750/github/caffe/build/tools/convert_imageset';
merge_txt='cylindrical_map_merge.txt';
gal_data_root='/home/scw4750/github/IJCB2017/liufeng/evaluation/with_3d/gallery_lightcnn_alignment';
pro_data_root='/home/scw4750/github/IJCB2017/liufeng/evaluation/with_3d/probe_lightcnn_alignment';
resize_height=128;
resize_width=128;
gray='true';
gal_output_name='gal_lmdb';
pro_output_name='pro_lmdb';
pos_neg_pair_name='cylindrical_map_merge.txt';


splitPair(pos_neg_pair_name);
gal_data_list=[pos_neg_pair_name '-gal'];
pro_data_list=[pos_neg_pair_name '-pro'];
if exist(gal_output_name,'dir')
   rmdir(gal_output_name,'s'); 
end
if exist(pro_output_name,'dir')
   rmdir(pro_output_name,'s'); 
end

system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
    num2str(resize_width) ' --gray=' gray ' ' gal_data_root filesep ' ' ...
    gal_data_list ' ' gal_output_name]);
system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
    num2str(resize_width) ' --gray=' gray ' ' pro_data_root filesep ' ' ...
    pro_data_list ' ' pro_output_name]);
delete(gal_data_list);
delete(pro_data_list);
