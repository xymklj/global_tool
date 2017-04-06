function get_list_by_dirname(img_dir,txt_name,file_filter)
%get list by directory name just for the directory such as  class_number/the_images_for_the_class
%input:
%  img_dir    --the root dir for all image  
%txt_name:
%  txt_name   --the output list name
%file_filer
%	      --file_filter as '*.jpg' and so on.
%Jun Hu
%2017-3
fid=fopen(txt_name,'wt');
img_struct=dir(img_dir);
img_struct=img_struct(3:end);

for i=1:length(img_struct)
    class=str2num(img_struct(i).name);
    sub_img_struct=dir([img_dir filesep img_struct(i).name filesep file_filter]);
    for i_s=1:length(sub_img_struct)
        img_name=[img_struct(i).name filesep sub_img_struct(i_s).name];
        fprintf(fid,'%s %d\n',img_name,class);
    end
end
fclose(fid);
end
