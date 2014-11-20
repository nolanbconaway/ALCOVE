function [ps]=RESPONSERULE(outputactivation,phi)
%--------------------------------------------------------------------------
% This script simply calculates classification probabilites for a set of
% alcove's output activations, with a given parameter phi.
% 
% -------------------------------------
% --INPUT ARGUMENTS         DESCRIPTION
% 	outputactivation		observed output activation from FORWARDPASS
% 	phi						response mapping parameter
%--------------------------------------------------------------------------

numcategories = size(outputactivation,2);
outputactivation = exp(outputactivation .* phi);
ps = outputactivation ./ repmat(sum(outputactivation,2),[1,numcategories]);