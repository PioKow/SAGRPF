function EdgesToSplit = analyse_gradients(Edges,DT,GradInElement,Tol,EdgesLengths,NoOfEdgesToSplit)
%  analyse_gradients :
%
% INPUTS
%  Edges              :
%  DT                 :
%  GradInElement      :
%  Tol                :
%  EdgesLengths       :
%  NoOfEdgesToSplit   :
%
% OUTPUTS
%  EdgesToSplit       :
%

EdgesToSplit = [];
if(NoOfEdgesToSplit==0)
    NoOfEdgesToSplit=1;
end

if(size(Edges,1)<=NoOfEdgesToSplit)
    EdgesToSplit = Edges;
else
    AngleInEdges =zeros(size(Edges,1),1);
    ElementsAttached = edgeAttachments(DT,Edges);

    v = zeros(1,3);
    u = zeros(1,3);
    for ik = 1:size(Edges,1)
        nrOfElementTemp = ElementsAttached{ik};
        if(size(nrOfElementTemp,2)==2)
            v(1:2) = GradInElement(nrOfElementTemp(:,1),:);
            u(1:2) = GradInElement(nrOfElementTemp(:,2),:);

            %other possibily to calculate angle
            %AngleInEdges(ik,1) = acos(dot(u,v)/(norm(u)*norm(v)));
            AngleInEdges(ik,1) =  atan2(norm(cross(u,v)),dot(u,v));
            if isnan(AngleInEdges(ik,1))
                AngleInEdges(ik,1) = pi;
            end
        end
    end

    EdgesRankingLog = log10(EdgesLengths/Tol).*real(AngleInEdges);
    EdgesRankingLog(EdgesRankingLog <= eps) = 0;

    EdgesToRankLog = EdgesRankingLog~=0;
    EdgesRankLog = Edges(EdgesToRankLog,:);

    if(size(EdgesRankLog,1)<NoOfEdgesToSplit)
        if(size(EdgesRankLog,1)>0)
            EdgesToSplit = EdgesRankLog;
            NoOfEdgesToSplit = NoOfEdgesToSplit-size(EdgesRankLog,1);
        end
        EdgesRankLen = Edges(~EdgesToRankLog,:);

        RankingEdgesLengths = EdgesLengths(~EdgesToRankLog);
        EdgesRank =sort(RankingEdgesLengths,'descend');
        EdgesToSplit = [
            EdgesToSplit;
            EdgesRankLen(EdgesRank(NoOfEdgesToSplit)<= RankingEdgesLengths,:)
            ];
    elseif(size(EdgesRankLog,1)==NoOfEdgesToSplit)
        EdgesToSplit = EdgesRankLog;
    else
        EdgesRankingLog = EdgesRankingLog(EdgesToRankLog);
        EdgesRank = sort(EdgesRankingLog,'descend');
        EdgesToSplit = EdgesRankLog(EdgesRank(NoOfEdgesToSplit) <= EdgesRankingLog,:);
    end
end

end

