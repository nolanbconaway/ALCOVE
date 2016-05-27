function [ps]=RESPONSERULE(outputactivation,phi)
%--------------------------------------------------------------------------
% This script simply calculates classification probabilities for a set of
% alcove's output activations, with a given parameter phi.
%	 
% -------------------------------------
% --INPUT ARGUMENTS		 	DESCRIPTION
% 	outputactivation		observed output activation from FORWARDPASS
% 	phi						response mapping parameter
%--------------------------------------------------------------------------

outputactivation 	= exp(outputactivation .* phi);
ps = bsxfun(@rdivide,outputactivation,sum(outputactivation,2));
