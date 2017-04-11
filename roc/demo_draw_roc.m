clear;
caffe_path='/home/scw4750/github/caffe/matlab';

addpath(genpath('..'));
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
% 
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

% %for face-caffe
% prototxt='/home/scw4750/github/caffe-face-caffe-face/face_example/face_deploy.prototxt';
% caffemodel='/home/scw4750/github/caffe-face-caffe-face/face_example/face_model.caffemodel';
% data_key='data';
% feature_key='fc5';
% is_gray=false;
% data_size=[112 96];
% is_transpose=true;
% norm_type=0;
% averageImg=[0 0 0];

ori_txt='/home/scw4750/github/IJCB2017/liangjie/txt/gallery_list.txt';
pair_txt='/home/scw4750/github/IJCB2017/liangjie/txt/probe_list.txt';

pos_pair=makePosPair(ori_txt,pair_txt,3000,0,'pos.txt');
neg_pair=makeNegPair(ori_txt,pair_txt,3000,0,'neg.txt');


pos_ori_dir='/home/scw4750/github/IJCB2017/liangjie/croped/multipie/enlarge_mulitpie_with_margin/gallery';
pos_pair_dir='/home/scw4750/github/IJCB2017/liangjie/croped/multipie/global_probe_with_margin';
neg_ori_dir=pos_ori_dir;
neg_pair_dir=pos_pair_dir;

net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;
preprocess_param=[];
draw_roc(pos_ori_dir,pos_pair_dir,neg_ori_dir,neg_pair_dir,'pos.txt','neg.txt',caffe_path,prototxt,caffemodel,net_param,preprocess_param);
