function probabilities=FORWARD_PASS(params,stimuli,referencepoints,...
	distanceMetric,attentionweights,associationweights)

%-----------------------------------------------------
% this script simply runs a forward pass in alcove and returns the
% probability of classification for all categories.
% 
% params=[c,outlearnrate,attnlearnrate,phi];
% stimuli=items to be passed through the model
% referencepoints=coordinates of each known exemplar
% distancemetric= 0 for city block, 1 for euclidean
% attentionweights=vector of weights connecting inputs and hidden nodes
% assoicationweights=matrix of weights connecting hiddens and outputs
%-----------------------------------------------------

% initalize variables
c=params(1);
phi=params(4);
numStim=size(stimuli,1);
numHidNodes=size(referencepoints,1);
numOutputs=size(associationweights,2);
probabilities=zeros(numStim,numOutputs);

%-----------------------------------------------------
% iterate over all stimuni
for stim=1:numStim
    
%Calculate Distances and Activation at Hidden Node
%-----------------------------------------------------
    if distanceMetric == 0
        distances = abs(repmat(stimuli(stim,:),[numHidNodes,1]) - referencepoints);
        distances= sum(distances .* repmat(attentionweights,[numHidNodes,1]),2);
    elseif distanceMetric == 1
        distances = (repmat(stimuli(stim,:),[numHidNodes,1]) - referencepoints).^2;
        distances= sqrt(sum(distances .* repmat(attentionweights,[numHidNodes,1]),2))';
    end
    hiddenactivation = exp((-c)*distances);

% Calculates the activation at the output nodes
%-----------------------------------------------------
    outactivation = hiddenactivation * associationweights;
   	outactivation(outactivation> 1) = 1.0;
	outactivation(outactivation<-1)= -1.0;
	
% Calculate the categorization probabilities
%----------------------------------------------------
	sumActivation=sum(exp(phi * outactivation));    
    probabilities(stim,:) = exp(phi * outactivation) / sumActivation;
end
