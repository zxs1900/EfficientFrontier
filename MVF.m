% function [Wmv] = MVF( NumPortf,filename,ExcelRange)

% This script generates the traditional Minimum Variance frontier, with no
% resampling. It is called by frontier_resampling_main.m but could be used
% also on its onwn (in this case, you'd need to un-comment the portion of
% the script that loads the data, i.e. the next section). You could also
% tranform it into a function (see top line of code, now commented out).

%%
%generates random series (50 returns for 6 assets)
%RetSeries=randn(50,6);

%%if you are using matlab 7 and above
% prices = xlsread('Data','B2:K950');
%%if you are using matlab 6
%prices = xlsread('Data','B2:K950');
%prices(:,1)=[];
%prices(:,11)=[];
% 
% dimdata=size(prices);
% numprices=dimdata(1,1); %number of observations in the sample
% RetSeries=prices(1:numprices-1,:)./prices(2:numprices,:)-1;     %daily returns

%%

tic;
%get number of assets
NumAssets = length(RetSeries); 

T = size(RetSeries, 1); %determine time series length
NumAssets = size(RetSeries, 2); %determine number of assets
ERassets = mean(RetSeries); %compute expected returns
varcov = cov(RetSeries); %compute variance covariance matrix

% find maximum expected return.
ERmax = max(ERassets);

% set equality constraints
Aeq=ones(1,NumAssets);  %vector of ones
beq=1;
lb=zeros(NumAssets,1);  %vector of zeros
   
%%
%  QUADPROG Quadratic programming. 
%     X=QUADPROG(H,f,A,b) attempts to solve the quadratic programming problem:
%  
%              min 0.5*x'*H*x + f'*x   subject to:  A*x <= b 
%               x    
%  
%     X=QUADPROG(H,f,A,b,Aeq,beq) solves the problem above while additionally
%     satisfying the equality constraints Aeq*x = beq.
%  
% find minimum expected return,i.e.,global minimum variance portfolio expected return.
%     X=QUADPROG(H,f,A,b,Aeq,beq,LB,UB) defines a set of lower and upper
%     bounds on the design variables, X, so that the solution is in the 
%     range LB <= X <= UB. Use empty matrices for LB and UB
%     if no bounds exist. Set LB(i) = -Inf if X(i) is unbounded below; 
%     set UB(i) = Inf if X(i) is unbounded above.
    
options = optimset('display', 'off','largescale', 'off'); %set optimisation options
Wgmv = quadprog(varcov, [], [], [], Aeq, beq, lb, [], [], options); 
ERgmv = ERassets * Wgmv;

%compute expected return range partition
ERmv = linspace(ERgmv,ERmax,NumPortf);
%redefine constraints
Aeq = [Aeq; ERassets]; 
beq = [ones(1, NumPortf); ERmv];
%preallocate arrays
Wmv = zeros(NumAssets, NumPortf); 
SDmv = zeros(NumPortf, 1);
%generate efficient frontier using standard algorithm
for i=1 : NumPortf
    % compute target portfolio weights
    beq(:,i)
    Wmv(:,i) = quadprog(varcov, [], [], [], Aeq, beq(:,i), lb, [], [] , options);
    %compute target portfolio standard deviation
    SDmv(i,:) = sqrt(Wmv(:,i)'* varcov * Wmv(:,i));
end

plot(SDmv,ERmv,'-o')
xlabel('Standard deviation')
ylabel('Expected return')