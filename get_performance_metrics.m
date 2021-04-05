function [acc,spec,sens,f1,mcc] = get_performance_metrics(truth,predicted)
    C = confusionmat(truth,predicted);
    acc = (C(1,1)+C(2,2)) / sum(sum(C));
    spec = C(1,1) / sum(C(1,:)); 
    sens = C(2,2) / sum(C(2,:));
    precision = C(2,2) / sum(C(:,2));
    recall = sens;
    f1 = 2 * ((precision*recall)/(precision+recall));
    TP = C(1,1);
    TN = C(2,2);
    FP = C(1,2);
    FN = C(2,1);
    mcc = (TP*TN - FP*FN) / (1+sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)));
end