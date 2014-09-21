function [result] = ALCOVE(model)

% ------------------------------------------------------------------------
% This trains the alcove network given the design specification in the sole
% argument, model. This argument contains critical information about the
% model, and must include:
% 
% 	  distanceMetric: 0 for city block, 1 for euclidean
%	  referencepoints: coordinates for the training stimuli
% 	  numEpochs: number of times to iterate over referencePoints
% 	  numOrders: number of presentation orders to be averaged across
%	  teachervalues: category assignment for each item in referencePoints
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
numfeatures=size(referencepoints,2);
numcategories=size(teachervalues,2);
numstimuli=size(referencepoints,1);
numupdates = numstimuli*numblocks;

c=params(1);
assoclearning=params(2);
attenlearning=params(3);
phi=params(4);

%-----------------------------------------------------------%
% iterate over presentation orders
trainingdata=zeros(numupdates,numinitals);
for modelnumber=1:numinitals
	
    %  initialize weight matrices
	attentionweights=ones(1,numfeatures)*(1/numfeatures); % vector of attention weights
	associationweights=zeros(numstimuli,numcategories);% matrix of association weights
    
    %  generate a random presentation order
    presentationorder = getpresentationorder(numstimuli,numblocks,teachervalues);

    %  iterate over trials
	for trialnumber=1:numupdates
        
        networkinput=referencepoints(presentationorder(trialnumber),:);
        targetactivation=teachervalues(presentationorder(trialnumber),:);
        correctcategory=targetactivation==1;
        
        % Calculate Distances and Activation at Hidden Node
        %--------------------------------------------------------------
        if distancemetric == 0
            distances = abs(repmat(networkinput,[numstimuli,1]) - referencepoints);
            distances = sum(distances .* repmat(attentionweights,[numstimuli,1]),2)';

        elseif distancemetric == 1
            distances = (repmat(networkinput,[numstimuli,1]) - referencepoints).^2;
            distances = sqrt(sum(distances .* repmat(attentionweights,[numstimuli,1]),2))';
        end
        hiddenactivation = exp((-c)*distances);
		
        % Calculates the activation at the output nodes
        %--------------------------------------------------------------
        outputactivation = hiddenactivation * associationweights;
        outputactivation(outputactivation> 1) = 1.0; % humble teachers
        outputactivation(outputactivation<-1)= -1.0;

        % Calculate the categorization probabilities and store perfomance
        %--------------------------------------------------------------
        sumActivation=sum(exp(phi * outputactivation)); 
        trainingdata(trialnumber,modelnumber) = exp(phi * outputactivation(correctcategory)) / sumActivation;

        % Adjust the weights between hidden nodes and output nodes
        %--------------------------------------------------------------
        outputerror = targetactivation - outputactivation;
        outputderivative = assoclearning * (outputerror' *hiddenactivation);
        associationweights = associationweights + outputderivative';

        % Adjust the attention weights between input nodes and hidden nodes
        %--------------------------------------------------------------
        hiddenerror=sum(associationweights.*repmat(outputerror,[numstimuli,1]),2);
        hiddenderivative = hiddenerror' .* hiddenactivation * c * (abs(referencepoints - repmat(networkinput,[numstimuli,1])));
        attentionweights = attentionweights + ((-attenlearning) * hiddenderivative);
        attentionweights(attentionweights>1)=1;
        attentionweights(attentionweights<0)=0;
	end   
	
% % 	a test set can go here
% 	ps = FORWARDPASS(params,referencepoints,referencepoints,...
% 		distancemetric,attentionweights,associationweights)
end

% save items in the result struct
result=struct;
result.training=returnblocks(mean(trainingdata,2),numstimuli)';
		  
