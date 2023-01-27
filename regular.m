function [EdgesToSplit, Mode] = regular(NodesCoord,Tol,DT,Elements,CandidateEdges)
%  regular : Regular Global complex Roots and Poles Finding appraoch
%            base on -> https://github.com/PioKow/GRPF
%
% INPUTS
%  NodesCoord      :
%  Tol             :
%  DT              :
%  Elements        :
%  CandidateEdges  :
%
% OUTPUTS
%  CandidateEdges  :
%  Mode            :
%

Mode = 1;
if(isempty(CandidateEdges))
    Mode = 2;
    return
end

CandidateEdgesLengths=sqrt(sum((NodesCoord(CandidateEdges(:,2),:)-NodesCoord(CandidateEdges(:,1),:)).^2,2));
MaxCandidateEdgesLengths=max(CandidateEdgesLengths);
disp(['Candidate edges length min: ' , num2str(min(CandidateEdgesLengths)), ' max: ',num2str(MaxCandidateEdgesLengths)])

if(MaxCandidateEdgesLengths<Tol)
    Mode = 3;
end

ArrayOfCandidateElements = vertexAttachments(DT,unique(CandidateEdges));
NoOfConnectionsToCandidate=zeros(size(Elements,1),1);
for ik=1:size(ArrayOfCandidateElements,1)
    NoOfConnectionsToCandidate(ArrayOfCandidateElements{ik})=NoOfConnectionsToCandidate(ArrayOfCandidateElements{ik})+1;
end
SkinyEdges = find_skiny_elements(Elements(NoOfConnectionsToCandidate>=1,:),NodesCoord,10);

EdgesToSplit=[
    CandidateEdges;
    SkinyEdges
    ];
EdgesToSplit = unique(EdgesToSplit,'rows');
EdgesToSplitLengths=sqrt(sum((NodesCoord(EdgesToSplit(:,2),:)-NodesCoord(EdgesToSplit(:,1),:)).^2,2));
EdgesToSplit=EdgesToSplit(EdgesToSplitLengths>Tol,:);

end

