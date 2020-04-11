clc;clear all;close all;


%%
%Q2
mydata1 = readtable('portfolios.xls','Sheet',1);
[myplot1,Q1marSharpe,Q1marGMVP,Q1bsSharpe1,Q1bsGMVP1,Q1bsSharpe2,Q1bsGMVP2] =...
    EF(mydata1,'17 industries portfolio efficient frontier');

%%
%Q3
mydata2 = readtable('portfolios.xls','Sheet',2);
[myplot2,Q2marSharpe,Q2marGMVP,Q2bsSharpe1,Q2bsGMVP1,Q2bsSharpe2,Q2bsGMVP2] =...
    EF(mydata2,'17 individual stocks portfolio efficient frontier');


%%
%Q4
myplot3 = budget(mydata1,'17 industries portfolio with risk free asset');


%%
%Q5
mydata3 = readtable('portfolios.xls','Sheet',3);
mydata4 = readtable('portfolios.xls','Sheet',4);
[myplot4,Q5ff3Sharpe,Q5ff3GMVP,Q5ff5Sharpe,Q5ff5GMVP] = ...
    fama(mydata3,mydata4,'fama french mimicking');


%%
%Q6
mydata5 = readtable('portfolios.xls','Sheet',5);
mydata6 = readtable('portfolios.xls','Sheet',6);
[myplot5,Q6ff3Sharpe,Q6ff3GMVP,Q6ff5Sharpe,Q6ff5GMVP] = ...
    fama(mydata5,mydata6,'fama french proxies');

%%
%Q8
mydata7 = readtable('portfolios.xls','Sheet',7);
[myplot7,Q30marSharpe,Q30marGMVP,Q30bsSharpe1,Q30bsGMVP1,Q30bsSharpe2,Q30bsGMVP2] =...
    EF(mydata7,'30 industries efficient frontier');
mydata8 = readtable('portfolios.xls','Sheet',8);
[myplot8,Q48marSharpe,Q48marGMVP,Q48bsSharpe1,Q48bsGMVP1,Q48bsSharpe2,Q48bsGMVP2] ...
    = EF(mydata8,'48 industries efficient frontier');


