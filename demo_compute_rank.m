clear;
caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% % for lightencnn
% prototxt='/home/scw4750/github/IJCB2017/lightencnn_deploy.prototxt';
% caffemodel='/home/scw4750/github/IJCB2017/final_LightenedCNN_C.caffemodel';
% data_key='image';
% feature_key='eltwise_fc1';
% is_gray=true;
% data_size=[128 128]
% is_transpose=true;
% norm_type=0;  %type=0 indicates that the data is just divided by 255
% averageImg=[0 0 0]

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
%prototxt='/home/scw4750/github/caffe-face-caffe-face/face_example/face_deploy.prototxt';
%caffemodel='/home/scw4750/github/caffe-face-caffe-face/face_model.caffemodel';
%data_key='data';
%feature_key='fc5'
%is_gray=false;
%data_size=[112 96];
%is_transpose=true;
%norm_type=2
%averageImg=[0 0 0];

gallery_root_dir='/home/scw4750/github/IJCB2017/liangjie/croped';
probe_dir='/home/scw4750/github/IJCB2017/liangjie/croped/global_probe';
% disposed gallery_txt because it is unfair
% gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/gallery_list.txt';
%for images croped by liang
gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/gallery_list_croped_by_liang.txt';
probe_txt='/home/scw4750/github/IJCB2017/liangjie/txt/probe_list.txt';
gallery_dir_name={'enlarge_mulitpie' 'enlarge_mulitpie_vis' 'enlarge_multipie_single' ...
    'enlarge_multipie_han' 'baseline_mulitpie' 'enlarge_mulitpie_croped_by_liang'};
for i=1:length(gallery_dir_name)
    gallery_dir=[gallery_root_dir filesep gallery_dir_name{i} filesep 'gallery'];
    result_rankn = compute_rank(gallery_dir,probe_dir,gallery_txt,probe_txt,prototxt,caffemodel, ...
        data_key,feature_key,is_gray,data_size,norm_type,averageImg,rank_n,caffe_path);
    cmc(i).name=gallery_dir_name{i};
    cmc(i).rankn=result_rankn;
end
%for baseline dataset
baseline_gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/baseline_list.txt';
gallery_dir='/home/scw4750/github/IJCB2017/liangjie/croped/baseline_mulitpie/gallery';
result_rankn = compute_rank(gallery_dir,probe_dir,baseline_gallery_txt,probe_txt,prototxt,caffemodel, ...
    data_key,feature_key,is_gray,data_size,norm_type,averageImg,rank_n,caffe_path);
cmc(i+1).name='baseline_mulitpie';
cmc(i+1).rankn=result_rankn;