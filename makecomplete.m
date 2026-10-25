function G = make_complete(n)
I = eye(n, n);
onesVector = ones(n,1);
G = onesVector * onesVector' - I;
end

disp(make_complete(5));