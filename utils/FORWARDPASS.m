function [outputactivation, hiddenactivation] = FORWARDPASS(...
	stimuli,exemplars,distancemetric,attentionweights,associationweights,params)
%--------------------------------------------------------------------------
% This script runs a forward pass in alcove and returns the information
% about network performance.
% 
% -------------------------------------
% --INPUT ARGUMENTS			DESCRIPTION
%	networkinput			items to be passed through the model
%	exemplars				coordinates of each known exemplar
%	attentionweights		input->hidden weights
% 	associationweights		hidden->output weights
%	distancemetric			0 for city block, 1 for euclidean
% 	params					parameters [c,assoclearning,attenlearning,phi]

% -------------------------------------
% --OUTPUT ARGUMENTS		DESCRIPTION
%	outputactivation		output unit activations
%	hiddenactivation		exemplar node activations
%--------------------------------------------------------------------------

% initialize variables
c = params(1);
	
%Calculate Distances and Activation at Hidden Node
%-----------------------------------------------------
distances = pairdist(stimuli,exemplars,distancemetric,attentionweights);
hiddenactivation = exp((-c)*distances);

% Calculates the activation at the output nodes
%-----------------------------------------------------
outputactivation = hiddenactivation * associationweights;
   	
% humble teachers
outputactivation(outputactivation> 1) =  1.0;
outputactivation(outputactivation<-1) = -1.0;

end
