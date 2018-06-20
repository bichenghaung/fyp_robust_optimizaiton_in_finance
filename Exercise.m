n = 10;
S = randn(n);
S = S * S'; %make S a symmetric matrix
mu = randn(n,1);
e = ones(n,1);
I = eye(n);
x = 1/n*ones(n,1);
risk = x'*S*x;
returnmu = mu'*x;


















