%Construct and build dataset (10 stocks and three factors)
APTfactors = dataset('XLSFile', 'dataset_FTSE100.xlsx' ,'Sheet','APTfactors');

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
nfactor=8; %number of factors --- APT combined with four-factors model

%Construct factor matrix from dataset
factor = [double(APTfactors(1:60,2))' ; 
          %Confidence Risk
          double(APTfactors(1:60,3))';  
          %Time Horizon Risk
          double(APTfactors(1:60,4))';
          %Inflation Risk
          double(APTfactors(1:60,5))';
          %Business Cycle Risk
          double(factors(1:60,2))' ; 
          %Market Premium(market factor) = Market Return - Risk-free Rate
          double(factors(1:60,3))';  
          %SMB(value factor) = Small[market capitalization] Minus Big
          double(factors(1:60,4))';
          %HML(size factor) = High[book-to-market ratio] Minus Low
          double(factors(1:60,5))';]
          %UMD(momentum factor)
          
f = [ones(1, N); factor];

%Obtain real stock data from dataset
M_real_apt_4 = [double(TESCO(1:N,7))'; 
     double(BP(1:N,7))'; 
     double(NG(1:N,7))'
     double(BC(1:N,7))'
     double(HSBC(1:N,7))'
     double(LLOY(1:N,7))'
     double(BT(1:N,7))'
     double(BRBY(1:N,7))'
     double(SBRY(1:N,7))'
     double(EJ(1:N,7))'];

%Robust optimization algorithm
cvx_begin sdp
    cvx_precision high
    variable gama;
    variable F(n,nfactor+1);
    minimize(gama);
    subject to
    M_real_apt_4*ones(N,1) == F*f*ones(N,1);
    [gama*eye(n), M_real_apt_4-F*f; 
     (M_real_apt_4-F*f)', gama*eye(N)] >= 0; 
cvx_end

%Use sensitivity function F to predict(recalculate) stock return
M_predict_apt_4 = F*f;

%Rate of return from 2018.4.16 to 2018.4.27(10 days)
X_apt4 = M_predict_apt_4(:,51:60);
Y_apt4 = M_real_apt_4(:,51:60);
%Error Test
error_apt_4 = abs(M_predict_apt_4 - M_real_apt_4)*20;
meanerror_apt_4 = mean(error_apt_4');
e_4aptcombined_and4 = (meanerror_apt_4 - meanerror_4);%Error compared with 4-factor model

%mse_4 = immse(M_predict_4,M_real_4);

%plot
%tesco
figure;
plot(1:1:10,X_apt4(1,:),'r');
hold on;
plot(1:1:10,Y_apt4(1,:),'b');
hold on;
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('TESCO_{expected}', 'TESCO_{real}', 'Location','northeast')
%BP
figure;
plot(1:1:10,X_apt4(2,:),'r');
hold on;
plot(1:1:10,Y_apt4(2,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('BP_{expected}', 'BP_{real}', 'Location','northeast')
%NG
figure;
plot(1:1:10,X_apt4(3,:),'r');
hold on;
plot(1:1:10,Y_apt4(3,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('National Grid_{expected}', 'National Grid_{real}', 'Location','northeast')
%BC
figure;
plot(1:1:10,X_apt4(4,:),'r');
hold on;
plot(1:1:10,Y_apt4(4,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Barclays_{expected}', 'Barclays_{real}', 'Location','northeast')
%HSBC
figure;
plot(1:1:10,X_apt4(5,:),'r');
hold on;
plot(1:1:10,Y_apt4(5,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('HSBC_{expected}', 'HSBC_{real}', 'Location','northeast')
%LLOY
figure;
plot(1:1:10,X_apt4(6,:),'r');
hold on;
plot(1:1:10,Y_apt4(6,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Lloyds Banking_{expected}', 'Lloyds Banking_{real}', 'Location','northeast')
%BT
figure;
plot(1:1:10,X_apt4(7,:),'r');
hold on;
plot(1:1:10,Y_apt4(7,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('BT_{expected}', 'BT_{real}', 'Location','northeast')
%BRBY
figure;
plot(1:1:10,X_apt4(8,:),'r');
hold on;
plot(1:1:10,Y_apt4(8,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Burberry_{expected}', 'Burberry_{real}', 'Location','northeast')
%SBRY
figure;
plot(1:1:10,X_apt4(9,:),'r');
hold on;
plot(1:1:10,Y_apt4(9,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Sainsbury_{expected}', 'Sainsbury_{real}', 'Location','northeast')
%EJ
figure;
plot(1:1:10,X_apt4(10,:),'r');
hold on;
plot(1:1:10,Y_apt4(10,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Easy-Jet_{expected}', 'Easy-Jet_{real}', 'Location','northeast')



