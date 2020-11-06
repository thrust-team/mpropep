function [M, err, n] = leggeAree(epsilon, k, M0, tol)
    M1 = M0;
    err = leggeAreeTraslata(M0, k, epsilon)/leggeAreeDerivata(M0, k);
    n = 1;
    while abs(err) > abs(tol)
        err = leggeAreeTraslata(M1, k, epsilon)/leggeAreeDerivata(M1, k);
        M2 = M1 - err;
        M1 = M2;
        n = n+1;
    end
    M = M2;
end