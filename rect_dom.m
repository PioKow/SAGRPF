function NodesCoord = rect_dom(xb,xe,yb,ye)
%  rect_dom : generates the initial mesh for rectangular domain
%             z=x+jy x\in[xb,xe] , y\in[yb,ye]
%
% INPUTS
%  xb     : real part range begin
%  xe     : real part range end
%  yb     : imag part range begin
%  ye     : imag part range end
%
% OUTPUTS
%  NodesCoord  : generated nodes coordinates
%

X=xe-xb;
Y=ye-yb;
n=2;

if(X == Y)
    NodesCoord=[
        xb,yb;
        xe,yb;
        xe,ye;
        xb,ye;
        ];
else
    if(X>=Y)
        r = Y/(n-1);
        dy=Y/(n-1);
        m=ceil(X/sqrt(r^2-dy^2/4) +1);
        dx = X/(m-1);

        vx=linspace(xb,xe,m);
        vy=linspace(yb,ye,n);
        [x,y]=meshgrid(vx,vy);
        temp=ones(n,1);
        temp(n,:)=0;
        y=y+0.5*dy*kron( (1+(-1).^(1:m))/2, temp);

        x=reshape(x,m*n,1);
        y=reshape(y,m*n,1);
        if(mod(m,2)==1)
            tx=((2:2:m)-1)'*dx + xb;
        else
            tx=((2:2:m-1)-1)'*dx + xb;
            tx = [tx; xe];
        end
        ty=tx*0+yb;
        x=[x ; tx];
        y=[y ; ty];

        NodesCoord=[x,y];
    else
        m = n;
        r = X/(m-1);
        dx=X/(m-1);
        n=ceil(Y/sqrt(r^2-dx^2/4) +1);
        dy = Y/(n-1);

        vx=linspace(xb,xe,m);
        vy=linspace(yb,ye,n);
        [x,y]=meshgrid(vx,vy);
        temp=ones(m,1);
        temp(m,:)=0;
        x=x+0.5*dx*(kron( (1+(-1).^(1:n))/2, temp)');

        x=reshape(x,m*n,1);
        y=reshape(y,m*n,1);
        if(mod(n,2)==1)
            ty=((2:2:n)-1)'*dy + yb;
        else
            ty=((2:2:n-1)-1)'*dy + yb;
            ty = [ty; ye];
        end
        tx=ty*0+xb;
        x=[x ; tx];
        y=[y ; ty];

        NodesCoord=[x,y];
    end
end

end

