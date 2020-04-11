function [myplot,marPort,a,b,c,d,e,f] =EF(mydata,graphname)

%Q2

%markowitz


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


a = [marRisk1,marRet1];
b = [marGrisk,marGret];


%bayes shrinkage

q = ones(w,1)';
weights = 1/((q * inv(marCov))* q');

vol = ((weights*inv(marCov))*q')';
retp = vol * marMean;
i1 = (marMean-retp)'*inv(marCov);

lambda = (w+2)*(h+1)./(i1*(i1'*(h-w-2)));
psi = lambda/(lambda+h);
bsRet = (1-psi)*marMean'+psi*retp;


i2 = 1/(q *inv(marCov) * q');
i3 = lambda/(h*(h+lambda+1));
bsCov = marCov*(1+1/(h+lambda))+i2*i3;

%shrink only mean
bsPort1 = Portfolio('AssetList',industry,'RiskFreeRate',rf);
bsPort1 = setAssetMoments(bsPort1,bsRet,marCov);
bsPort1 = setDefaultConstraints(bsPort1);
bsSharpe1 = estimateMaxSharpeRatio(bsPort1);
[bsRisk1,bsRet1] = estimatePortMoments(bsPort1,bsSharpe1);
[bsMean1,bsCov1] = getAssetMoments(bsPort1);

bsGMVP1 = estimateFrontierByReturn(bsPort1,min(bsMean1));
[bsGrisk1,bsGret1] = estimatePortMoments(bsPort1,bsGMVP1); %GMVP

%shrink both mean and cov-var
bsPort2 = Portfolio('AssetList',industry,'RiskFreeRate',rf);
bsPort2 = setAssetMoments(bsPort2,bsRet,bsCov);
bsPort2 = setDefaultConstraints(bsPort2);
bsSharpe2 = estimateMaxSharpeRatio(bsPort2);
[bsRisk2,bsRet2] = estimatePortMoments(bsPort2,bsSharpe2);
[bsMean2,bsCov2] = getAssetMoments(bsPort2);



bsGMVP2 = estimateFrontierByReturn(bsPort2,min(bsMean2));
[bsGrisk2,bsGret2] = estimatePortMoments(bsPort2,bsGMVP2); %GMVP

c = [bsRisk1,bsRet1];
d = [bsGrisk1,bsGret1];
e = [bsRisk2,bsRet2];
f = [bsGrisk2,bsGret2];





myplot = figure(1);
% efficient frontier
plotFrontier(marPort,50); 
hold on;
plotFrontier(bsPort1,50);
plotFrontier(bsPort2,50);
title(graphname);

%tangency portfolio
plot(marRisk1,marRet1,'p','MarkerSize',15); 
plot(bsRisk1,bsRet1,'p','MarkerSize',15);
plot(bsRisk2,bsRet2,'p','MarkerSize',15);

%GMVP
scatter(marGrisk,marGret); 
scatter(bsGrisk1,bsGret1);
scatter(bsGrisk2,bsGret2);

% CAL
plot([0,marRisk1],[rf,marRet1]); 
plot([0,bsRisk1],[rf,bsRet1]);
plot([0,bsRisk2],[rf,bsRet2]);



legend('markowitz','bs only mean','bs both',...
    'markowitz tangency','bs only mean tangency','bs both tangency',...
    'markowitz GMVP','bs only GMVP','bs both GMVP',...
    'markowitz tangency line','bs only tangency line','bs both tangency line');
hold off;





end