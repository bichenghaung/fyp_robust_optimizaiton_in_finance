%Basic algorithm derived from factor model
%Basic algorithm is tested by randomly generated data
%with 5 risk factors, 9 stocks, and time period 10
nf = 5; n = 9; N = 10;
F_hat = randn(n,nf+1); fi = randn(nf+1,N);
M_real = F_hat*fi;
cvx_begin sdp; cvx_precision high
    variable gama;
    variable F(n,nf+1);
    minimize(gama);
    subject to 
    M_real == F*fi;
    [gama*eye(N),(M_real-F*fi)';
     M_real-F*fi,gama*eye(n)] >= 0;
cvx_end

M_predict = F*fi;
difference = M_predict - M_real; %error between real and predicted data
e_F = abs((F-F_hat)./F_hat); %error between two factor loading matrices







