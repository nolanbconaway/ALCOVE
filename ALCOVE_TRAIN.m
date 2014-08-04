function [result] = ALCOVE_TRAIN(model)

% ------------------------------------------------------------------------
% This trains the alcove network given the design specification in the sole
% argument, model. This argument contains critical information about the
% model, and must include:
% 
% 	  distanceMetric: 0 for city block, 1 for euclidean
%	  referencePoints: coordinates for the training stimuli
% 	  numEpochs: number of times to iterate over referencePoints
% 	  numOrders: number of presentation orders to be averaged across
%	  teacherValues: category assignment for each item in referencePoints
% 	  params: [c, outLrnRate, hidLrnRate, phi]
% 
% The model struct may contain more fields (such as test items), but those
% are the necessary fields.
% 
% The sole output, result, is a struct containing the following:
%	  training: accuracy for each block,(averaged across presentaton orders)
% ------------------------------------------------------------------------

% unpack input struct
v2struct(model)

%************* Declaration of Global Variables *************%
%-----------------------------------------------------------%
numInputs=size(referencepoints,2);
numOutputs=size(teachervalues,2);
numStim=size(referencepoints,1);
numHidNodes=numStim;

c=params(1);
assoclearning=params(2);
attenlearning=params(3);
phi=params(4);

%-----------------------------------------------------------%
% iterate over presentation orders
trainingdata=zeros(numEpochs,numOrders);
for ordernumber=1:numOrders
	
% 	initialize weight matrices
	attentionweights=ones(1,numInputs)*(1/numInputs); % vector of attention weights
	associationweights=zeros(numHidNodes,numOutputs);% matrix of association weights

% 	iterate over epochs
	for epoch=1:numEpochs
		
% 		generate a single block of random trials
		presentationorder=randperm(size(referencepoints,1));
		probCorrect=zeros(numStim,1);
        
		for stim=1:numStim
            networkinput=referencepoints(presentationorder(stim),:);
            targetactivation=teachervalues(presentationorder(stim),:);
            correctcategory=targetactivation==1;
	
			%Calculate Distances and Activation at Hidden Node
			%--------------------------------------------------------------
            if distanceMetric == 0
                distances = abs(repmat(networkinput,[numHidNodes,1]) - referencepoints);
                distances = sum(distances .* repmat(attentionweights,[numHidNodes,1]),2)';
                
            elseif distanceMetric == 1
                distances = (repmat(networkinput,[numHidNodes,1]) - referencepoints).^2;
                distances = sqrt(sum(distances .* repmat(attentionweights,[numHidNodes,1]),2))';
            end
            hiddenactivation = exp((-c)*distances);
	
			% Calculates the activation at the output nodes
			%--------------------------------------------------------------
            outputactivation = hiddenactivation * associationweights;
            outputactivation(outputactivation> 1) = 1.0; % humble teachers
            outputactivation(outputactivation<-1)= -1.0;
            
            % Calculate the categorization probabilities
			%--------------------------------------------------------------
            sumActivation=sum(exp(phi * outputactivation)); 
            probCorrect(stim) = exp(phi * outputactivation(correctcategory)) / sumActivation;
		 
			% Adjust the weights between hidden nodes and output nodes
			%--------------------------------------------------------------
            outputerror = targetactivation - outputactivation;
            outputderivative = assoclearning * (outputerror' *hiddenactivation);
            associationweights = associationweights + outputderivative';
            
            % Adjust the attention weights between input nodes and hidden nodes
			%--------------------------------------------------------------
            hiddenerror=sum(associationweights.*repmat(outputerror,[numHidNodes,1]),2);
            hiddenderivative = hiddenerror' .* hiddenactivation * c * (abs(referencepoints - repmat(networkinput,[numHidNodes,1])));
            attentionweights = attentionweights + ((-attenlearning) * hiddenderivative);
            attentionweights(attentionweights>1)=1;
            attentionweights(attentionweights<0)=0;

		 end 

 % 		 store model performance
		 trainingdata(epoch,ordernumber) = mean(probCorrect);
	end   
end

% save items in the result struct
result=struct;
result.training=mean(trainingdata,2);
		  
