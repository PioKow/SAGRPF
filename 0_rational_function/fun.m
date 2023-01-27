function w = fun(F,varargin)
%  fun : example rational function 
%
% INPUTS
%  F         :
%  varargin   : "island size"
%
% OUTPUTS
%  w         :
%

epsilon = varargin{1};
z = F(1)+ 1i*F(2);

za = 1/2 - (sqrt(3)/6)*1i;
zb = (sqrt(3)/3)*1i;
zc = -1/2 - (sqrt(3)/6)*1i;

w = (z-za)*(z-zb-epsilon)/(z-zc)/(z-zb+epsilon);

end

