clc;
clear all;
close all;
warning off;

%---------------CHANGE PATH TO TRAINING IMAGES FOLDER------------%


imds=imageDatastore('path to train folder','IncludeSubfolders',true,'LabelSource','foldernames');
hogFeatures=[];
trainingLabels=imds.Labels;       
for i = 1:numel(imds.Files)
    im = readimage(imds,i);
    im = imresize(im,[200 200]);
    disp(i);        %DISPLAYS THE COUNT OF IMAGES%
    % hogFeatures(i,:) = extractHOGFeatures(im,'CellSize',[8 8]);
    hogFeatures(i,:) = extractCustomHOGFeatures(im);
end

%--------------TO SAVE THE EXTRACTED FEATURES-----------------%
save('hogfeatures.mat', 'hogFeatures', '-v7.3')
save('traininglabels.mat', 'trainingLabels', '-v7.3')