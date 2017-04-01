function [pos_pair,neg_pair]=draw_roc(pos_ori_dir,pos_pair_dir,neg_ori_dir,neg_pair_dir,ori_txt, ...
    pair_txt,caffe_path,prototxt,caffemodel,net_param,pos_mat,neg_mat)
%draw roc curve for cnn
%
%inputs:
%  pos(neg)_ori_dir                   --the direcory contains origin images
%  pos(neg)_pair_dir                  --the direcory contains pair images
%  ori(pair)_txt                      --the txt contains lines such as *.png *.jpg and its labels.
%           Notices:pos(neg)_ori_dir+(lines in pos(neg)_txt) should be the
%           full path of all images
%  net                                -- for special network
%  net_param.data_key                 -- the input data layer name
%  net_param.feature_key              -- the feature layer name
%  net_param.is_gray                  -- true if the channel of input layer is
%           1;false if the channel of input layer is 3
%  net_param.data_size                -- the data size of input layer.Example:[height width]
%  net_param.norm_type                -- type=0 indicates that the data is just divided by 255
%           type==1 indicates that the data is substracted by [129.1863,104.7624,93.5940]
%           type==2 indicates that we process data as eccv16 deep face
%  net_param.averageImg               -- the mean value of three channels;if gray,it
%          is zero,otherwise,[129.1863,104.7624,93.5940]

%output:
%      			                       --the postive and negative pair with its feature and
%      			    score
%
%Jun Hu
%2017-4
addpath(genpath(caffe_path));
caffe.set_mode_gpu();
net=caffe.Net(prototxt,caffemodel,'test');

if nargin <=10
pos_pair=makePosPair(ori_txt,pair_txt,3000,0);
neg_pair=makeNegPair(ori_txt,pair_txt,3000,0);
else
    load('pos_mat');
    load('neg_mat');
end
data_size=net_param.data_size;
data_key=net_param.data_key;
feature_key=net_param.feature_key;
is_gray=net_param.is_gray;
norm_type=net_param.norm_type;
averageImg=net_param.averageImg;
% we might accelerate the runtime of following codes, because the feature may be computed n times.
for i_p=1:length(pos_pair)
    i_p
    pos_pair(i_p).ori_fea=extract_feature_single(pos_ori_dir,pos_pair(i_p).ori_name,data_size, ...
        data_key,feature_key,net,is_gray,norm_type,averageImg);
    pos_pair(i_p).pair_fea=extract_feature_single(pos_pair_dir,pos_pair(i_p).pair_name,data_size, ...
        data_key,feature_key,net,is_gray,norm_type,averageImg);
    pos_pair(i_p).score=compute_cosine_score(pos_pair(i_p).ori_fea,pos_pair(i_p).pair_fea);
end
for i_p=1:length(neg_pair)
    i_p
    neg_pair(i_p).ori_fea=extract_feature_single(neg_ori_dir,neg_pair(i_p).ori_name,data_size, ...
        data_key,feature_key,net,is_gray,norm_type,averageImg);
    neg_pair(i_p).pair_fea=extract_feature_single(neg_pair_dir,neg_pair(i_p).pair_name,data_size, ...
        data_key,feature_key,net,is_gray,norm_type,averageImg);
    neg_pair(i_p).score=compute_cosine_score(neg_pair(i_p).ori_fea,neg_pair(i_p).pair_fea);
end
pos_scores=extractfield(pos_pair,'score');
pos_label=ones(1,length(pos_pair));
neg_scores=extractfield(neg_pair,'score');
neg_label=zeros(1,length(neg_pair));
scores=[pos_scores neg_scores];
labels=[pos_label neg_label];
ROC(scores,labels,10,0);

caffe.reset_all();
end
