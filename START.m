%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This just runs alcove based on the parameters provided below.
% It does not search for new parameters or fit to data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close;clear;clc
addpath([pwd '/utils/'])


% % % % % % % % % % %  Network design % % % % % % % % % % % %
model=struct;
	model.distancemetric = 0; % 0 for city block, 1 for euclidean
	model.numblocks = 16; % num passes through the training set
	model.numinitials = 10; % Number of initializations to average across
	model.params = [2  0.1  0.2  4]; %c, assoclearning, attenlearning, phi
 
%   load exemplars
	load shj
	model.exemplars = stimuli;
 
% % % % % % % % % Run Simulations % % % % % % % % %
training =  zeros(model.numblocks,6);

for i=1:6
	
% 	set up category assignments.
%	Categories are dummycoded, using [-1, +1]
	model.targets = dummyvar(assignments(:,i)) * 2 - 1;
	
% 	run simulation
	result = ALCOVE(model);
	
% 	add data to training matrix
	training(:,i) = result.training;
	
end

disp(training)
