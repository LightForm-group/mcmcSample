%%
function [samples,n_loop,min_error] = updateSamples(odf,psi,samples,n_loop,sample,min_error,threshold)

    % make a temp copy
    temp_samples = samples;
    
    % add the new sample to the list
    temp_samples(n_loop+1) = sample;    
    
    % calculate the new odf
    odf_redo = calcDensity(temp_samples(1:n_loop+1),'kernel',psi);
    
    % determine the error
    error = calcError(odf,odf_redo);
    
    % if error is reduced, then update the samples
    if error <= min_error

        samples = temp_samples;
        n_loop = n_loop + 1;
        
        if min_error <= threshold
            min_error = threshold;
        else
            min_error = error;
        end
    end
end