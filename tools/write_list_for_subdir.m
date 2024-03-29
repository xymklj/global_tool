function write_list_by_handle(img_dir,txt_name,filter,param)
%To get list for the directory as  sub_dir/images, the output is a txt
%   which containing lines with name and label
%input:
%  img_dir    --the root dir for all image
%txt_name:
%  txt_name   --the output list name
%filter
%	      --file_filter as '*.jpg' and so on.
%param.out_format --the output format
%param.dir_handle --a function that get label from subdirectory
%param.name_handle --a function taht get label from image name
%param.is_fullpath --if true, the list should contain the directory name
%
%output:
%    if param.is_fullpath is true,
%          then the output should be [ sub_dir/image_name(1:end-length(filter)+2) out_format] and label
%    otherwise,[image_name(1:end-length(filter)+2) out_format]
%
%Jun Hu
%2017-4


fid=fopen(txt_name,'wt');
img_struct=dir(img_dir);
img_struct=img_struct(3:end);

for i=1:length(img_struct)
    if isfield(param,'dir_handle')
        label=dir_handle(img_struct(i).name);
    end
    sub_img_struct=dir([img_dir filesep img_struct(i).name filesep filter]);
    for i_s=1:length(sub_img_struct)
        label=i_s-1;
        output_name=sub_img_struct(i_s).name;
        if isfield(param,'name_handle')
            label=name_handle(name);
        end
        if isfield(param,'out_format')
            output_name=[output_name(1:end-length(filter)+2) param.out_format];
        end
        if isfield(param,'is_fullpath')
            output_name=[img_struct(i).name filesep output_name];
        end
        if label~=Inf
            fprintf(fid,'%s %d\n',output_name,label);
        end
    end
end
fclose(fid);
end
