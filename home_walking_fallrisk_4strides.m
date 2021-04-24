% Train walking fall risk model from home data - using LOSO validation
clear;clc

load('four_strides_ABC_all.mat')
training_accuracy = [];validation_accuracy = [];
test_scores = [];
test_pred = [];
test_total_labels = [];
threshold = [];
count = 1;

agg_str = agg_str_abc;

uni_subs = unique(sub_ind);

for s = 1:length(uni_subs)
    fprintf('Iteration %d of %d \n',s,num_subs)
    % split training and validaiton data.
    % Using leave one subject out validation
    uni_subs = unique(sub_ind);
    if s < length(uni_subs)
        val_ind = sub_ind == uni_subs(s);
        test_ind = sub_ind == uni_subs(s+1);
        xVal = agg_str(val_ind);
        yVal = fall_labels(val_ind);
        xTest = agg_str(test_ind);
        yTest = fall_labels(test_ind);
        xTrain = agg_str(~val_ind);
        yTrain = fall_labels(~val_ind);
    else
        val_ind = sub_ind == uni_subs(s);
        test_ind = sub_ind == uni_subs(1);
        xVal = agg_str(val_ind);
        yVal = fall_labels(val_ind);
        xTest = agg_str(test_ind);
        yTest = fall_labels(test_ind);
        xTrain = agg_str(~val_ind);
        yTrain = fall_labels(~val_ind);
    end
    
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
        
        
        
        
        numObservationsVal = numel(xVal);
        sequenceLengthsVal = [];
        for i=1:numObservationsVal
            sequence = xVal{i};
            sequenceLengthsVal(i) = size(sequence,2);
        end
        [sequenceLengthsVal,idx_v] = sort(sequenceLengthsVal);
        xVal = xVal(idx_v);
        yVal = yVal(idx_v);
        
        inputSize = 25;
        numHiddenUnits1 = 50;
        numHiddenUnits2 = 25;
        numClasses = 2;
        
        layers = [ ...
            sequenceInputLayer(inputSize)
            lstmLayer(numHiddenUnits1,'OutputMode','sequence')
            dropoutLayer(0.3)
            bilstmLayer(numHiddenUnits2,'OutputMode','Last')
            dropoutLayer(0.4)
            fullyConnectedLayer(numClasses)
            softmaxLayer
            classificationLayer];
        
        maxEpochs = 25;
        miniBatchSize = 200;
        
        options = trainingOptions('adam', ...
            'ExecutionEnvironment','auto', ...
            'GradientThreshold',1, ...
            'MaxEpochs',maxEpochs, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest', ...
            'Shuffle','every-epoch', ... % 'Shuffle', Never
            'Verbose',1, ...
            'Plots','none','ValidationData',{xVal,yVal});
        
        net = trainNetwork(xTrain,yTrain,layers,options);
        
        numObservationsTest = numel(xTest);
        sequenceLengthsTest = [];
        for i=1:numObservationsTest
            sequence = xTest{i};
            sequenceLengthsTest(i) = size(sequence,2);
        end
        [sequenceLengthsTest,idx_t] = sort(sequenceLengthsTest);
        xTest = xTest(idx_t);
        yTest = yTest(idx_t);
        
        [YPred_tr,train_scores] = classify(net,xTrain, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest');
        
        [X,Y,T,AUC] = perfcurve(yTrain,train_scores(:,2),categorical(1));
        thresh = get_youdin(X,Y,T);
        
        threshold = [threshold;thresh];
        
        training_accuracy(count) = sum(YPred_tr == yTrain)./numel(yTrain);
        
        
        [YPred_val,val_scores] = classify(net,xVal, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest');
        validation_accuracy(count) = sum(YPred_val == yVal)./numel(yVal);
        
        [YPred,scores] = classify(net,xTest, ...
            'MiniBatchSize',miniBatchSize, ...
            'SequenceLength','longest');
        
        
        test_pred = [test_pred; YPred];
        test_scores = [test_scores; scores];
        test_total_labels = [test_total_labels; yVal];
        
        clear sequenceLengthsVal sequenceLengths
        count = count+1;
    end % if xVal isempty
end

save('April_23_21_home_raw_walking_4str_all_bouts_abc','test_total_labels','test_scores','test_pred','training_accuracy','threshold','net');

[acc,spec,sens,f1,mcc] = get_performance_metrics(test_total_labels,test_pred);

[X,Y,T,AUC] = perfcurve(test_total_labels,test_scores(:,2),categorical(1));
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



for q = 1:num_subs
    ind = q == sub_ind;
    sub_scores = test_scores(ind,:);
    sub_pred = test_pred(ind);
    mode_pred(q) = mode(sub_pred);
    fall_status(q) = mode(fall_labels(ind));
    mean_scores(q,:) = mean(sub_scores);
    median_scores(q,:) = median(sub_scores);
    mode_scores(q,:) = mode(sub_scores);
end

disp('-----After Aggregation------')
[X,Y,T,AUC] = perfcurve(fall_status,mean_scores(:,2),categorical(1));
%Plot stuff
figure;plot(X,Y,'linewidth',2); hold on; grid on;
plot([0,1],[0,1],'--k');
xlabel('FPR'); ylabel('TPR');
axis equal;
xlim([0,1]); ylim([0,1]);

[acc,spec,sens,f1,mcc] = get_performance_metrics3(fall_status,categorical(median_scores(:,2)>mean(threshold)));

fprintf('MCC = %f \n',mcc)

fprintf('F1 = %f \n',f1)

fprintf('AUC = %f \n',AUC)

fprintf('Sens = %f \n',sens)

fprintf('Spec = %f \n',spec)

fprintf('Acc = %f \n',acc)