function SkinyEdges =  find_skiny_elements(Elements,NodesCoord,skinRatio)
%  find_skiny_elements : 
%
% INPUTS
%  Elements       : 
%  NodesCoord     :
%  skinRatio      :
%
% OUTPUTS
%  SkinyEdges     : 
%

SkinyEdges=[];
for it=1:size(Elements,1)
    Edges = sort([
        Elements(it,1) Elements(it,2);
        Elements(it,1) Elements(it,3);
        Elements(it,2) Elements(it,3);
        ],2);
    sideLength = sqrt(sum((NodesCoord(Edges(:,2),:)-NodesCoord(Edges(:,1),:)).^2,2));

    xa=NodesCoord(Elements(it,1),1);
    ya=NodesCoord(Elements(it,1),2);

    xb=NodesCoord(Elements(it,2),1);
    yb=NodesCoord(Elements(it,2),2);

    xc=NodesCoord(Elements(it,3),1);
    yc=NodesCoord(Elements(it,3),2);

    P=abs((xb-xa)*(yc-ya)-(yb-ya)*(xc-xa))/2;

    [sideMax, idSideMax]=max(sideLength);
    hmin=2*P/sideMax;
    ElementRatio=sideMax/hmin;

    if ElementRatio>skinRatio
        SkinyEdges = [SkinyEdges; Edges(idSideMax,:)];
    end
end

end

