function [samples,nLoop,minimumError] = updateSamples(odf,psi,samples,nLoop,sample,minimumError,threshold)
% updateSamples - Update a list of orientations using MCMC
% 
% Input Arguments:
% - odf (SO3Fun)
%   ODF to sample from
%
% - psi (SO3Kernel)
%   SO3Kernel function
%
% - samples (orientation)
%   Samples previously drawn from the ODF
%
% - nLoop (integer)
%   Current number of samples drawn
%
% - sample (orientation)
%   New orientation sampled from the ODF
% 
% - minimumError (float)
%   Current ODF error
%
% - threshold (float)
%   Minimum accuracy threshold
%
% Output Arguments:
% - samples (orientation)
%   Updated samples drawn from the ODF
%
% - nLoop (integer)
%   Updated number of samples drawn
%
% - minimumError (float)
%   Updated ODF error

    % make a trial copy of samples
    trialSamples = samples;
    
    % add the new sample to the array
    trialSamples(nLoop+1) = sample;    
    
    % calculate the new odf
    odfReconstruction = calcDensity(trialSamples(1:nLoop+1),'kernel',psi);
    
    % determine the error
    error = calcError(odf,odfReconstruction);
    
    % if error is reduced, then update the samples
    if error <= minimumError

        samples = trialSamples;
        nLoop = nLoop + 1;
        
        if minimumError <= threshold
            minimumError = threshold;
        else
            minimumError = error;
        end
    end
end