function M = getMachFromAreaRatio(k, e, M0)
    tol = 1e-12;
    M1 = M0;
    err = leggeAreeTraslata(M0, k, e)/leggeAreeDerivata(M0, k);
    while abs(err) > abs(tol)
        err = leggeAreeTraslata(M1, k, e)/leggeAreeDerivata(M1, k);
        M2 = M1 - err;
        M1 = M2;
    end
    M = M2;
end