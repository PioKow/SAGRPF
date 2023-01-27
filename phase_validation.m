function flag =  phase_validation(A,B,C)
%  phase_validation :
%
% INPUTS
%  A   :
%  B   :
%  C   :
%
% OUTPUTS
%  flag    : 
%

vA = vinq_prim(A);
vB = vinq_prim(B);
vC = vinq_prim(C);
pA = angle(A);
pB = angle(B);
pC = angle(C);

if(abs(vA-vB) ==2)
    flag =0;
else
    if(vA ==2 && vB == 3 )
        pB = pB + 2*pi;
        if(vC == 3)
            pC = pC +2*pi;
        end
    elseif(vA ==3 && vB ==2)
        pA = pA + 2*pi;
        if(vC == 3)
            pC = pC + 2*pi;
        end
    end
    if((pA>=pC && pC>=pB) || (pA<=pC && pC<=pB))
        pDiff = abs(pA-pB);
        if(pDiff<pi)
            flag=1;
        else
            flag=2;
        end
    else
        flag = 2;
    end
end

    function w = vinq_prim(f)
        if real(f)>0  && imag(f)>=0
            w=1;
        elseif real(f)<=0 && imag(f)>=0
            w=2;
        elseif real(f)<0 && imag(f)<0
            w=3;
        elseif real(f)>=0  && imag(f)<0
            w=4;
        else
            w=NaN;
        end
    end

end

