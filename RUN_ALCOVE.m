%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This just runs alcove based on the parameters provided below.
% It does not search for new parameters or fit to data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close;clear;clc
addpath([pwd '/utility/'])

%*************** Network design **************%
%---------------------------------------------%
model=struct;

% distance metric: 0 for city block, 1 for euclidean
  model.distanceMetric = 0;
  
% Number of times Alcove will iterate over the list of input stimuli 
  model.numEpochs = 16;
  
% Number of random presentation orders to be averaged across
  model.numOrders=1;
  
% coordinates for the training stimuli. also used as reference points
  [model.referencepoints,model.teachervalues]= SHJINPUTS(1);
% 
% order of parameters: c, outLrnRate, hidLrnRate, phi
  model.params = [4.087343  0.191752  0.020000  2.358758];
 
%************* Run Simulations ***************%
result = ALCOVE_TRAIN(model);
v2struct(result)


training
