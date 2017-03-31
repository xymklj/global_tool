%

function feature=extract_feature_single(img_dir,img_file,img_size,data_key,feature_key,net,is_gray,norm_type,averageImg)

img=imread([img_dir filesep img_file]);
%fprintf('img %s\n',[img_dir filesep img_file]);
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


data = zeros(img_size(1),img_size(2),1,1);
data = single(data);
if is_gray
    if norm_type==0
        data(:,:,:,1) = (single(img)/255.0);
    elseif norm_type==1
        data(:,:,:,1) = (single(img)-averageImg(1));
    elseif norm_type==2
        data(:,:,:,1)=(single(img)-127.5)/128.0;
    end
else
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

