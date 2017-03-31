function get_list_by_dirname(img_dir,txt_name)
fid=fopen(txt_name,'wt');
img_struct=dir(img_dir);
img_struct=img_struct(3:end);

for i=1:length(img_struct)
    class=str2num(img_struct(i).name);
    sub_img_struct=dir([img_dir filesep img_struct(i).name]);
    sub_img_struct=sub_img_struct(3:end);
    for i_s=1:length(sub_img_struct)
        img_name=[img_struct(i).name filesep sub_img_struct(i_s).name];
        fprintf(fid,'%s %d\n',img_name,class);
    end
end
fclose(fid);
end
