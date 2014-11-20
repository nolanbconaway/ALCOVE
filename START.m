%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This just runs alcove based on the parameters provided below.
% It does not search for new parameters or fit to data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close;clear;clc
addpath([pwd '/utils/'])

%*************** Network design **************%
%---------------------------------------------%
model=struct;
  model.distancemetric = 0; % 0 for city block, 1 for euclidean
  model.numblocks = 16; % num passes through the training set
  model.numinitials = 10; % Number of initializations to average across
  model.params = [2  0.1  0.2  4]; %c, assoclearning, attenlearning, phi
 
%************* Run Simulations ***************%
training =  zeros(model.numblocks,6);
for i=1:6
	% coordinates for the training stimuli. also used as reference points
	[model.referencepoints,model.teachervalues]= SHJINPUTS(i);
	
% 	run simulation and add data to training matrix
	result = ALCOVE(model);
	training(:,i) = result.training;
end

disp(training)

% --- PLOTTING RESULTS
figure
for i = 1:6
	plot(training(:,i),'--k')
	text(1:model.numblocks,training(:,i),num2str(i),...
		'horizontalalignment','center','fontsize',15)
	hold on
end
axis([0.5 model.numblocks+0.5 0 1])
axis square
set(gca','ygrid','on')
