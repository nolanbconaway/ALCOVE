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
  model.distancemetric = 0;
  
% Number of times Alcove will iterate over the list of input stimuli 
  model.numblocks = 16;
  
% Number of random presentation orders to be averaged across
  model.numinitals=5;
  
% coordinates for the training stimuli. also used as reference points
  [model.referencepoints,model.teachervalues]= SHJINPUTS(1);
% 
% order of parameters: c, assoclearning, attenlearning, phi
  model.params = [4  0.1  0.2  4];
 
%************* Run Simulations ***************%
result = ALCOVE(model);
v2struct(result)


training
