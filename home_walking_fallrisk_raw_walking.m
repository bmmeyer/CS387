% Train walking fall risk model from home data - using LOSO validation
clear;clc

load('raw_walking_data_4str.mat')
training_accuracy = [];
validation_scores = [];
validation_pred = [];
validation_total_labels = [];
threshold = [];
count = 1;
for s = 1:num_subs
    fprintf('Iteration %d of %d \n',s,num_subs)
    % split training and validaiton data.
    % Using leave one subject out validation
    val_ind = sub_ind == s;
    xVal = agg_str(val_ind);
    yVal = fall_labels(val_ind);
    xTrain = agg_str(~val_ind);
    yTrain = fall_labels(~val_ind);
    
    if isempty(xVal)
    else
        
        numObservations = numel(xTrain);
        sequenceLengths = [];
        for i=1:numObservations
            sequence = xTrain{i};
            sequenceLengths(i) = size(sequence,2);
        end
        
        [sequenceLengths,idx] = sort(sequenceLengths);
        xTrain = xTrain(idx);
        yTrain = yTrain(idx);
        
        inputSize = 6;
        numHiddenUnits1 = 20;
        numHiddenUnits2 = 10;
        numClasses = 2;
        
        layers = [ ...
            sequenceInputLayer(inputSize)
            lstmLayer(numHiddenUnits1,'OutputMode','sequence')
            dropoutLayer(0.3)
%             bilstmLayer(numHiddenUnits2,'OutputMode','sequence')
%             dropoutLayer(0.2)
            bilstmLayer(numHiddenUnits2,'OutputMode','last')
            dropoutLayer(0.4)
            fullyConnectedLayer(numClasses)
            softmaxLayer
            classificationLayer];
        
        maxEpochs = 100;
        miniBatchSize = 200;
        
        options = trainingOptions('adam', ...
            'ExecutionEnvironment','auto', ...
            'GradientThreshold',1, ...
            'MaxEpochs',maxEpochs, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest', ...
            'Shuffle','every-epoch', ... % 'Shuffle', Never
            'Verbose',1, ...
            'Plots','none');
        
        net = trainNetwork(xTrain,yTrain,layers,options);
        
        numObservationsVal = numel(xVal);
        sequenceLengthsVal = [];
        for i=1:numObservationsVal
            sequence = xVal{i};
            sequenceLengthsVal(i) = size(sequence,2);
        end
        [sequenceLengthsVal,idx_v] = sort(sequenceLengthsVal);
        xVal = xVal(idx_v);
        yVal = yVal(idx_v);
        
        [YPred_tr,train_scores] = classify(net,xTrain, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest');
        
        [X,Y,T,AUC] = perfcurve(yTrain,train_scores(:,2),categorical(1));
        thresh = get_youdin(X,Y,T);
        
        threshold = [threshold;thresh];
        
        training_accuracy(count) = sum(YPred_tr == yTrain)./numel(yTrain);
        
        [YPred,scores] = classify(net,xVal, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest');
        
        
        validation_pred = [validation_pred; YPred];
        validation_scores = [validation_scores; scores];
        validation_total_labels = [validation_total_labels; yVal];
        
        clear sequenceLengthsVal sequenceLengths
        count = count+1;
    end % if xVal isempty
end

save('April_08_21_home_raw_walking','validation_total_labels','validation_scores','validation_pred','training_accuracy','threshold','net');

[acc,spec,sens,f1,mcc] = get_performance_metrics(validation_total_labels,validation_pred);

[X,Y,T,AUC] = perfcurve(validation_total_labels,validation_scores(:,2),categorical(1));
%Plot stuff
figure;plot(X,Y,'linewidth',2); hold on; grid on;
plot([0,1],[0,1],'--k');
xlabel('FPR'); ylabel('TPR');
axis equal;
xlim([0,1]); ylim([0,1]);

fprintf('MCC = %f \n',mcc)

fprintf('F1 = %f \n',f1)

fprintf('AUC = %f \n',AUC)

fprintf('Sens = %f \n',sens)

fprintf('Spec = %f \n',spec)

fprintf('Acc = %f \n',acc)



