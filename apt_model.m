%Construct and build dataset (10 stocks and three factors)
APTfactors = dataset('XLSFile', 'dataset_FTSE100.xlsx' ,'Sheet','APTfactors');

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
nfactor=4; %number of factors --- APT model

%Construct factor matrix from dataset
factor = [double(APTfactors(1:60,2))' ; 
          %Confidence Risk
          double(APTfactors(1:60,3))';  
          %Time Horizon Risk
          double(APTfactors(1:60,4))';
          %Inflation Risk
          double(APTfactors(1:60,5))';]
          %Business Cycle Risk
          
f = [ones(1, N); factor];

%Obtain real stock data from dataset
M_real_apt = [double(TESCO(1:N,7))'; 
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
    M_real_apt*ones(N,1) == F*f*ones(N,1);
    [gama*eye(n), M_real_apt-F*f; 
     (M_real_apt-F*f)', gama*eye(N)] >= 0; 
cvx_end

%Use sensitivity function F to predict(recalculate) stock return
M_predict_apt = F*f;

%Rate of return from 2018.4.16 to 2018.4.27
X_apt = M_predict_apt(:,51:60);
Y_apt = M_real_apt(:,51:60);

%error_4 = abs((M_predict_4 - M_real_4)./M_real_4);
error_apt = abs(M_predict_apt - M_real_apt).*20;

meanerror_apt = mean(error_apt');

e_aptand4 = (meanerror_apt - meanerror_4);

%mse_4 = immse(M_predict_4,M_real_4);
%plot
%tesco
figure;
plot(1:1:10,X_apt(1,:),'r');
hold on;
plot(1:1:10,Y_apt(1,:),'b');
hold on;
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('TESCO_{expected}', 'TESCO_{real}', 'Location','northeast')
%BP
figure;
plot(1:1:10,X_apt(2,:),'r');
hold on;
plot(1:1:10,Y_apt(2,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('BP_{expected}', 'BP_{real}', 'Location','northeast')
%NG
figure;
plot(1:1:10,X_apt(3,:),'r');
hold on;
plot(1:1:10,Y_apt(3,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('National Grid_{expected}', 'National Grid_{real}', 'Location','northeast')
%BC
figure;
plot(1:1:10,X_apt(4,:),'r');
hold on;
plot(1:1:10,Y_apt(4,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Barclays_{expected}', 'Barclays_{real}', 'Location','northeast')
%HSBC
figure;
plot(1:1:10,X_apt(5,:),'r');
hold on;
plot(1:1:10,Y_apt(5,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('HSBC_{expected}', 'HSBC_{real}', 'Location','northeast')
%LLOY
figure;
plot(1:1:10,X_apt(6,:),'r');
hold on;
plot(1:1:10,Y_apt(6,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Lloyds Banking_{expected}', 'Lloyds Banking_{real}', 'Location','northeast')
%BT
figure;
plot(1:1:10,X_apt(7,:),'r');
hold on;
plot(1:1:10,Y_apt(7,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('BT_{expected}', 'BT_{real}', 'Location','northeast')
%BRBY
figure;
plot(1:1:10,X_apt(8,:),'r');
hold on;
plot(1:1:10,Y_apt(8,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Burberry_{expected}', 'Burberry_{real}', 'Location','northeast')
%SBRY
figure;
plot(1:1:10,X_apt(9,:),'r');
hold on;
plot(1:1:10,Y_apt(9,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Sainsbury_{expected}', 'Sainsbury_{real}', 'Location','northeast')
%EJ
figure;
plot(1:1:10,X_apt(10,:),'r');
hold on;
plot(1:1:10,Y_apt(10,:),'b');
xlabel('Days') % x-axis label
ylabel('Rate of Return') % y-axis label
legend('Easy-Jet_{expected}', 'Easy-Jet_{real}', 'Location','northeast')







