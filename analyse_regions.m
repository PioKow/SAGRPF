function [Regions, zRoot, zRootsMultiplicity, zPoles, zPolesMultiplicity] = analyse_regions(DT,NodesCoord,Elements,Edges,Quadrants,PhasesDiff,CandidateEdges)
%  analyse_regions :
%
% INPUTS
%  DT                  :
%  NodesCoord          :
%  Elements            :
%  Edges               :
%  Quadrants           :
%  PhasesDiff          :
%  CandidateEdges      :
%
% OUTPUTS
%  Regions             :
%  zRoot               :
%  zRootsMultiplicity  :
%  zPoles              :
%  zPolesMultiplicity  :

Regions=[];
zRoot =[];
zRootsMultiplicity =[];
zPoles =[];
zPolesMultiplicity=[];

colorSet = [
    1 0 0 ;
    1 1 0;
    0 1 0;
    0 0 1
    ];

NrOfElements=size(Elements,1);
vis(NodesCoord, Edges, Quadrants,PhasesDiff)
title('final mesh with results')

% Evaluation of regions and verification
disp('Evaluation of regions and verification...')
if(isempty(CandidateEdges))
    disp('No roots in the domain!')
    return
end

% Evaluation of contour edges from all candidates edges
ArrayOfCandidateElements = edgeAttachments(DT,CandidateEdges(:,1),CandidateEdges(:,2));
NoOfConnectionsToCandidate=zeros(NrOfElements,1);
for k=1:size(ArrayOfCandidateElements,1)
    NoOfConnectionsToCandidate(ArrayOfCandidateElements{k})=1;
end

IDOfCandidateElements=find(NoOfConnectionsToCandidate==1);
NoOfCandidateElements=size(IDOfCandidateElements,1);
CandidateElements=Elements(IDOfCandidateElements,:);

TempEdges=zeros(NoOfCandidateElements*3,2);

for k=1:NoOfCandidateElements
    TempEdges((k-1)*3+1,:)=[CandidateElements(k,1) CandidateElements(k,2)];
    TempEdges((k-1)*3+2,:)=[CandidateElements(k,2) CandidateElements(k,3)];
    TempEdges((k-1)*3+3,:)=[CandidateElements(k,3) CandidateElements(k,1)];
end

% Reduction of edges to contour
MultiplicationOfTempEdges=zeros(3*NoOfCandidateElements,1);
RevTempEdges=fliplr(TempEdges);
for k=1:3*NoOfCandidateElements
    if MultiplicationOfTempEdges(k)==0
        NoOfEdge=find(RevTempEdges(:,1)==TempEdges(k,1)&RevTempEdges(:,2)==TempEdges(k,2));
        if isempty(NoOfEdge)
            MultiplicationOfTempEdges(k)=1;
        else
            MultiplicationOfTempEdges(k)=2;
            MultiplicationOfTempEdges(NoOfEdge)=2;
        end
    end
end
ContourEdges=TempEdges(MultiplicationOfTempEdges==1,:);

% Evaluation of the regions
NoOfRegions=1;
Regions{NoOfRegions}=ContourEdges(1,1);
RefNode=ContourEdges(1,2);
ContourEdges(1,:)=[];
while size(ContourEdges,1)>0
    IndexOfNextEdge=find(ContourEdges(:,1)==RefNode);

    if isempty(IndexOfNextEdge)
        Regions{NoOfRegions}=[Regions{NoOfRegions} RefNode];
        if size(ContourEdges,1)>0
            NoOfRegions=NoOfRegions+1;
            Regions{NoOfRegions}=ContourEdges(1,1);
            RefNode=ContourEdges(1,2);
            ContourEdges(1,:)=[];
        end
    else
        if size(IndexOfNextEdge,1)>1
            PrevNode= Regions{NoOfRegions}(end);
            TempNodes=ContourEdges(IndexOfNextEdge,2);
            Index= find_next_node(NodesCoord,PrevNode,RefNode,TempNodes);
            IndexOfNextEdge=IndexOfNextEdge(Index);
        end

        Regions{NoOfRegions}=[Regions{NoOfRegions} ContourEdges(IndexOfNextEdge,1)];
        RefNode=ContourEdges(IndexOfNextEdge,2);
        ContourEdges(IndexOfNextEdge,:)=[];
    end

end
Regions{NoOfRegions}=[Regions{NoOfRegions} RefNode];

disp('Results:')
for k=1:NoOfRegions
    QuadrantSequence=Quadrants(Regions{k});
    dQ=QuadrantSequence(2:end)-QuadrantSequence(1:end-1);
    dQ(dQ==3)=-1;
    dQ(dQ==-3)=1;
    dQ(abs(dQ)==2)=NaN;
    q(k,1)=sum(dQ)/4;
    z(k,1)=mean(unique(NodesCoord(Regions{k},1)+1i*NodesCoord(Regions{k},2)));

    NodesCoordPolygon = NodesCoord(Regions{k},:);

    ArrowP1 = [NodesCoordPolygon(1:end-1,1), NodesCoordPolygon(1:end-1,2)];
    ArrowP2 = [NodesCoordPolygon(2:end,1), NodesCoordPolygon(2:end,2)];
    ArrowDP = ArrowP2-ArrowP1;
    hold on
    quiver(ArrowP1(:,1),ArrowP1(:,2),ArrowDP(:,1)/2,ArrowDP(:,2)/2,0,...
        'LineWidth',2,'Color','m','MaxHeadSize',4);

    NodesCoordPolygon(end,:)=[];
    ColorNode = colorSet(QuadrantSequence(1:end),:);
    ColorNode(end,:) = [];
    hold on
    fillHandle=fill(NodesCoord(Regions{k},1) ,NodesCoord(Regions{k},2),[0.3 0.3 0.3]);
    set(fillHandle,'facealpha',0.1);
    hold on
    patch('XData',NodesCoordPolygon(:,1),'YData',NodesCoordPolygon(:,2),...
        'FaceVertexCData',ColorNode,...
        'Marker','.','MarkerSize',15,'FaceColor','none','EdgeColor','interp','LineWidth',2);
    disp(['Region: ',num2str(k),' z = ',num2str(z(k)),' with q = ',num2str(q(k)) ])
end

zRoot=z(q>0);
zRootsMultiplicity=q(q>0);

disp('---------------------')
disp('Root and its multiplicity: ' );
[zRoot zRootsMultiplicity]

zPoles=z(q<0);
zPolesMultiplicity=q(q<0);

disp('---------------------')
disp('Poles and its multiplicity: ');
[zPoles zPolesMultiplicity]

hold on
plot(real(zRoot),imag(zRoot),'o',...
    'LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','m',...
    'MarkerSize',10);
plot(real(zPoles),imag(zPoles),'o',...
    'LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','c',...
    'MarkerSize',10);
drawnow;

end

