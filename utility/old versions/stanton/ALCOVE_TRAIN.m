function [] = ALCOVE_TRAIN(params,fitMeasure,data,numInputs,...
    numHidNodes,numOutputs,distanceMetric,numEpochs,numStim,stimCoords,teacherValues) 

%Although this was designed for the SHJ data types, it should be general
%enough to work with any stimulus structure.

global fitValue;

SSD = 0; %Sum of Squared Deviations as measure of fit
RMSD = 1; %Root means square deviation as measure of fit

%************* Declaration of Global Variables *************%
%-----------------------------------------------------------%
c=params(1);
outLrnRate=params(2);
hidLrnRate=params(3);
phi=params(4);

% Matrix of attention weights connecting input and hidden nodes 
wts=ones(1,numInputs)*(1/numInputs);

% Matrix of weights connecting hidden and output nodes */
outWeight=zeros(numHidNodes,numOutputs);

%-----------------------------------------------------------%

    for epoch=1:numEpochs
        for stim=1:numStim
	
            %Calculate Distances and Activation at Hidden Node
            %-----------------------------------------------------
                for i=1:numHidNodes

                    distances(i) = 0;
                    hidAct(i) = 0;
                    for j=1:numInputs
				        if distanceMetric == 0 %city block metric
                            distances(i) = distances(i) + wts(j) * abs(stimCoords(i,j) - stimCoords(stim,j));
                        else %euclidean metric
                            distances(i) = distances(i) + wts(j) * ((stimCoords(i,j) - stimCoords(stim,j)) * ...
                            (stimCoords(i,j) - stimCoords(stim,j))); 
                        end
  
                    end

                    if distanceMetric == 1
                        distances(i) = sqrt(distances(i));
                    end
                    hidAct(i) = exp((-c)*distances(i));
                end
	
            % Calculates the activation at the output nodes
            %-----------------------------------------------------
            
                for i=1:numOutputs
                    outAct(i) = 0;
                    for j=1:numHidNodes
                        outAct(i) = outAct(i) + (outWeight(j,i) * hidAct(j));

                    end
                
                end
                

            
            % Adjust the weights between hidden nodes and output nodes..."humble" teachers
            % ----------------------------------------------------
                teach = teacherValues(stim,:);
                for i=1:numOutputs
                    if outAct(i) > 1.0
                        outAct(i) = 1.0;
                    end
                    if outAct(i) < -1.0
                        outAct(i) = -1.0;
                    end  
                    for j=1:numHidNodes
                        outWeight(j,i) = outWeight(j,i) + (outLrnRate * (teach(1,i) - outAct(i)) * hidAct(j));

                    end
                          
                end
                
                
             % Adjust the attention weights between input nodes and hidden nodes
             %----------------------------------------------------
             
                for i=1:numInputs
                    for j=1:numHidNodes
                        firstSum = 0.0;
                        for k=1:numOutputs
                            firstSum = firstSum + ((teach(1,k) - outAct(k)) * outWeight(j,k));
                        end
                        wts(i) = wts(i) + ((-hidLrnRate) * (firstSum * hidAct(j) * c * (abs(stimCoords(j,i) - stimCoords(stim, i)))));
                        if wts(i) < 0
                            wts(i) = 0;
                        end
                        if wts(i) > 1
                            wts(i) = 1;
                        end
                    end
                end
             
             % Calculate the categorization probabilities
             %----------------------------------------------------
                sumActivation=0;
                for i=1:numOutputs
                    sumActivation = sumActivation + exp(phi * outAct(i));
                end
             
                for i=1:numOutputs
                    probThisCategory(i) = exp(phi * outAct(i)) / sumActivation;
                    if teach(1,i) == 1
                        probCorrect(stim)=probThisCategory(i);
                    end
                end

         end %end of stimulus loop 
         avgProbCorrect(epoch) = mean(probCorrect);

     end %end of epochs loop
     
% Compute the overall fit to data as the Sum of Squared Deviations

if fitMeasure == SSD
    %Fit using Sum of Squared Deviations:
    SSD = dot(avgProbCorrect - data, avgProbCorrect - data);
    fitValue = fitValue+SSD;
else
    %Fit using Root Mean Squared Deviation
    SSD = dot(avgProbCorrect - data, avgProbCorrect - data);
    RMSD = sqrt(SSD/numEpochs);
    fitValue=fitValue+RMSD;
end

     
          