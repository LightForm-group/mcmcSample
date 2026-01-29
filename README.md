# mcmcSample
Scripts for sampling an orientation distribution function (ODF) using MCMC sampling in MTEX.

## Requirements
The sampling procedure has been developed with the following versions of MTEX and MATLAB, while forwards and backwards compatibility may be possible, they have not been explicity verified. 
- MTEX 6.0.0
- MATLAB_R2024b

## Usage
An ODF may be sampled using the `mcmcSample` function by specifying an ODF and the number of samples. Optional arguments such as a kernel and an accuracy threshold may also be specified using the keywords `kernel` and `threshold`, respectively. See the `src/example.m` script for further details. 

## Installation
The scripts can be used by either running directly or adding to the MATLAB path using the 'Set Path' dialogue box. 
