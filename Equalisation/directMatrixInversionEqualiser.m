function [ dmiEqualiser ] = directMatrixInversionEqualiser( inputSignal, trainingSequence )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    lengthTraining = length(trainingSequence);
    
    for i = 1: lengthTraining
        
        R = (inputSignal(:,i) * inputSignal(:,i)')/(lengthTraining);
        p = (inputSignal(:,i) * trainingSequence(i)')/(lengthTraining);

    end
    
    dmiEqualiser = pinv(R) * p;
end


