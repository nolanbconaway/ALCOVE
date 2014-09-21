close;clear;clc; format shortg
addpath([pwd '/utility/'])

% -------------------------------------------------------------------
% this script runs a grid search over alcoves four paramaters.
% as a demo, it fits to the shj type of your choice, but is problem-general
% -------------------------------------------------------------------

% pick your shj type
shjtype=2;

% -------------------------------------------------------------------
%  Define search range
specificity=2:.5:4;
outrate=.05:.05:.1;
attnrate=.05:.05:.1;
responsemapping=2:.5:4;
% -------------------------------------------------------------------

% create a list of every combination of the above values
	% order of parameters: c, outLrnRate, hidLrnRate, phi
parameterlist=allcomb(specificity,outrate,attnrate,responsemapping);
numparams=size(parameterlist,1);

% -------------------------------------------------------------------
% initialize alcove's design
model=struct;
% distance metric: 0 for city block, 1 for euclidean
  model.distancemetric = 0;
% Number of times Alcove will iterate over the list of input stimuli 
  model.numblocks = 16;
% Number of random presentation orders to be averaged across
  model.numinitials=10;
% coordinates for the training stimuli and category labels
  [model.referencepoints,model.teachervalues]= SHJINPUTS(shjtype);
% ------------------------------------------------------------------- 

% -------------------------------------------------------------------
% iterate over parameters
training=zeros(model.numEpochs,numparams);
for pnum=1:numparams

% 	get current parameter configuration
	model.params = parameterlist(pnum,:);
	
%   run simulation
	result = ALCOVE(model);
  
%   calculate and store fit (in SSD)
	training(:,pnum)=result.training;
	
% 	update the console
	if mod(pnum,25)==1 
		disp([num2str(100*(pnum / numparams),4) ' %'])
	end
end

% save fits and paramaters
save('alcove.mat','training','parameterlist')

