function rank_score=compute_cmc_by_analysis_matrix(analysis,rank_param)
%input:
%  analysis             --analysis matrix named by Jun Hu
%  rank_param.rank_n    --
%output:
%  rank_score           --
%
%Jun Hu
%2017-4
rank_n=rank_param.rank_n;
sort_matrix=analysis.sort_matrix;
rank_count=zeros(rank_n,1);
gallery=analysis.gallery_info;
probe=analysis.probe_info;
for i_p=1:size(sort_matrix,1)
    index=sort_matrix(i_p,:);
    has_pinned=0;
    for i_s=1:rank_n
        if probe(i_p).label==gallery(index(i_s)).label
            has_pinned=1;
        end
        rank_count(i_s)=rank_count(i_s)+has_pinned;
    end
end
rank_score=rank_count/size(sort_matrix,1);
end