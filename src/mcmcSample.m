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
    psi = get_option(varargin, 'kernel', SO3DeLaValleePoussinKernel())
        
    % check the number of accepted samples
    n_loop = 1;
    
    % create a dummy list of samples for memory pre-allocation
    samples = odf.discreteSample(n);
   
    % calculate the odf, only using n_loop samples
    odf_redo = calcDensity(samples(1:n_loop),'kernel',psi);
    
    % determine the baseline error
    min_error = calcError(odf,odf_redo);
    
    % create a waitbar to track progress
    f = waitbar(0, 'Beginning sample...');
    pause(.5)

    % loop
    while n_loop < n
        
        % sample the objective odf once
        trial_sample = odf.discreteSample(1);
        
        % add to the list of samples and determine if the error is reduced
        [samples,n_loop,min_error] = updateSamples(odf,psi,samples,n_loop,trial_sample,min_error,threshold);

        statement = ['Number of samples: ',num2str(n_loop),', ODF error: ', num2str(round(min_error,3))];
        
        fraction = n_loop/n;

        f = waitbar(fraction,f,statement);

    end
    
    % close the waitbar and print the final result
    close(f)
    disp(statement)
