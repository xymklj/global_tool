function result_rankn=compute_rank(gallery_dir,probe_dir,gallery_txt,probe_txt,prototxt,caffemodel,data_key,feature_key,is_gray, ...
    data_size,norm_type,averageImg,rank_n,caffe_path)
%compute the rank 1-n for cnn
%
%inputs:
%  gallery(probe)_dir --the direcory contains imgs
%  gallery(probe)_txt --the txt contains lines such as *.png *.jpg and its labels.
%           Notices:gallery(probe)_dir+(lines in gallery(probe)_txt) should be the
%           full path of all images
%  prototxt and caffemodel  -- for special network
%  data_key                 -- the input data layer name
%  feature_key                 -- the feature layer name
%  is_gray                  -- true if the channel of input layer is
%           1;false if the channel of input layer is 3
%  data_size                -- the data size of input layer.Example:[height width]
%  norm_type                -- type=0 indicates that the data is just divided by 255
%           type==1 indicates that the data is substracted by [129.1863,104.7624,93.5940]
%           type==2 indicates that we process data as eccv16 deep face
%  averageImg               -- the mean value of three channels;if gray,it
%          is zero,otherwise,[129.1863,104.7624,93.5940]
%  rank_n                   -- to calculate rank 1-n
%  caffe_path               -- the matlab path in compilated caffe

%output:
%      			    --the rank 1-n cumulative scores
%
%Jun Hu
%2017-3
addpath(genpath('../..'));

addpath(genpath(caffe_path));

net=caffe.Net(prototxt,caffemodel,'test');
caffe.set_mode_gpu();

%read list
gallery=get_name_label_by_txt(gallery_txt);
probe=get_name_label_by_txt(probe_txt);

%info for extract_feature


%extract feature
for i_g=1:length(gallery)
    fprintf('extract faeture i_g:%d\n',i_g);
    feature=extract_feature_single(gallery_dir,gallery(i_g).name,data_size,data_key,feature_key,net,is_gray,norm_type,averageImg);
    gallery(i_g).fea=feature;
end
for i_p=1:length(probe)
    fprintf('extract faeture i_p:%d\n',i_p);
    feature=extract_feature_single(probe_dir,probe(i_p).name,data_size,data_key,feature_key,net,is_gray,norm_type,averageImg);
    probe(i_p).fea=feature;
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
