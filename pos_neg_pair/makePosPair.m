function posPair=makePosPair(ori_txt,pair_txt,max_num,is_shuffle,output_txt)
%to build negtive pair by randomly choose the images in ori_txt and
%       pair_txt.The particular ratio of some specal class to some other
%       class is determined by the number of them in ori_txt and pair_txt.
%input:
%  ori_txt         --the gallery file that contains image name and its label 
%  pair_txt        --the probe file that contains image name and its label
%  max_num         --the max number of the final positive pair;
%  is_shuflle      --randomly permute the positive pair
%  output_txt      --if this parameter exists, this function writes postive
%                    pair to txt.
%
%output:
%  posPair         --positive pair txt
%Jun Hu
%2017-3
fid=fopen(ori_txt,'rt');
ori=textscan(fid,'%s %d');
ori_name=ori{1};
ori_label=ori{2};
assert(length(ori_name)==length(ori_label));
fclose(fid);
fid=fopen(pair_txt,'rt');
pair=textscan(fid,'%s %d');
pair_name=pair{1};
pair_label=pair{2};
assert(length(pair_name)==length(pair_label));
fclose(fid);
total_pos_pair=0;
for i_o=1:length(ori_label)
    for i_p=1:length(pair_label)
        if ori_label(i_o)==pair_label(i_p)
            total_pos_pair=total_pos_pair+1;
        end
    end
end
rand_thre=single(max_num)/total_pos_pair;
pos_pair_count=1;
for i_o=1:length(ori_label)
    for i_p=1:length(pair_label)
        if ori_label(i_o)==pair_label(i_p)
            if rand()<rand_thre
                posPair(pos_pair_count).ori_name=ori_name{i_o};
                posPair(pos_pair_count).pair_name=pair_name{i_p};
                posPair(pos_pair_count).label=1;
                if pos_pair_count>= max_num
                    break; % we can acclerate by set a stop flag
                end
                pos_pair_count=pos_pair_count+1;
            end
        end
    end
end
if is_shuffle
    r=randperm(length(posPair));
    posPair=posPair(r);
end
if nargin>4
    fid=fopen(output_txt,'wt');
    for i=1:length(posPair)
        fprintf(fid,'%s %s %d\n',posPair(i).ori_name,posPair(i).pair_name,posPair(i).label);
    end
    fclose(fid);
end

end
