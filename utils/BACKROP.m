function [attentionweights,associationweights]=BACKROP(associationweights, ...
	attentionweights,targetactivation,outputactivation,hiddenactivation, ...
	referencepoints,networkinput,params)
%--------------------------------------------------------------------------
% This script updates the weights of an ALCOVE network based on the results
% of a prior call to FORWARDPASS.m. Its sole outputs are updated weight
% matrices
% 
% -------------------------------------
% --INPUT ARGUMENTS         DESCRIPTION
% 	associationweights		weights to update
%	attentionweights		weights to update
% 	targetactivation		Target (teacher) activations, in range [-1 +1]
% 	outputactivation		observed output activation from FORWARDPASS
% 	hiddenactivation		observed hidden activation from FORWARDPASS
%	referencepoints			coordinates of each known exemplar
%	networkinput			patterns passed through the model
% 	params					parameters [c,assoclearning,attenlearning,phi]
%--------------------------------------------------------------------------

% define global variables
c				   = params(1);
assoclearning	   = params(2);
attenlearning	   = params(3);
numhiddenunits	   = size(associationweights,1);



 % Adjust the weights between hidden nodes and output nodes
%--------------------------------------------------------------
outputerror = targetactivation - outputactivation;
outputderivative = assoclearning * (outputerror' * hiddenactivation);
associationweights = associationweights + outputderivative';

% Adjust the attention weights between input nodes and hidden nodes
%--------------------------------------------------------------
hiddenerror=sum(associationweights.*repmat(outputerror,[numhiddenunits,1]),2);
hiddenderivative = hiddenerror' .* hiddenactivation * c * ...
	(abs(referencepoints - repmat(networkinput,[numhiddenunits,1])));
attentionweights = attentionweights + ((-attenlearning) .* hiddenderivative);
attentionweights(attentionweights>1)=1;
attentionweights(attentionweights<0)=0;