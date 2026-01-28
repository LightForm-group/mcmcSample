function samples = mcmcSample(odf,n,varargin)
% mcmcSample - Sample an ODF using a MCMC algorithm
% 
% Input Arguments:
% - odf (SO3Fun)
%   ODF to sample from
%
% - n (integer)
%   Number of samples to draw
%
% - threshold (float)
%   Optional minimum accuracy threshold, default 0.05
% 
% - kernel (SO3Kernel)
%   Optional kernel to specify, default SO3DeLaValleePoussinKernel()
%
% Output Arguments:
% - samples (array)
%   Samples drawn from the ODF
    
    % default arguments
    threshold = get_option(varargin, 'threshold',0.05);
    psi = get_option(varargin, 'kernel', SO3DeLaValleePoussinKernel());
        
    % check the number of accepted samples
    nLoop = 1;
    
    % create a dummy list of samples for memory pre-allocation
    samples = odf.discreteSample(n);
   
    % calculate the odf, only using nLoop samples
    odfReconstruction = calcDensity(samples(1:nLoop),'kernel',psi);
    
    % determine the baseline error
    minimumError = calcError(odf,odfReconstruction);
    
    % create a waitbar to track progress
    f = waitbar(0, 'Beginning sampling algorithm...');
    pause(.5)

    % loop
    while nLoop < n
        
        % sample the objective odf once
        trial_sample = odf.discreteSample(1);
        
        % add to the list of samples and determine if the error is reduced
        [samples,nLoop,minimumError] = updateSamples(odf,psi,samples,nLoop,trial_sample,minimumError,threshold);

        statement = ['Number of samples: ',num2str(nLoop),', ODF error: ', num2str(round(minimumError,3))];
        
        fraction = nLoop/n;

        f = waitbar(fraction,f,statement);

    end
    
    % close the waitbar and print the final result
    close(f)
    disp(statement)
