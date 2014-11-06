function probabilities=FORWARDPASS(params,stimuli,referencepoints,...
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

% initialize variables
c=params(1);
phi=params(4);
numstimuli=size(stimuli,1);
numhiddens=size(referencepoints,1);
numcategories=size(associationweights,2);
probabilities=zeros(numstimuli,numcategories);

%-----------------------------------------------------
% iterate over all stimuli
for stim=1:numstimuli
    networkinput = stimuli(stim,:);
    
%Calculate Distances and Activation at Hidden Node
%-----------------------------------------------------
    if distanceMetric == 0
        distances = abs(repmat(networkinput,[numhiddens,1]) - referencepoints);
        distances = sum(distances .* repmat(attentionweights,[numhiddens,1]),2)';
    elseif distanceMetric == 1
        distances = (repmat(networkinput,[numhiddens,1]) - referencepoints).^2;
        distances = sqrt(sum(distances .* repmat(attentionweights,[numhiddens,1]),2))';
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
