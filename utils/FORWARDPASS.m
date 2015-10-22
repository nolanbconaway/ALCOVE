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
numstimuli		   = size(stimuli,1);
c				   = params(1);
numhiddens		   = size(exemplars,1);
numcategories	   = size(associationweights,2);

% initialize storage
outputactivation   = zeros(numstimuli,numcategories);
hiddenactivation   = zeros(numstimuli,numhiddens);

%-----------------------------------------------------
% iterate over all stimuli
for stim=1:numstimuli
	networkinput = stimuli(stim,:);
	
%Calculate Distances and Activation at Hidden Node
%-----------------------------------------------------
	distances = pairdist(networkinput,exemplars,distancemetric,attentionweights);
	hiddenactivation(stim,:) = exp((-c)*distances);

% Calculates the activation at the output nodes
%-----------------------------------------------------
	outputactivation(stim,:) = hiddenactivation(stim,:) * associationweights;
   	
end

% humble teachers
outputactivation(outputactivation> 1) =  1.0;
outputactivation(outputactivation<-1) = -1.0;

end
