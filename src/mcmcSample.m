function [samples] = mcmcSample(odf,psi,n,threshold)

    % check the number of accepted samples
    n_loop = 1;
    
    % create a dummy list of samples for memory pre-allocation
    samples = odf.discreteSample(n);
   
    % calculate the odf, only using n_loop samples
    odf_redo = calcDensity(samples(1:n_loop),'kernel',psi);
    
    % determine the baseline error
    min_error = calcError(odf,odf_redo);

    f = waitbar(0, 'Beginning sample...');
    
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