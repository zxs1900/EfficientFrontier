% See chapter "Portfolio Selection: “Optimizing? an Error" from
% "Implementing Models in Quantitative Finance: Methods and Cases" 
% by Gianluca Fusai and Andrea Roncoroni

% Frontier resampling for Assignment 1
tic;
clear 
clc

%generates random series (50 returns for 6 assets)
%RetSeries=randn(50,6);

%%if you are using matlab 7 and above
RetSeries = xlsread('17_Industry_Portfolios.xls','A2:Q685');
%%if you are using matlab 6
%prices = xlsread('Data','B2:K950');
%prices(:,1)=[];
%prices(:,11)=[];


%%
%compute resampled frontier
NumPortf=20;
NumSimu=100;
[Wrsp,ERrsp,SDrsp,Wmv,ERmv,SDmv,Wmv_S] = resampfront(RetSeries, NumPortf, NumSimu);
size(Wrsp)
%%
%plots confidence region
PortfSet=[1,5,10,15,17,20];
ConfLevel=10;
confregion(Wrsp,ERrsp,SDrsp,ERmv,SDmv,Wmv_S,RetSeries,PortfSet,ConfLevel)
%%
%plots statistical equivalence region
stateqregion(RetSeries, ERmv, SDmv, Wmv_S)

%generates statistics
[Stats]=resampstats(Wmv, Wmv_S, Wrsp, PortfSet, ConfLevel);
nameasset=cellstr(['ENI      ';	'TIM      ';'ENEL     ';	'UNICREDIT';	'GENERALI ';	'TELECOM  ';	'BCAINTESA';	'ST MICRO ';	'AUTOSTR  ';	'SANPAOLO '])

%%

figure(4)
for i=1:10
     subplot(5,2,i)
     hist(Wmv_S(i,1,:))
     xlabel('Simulated weight')
%      ylabel('Frequency')
     title(nameasset( i,1))
 end
toc;
