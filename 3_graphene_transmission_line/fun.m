function w  =  fun(F,varargin)
%  fun: function definition
%       problem considers the evaluation of propragation coefficients of 
%       a graphene transmission line 
%       z = alfa + j Beta 
%       f = frequency
%
% INPUTS
%  F          : function argument F = [alfa, beta]
%  varargin   : some optional parameters
%
% OUTPUTS
%  w          : function value
%

z = F(1)+ 1i*F(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 299792458;        %
uo = 4 * pi * 1e-7;   %       
eo = 1/(uo*c*c);      %
                      %  
e = 1.602176565e-19;  %
kB = 1.3806488e-23;   % constans
hk = 1.05457168e-34;  % 
vFe = 1e6;            %
muc = 0.05*e;         % 
t = 0.135e-12;        %
T = 300;              %

er1=1;                % relative permittivity first dielectric
er2=11.9;             % relative permittivity second dielectric
f = 1e12;             % frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w=2*pi*f;
k0=w/c;
kro = -1j*z*k0;
Slo=-1j*e*e*kB*T*log( 2+2*cosh(muc/kB/T) )  / (pi*hk*hk*(w-1j/t));
a = -3*vFe*vFe*Slo/(4*(w-1j/t)^2);
b = a/3;

Y1TM = w*er1*eo/sqrt(er1*k0^2 - kro^2);
Y2TM = w*er2*eo/sqrt(er2*k0^2 - kro^2);
YSTM = Slo + 1*a*kro^2 + 1*b*kro^2;

w1 = Y1TM + Y2TM + YSTM;  %1 Riemann sheets
w2 = -Y1TM + Y2TM + YSTM; %2 Riemann sheets
w3 = Y1TM - Y2TM + YSTM;  %3 Riemann sheets
w4 = -Y1TM - Y2TM + YSTM; %4 Riemann sheets

w=w1*w2*w3*w4;

end

