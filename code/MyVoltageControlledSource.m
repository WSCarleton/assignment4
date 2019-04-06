

function MyVoltageControlledSource (n1, n2, refn1, refn2, val)

    global C
    global G
    global B

    cSize = size (C,1);
    cSize = cSize + 1;

    C(cSize, cSize) = 0;
    G(cSize, cSize) = 0;
    B(cSize) = 0;

    if (n1 ~= 0)
        G(n1, cSize) = 1;
        G(cSize, n1) = 1;
    end 

    if (n2 ~= 0)
        G(n2, cSize) = -1;
        G(cSize, n2) = -1;
    end
    
    if (refn1 ~= 0 )
        G(cSize, refn1) = G(cSize, refn1) - val;
    end
    if (refn2 ~= 0 )
        G(cSize, refn2) = G(cSize, refn2) + val;
    end
    

end