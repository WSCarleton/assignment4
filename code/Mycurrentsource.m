%This is the stamp for the current source

function Mycurrentsource (n1, n2, val)


    global B;

    if (n1 ~= 0)
        B(n1) = B(n1) + val;
    end
    if (n2 ~= 0)
        B(n2) = B(n2) - val;
    end 


end

