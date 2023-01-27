function Edges = get_edges_attach_toVertix(DT, Elements, CandidateNodesId)
%  get_edges_attach_toVertix : 
%
% INPUTS
%  DT                : 
%  Elements          :
%  CandidateNodesId  :
%
% OUTPUTS
%  Edges   : 
%

Edges = [];
for ik = 1:size(CandidateNodesId,1)
    nrOfElementTemp = vertexAttachments(DT,CandidateNodesId(ik,:));
    verticesTemp = unique(Elements(nrOfElementTemp{1},:));
    verticesTemp(verticesTemp == CandidateNodesId(ik,:)) = [];
    
    EdgesTemp =zeros(size(verticesTemp,1),2);
    EdgesTemp(:,1) = verticesTemp;
    EdgesTemp(:,2) = CandidateNodesId(ik,:);
    EdgesTemp = sort(EdgesTemp,2,'ascend');
    Edges = [Edges;EdgesTemp];
end

end

