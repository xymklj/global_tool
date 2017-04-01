function rank_score=compute_rank_single(gallery,probe,rank_n)
%compute rank_socre 
%
%input:
%  gallery  -- a struct that has field fea() and its label for gallery
%  probe    -- a struct that has field fea() and its label for probe
%  rank_n   -- the max rank number
%
%output:
%  rank_score
%
%
%Jun Hu
%2017-3

rank_count=zeros(rank_n,1);

for i_p=1:length(probe)
    fprintf('compute rank i_p:%d\n',i_p);
    for i_g=1:length(gallery)
        result(i_g).score=compute_cosine_score(gallery(i_g).fea,probe(i_p).fea);
    end
    [sort_score,index]=sort([result.score],'descend');
    %     thre=sort_score(rank_n);
    has_pinned=0;
    for i_s=1:rank_n
        if probe(i_p).label==gallery(index(i_s)).label
            has_pinned=1;
        end
        rank_count(i_s)=rank_count(i_s)+(probe(i_p).label==gallery(index(i_s)).label||has_pinned);
    end
end
rank_score=single(rank_count)/single(length(probe));
end
