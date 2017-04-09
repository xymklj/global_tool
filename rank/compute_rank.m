function result_rankn=compute_rank(gallery_dir,probe_dir,gallery_txt,probe_txt,caffe_path,prototxt,caffemodel,net_param,preprocess_param,rank_n)
%compute the rank 1-n for cnn
%
%inputs:
%  gallery(probe)_dir --the direcory contains imgs
%  gallery(probe)_txt --the txt contains lines such as *.png *.jpg and its labels.
%           Notices:gallery(probe)_dir+(lines in gallery(probe)_txt) should be the
%           full path of all images
%  caffe_path               -- the matlab path in compilated caffe
%  prototxt and caffemodel  -- for special network
%  net_param.data_key                 -- the input data layer name
%  net_param.feature_key                 -- the feature layer name
%  net_param.is_gray                  -- true if the channel of input layer is
%           1;false if the channel of input layer is 3
%  net_param.data_size                -- the data size of input layer.Example:[height width]
%  net_param.norm_type                -- type=0 indicates that the data is just divided by 255
%           type==1 indicates that the data is substracted by [129.1863,104.7624,93.5940]
%           type==2 indicates that we process data as eccv16 deep face
%  net_param.averageImg               -- the mean value of three channels;if gray,it
%          is zero,otherwise,[129.1863,104.7624,93.5940]
%  rank_n                   -- to calculate rank 1-n

%output:
%      			    --the rank 1-n cumulative scores
%
%Jun Hu
%2017-3

addpath(genpath(caffe_path));
caffe.set_mode_gpu();
net=caffe.Net(prototxt,caffemodel,'test');


%read list
gallery=get_name_label_by_txt(gallery_txt);
probe=get_name_label_by_txt(probe_txt);

%info for extract_feature
data_size=net_param.data_size;
data_key=net_param.data_key;
feature_key=net_param.feature_key;
is_gray=net_param.is_gray;
norm_type=net_param.norm_type;
averageImg=net_param.averageImg;


%extract feature
for i_g=1:length(gallery)
    fprintf('extract faeture i_g:%d\n',i_g);
    feature=extract_feature_single(gallery_dir,gallery(i_g).name,data_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    gallery(i_g).fea=feature;
    %gallery(i_g).img=imread([gallery_dir filesep gallery(i_g).name]);
end
for i_p=1:length(probe)
    fprintf('extract faeture i_p:%d\n',i_p);
    feature=extract_feature_single(probe_dir,probe(i_p).name,data_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    probe(i_p).fea=feature;
    %probe(i_p).img=imread([probe_dir filesep probe(i_p).name]);
end
%compute rank
result_rankn=compute_rank_single(gallery,probe,rank_n);
% fprintf('rank1: %f\n',rankn(1));
caffe.reset_all();
end

function result=get_name_label_by_txt(txt)
fid=fopen(txt,'rt');
list=textscan(fid,'%s %f');
fclose(fid);
for i_g=1:length(list{1})
    result(i_g).name=list{1,1}{i_g};
    result(i_g).label=list{1,2}(i_g);
end
end
