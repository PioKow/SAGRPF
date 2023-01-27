function GradInElement = calc_gradient(Elements,NodesCoord,Pha)
%  calc_gradient :
%
% INPUTS
%  Elements     :
%  NodesCoord   :
%  Pha          :
%
% OUTPUTS
%  GradInElement :
%

NA=Elements(:,1);
NB=Elements(:,2);
NC=Elements(:,3);

DPhAB=dPhase(Pha(NA),Pha(NB));
DPhBC=dPhase(Pha(NB),Pha(NC));
DPhCA=dPhase(Pha(NC),Pha(NA));

Cyrk=DPhAB+DPhBC+DPhCA; % circulation around the perimeter of the triangle

%suspicious triangle - the loop does not add up to zero
if abs(Cyrk)>1e-12
    GradInElement=[0,0];
else
    CordNA=NodesCoord(NA,:);
    CordNB=NodesCoord(NB,:);
    CordNC=NodesCoord(NC,:);

    W = [CordNB(1)-CordNA(1) CordNB(2)-CordNA(2);
        CordNC(1)-CordNA(1)  CordNC(2)-CordNA(2)];

    Wa = [DPhAB  CordNB(2)-CordNA(2);
        -DPhCA  CordNC(2)-CordNA(2)];

    Wb = [CordNB(1)-CordNA(1) DPhAB;
        CordNC(1)-CordNA(1)  -DPhCA];

    a=det(Wa)/det(W);
    b=det(Wb)/det(W);

    GradInElement=[a,b];
end

end

