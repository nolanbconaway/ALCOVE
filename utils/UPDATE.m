function [attentionweights, associationweights] = UPDATE(associationweights, ...
	attentionweights, target, outputactivation, hiddenactivation, ...
	exemplars, networkinput, params)
%--------------------------------------------------------------------------
% This script updates the weights of an ALCOVE network based on the results
% of a prior call to FORWARDPASS.m. Its sole outputs are updated weight
% matrices.
% 
% Future version of this code should support lists of inputs-- the code has
% not yet been tested on its function beyond a single training pattern.
% 
% -------------------------------------
% --INPUT ARGUMENTS		 	DESCRIPTION
% 	associationweights		weights to update
%	attentionweights		weights to update
% 	target					Target (teacher) activations, in range [-1 +1]
% 	outputactivation		observed output activation from FORWARDPASS
% 	hiddenactivation		observed hidden activation from FORWARDPASS
%	exemplars				coordinates of each known exemplar
%	networkinput			patterns passed through the model
% 	params					parameters [c,assoclearning,attenlearning,phi]
%--------------------------------------------------------------------------

% define global variables
c				   = params(1);
assoclearning	   = params(2);
attenlearning	   = params(3);
numhiddenunits	   = size(associationweights,1);

% Compute update for the association weights
%--------------------------------------------------------------
outputerror = target - outputactivation;
outputderivative = assoclearning * (outputerror' * hiddenactivation);

% Compute update for the attention weights
%--------------------------------------------------------------
hiddenerror=sum(associationweights.*repmat(outputerror,[numhiddenunits,1]),2);
hiddenderivative = hiddenerror' .* hiddenactivation * c * ...
	(abs(exemplars - repmat(networkinput,[numhiddenunits,1])));

% Apply weight updates
%--------------------------------------------------------------
associationweights = associationweights + outputderivative';

attentionweights = attentionweights + ((-attenlearning) .* hiddenderivative);
attentionweights(attentionweights<0)=0; % attention is non-negative

% Attention capacity: should the weights sum to 1?  
% attentionweights = attentionweights ./ sum(attentionweights,2);
