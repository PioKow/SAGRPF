function [EdgesToSplit, GradeInElements] = adaptive(NodesCoord,FunctionValues,DT,Elements,Edges,CandidateEdges,PreviousIt,TolGlobal)
%  analyse_gradients : main function of Self-adaptive Mesh Generator 
%
% INPUTS
%  NodesCoord         :
%  FunctionValues     :
%  DT                 :
%  Elements           :
%  Edges              :
%  CandidateEdges     :
%  PreviousIt         :
%  TolGlobal          :
%
% OUTPUTS
%  EdgesToSplit       :
%  GradeInElements    :
%

%checking the condition of the mesh
EdgesLengths=sqrt(sum((NodesCoord(Edges(:,2),:)-NodesCoord(Edges(:,1),:)).^2,2));
TolAdaptive = min(EdgesLengths);
disp(['Edges length min: ' , num2str(TolAdaptive), ' max: ',num2str(max(EdgesLengths))])
if(TolAdaptive<=TolGlobal)
    TolAdaptive = TolGlobal;
end

%checking which elements are new (for gradients and skins analysis)
ElementsPrevious = PreviousIt.Elements;
if(isempty(ElementsPrevious))
    NewElementsBool = true(size(Elements,1),1);
else
    [NewElementsBool,NewElementsId]=ismember(sort(Elements,2),sort(ElementsPrevious,2),'rows');
    NewElementsBool = ~NewElementsBool;
end

%%%% I - skiny
SkinyEdges = find_skiny_elements(Elements(NewElementsBool,:),NodesCoord,10);

%%%% II - adding new points in a phase extremum
%checking the phases in the previously added points
EdgesToSplitPrevious = PreviousIt.EdgesToSplit;
NrOfNodes=size(NodesCoord,1)-size(EdgesToSplitPrevious,1);
PhaseFlagOnEdges = ones(size(EdgesToSplitPrevious,1),1);
if(~isempty(EdgesToSplitPrevious))
    for ik=1:size(EdgesToSplitPrevious,1)
        PhaseFlagOnEdges(ik,1)=phase_validation(FunctionValues(EdgesToSplitPrevious(ik,1)),FunctionValues(EdgesToSplitPrevious(ik,2)),FunctionValues(ik+NrOfNodes,1));
    end
end
ExtremeNodesId = NrOfNodes+find(PhaseFlagOnEdges==2|isnan(PhaseFlagOnEdges));
ExtremeEdges = get_edges_attach_toVertix(DT, Elements, ExtremeNodesId);

%%%% cumulating edges from I, II + candidate Edges
EdgesToSplit =[
    CandidateEdges;
    ExtremeEdges;
    SkinyEdges
    ];
EdgesToSplit = unique(EdgesToSplit,'rows');
EdgesToCheckBool =ismember(Edges,EdgesToSplit,'rows');
EdgesToSplit=EdgesToSplit(EdgesLengths(EdgesToCheckBool)>TolGlobal,:);

%%%% III - gradienty
%preventing re-calculating of gradients
GradeInElementsPrevious = PreviousIt.GradeInElements;
GradeInElements =zeros(size(Elements,1),2);
if(~isempty(GradeInElementsPrevious))
    GradeInElements(~NewElementsBool,:) = GradeInElementsPrevious(NewElementsId(~NewElementsBool),:);
end

GradeElementsBool = true(size(Elements,1),1);
for ik = 1:size(CandidateEdges,1)
    TempElements = (Elements == CandidateEdges(ik,1) | Elements == CandidateEdges(ik,2));
    GradeElementsBool = GradeElementsBool&(sum(TempElements,2)<2);
end
GradeElementsBool = GradeElementsBool & NewElementsBool;

%calculating new gradients
ElementsTemp = Elements(GradeElementsBool,:);
GradeInElementsNew  = zeros(size(ElementsTemp,1),2);
for in=1:size(ElementsTemp,1)
    GradeInElementsNew(in,:) = calc_gradient(ElementsTemp(in,:),NodesCoord,angle(FunctionValues));
end
GradeInElements(GradeElementsBool,:) = GradeInElementsNew;

%determining the most important edge from the remaing
EdgesToCheck = ~EdgesToCheckBool;
EdgesToCheck = (EdgesLengths>TolAdaptive) & EdgesToCheck;
NrOfEdgesCheck = size(CandidateEdges,1)+size(ExtremeEdges,1);

TopEdge =  analyse_gradients(Edges(EdgesToCheck,:),DT,GradeInElements,TolAdaptive,EdgesLengths(EdgesToCheck),NrOfEdgesCheck);

%%%% final return edges
EdgesToSplit = [
    EdgesToSplit;
    TopEdge
    ];

end

