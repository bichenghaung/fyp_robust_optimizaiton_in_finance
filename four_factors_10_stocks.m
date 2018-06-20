%Construct and build dataset (3 stocks and four factors)
factors = dataset('XLSFile', 'dataset.xlsx' ,'Sheet','factors');

GE = dataset('XLSFile','dataset.xlsx' ,'Sheet','GE');

BP = dataset('XLSFile','dataset.xlsx', 'Sheet','BP');

BC = dataset('XLSFile','dataset.xlsx','Sheet','BC');

HSBC = dataset('XLSFile','dataset.xlsx','Sheet','HSBC');

LLOY = dataset('XLSFile','dataset.xlsx','Sheet','LLOY');

SBRY = dataset('XLSFile','dataset.xlsx','Sheet','SBRY');

RYAAY = dataset('XLSFile','dataset.xlsx','Sheet','RYAAY');

RBS = dataset('XLSFile','dataset.xlsx','Sheet','RBS');

EJ = dataset('XLSFile','dataset.xlsx','Sheet','EJ');

NG = dataset('XLSFile','dataset.xlsx','Sheet','NG');


N=59; %number of periods
n=10; %number of stocks
nfactor=4; %number of factors --- Carhart Four-Factor Model
           %market factor; size factor; value factor; momentum factor
           
           
factor = [double(factors(1:59,2))' ; 
          %Market Premium(market factor) = Market Return - Risk-free Rate
          double(factors(1:59,3))';  
          %SMB(value factor) = Small[market capitalization] Minus Big
          double(factors(1:59,4))';
          %HML(size factor) = High[book-to-market ratio] Minus Low
          double(factors(1:59,5))';]
          %UMD(momentum factor)
      
f = [ones(1, N); factor];

M_real = [double(GE(1:N,8))'; 
     double(BP(1:N,8))'; 
     double(NG(1:N,8))'
     double(BC(1:N,8))'
     double(HSBC(1:N,8))'
     double(LLOY(1:N,8))'
     double(RBS(1:N,8))'
     double(RYAAY(1:N,8))'
     double(SBRY(1:N,8))'
     double(EJ(1:N,8))'];
 

% M_real = [double(GE(55:62,8))';
%           double(BP(55:62,8))'; 
%           double(NG(55:62,8))'];
% Calculate Robust Model value

%[F] = FactormodelAlgorithm(M,f,N,n);
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

M_predict = F*f;

error_four = abs((M_real - M_predict)./M_predict);

meanerror_four = mean(error_four');

e = (meanerror_four - meanerror_three)./meanerror_three;











