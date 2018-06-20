%Construct and build dataset (10 stocks and three factors)
factors = dataset('XLSFile', 'dataset_FTSE100.xlsx' ,'Sheet','factors');

TESCO = dataset('XLSFile','dataset_FTSE100.xlsx' ,'Sheet','TSCO');

BP = dataset('XLSFile','dataset_FTSE100.xlsx', 'Sheet','BP');

BC = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','BC');

HSBC = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','HSBC');

LLOY = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','LLOY');

SBRY = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','SBRY');

BRBY = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','BRBY');

BT = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','BT');

EJ = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','EJ');

NG = dataset('XLSFile','dataset_FTSE100.xlsx','Sheet','NG');



N=60; %number of periods
n=10; %number of stocks
nfactor=3; %number of factors --- Four-factor model

%Construct factor matrix from dataset
factor = [%double(factors(1:60,2))' ; 
          %Market Premium(market factor) = Market Return - Risk-free Rate
          double(factors(1:60,3))';  
          %SMB(size factor) = Small[market capitalization] Minus Big
          double(factors(1:60,4))';
          %HML(value factor) = High[book-to-market ratio] Minus Low
          double(factors(1:60,5))';]
          %UMD(momentum factor)
          
f = [ones(1, N); factor];

%Obtain real stock data from dataset
M_real_3o4 = [double(TESCO(1:N,7))'; 
     double(BP(1:N,7))'; 
     double(NG(1:N,7))'
     double(BC(1:N,7))'
     double(HSBC(1:N,7))'
     double(LLOY(1:N,7))'
     double(BT(1:N,7))'
     double(BRBY(1:N,7))'
     double(SBRY(1:N,7))'
     double(EJ(1:N,7))'];
 

% M_real = [double(GE(55:62,8))';
%           double(BP(55:62,8))'; 
%           double(NG(55:62,8))'];

%[F] = FactormodelAlgorithm(M,f,N,n);

%Robust optimization algorithm
cvx_begin sdp
    cvx_precision high
    variable gama;
    variable F(n,nfactor+1);
    minimize(gama);
    subject to
    M_real_3o4*ones(N,1) == F*f*ones(N,1);
    [gama*eye(n), M_real_3o4-F*f; 
     (M_real_3o4-F*f)', gama*eye(N)] >= 0; 
cvx_end

%Use sensitivity function F to predict(recalculate) stock return
M_predict_3o4 = F*f;

%Rate of return from 2018.4.16 to 2018.4.27
X_four = M_predict_3o4(:,51:60);
Y_four = M_real_3o4(:,51:60);

%error_4 = abs((M_predict_4 - M_real_3o4)./M_real_3o4);
error_3o4 = abs(M_predict_3o4 - M_real_3o4).*20;

meanerror_3o4 = mean(error_3o4');
e_4 = (meanerror_3o4 - meanerror_4);