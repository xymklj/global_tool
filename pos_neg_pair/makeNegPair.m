function negPair=makeNegPair(ori_txt,pair_txt,max_num,is_shuffle,output_txt)
%to build negtive pair by randomly choose the images in ori_txt and
%       pair_txt.The particular ratio of some specal class to some other
%       class is determined by the number of them in ori_txt and pair_txt.
%input:
%  ori_txt         --the gallery file that contains image name and its label 
%  pair_txt        --the probe file that contains image name and its label
%  max_num         --the max number of the final negitive pair;
%  is_shuflle      --randomly permute the negitive pair
%  output_txt      --if this parameter exists, this function writes negtive
%                    pair to txt.
%
%output:
%  posPair         --it has field ori_name,pair_name,label
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


total_neg_pair=0;
for i_o=1:length(ori_label)
    for i_p=1:length(pair_label)
        if ori_label(i_o)~=pair_label(i_p)
            total_neg_pair=total_neg_pair+1;
        end
    end
end
rand_thre=single(max_num)/total_neg_pair;
neg_pair_count=1;
for i_o=1:length(ori_label)
    for i_p=1:length(pair_label)
        if ori_label(i_o)~=pair_label(i_p)
            if rand()<rand_thre
                negPair(neg_pair_count).ori_name=ori_name{i_o};
                negPair(neg_pair_count).pair_name=pair_name{i_p};
                negPair(neg_pair_count).label=0;
                if neg_pair_count>= max_num
                    break; % we can acclerate by set a stop flag
                end
                neg_pair_count=neg_pair_count+1;
            end
        end
    end
end
if is_shuffle
    r=randperm(length(negPair));
    negPair=negPair(r);
end
if nargin>4
    fid=fopen(output_txt,'wt');
    for i=1:length(negPair)
        fprintf(fid,'%s %s %d\n',negPair(i).ori_name,negPair(i).pair_name,negPair(i).label);
    end
    fclose(fid);
end

end
