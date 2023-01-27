function vis(NodesCoord, Edges, Quadrants, PhasesDiff)
% vis : mesh visualization
%
% INPUTS
%  NodesCoord     : nodes coordinates
%  Edges          : edges definition
%  Quadrants      : quadrants in the nodes
%  PhasesDiff     : quadrant difference along the edges
%
% OUTPUTS
%

NoOfEdges=size(Edges,1);
EdgesColor=zeros(NoOfEdges,1);

EdgesColor(PhasesDiff==2|isnan(PhasesDiff))=5; % suspected edges
Temp=(PhasesDiff==0);
EdgesColor(Temp)=Quadrants(Edges(Temp,1));
vNaN=zeros(NoOfEdges,1)*NaN;

EdgesXCoord = [ NodesCoord(Edges(:,1),1) NodesCoord(Edges(:,2),1) vNaN];
EdgesYCoord = [ NodesCoord(Edges(:,1),2) NodesCoord(Edges(:,2),2) vNaN];
EdgesXCoord = reshape(EdgesXCoord',3*NoOfEdges,1);
EdgesYCoord = reshape(EdgesYCoord',3*NoOfEdges,1);
EdgesColor = kron(EdgesColor,[1;1;1]);

figure()
line(EdgesXCoord(EdgesColor == 0,:),EdgesYCoord(EdgesColor == 0,:),'Color','k','LineWidth',0.5);
line(EdgesXCoord(EdgesColor == 1,:),EdgesYCoord(EdgesColor == 1,:),'Color','r','LineWidth',0.5);
line(EdgesXCoord(EdgesColor == 2,:),EdgesYCoord(EdgesColor == 2,:),'Color','y','LineWidth',0.5);
line(EdgesXCoord(EdgesColor == 3,:),EdgesYCoord(EdgesColor == 3,:),'Color','g','LineWidth',0.5);
line(EdgesXCoord(EdgesColor == 4,:),EdgesYCoord(EdgesColor == 4,:),'Color','b','LineWidth',0.5);
line(EdgesXCoord(EdgesColor == 5,:),EdgesYCoord(EdgesColor == 5,:),'Color','m','LineWidth',3);
axis equal
hold on
title(['number of nodes = ',num2str(size(NodesCoord,1))])
drawnow;
hold off

end

