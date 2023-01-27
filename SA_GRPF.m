% Copyright (c) 2023 Gdansk University of Technology
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
%
% Authors: S.Dziedziewicz P.Kowalczyk R.Lech M.Warecka
% Project homepage: https://github.com/PioKow/SAGRPF
%
%
% main program SA-GRPF
%
close all;
clear all;
clc;
format long;
restoredefaultpath

%choose the example
%addpath('0_rational_function');
addpath('3_graphene_transmission_line');

analysis_parameters %input file
NewNodesCoord = rect_dom(xb,xe,yb,ye); %generates the initial mesh

%initialization of the variables
it=0;
NodesCoord=[];
PreviousIt.EdgesToSplit=[];
PreviousIt.Elements=[];
PreviousIt.GradeInElements=[];
NrOfNodes = size(NodesCoord,1);

%%%% analysis modes    
%Mode = 0 - Self-adaptive Mesh Generator 
%Mode = 1 - Regular Global complex Roots and Poles Finding algorithm -> https://github.com/PioKow/GRPF
%Mode = 2 - The result of aborted analysis
%Mode = 3 - The final result (accuracy achieved)
%%%%
%% general loop
while it<ItMax && Mode<2

    %function evaluation
    NodesCoord=[NodesCoord ; NewNodesCoord];
    disp(['Evaluation of the function in ',num2str(size(NewNodesCoord,1)),' new points...'])

    TimerOfFunEval = tic;
    for Node=NrOfNodes+1:NrOfNodes+size(NewNodesCoord,1)
        FunctionValues(Node,1)=fun(NodesCoord(Node,:),Optional);
        Quadrants(Node,1) = vinq( FunctionValues(Node,1) );
    end
    if(size(NewNodesCoord,1)>0)
        SingleNodeTime = toc(TimerOfFunEval)/size(NewNodesCoord,1);
    else
        SingleNodeTime=NaN;
    end

    %%% meshing operation
    NrOfNodes=size(NodesCoord,1);
    disp(['Triangulation and analysis of ',num2str(NrOfNodes),' nodes...'])
    DT = delaunayTriangulation(NodesCoord(:,1),NodesCoord(:,2));
    Elements = DT.ConnectivityList;
    Edges = edges(DT);

    %phase analysis
    PhasesDiff=abs(Quadrants(Edges(:,1))-Quadrants(Edges(:,2)));
    PhasesDiff(PhasesDiff==3)=1;
    CandidateEdges=Edges(PhasesDiff==2|isnan(PhasesDiff),:);

    %Self-adaptive Mesh Generator Mode
    if(Mode==0)
        [EdgesToSplit,GradeInElements] = adaptive(NodesCoord,FunctionValues,DT,Elements,Edges,CandidateEdges,PreviousIt,Tol);
        PreviousIt.EdgesToSplit=EdgesToSplit;
        PreviousIt.Elements=Elements;
        PreviousIt.GradeInElements=GradeInElements;

        if(isempty(EdgesToSplit))
            Mode = 3;
        elseif(NrOfNodes>NodesMin && NrOfNodes<NodesMax)
            %visualization
            vis(NodesCoord, Edges, Quadrants,PhasesDiff)
            disp(['Do you want to continue the SA mode and add new ',num2str(size(EdgesToSplit,1)),' points?'])
            disp(['Estimated time of the analysis: ',num2str(floor(size(EdgesToSplit,1)*SingleNodeTime)),' s'])
            Mode=-1;
            while Mode<0
                Prompt = 'Select analysis mode -> Adaptive/Regular/Cancel? [a]/[r]/[c]';
                str = input(Prompt,'s');
                if(str=="r")
                    Mode=1;
                elseif(str=="c")
                    Mode=2;
                elseif(str=="a")
                    Mode=0;
                end
            end
        elseif(NrOfNodes>=NodesMax)
            Mode = 1;
        end
        if(Mode==1)
            disp("The mode has been switched to the regular GRPF")
            disp('---------------------')
        end
    end

    if(Mode==1) %Regular Global complex Roots and Poles Finding algorithm
        [EdgesToSplit, Mode] = regular(NodesCoord,Tol,DT,Elements,CandidateEdges);
    end

    %split the edge in half
    if(~isempty(EdgesToSplit))
        NewNodesCoord = (NodesCoord(EdgesToSplit(:,1),:)+NodesCoord(EdgesToSplit(:,2),:))/2;
    end

    it=it+1;
    disp(['Iteration : ',num2str(it), ' done'])
    disp('----------------------------------------------------------------')

end

%final analysis
if(Mode==2)
    disp(['Finish after: ',num2str(it), ' iteration'])
end
if(Mode==3)
    disp(['Assumed accuracy is achieved in iteration: ',num2str(it)])
end

[Regions, z_root, z_roots_multiplicity, z_poles, z_poles_multiplicity] = analyse_regions(DT,NodesCoord,Elements,Edges,Quadrants,PhasesDiff,CandidateEdges);

