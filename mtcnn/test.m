clear;

%minimum size of face
minsize=20;

%path of toolbox
caffe_path='/home/scw4750/github/caffe/matlab';
pdollar_toolbox_path='/home/scw4750/github/MTCNN/toolbox-master'
caffe_model_path='/home/scw4750/github/MTCNN/code/codes/MTCNNv2/model'
addpath('/home/scw4750/github/MTCNN/code/codes/MTCNNv2');
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

%use cpu
%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();
caffe.set_device(gpu_id);

%three steps's threshold
threshold=[0.6 0.7 0.7];

%scale factor
factor=0.709;

%load caffe models
prototxt_dir =strcat(caffe_model_path,'/det1.prototxt');
model_dir = strcat(caffe_model_path,'/det1.caffemodel');
PNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det2.prototxt');
model_dir = strcat(caffe_model_path,'/det2.caffemodel');
RNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det3.prototxt');
model_dir = strcat(caffe_model_path,'/det3.caffemodel');
ONet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir =  strcat(caffe_model_path,'/det4.prototxt');
model_dir =  strcat(caffe_model_path,'/det4.caffemodel');
LNet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);
error_img=[];

%%%%%%%%%%%%%%%%%%%%%%%
% imglist=importdata('protocols/probe_video_with_label.txt');
% output_root_dir='/home/scw4750/github/IJCB2017/liangjie/croped/multipie/enlarge_multipie_single_with_margin_1.1/gallery';
% crop_factor=1;
% img_root_dir='/home/scw4750/github/IJCB2017/liufeng';
all_img=dir('unusual/*.jpg');
%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(all_img)
    i
    img=imread([all_img(i).folder filesep all_img(i).name]);
    data=uint8(ones(400,400)*255);
    data(20:219,20:219)=img(1:200,1:200);
    img=data;
    img(:,:,1)=img(:,:,1);
    img(:,:,2)=img(:,:,1);
    img(:,:,3)=img(:,:,1);
    %we recommend you to set minsize as x * short side
    %minl=min([size(img,1) size(img,2)]);
    %minsize=fix(minl*0.1)
    tic
    [boudingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,LNet,threshold,false,factor);
    toc
    faces{i,1}={boudingboxes};
    faces{i,2}={points'};
    %show detection result
    numbox=size(boudingboxes,1);
    imshow(img)
    hold on;
    
    %     ptr_name=[imglist{i}(1:end-3) 'pts'];
    %     fid=fopen(ptr_name,'wt');
    for j=1:numbox
        plot(points(1:5,j),points(6:10,j),'g.','MarkerSize',10);
        r=rectangle('Position',[boudingboxes(j,1:2) boudingboxes(j,3:4)-boudingboxes(j,1:2)],'Edgecolor','g','LineWidth',3);
    end
    hold off;
    pause
end
fprintf('error images number:%d\n',length(error_img));
caffe.reset_all();
% save result box landmark

