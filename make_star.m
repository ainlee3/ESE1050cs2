function G = makestar(n)
e1 = zeros(n,1);
e1(1) = 1;
one = ones(n,1);

G = e1*one' + one*e1' - (2*e1)*e1';

end


