function G = make_disk(P, r)
s = P(:,1).^2 + P(:,2).^2;
one = ones(size(P,1),1);

delta = s* one' + one*s' - (2*P)*P';

A = double(delta <= r^2);

G = A - eye(size(P, 1));

end

