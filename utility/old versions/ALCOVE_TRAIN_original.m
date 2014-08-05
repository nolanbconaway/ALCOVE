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
	attenweights=ones(1,numInputs)*(1/numInputs); % vector of attention weights
	assocweights=zeros(numHidNodes,numOutputs);% matrix of association weights

% 	iterate over epochs
	for epoch=1:numEpochs
		
% 		generate a single block of random trials
		presentationorder=randperm(size(referencepoints,1));
		currentstim=referencepoints(presentationorder,:);
		currentlabs=teachervalues(presentationorder,:);
        
		probCorrect=zeros(numStim,1);
		for stim=1:numStim
	
			%Calculate Distances and Activation at Hidden Node
			%-----------------------------------------------------
			distances=zeros(numHidNodes,1);
			hidAct=zeros(numHidNodes,1);
				for i=1:numHidNodes
					for j=1:numInputs
						if distanceMetric == 0 %city block metric
							distances(i) = distances(i) + attenweights(j) * ...
								abs(referencepoints(i,j) - currentstim(stim,j));
						else %euclidean metric
							distances(i) = distances(i) + attenweights(j) * ...
								((referencepoints(i,j) - currentstim(stim,j)) * ...
								(referencepoints(i,j) - currentstim(stim,j))); 
						end
						
					end

					if distanceMetric == 1
						distances(i) = sqrt(distances(i));
					end
					hidAct(i) = exp((-c)*distances(i));
				end
	
			% Calculates the activation at the output nodes
			%-----------------------------------------------------
			outAct=zeros(1,numOutputs);
				for i=1:numOutputs
					outAct(i) = 0;
					for j=1:numHidNodes
						outAct(i) = outAct(i) + (assocweights(j,i) * hidAct(j));
					end
				end
		 
			% Adjust the weights between hidden nodes and output nodes..."humble" teachers
			% ----------------------------------------------------
				teach = currentlabs(stim,:);
				outAct(outAct>1.0)=1.0;
				outAct(outAct<-1.0)=-1.0;
				for i=1:numOutputs
					for j=1:numHidNodes
						assocweights(j,i) = assocweights(j,i) + (assoclearning * (teach(1,i) - outAct(i)) * hidAct(j));
					end
				end
				
				
			 % Adjust the attention weights between input nodes and hidden nodes
			 %----------------------------------------------------
			 
				for i=1:numInputs
					for j=1:numHidNodes
						firstSum = 0.0;
						for k=1:numOutputs
							firstSum = firstSum + ((teach(1,k) - outAct(k)) * assocweights(j,k));
						end
						attenweights(i) = attenweights(i) + ((-attenlearning) * (firstSum * hidAct(j) * ...
							c * (abs(referencepoints(j,i) - currentstim(stim, i)))));
					end
				end
				attenweights(attenweights>1)=1;
				attenweights(attenweights<0)=0;
			 
			 
			 % Calculate the categorization probabilities
			 %----------------------------------------------------
				sumActivation=0;
				for i=1:numOutputs
					sumActivation = sumActivation + exp(phi * outAct(i));
				end
				
				probThisCategory=zeros(numOutputs,1);
				for i=1:numOutputs
					probThisCategory(i) = exp(phi * outAct(i)) / sumActivation;
					if teach(1,i) == 1
						probCorrect(stim)=probThisCategory(i);
					end
					
				end	

		 end %end of stimulus loop 
         
% 		 store model performance
		 trainingdata(epoch,ordernumber) = mean(probCorrect);
         
		 
    end   

end

% save items in the result struct
result=struct;
result.training=mean(trainingdata,2);
		  
