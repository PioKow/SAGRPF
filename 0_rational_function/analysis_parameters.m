% this file contains all parameters of the analysis
% it is required ten variables:
% optional,xb,xe,yb,ye,Tol,NodesMin,NodesMax,ItMax,Mode

Optional = 1e-2; % "island size"

%domain size
xb = -1;  % real part range begin 
xe =  1;  % real part range end
yb = -1;  % imag part range begin
ye =  1;  % imag part range end 

Tol = 1e-9; %final accurency of finding roots 

%the number of points below which the adaptive mode is automatically used (without interrupt possibilities)
%set 0 if you want to manually choose the mode after each iteration
NodesMin = 0;

%the number of points after that the regular mode is automatically switched (without interrupt possibilities)
%set Inf if you want to manually choosing the mode after each iteration
NodesMax = Inf; 

ItMax = 50000; % Maximum number of iterations (buffer)

Mode = 0; 
%%%% analysis modes    
%Mode = 0 - Self-adaptive Mesh Generator 
%Mode = 1 - Regular Global complex Roots and Poles Finding algorithm -> https://github.com/PioKow/GRPF
%%%%

