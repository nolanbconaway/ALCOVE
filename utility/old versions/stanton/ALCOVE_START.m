function [] = ALCOVE_START()

% To run this, be sure that the line in SHJ_ALCOVE.m that computes the fit
% value is not commented out.  This should be the last line in that m-file.
close;clear;clc
data = load('accuracy_data.txt'); 

SSD = 0; %Sum of Squared Deviations as measure of fit
RMSD = 1; %Root means square deviation as measure of fit

fitMeasure = SSD;

%*************** Network design **************%
%---------------------------------------------%
% Number of input stimulus dimensions
  numInputs = 3;
% Number of hidden nodes (if not using Covering Map, then this is equal to the number of stimuli)
  numHidNodes=8; 
% Number of Output categories 
  numOutputs = 2;
% distance metric: 0 for city block, 1 for euclidean
  distanceMetric = 0;
% Number of times Alcove will iterate over the complete list of input stimuli */
  numEpochs = 16;

  stimCoords = load('stim.txt');  
  numStim=size(stimCoords,1);

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Fit ALCOVE to the data  %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Use several different starting parameters
%     %order of parameters: c, outLrnRate, hidLrnRate, phi
startingParams = [2  0.003  0.0033  2; 
                    3 .0001 .0001 1; 
                    2 .002 .002 2; 
                    1 .1 .1 1; 
                    8 .15 .15 2; 
                    10 .2 .2 4; 
                    2.5 0.0 0.0 1; 
                    2 .02 .2 3; 
                    1 .1 .01 1; 
                    3 .1 .01 1];
                
%Options for fminsearch
%defaultOptions = optimset(@fmincon);
defaultOptions = optimset(@fminsearch); 
searchOptions = optimset(defaultOptions,'MaxFunEvals',2000,...
    'TolX',0.000001,'TolFun',0.000001); 

fout = fopen('fit_result.txt','a');  
for i=1:size(startingParams,1)
		[paramBest,fitValue,searchConverged,searchHistory] = ...
            fminsearch(@ALCOVE_FIT,startingParams(i,:),searchOptions,...
            fitMeasure,data,numInputs,numHidNodes,numOutputs,...
            distanceMetric,numEpochs,numStim,stimCoords)

    fprintf(fout,'%f  %f  %f  %f  %f\n', fitValue, paramBest)    
end
fprintf(fout,'\n')
fclose(fout);
  
  
  
  
