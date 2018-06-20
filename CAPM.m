%Obtain data of risk-free rate
rfree = dataset('XLSFile', 'dataset_FTSE100.xlsx' ,'Sheet','United Kingdom 20-Year Bond Yie');
%Obtain data of market risk factor
factors = dataset('XLSFile', 'dataset_FTSE100.xlsx' ,'Sheet','factors');
%Obtain real stock data from dataset
M_real_capm = [double(TESCO(1:N,7))';
     double(BP(1:N,7))' ;
     double(NG(1:N,7))';
     double(BC(1:N,7))';
     double(HSBC(1:N,7))';
     double(LLOY(1:N,7))';
     double(BT(1:N,7))';
     double(BRBY(1:N,7))';
     double(SBRY(1:N,7))';
     double(EJ(1:N,7))'];
%Determine value of beta for each stock
 beta = [0.99;1.35;0.86;0.48;1.08;0.52;1.1;1.44;1.04;0.22];
 %Construct risk free rate matrix for the portfolio
 r_f = [double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';
        double(rfree(1:60,6))';];
 %Compute expected rate of return for each stock   
 r_i = r_f + [0.99*double(factors(1:60,2))';
              1.35*double(factors(1:60,2))';
              0.86*double(factors(1:60,2))';
              0.48*double(factors(1:60,2))';
              1.08*double(factors(1:60,2))';
              0.52*double(factors(1:60,2))';
              1.1*double(factors(1:60,2))';
              1.44*double(factors(1:60,2))';
              1.04*double(factors(1:60,2))';
              0.22*double(factors(1:60,2))';]
%Error Test         
 error_capm = abs(r_i - M_real_capm)*20;%Error test of CAPM
 
 meanerror_capm = mean(error_capm');
 
 e_capm = (meanerror_capm - meanerror_apt_4);%Accuracy compared with 4-factot-APT model
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 