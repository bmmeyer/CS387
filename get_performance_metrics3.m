function [acc,spec,sens,f1,mcc] = get_performance_metrics3(truth,predicted)
    C = confusionmat(truth,predicted);
    acc = (C(1,3)+C(2,4)) / sum(sum(C));
    spec = C(1,3) / sum(C(1,:)); 
    sens = C(2,4) / sum(C(2,:));
    precision = C(2,4) / sum(C(:,4));
    recall = sens;
    f1 = 2 * ((precision*recall)/(precision+recall));
    TP = C(1,3);
    TN = C(2,4);
    FP = C(1,4);
    FN = C(2,3);
    mcc = (TP*TN - FP*FN) / (1+sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)));
end