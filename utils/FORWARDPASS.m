function [outputactivation, hiddenactivation] = FORWARDPASS(...
	networkinput,referencepoints,distancemetric,attentionweights,...
	associationweights,params)
%--------------------------------------------------------------------------
% This script runs a forward pass in alcove and returns the information
% about network performance.
% 
% -------------------------------------
% --INPUT ARGUMENTS			DESCRIPTION
%	networkinput			items to be passed through the model
%	referencepoints			coordinates of each known exemplar
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
numstimuli		   = size(networkinput,1);
c				   = params(1);
numhiddens		   = size(referencepoints,1);
numcategories	   = size(associationweights,2);

% initialize storage
outputactivation   = zeros(numstimuli,numcategories);
hiddenactivation   = zeros(numstimuli,numhiddens);

%-----------------------------------------------------
% iterate over all stimuli
for stim=1:numstimuli
	networkinput = networkinput(stim,:);
	
%Calculate Distances and Activation at Hidden Node
%-----------------------------------------------------
	if distancemetric == 0
		distances = abs(repmat(networkinput,[numhiddens,1]) - referencepoints);
		distances = sum(distances .* repmat(attentionweights,[numhiddens,1]),2)';
	elseif distancemetric == 1
		distances = (repmat(networkinput,[numhiddens,1]) - referencepoints).^2;
		distances = sqrt(sum(distances .* repmat(attentionweights,[numhiddens,1]),2))';
	end
	hiddenactivation(stim,:) = exp((-c)*distances);

% Calculates the activation at the output nodes
%-----------------------------------------------------
	outputactivation(stim,:) = hiddenactivation(stim,:) * associationweights;
   	
end

% humble teachers
outputactivation(outputactivation> 1) = 1.0;
outputactivation(outputactivation<-1)= -1.0;

end
