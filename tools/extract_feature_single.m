function feature=extract_feature_single(img_dir,img_file,img_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg)

img=imread([img_dir filesep img_file]);
feature=extract_feature_single_image(img,img_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
end
