mydata1 = readtable('portfolios.xls','Sheet',9);
mydata2 = readtable('portfolios.xls','Sheet',3);
mydata3 = readtable('portfolios.xls','Sheet',4);



[~,w1] = size(mydata1);
[h2,w2] = size(mydata2);
[h3,w3] = size(mydata3);
monthlyReturn1 = mydata1(:,1:w1);
monthlyReturn1 = table2array(monthlyReturn1);
monthlyReturn3 = mydata2(h2-118:h2,1:w2);
monthlyReturn3 = table2array(monthlyReturn3);
monthlyReturn5 = mydata3(h3-118:h3,1:w3);
monthlyReturn5 = table2array(monthlyReturn5);
rf = 0.3772;

%%
marPort = Portfolio('RiskFreeRate',rf);
marPort = estimateAssetMoments(marPort,monthlyReturn1);
[marMean,marCov] = getAssetMoments(marPort);

marPort = setDefaultConstraints(marPort); %no short sale

marSharpe = estimateMaxSharpeRatio(marPort);
[marRisk1 , marRet1] = estimatePortMoments(marPort,marSharpe);

marGMVP = estimateFrontierByReturn(marPort,min(marMean));
[marGrisk,marGret] = estimatePortMoments(marPort,marGMVP); %GMVP

%%

%famafrench 3 factor

rf = 0.3772;

fama3Port = Portfolio('RiskFreeRate',rf);
fama3Port = estimateAssetMoments(fama3Port,monthlyReturn3);
[fama3Mean,~] = getAssetMoments(fama3Port);
fama3Port = setDefaultConstraints(fama3Port); %no short sale
fama3Sharpe = estimateMaxSharpeRatio(fama3Port);
[fama3risk , fama3ret] = estimatePortMoments(fama3Port,fama3Sharpe);
fama3gm = estimateFrontierByReturn(fama3Port,min(fama3Mean));
[fama3grisk,fama3gret] = estimatePortMoments(fama3Port,fama3gm); %GMVP


a = [fama3risk , fama3ret];
b = [fama3grisk,fama3gret];

%famafrench 5 factor
fama5Port = Portfolio('RiskFreeRate',rf);
fama5Port = estimateAssetMoments(fama5Port,monthlyReturn5);
[fama5Mean,~] = getAssetMoments(fama5Port);

fama5Port = setDefaultConstraints(fama5Port); %no short sale
fama5Sharpe = estimateMaxSharpeRatio(fama5Port);
[fama5risk , fama5ret] = estimatePortMoments(fama5Port,fama5Sharpe);

fama5gm = estimateFrontierByReturn(fama5Port,min(fama5Mean));
[fama5grisk,fama5gret] = estimatePortMoments(fama5Port,fama5gm); %GMVP

c = [fama5risk , fama5ret];
d = [fama5grisk,fama5gret];




myplot = figure();
plotFrontier(marPort,50);
hold on;
plotFrontier(fama3Port,50); % efficient frontier
plotFrontier(fama5Port,50);
plot(marRisk1,marRet1,'p','MarkerSize',15); 
plot(fama3risk,fama3ret,'p','MarkerSize',15); %tangency portfolio
plot(fama5risk,fama5ret,'p','MarkerSize',15); %tangency portfolio




legend('small cap','fama3','fama5',...
    'small cap tangency port','fama3 tangency port','fama5 tangency port');

hold off;


