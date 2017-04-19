clear;
addpath(genpath('/home/scw4750/github/global_tool'));

caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% for lightencnn
prototxt='/home/scw4750/github/IJCB2017/lightencnn_deploy.prototxt';
caffemodel='/home/scw4750/github/IJCB2017/final_LightenedCNN_C.caffemodel';
data_key='image';
feature_key='eltwise_fc1';
is_gray=true;
data_size=[128 128];
is_transpose=true;
norm_type=0;  %type=0 indicates that the data is just divided by 255
averageImg=[0 0 0];
preprocess_param.do_alignment=true;
preprocess_param.align_param.alignment_type='lightcnn';
distance_type='cos';

% %for vgg
% prototxt='/home/scw4750/github/vgg_face_caffe/VGG_FACE_deploy.prototxt';
% caffemodel='/home/scw4750/github/vgg_face_caffe/VGG_FACE.caffemodel';
% data_key='data';
% feature_key='fc7';
% is_gray=false;
% data_size=[224 224];
% is_transpose=true;
% norm_type=1;
% averageImg=[129.1863,104.7624,93.5940] ;
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='bbox';
% distance_type='cos';

% %for face-caffe
% prototxt='/home/scw4750/github/eccv_deep_face/face_example/face_deploy.prototxt';
% caffemodel='/home/scw4750/github/eccv_deep_face/face_example/face_model.caffemodel';
% data_key='data';
% feature_key='fc5';
% is_gray=false;
% data_size=[112 96];
% is_transpose=true;
% norm_type=2;
% averageImg=[0 0 0];
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='eccv16';
% distance_type='cos';

net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;
%preprocess_param
% preprocess_param.is_square=true;

matrix_param.distance_type='cos';

probe_dir='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie/global_probe';
probe_txt='/home/scw4750/github/IJCB2017/liangjie/txt/probe_list.txt';


gallery_root_dir='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie';
gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/gallery_list.txt';

analysis = get_analysis_matrix_from_net([gallery_root_dir filesep  'enlarge_mulitpie/gallery/'],probe_dir,...
    gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,matrix_param);

