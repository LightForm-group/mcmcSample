%% generate synthetic texture (mtex example)
CS = crystalSymmetry('cubic');
SS = specimenSymmetry('222');
h = [Miller(1,1,1,CS),Miller(2,0,0,CS),Miller(2,2,0,CS)];

% some component center
ori = [orientation.byEuler(135*degree,45*degree,120*degree,CS,SS) ...
  orientation.byEuler( 60*degree, 54.73*degree, 45*degree,CS,SS) ...
  orientation.byEuler(70*degree,90*degree,45*degree,CS,SS)...
  orientation.byEuler(0*degree,0*degree,0*degree,CS,SS)];

% with corresponding weights
c = [.4,.13,.4,.07];

% the model odf
odf = unimodalODF(ori(:),'weights',c,'halfwidth',12*degree)

plotPDF(odf,h,'antipodal','silent','complete')

%% stochastic improvement sampling using mcmcSample
n = 25; % number of samples
threshold = 0.05; % threshold error

samples = mcmcSample(odf,psi,n,threshold);

%% compare errors

% calculate the odf for the mcmcSample and the equivalent discreteSample
odf_redo = calcDensity(samples,'kernel',psi);
odf_direct = calcDensity(odf.discreteSample(100),'kernel',psi)

direct_error = calcError(odf,odf_direct)
mcmc_error = calcError(odf,odf_redo)

% print statement
statement = ['discreteSample error: ',num2str(direct_error),', mcmcSample error: ', num2str(mcmc_error)];
disp(statement)

plotPDF(odf_redo,h,'antipodal','silent','complete')
