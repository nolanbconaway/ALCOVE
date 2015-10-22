function [result] = ALCOVE(model)

% ------------------------------------------------------------------------
% This trains the alcove network given the design specification in the sole
% argument, model. This argument contains critical information about the
% model, and must include:
% 
% 	  distancemetric: 0 for city block, 1 for euclidean
%	  exemplars: coordinates for the training stimuli
% 	  numblocks: number of times to iterate over the training set
% 	  numinitials: number of random initializations
%	  targets: category assignment for each training pattern
% 	  params: [c, out learning, attn learning, phi]
% 
% The model struct may contain more fields (such as test items), but those
% are the necessary fields.
% 
% The sole output, result, is a struct containing the following:
%	  training: accuracy for each block,(averaged across presentation orders)
% ------------------------------------------------------------------------

% unpack input struct
v2struct(model)

rng('shuffle') %get random seed

%************* Declaration of Global Variables *************%
%-----------------------------------------------------------%
numfeatures		   = size(exemplars,2);
numcategories	   = size(targets,2);
numexemplars = size(exemplars,1);
numupdates		   = numexemplars*numblocks;

%-----------------------------------------------------------%
% iterate over presentation orders
training=zeros(numupdates,numinitials);
for modelnumber=1:numinitials
	
	%  initialize weight matrices and presentation order
	attentionweights   = ones(1,numfeatures) .* (1/numfeatures);
	associationweights = zeros(numexemplars,numcategories);
	presentationorder  = shuffletrials(numexemplars, numblocks);

	%  iterate over trials
	for trialnumber=1:numupdates
		
		trialinput	 = exemplars(presentationorder(trialnumber),:);
		trialtarget = targets(presentationorder(trialnumber),:);
		correctcategory  = trialtarget == 1;
		
		% pass activations through the network
		%--------------------------------------------------------------
		[outputactivation, hiddenactivation] = FORWARDPASS(...
			trialinput,exemplars,distancemetric,attentionweights,...
			associationweights,params);

		% calculate classification probabilities
		ps = RESPONSERULE(outputactivation,params(4));
		training(trialnumber,modelnumber) = ps(correctcategory);

		% update weights using backprop
		%--------------------------------------------------------------
		[attentionweights,associationweights]=BACKPROP(associationweights, ...
			attentionweights,trialtarget,outputactivation,hiddenactivation, ...
			exemplars,trialinput,params);
	end   
end

% save items in the result struct
result=struct;
result.training=blockrows(mean(training,2),numexemplars);
		  
