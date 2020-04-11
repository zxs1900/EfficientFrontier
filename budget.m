function myplot = budget(mydata,graphname)

[h,w] = size(mydata);
industry = mydata.Properties.VariableNames(1:w)';
monthlyReturn = table2array(mydata(:,1:w));
rf = 0.3772;



marPort = Portfolio('AssetList',industry,'RiskFreeRate',rf);
marPort = estimateAssetMoments(marPort,monthlyReturn);
[marMean,marCov] = getAssetMoments(marPort);

marPort = setDefaultConstraints(marPort); %no short sale

marSharpe = estimateMaxSharpeRatio(marPort);
[marRisk1 , marRet1] = estimatePortMoments(marPort,marSharpe);

marGMVP = estimateFrontierByReturn(marPort,min(marMean));
[marGrisk,marGret] = estimatePortMoments(marPort,marGMVP); %GMVP

b2 = setBudget(marPort,0,1); % without leverage 0% to 100%

b2wgt = estimateFrontier(b2,50);
[b2risk,b2ret] = estimatePortMoments(b2,b2wgt);





myplot = figure(1);
% efficient frontier
plotFrontier(marPort,50)
hold on;
title(graphname);
%tangency portfolio
plot(marRisk1,marRet1,'p','MarkerSize',15); 
%with risk free asset
plot(b2risk,b2ret);
%GMVP
scatter(marGrisk,marGret); 


legend('markowitz','markowitz tangency','markowitz rf asset','markowitz GMVP')

hold off;


end