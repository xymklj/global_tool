function [scores,labels]=draw_roc(pos_ori_dir,pos_pair_dir,neg_ori_dir,neg_pair_dir,posPair_txt, ...
    negPair_txt,caffe_path,prototxt,caffemodel,net_param,preprocess_param)
%draw roc curve for cnn
%
%inputs:
%  pos(neg)_ori_dir                   --the direcory contains origin images
%  pos(neg)_pair_dir                  --the direcory contains pair images
%  posPair_txt                        --the txt contains lines as the relative path of origin image,pair image and 1.
%           Notices:pos(neg)_ori_dir+(lines in pos(neg)_txt) should be the
%           full path of all images
%  negPair_txt                        --the txt contains lines as the relative path of origin image,pair image and 0.
%  caffe_path                         -- the matlab path in compilated caffe
%  prototxt and caffemodel            -- for special network
%  net                                -- for special network
%  net_param and preprocess_param     --see net_param_preprocess_param_doc.txt in root directory.
%
%output:
%      			              --the postive and negative pair with its feature and
%      			    score
%
%Jun Hu
%2017-4
addpath(genpath(caffe_path));
caffe.set_mode_gpu();
net=caffe.Net(prototxt,caffemodel,'test');

fid=fopen(posPair_txt,'rt');
list=textscan(fid,'%s %s %d');
for i=1:length(list{1})
    pos_pair(i).ori_name=list{1}{i};
    pos_pair(i).pair_name=list{2}{i};
end
fclose(fid);

fid=fopen(negPair_txt,'rt');
list=textscan(fid,'%s %s %d');
for i=1:length(list{1})
    neg_pair(i).ori_name=list{1}{i};
    neg_pair(i).pair_name=list{2}{i};
end
fclose(fid);

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
        data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    pos_pair(i_p).pair_fea=extract_feature_single(pos_pair_dir,pos_pair(i_p).pair_name,data_size, ...
        data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    pos_pair(i_p).score=compute_cosine_score(pos_pair(i_p).ori_fea,pos_pair(i_p).pair_fea);
end
for i_p=1:length(neg_pair)
    i_p
    neg_pair(i_p).ori_fea=extract_feature_single(neg_ori_dir,neg_pair(i_p).ori_name,data_size, ...
        data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    neg_pair(i_p).pair_fea=extract_feature_single(neg_pair_dir,neg_pair(i_p).pair_name,data_size, ...
        data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
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
