%Construct and build dataset (3 stocks and three factors)
factors = dataset('XLSFile', 'dataset.xlsx' ,'Sheet','factors');

GE = dataset('XLSFile','dataset.xlsx' ,'Sheet','GE');

BP = dataset('XLSFile','dataset.xlsx', 'Sheet','BP');

NG = dataset('XLSFile','dataset.xlsx','Sheet','NG');



N=59; %number of periods
n=3; %number of stocks
nfactor=3; %number of factors --- Three-Factor Model
           %market factor; size factor; value factor

%Construct factor matrix from dataset
factor = [double(factors(1:59,2))' ; 
          %Market Premium(market factor) = Market Return - Risk-free Rate
          double(factors(1:59,3))';  
          %SMB(value factor) = Small[market capitalization] Minus Big
          double(factors(1:59,4))';]
          %HML(size factor) = High[book-to-market ratio] Minus Low
      
f = [ones(1, N); factor];

%Obtain real stock data from dataset
M_real = [double(GE(1:N,8))'; 
     double(BP(1:N,8))'; 
     double(NG(1:N,8))'];
 

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
    M_real*ones(N,1) == F*f*ones(N,1);
    [gama*eye(n), M_real-F*f; 
     (M_real-F*f)', gama*eye(N)] >= 0; 
cvx_end

%Use sensitivity function F to predict(recalculate) stock return
M_predict = F*f;

error = abs((M_real - M_predict)/M_predict);

meanerror_three = mean(error');































