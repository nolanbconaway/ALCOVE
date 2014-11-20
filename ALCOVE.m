function [result] = ALCOVE(model)

% ------------------------------------------------------------------------
% This trains the alcove network given the design specification in the sole
% argument, model. This argument contains critical information about the
% model, and must include:
% 
% 	  distancemetric: 0 for city block, 1 for euclidean
%	  referencepoints: coordinates for the training stimuli
% 	  numblocks: number of times to iterate over the training set
% 	  numinitials: number of random initalizations
%	  teachervalues: category assignment for each training pattern
% 	  params: [c, outLrnRate, hidLrnRate, phi]
% 
% The model struct may contain more fields (such as test items), but those
% are the necessary fields.
% 
% The sole output, result, is a struct containing the following:
%	  training: accuracy for each block,(averaged across presentation orders)
% ------------------------------------------------------------------------

% unpack input struct
v2struct(model)

%************* Declaration of Global Variables *************%
%-----------------------------------------------------------%
numfeatures		   = size(referencepoints,2);
numcategories	   = size(teachervalues,2);
numreferencepoints = size(referencepoints,1);
numupdates		   = numreferencepoints*numblocks;

%-----------------------------------------------------------%
% iterate over presentation orders
training=zeros(numupdates,numinitials);
for modelnumber=1:numinitials
	
    %  initialize weight matrices and presentation order
	attentionweights   = ones(1,numfeatures) .* (1/numfeatures);
	associationweights = zeros(numreferencepoints,numcategories);
    presentationorder  = getpresentationorder(numreferencepoints,...
		numblocks,teachervalues);

    %  iterate over trials
	for trialnumber=1:numupdates
        
        networkinput     = referencepoints(presentationorder(trialnumber),:);
        targetactivation = teachervalues(presentationorder(trialnumber),:);
        correctcategory  = targetactivation == 1;
        
		% pass activations through the network
		%--------------------------------------------------------------
		[outputactivation, hiddenactivation] = FORWARDPASS(...
			networkinput,referencepoints,distancemetric,attentionweights,...
			associationweights,params);

		% calculate classification probabilities
		ps = RESPONSERULE(outputactivation,params(4));
		training(trialnumber,modelnumber) = ps(correctcategory);

		% update weights using backprop
		%--------------------------------------------------------------
		[attentionweights,associationweights]=BACKROP(associationweights, ...
			attentionweights,targetactivation,outputactivation,hiddenactivation, ...
			referencepoints,networkinput,params);
	end   
end

% save items in the result struct
result=struct;
result.training=blockrows(mean(training,2),numreferencepoints);
		  
