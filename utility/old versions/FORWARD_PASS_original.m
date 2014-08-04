function [probabilities]=FORWARD_PASS_original(params,stimuli,referencepoints,...
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
numInputs=length(attentionweights);
numHidNodes=size(referencepoints,1);
numOutputs=size(associationweights,2);
probabilities=zeros(numStim,numOutputs);

%-----------------------------------------------------
% iterate over all stimuni
for stim=1:numStim
	
%Calculate Distances and Activation at Hidden Node
%-----------------------------------------------------
	distances=zeros(1,numHidNodes);
	hiddenactivation=zeros(1,numHidNodes);
	for i=1:numHidNodes
		for j=1:numInputs
			if distanceMetric == 0 %city block metric
				distances(i) = distances(i) + attentionweights(j) * ...
					abs(referencepoints(i,j) - stimuli(stim,j));
			else %euclidean metric
				distances(i) = distances(i) + attentionweights(j) * ...
					((referencepoints(i,j) - stimuli(stim,j)) * ...
					(referencepoints(i,j) - stimuli(stim,j))); 
				
			end
		end
		if distanceMetric == 1
			distances(i) = sqrt(distances(i));
		end
		hiddenactivation(i) = exp((-c)*distances(i));
	end

% Calculates the activation at the output nodes
%-----------------------------------------------------
	outactivation=zeros(1,numOutputs);
	for i=1:numOutputs
		for j=1:numHidNodes
			outactivation(i) = outactivation(i) + ...
				(associationweights(j,i) * hiddenactivation(j));
		end
	end
	
% 	humble teachers
	outactivation(outactivation>1)=1.0;
	outactivation(outactivation<-1)=-1.0;
	
% Calculate the categorization probabilities
 %----------------------------------------------------
	sumActivation=0;
	for i=1:numOutputs
		sumActivation = sumActivation + exp(phi * outactivation(i));
	end

	for i=1:numOutputs
		probabilities(stim,i) = exp(phi * outactivation(i)) / sumActivation;
	end
end

