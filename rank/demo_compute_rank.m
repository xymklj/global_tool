clear;
addpath(genpath('..'));

caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% % for lightencnn
% prototxt='/home/scw4750/github/IJCB2017/lightencnn_deploy.prototxt';
% caffemodel='/home/scw4750/github/IJCB2017/final_LightenedCNN_C.caffemodel';
% data_key='image';
% feature_key='eltwise_fc1';
% is_gray=true;
% data_size=[128 128];
% is_transpose=true;
% norm_type=0;  %type=0 indicates that the data is just divided by 255
% averageImg=[0 0 0];

%for vgg
prototxt='/home/scw4750/github/vgg_face_caffe/VGG_FACE_deploy.prototxt';
caffemodel='/home/scw4750/github/vgg_face_caffe/VGG_FACE.caffemodel';
data_key='data';
feature_key='fc7';
is_gray=false;
data_size=[224 224];
is_transpose=true;
norm_type=1;
averageImg=[129.1863,104.7624,93.5940] ;

%for face-caffe
% prototxt='/home/scw4750/github/deep_learning/face_example/face_deploy.prototxt';
% caffemodel='/home/scw4750/github/deep_learning/face_example/face_model.caffemodel';
% data_key='data';
% feature_key='fc5';
% is_gray=false;
% data_size=[112 96];
% is_transpose=true;
% norm_type=2;
% averageImg=[0 0 0];

net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;


gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/gallery_list.txt';
probe_txt='/home/scw4750/github/IJCB2017/liangjie/txt/probe_list.txt';

% %for face alignment data
% gallery_root_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts';
% probe_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/global_probe_with_pts';
% gallery_dir_name={'enlarge_mulitpie_croped_by_liang_with_pts' 'enlarge_mulitpie_vis_croped_by_liang_with_pts' ...
%     'enlarge_multipie_han_with_pts' 'enlarge_multipie_single_with_pts'};

%for images croped by liang
gallery_root_dir='/home/scw4750/github/IJCB2017/liangjie/croped/without_pts';
probe_dir='/home/scw4750/github/IJCB2017/liangjie/croped/without_pts/global_probe';
gallery_dir_name={'enlarge_mulitpie' 'enlarge_mulitpie_vis' 'enlarge_multipie_single' ...
    'enlarge_multipie_han' 'enlarge_mulitpie_croped_by_liang' 'enlarge_mulitpie_vis_croped_by_liang'};


for i=1:length(gallery_dir_name)
    gallery_dir=[gallery_root_dir filesep gallery_dir_name{i} filesep 'gallery'];
    result_rankn = compute_rank(gallery_dir,probe_dir,gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
        net_param,rank_n);
    cmc(i).name=gallery_dir_name{i};
    cmc(i).rankn=result_rankn;
end
%for baseline dataset
baseline_gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/baseline_gallery_list_with_pts.txt';
% gallery_dir='/home/scw4750/github/IJCB2017/liangjie/croped/baseline_mulitpie/gallery';
%for face alignment data
gallery_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/baseline_mulitpie_with_pts/gallery';
result_rankn = compute_rank(gallery_dir,probe_dir,baseline_gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,rank_n);
cmc(i+1).name='baseline_mulitpie';
cmc(i+1).rankn=result_rankn;

