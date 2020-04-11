[~,w1] = size(mydata1);
[~,w3] = size(mydata3);
[~,w5] = size(mydata4);
industry = mydata1.Properties.VariableNames(1:w1)';
monthlyReturn1 = table2array(mydata1(:,1:w1));
monthlyReturn3 = mydata3(:,1:w3);
monthlyReturn3 = table2array(monthlyReturn3);
monthlyReturn5 = mydata4(:,1:w5);
monthlyReturn5 = table2array(monthlyReturn5);
rf = 0.3772;

%markowitz
marPort = Portfolio('AssetList',industry,'RiskFreeRate',rf);
marPort = estimateAssetMoments(marPort,monthlyReturn1);
marPort = setDefaultConstraints(marPort);
[marMean,marCov] = getAssetMoments(marPort);
marSharpe = estimateMaxSharpeRatio(marPort);
[marRisk1 , marRet1] = estimatePortMoments(marPort,marSharpe);
marGMVP = estimateFrontierByReturn(marPort,min(marMean));
[marGrisk,marGret] = estimatePortMoments(marPort,marGMVP); %GMVP


%famafrench 3 factor



fama3Port = Portfolio('RiskFreeRate',rf);
fama3Port = estimateAssetMoments(fama3Port,monthlyReturn3);
fama3Port = setDefaultConstraints(fama3Port); %no short sale
[fama3Mean,~] = getAssetMoments(fama3Port);
fama3Port = setDefaultConstraints(fama3Port); %no short sale
fama3Sharpe = estimateMaxSharpeRatio(fama3Port);
[fama3risk , fama3ret] = estimatePortMoments(fama3Port,fama3Sharpe);
fama3gm = estimateFrontierByReturn(fama3Port,min(fama3Mean));
[fama3grisk,fama3gret] = estimatePortMoments(fama3Port,fama3gm); %GMVP


%famafrench 5 factor
fama5Port = Portfolio('RiskFreeRate',rf);
fama5Port = estimateAssetMoments(fama5Port,monthlyReturn5);
fama5Port = setDefaultConstraints(fama5Port); %no short sale
[fama5Mean,~] = getAssetMoments(fama5Port);
fama5Port = setDefaultConstraints(fama5Port); %no short sale
fama5Sharpe = estimateMaxSharpeRatio(fama5Port);
[fama5risk , fama5ret] = estimatePortMoments(fama5Port,fama5Sharpe);
fama5gm = estimateFrontierByReturn(fama5Port,min(fama5Mean));
[fama5grisk,fama5gret] = estimatePortMoments(fama5Port,fama5gm); %GMVP



%%
figure();
plotFrontier(marPort) % efficient frontier
hold on;
plotFrontier(fama3Port,50);
plotFrontier(fama5Port,50);
title('Q5 plot1');
legend('markowitz','fama3','fama5');
hold off;





%%
figure();
plotFrontier(marPort,50);
 % efficient frontier
hold on;
plotFrontier(fama3Port,50);
plotFrontier(fama5Port,50);
plot([0,marRisk1],[rf,marRet1]); 
plot([0,fama3risk],[rf,fama3ret]); % CAL
plot([0,fama5risk],[rf,fama5ret]); % CAL
scatter(marGrisk,marGret);
scatter(fama3grisk,fama3gret); %GMVP
scatter(fama5grisk,fama5gret); %GMVP
plot(marRisk1,marRet1,'p','MarkerSize',15); 
plot(fama3risk,fama3ret,'p','MarkerSize',15); %tangency portfolio
plot(fama5risk,fama5ret,'p','MarkerSize',15); %tangency portfolio
title('Q5 plot2');
legend('mar','fama3','fama5',...
    'mar tangency','fama3 tangency','fama5 tangency',...
    'mar GMVP','fama3 GMVP','fama5 GMVP',...
    'mar tangency port','fama3 tangency port','fama5 tangency port');
hold off;
