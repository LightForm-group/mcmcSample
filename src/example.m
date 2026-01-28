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
psi = SO3DeLaValleePoussinKernel('halfwidth',12.0*degree, 'bandwidth',16);
odf = unimodalODF(ori(:),'weights',c,'kernel',psi);

plotPDF(odf,h,'antipodal','silent','complete');

%% stochastic improvement sampling using mcmcSample
n = 50; % number of samples
threshold = 0.05; % threshold error

samples = mcmcSample(odf,n,'threshold',threshold,'kernel',psi);

%% compare errors

% calculate the odf for the mcmcSample and the equivalent discreteSample
odfReconstruction = calcDensity(samples,'kernel',psi);
odfDirect = calcDensity(odf.discreteSample(100),'kernel',psi)

directError = calcError(odf,odfDirect)
MCMCError = calcError(odf,odfReconstruction)

% print statement
statement = ['discreteSample error: ',num2str(directError),', mcmcSample error: ', num2str(MCMCError)];
disp(statement)

plotPDF(odfReconstruction,h,'antipodal','silent','complete')
