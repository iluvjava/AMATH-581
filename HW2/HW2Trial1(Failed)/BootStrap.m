function Res = BootStrap(solutionVec, L, Epsilon, DeltaX)
% Bootstrap the boundary
    Res = solutionVec;
    Res = [(4*solutionVec(1) - solutionVec(2)) ...
            /(3 + 2*DeltaX*sqrt(L^2 - Epsilon));
            Res];
    Res(end + 1) = (4*solutionVec(end) - solutionVec(end - 1)) ... 
        /(3 + 2*DeltaX*sqrt(L^2 - Epsilon));
end
