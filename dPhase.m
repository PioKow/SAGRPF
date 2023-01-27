function DPh = dPhase(Ph1,Ph2)
%  dPhase :
%
% INPUTS
%  Ph1     :
%  Ph2     :
%
% OUTPUTS
%  DPh     :
%

DPh=Ph2-Ph1;
if DPh>pi
    DPh=DPh-2*pi;
elseif DPh<-pi
    DPh=DPh+2*pi;
end

end

