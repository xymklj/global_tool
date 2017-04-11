function feature=extract_feature_single(img,img_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg)

%the difference betwenn extract_feature_single_image and extract_feature_single is that
%        the input is not the same: one is image,and anthor is the location of the image in disk
%
% img=imread([img_dir filesep img_file]);
if isfield(preprocess_param,'is_square') && preprocess_param.is_square
    height=size(img,1);
    width=size(img,2);
    padding_factor=1;
    if isfield(preprocess_param,'padding_factor')
        padding_factor=preprocess_param.padding_factor;
    end
%     top_diff=0;down_diff=0;left_diff=0;right_diff=0;
%     if isfield(preprocess_param,'top_diff')
%         top_diff=preprocess_param.top_diff;
%     end
%     if isfield(preprocess_param,'down_diff')
%         down_diff=preprocess_param.down_diff;
%     end
%     if isfield(preprocess_param,'left_diff')
%         left_diff=preprocess_param.left_diff;
%     end
%     if isfield(preprocess_param,'right_diff')
%         right_diff=preprocess_param.right_diff;
%     end
    final_size=int32(max(width,height)*padding_factor);
    data=uint8(ones(final_size,final_size,3)*255);
    data(int32((final_size-height)/2)+1:int32((final_size-height)/2)+height,...
        int32((final_size-width)/2)+1:int32((final_size-width)/2)+width,:)= ...
        img(1:end,1:end,:);
end
if exist('data','var')
    img=data;
end
%fprintf('img %s\n',[img_dir filesep img_file]);
if norm_type==2
    cropImg=imresize(img,img_size);
    temp=cropImg;
    if size(cropImg,3)==1
        cropImg(:,:,1)=temp;
        cropImg(:,:,2)=temp;
        cropImg(:,:,3)=temp;
    end
    cropImg = single(cropImg);
    cropImg = (cropImg - 127.5)/128;
    cropImg = permute(cropImg, [2,1,3]);
    cropImg = cropImg(:,:,[3,2,1]);
    
    cropImg_(:,:,1) = flipud(cropImg(:,:,1));
    cropImg_(:,:,2) = flipud(cropImg(:,:,2));
    cropImg_(:,:,3) = flipud(cropImg(:,:,3));
    
    % extract deep feature
    res = net.forward({cropImg});
    res_ = net.forward({cropImg_});
    feature = [res{1}; res_{1}];
else
    if is_gray
        if size(img,3)==3
            img=rgb2gray(img);
        end
    else
        if size(img,3)==1
            rgb_img(:,:,1)=img;
            rgb_img(:,:,2)=img;
            rgb_img(:,:,3)=img;
            img=rgb_img;
        end
        img = img(:, :, [3, 2, 1]); % convert from RGB to BGR
    end
    
    img=imresize(img,img_size);
    if is_gray
        img=img';
    else
        img = permute(img, [2, 1, 3]); % permute width and height
    end
    
    
    if is_gray
        data = zeros(img_size(2),img_size(1),1,1);
        data = single(data);
        if norm_type==0
            data(:,:,:,1) = (single(img)/255.0);
        elseif norm_type==1
            data(:,:,:,1) = (single(img)-averageImg(1));
        elseif norm_type==2
            data(:,:,:,1)=(single(img)-127.5)/128.0;
        end
    else
        data = zeros(img_size(2),img_size(1),3,1);
        data = single(data);
        if norm_type==0
            data(:,:,1,1) = (single(img(:,:,1))/255.0);
            data(:,:,2,1) = (single(img(:,:,2))/255.0);
            data(:,:,3,1) = (single(img(:,:,3))/255.0);
        elseif norm_type==1
            img=single(img);
            img = cat(3,img(:,:,1)-averageImg(3),...
                img(:,:,2)-averageImg(2),...
                img(:,:,3)-averageImg(1));
            data(:,:,1,1) = (single(img(:,:,1)));
            data(:,:,2,1) = (single(img(:,:,2)));
            data(:,:,3,1) = (single(img(:,:,3)));
        elseif norm_type==2
            data(:,:,1,1) = (single(img(:,:,1))-127.5)/128.0;
            data(:,:,2,1) = (single(img(:,:,2))-127.5)/128.0;
            data(:,:,3,1) = (single(img(:,:,3))-127.5)/128.0;
        end
    end
    
    net.blobs(data_key).set_data(data);
    net.forward_prefilled();
    feature=net.blobs(feature_key).get_data();
end

end
