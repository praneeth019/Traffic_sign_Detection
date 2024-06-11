clc;
clear;
close all;
warning off;

% Load training data and labels
load hogfeatures.mat;
load traininglabels.mat;

% Partition dataset
cv = cvpartition(size(hogFeatures,1),'HoldOut',0.3);
idx = cv.test;
dataTrain = hogFeatures(~idx,:);
dataTrainL = trainingLabels(~idx);
dataTest = hogFeatures(idx,:);
dataTestL = trainingLabels(idx);

% Train the model
model = TreeBagger(700, dataTrain, dataTrainL, 'OOBPrediction', 'On', 'Method', 'classification');
save('classifier.mat', 'model', '-v7.3');

% Predict and calculate accuracy
[prediction, scores] = predict(model, dataTest);
Accuracy = sum(prediction == dataTestL) / numel(dataTestL) * 100;

% Performance metrics
confmat = confusionmat(dataTestL, categorical(prediction));
confchart = confusionchart(dataTestL,prediction);
Recall = mean(diag(confmat) ./ sum(confmat, 2));
Precision = mean(diag(confmat) ./ sum(confmat, 1)');
F_score = 2 * Recall * Precision / (Precision + Recall);


% Load classifier and process new images
load classifier.mat;

pathDirectory = 'path to test folder';
files = fullfile(pathDirectory, '**/*.png');
theFiles = dir(files);

for j = 1:length(theFiles)
    fullFileName = fullfile(theFiles(j).folder, theFiles(j).name);
    fprintf('Now reading %s\n', fullFileName);
    im = imread(fullFileName);
    f1 = figure('Name', theFiles(j).name, 'Visible', 'on');
    imshow(im);
    
    % Masks and detection
    [br, bb, by, or] = rybmasks(im);
    drawboxred(model, im, br);
    drawboxred(model, im, or);
    drawboxblue(model, im, bb);
    drawboxyellow(model, im, by);
    drawnow;
    pause(2);

    saveas(f1, fullfile(theFiles(j).folder, ['Processed_', theFiles(j).name]), 'png');
    close(f1);

end

