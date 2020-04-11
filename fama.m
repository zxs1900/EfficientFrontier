function [myplot,a,b,c,d] = fama(mydata1,mydata2,graphname)


[~,w1] = size(mydata1);
[~,w2] = size(mydata2);
monthlyReturn3 = mydata1(:,1:w1);
monthlyReturn3 = table2array(monthlyReturn3);
monthlyReturn5 = mydata2(:,1:w2);
monthlyReturn5 = table2array(monthlyReturn5);


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
plotFrontier(fama3Port,50); % efficient frontier
hold on;
plotFrontier(fama5Port,50);
plot([0,fama3risk],[rf,fama3ret]); % CAL
plot([0,fama5risk],[rf,fama5ret]); % CAL
scatter(fama3grisk,fama3gret); %GMVP
scatter(fama5grisk,fama5gret); %GMVP
plot(fama3risk,fama3ret,'p','MarkerSize',15); %tangency portfolio
plot(fama5risk,fama5ret,'p','MarkerSize',15); %tangency portfolio
title(graphname);



legend('fama3','fama5','fama3 tangency','fama5 tangency',...
    'fama3 GMVP','fama5 GMVP',...
    'fama3 tangency port','fama5 tangency port');

hold off;


end