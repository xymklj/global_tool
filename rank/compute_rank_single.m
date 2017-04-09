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
%notices:
%           -- just for the scores that the bigger the better.
%
%Jun Hu
%2017-3

rank_count=zeros(rank_n,1);

for i_p=1:length(probe)
    fprintf('compute rank i_p:%d\n',i_p);
    for i_g=1:length(gallery)
        result(i_g).score=compute_cosine_score(gallery(i_g).fea,probe(i_p).fea);
    end
%     if i_p==163
%        asdf=2; 
%     end
    [sort_score,index]=sort([result.score],'descend');
    %     thre=sort_score(rank_n);
    has_pinned=0;
    for i_s=1:rank_n
        if probe(i_p).label==gallery(index(i_s)).label
            has_pinned=1;
        end
        rank_count(i_s)=rank_count(i_s)+(probe(i_p).label==gallery(index(i_s)).label||has_pinned);
%     end
%    debug(i_p).gal_label=gallery(index(1)).label;
%    debug(i_p).pro_label=probe(i_p).label;
%    debug(i_p).gal_name=gallery(index(1)).name;
%    debug(i_p).pro_name=probe(i_p).name;
end
rank_score=single(rank_count)/single(length(probe));
end
