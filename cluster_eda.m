clear; clc;

load('cluster_results_4.mat')

used_subs = unique(cluster_subs);

%% Check for relationships with fall risk

[h,p] = corr(clusterX,cluster_fall_status','type','Spearman');

% increasing cluster number is correlated with a decreasing fall status

[h,p] = corr(clusterX,cluster_inputs(:,1),'type','Spearman');

% increasing cluster number is correlated with decreasing walking fall risk
% score

[h,p] = corr(clusterX,cluster_inputs(:,2),'type','Spearman')

% no significant correlation between standing fall risk score and cluster
% number

f_mask = cluster_fall_status == 2;

fallers = clusterX(f_mask);
non_fallers = clusterX(~f_mask);

figure;bar(non_fallers);title('non_fallers')
figure;bar(non_fallers);title('non_fallers')
% These plots don't show us much, other than fallers are most commonly 1
% and non_fallers typically have a higher cluster number


% both fallers and non_fallers fail the lilitest and are therefore not
% normal

[p,h] = ranksum(fallers,non_fallers);

% Fallers and non_fallers do not come from the same distribution, we reject
% null on rank sum

mean(fallers)
mean(non_fallers)
% Non_fallers has a high mean cluster number


range(fallers)
range(non_fallers)
% the same range is exhibited in both

std(fallers)
std(non_fallers)
% very similar standard deviations

%% Check for relationships with clincial parameters
tbl = readtable('ms_fall_study_session1_final.xlsx');

for g = 1:length(clusterX)
    sub = cluster_subs{g};
    for t = 1:size(tbl,1)
        if strcmp(tbl{t,3},sub)
            abc = tbl.ABC(t);
            edss = tbl.EDSS_T(t);
            msws = tbl.MSWS(t);
            mfis = tbl.MFIS(t);
            break;
        end
    end%t
    
    ABC(g) = abc;
    EDSS(g) = edss;
    MSWS(g) = msws;
    MFIS(g) = mfis;
end

[h,p] = corr(clusterX,ABC','type','Spearman');
% significant (weak) positive correlation for ABC

[h,p] = corr(clusterX,EDSS','type','Spearman');
% no significant corr for EDSS

[h,p] = corr(clusterX,MSWS','type','Spearman');
% significant weak negative correlation

[h,p] = corr(clusterX,MFIS','type','Spearman');
% No significant correlation for MFIS


%% Check to see who is changing clusters
for s = 1:length(used_subs)
    sub_ind = strcmp(cluster_subs,used_subs{s});
    sub_clusts = clusterX(sub_ind);
    summary_data(s,1) = min(sub_clusts);
    summary_data(s,2) = max(sub_clusts);
    summary_data(s,3) = mode(sub_clusts);
    summary_data(s,4) = length(unique(sub_clusts));
    summary_data(s,5) = mode(cluster_fall_status(sub_ind));
    
    if summary_data(s,3) == 2
        yPred_sub(s) = 1;
    else
        yPred_sub(s) = 2;
    end
    % walking model
    if summary_data(s,3) == 2 || summary_data(s,3) == 4
        yPred_sub_w(s) = 1;
    else
        yPred_sub_w(s) = 2;
    end
    
    % standing model
    if summary_data(s,3) == 1 || summary_data(s,3) == 1
        yPred_sub_s(s) = 1;
    else
        yPred_sub_s(s) = 2;
    end
end

% Mode cluster
[acc_sub,spec_sub,sens_sub,f1_sub] = get_performance_metrics(summary_data(:,5),yPred_sub);
% overall: acc = 0.6071, spec = 0.4286, sens = 0.7857, f1 = 0.667

[acc_sub_w,spec_sub_w,sens_sub_w,f1_sub_w] = get_performance_metrics(summary_data(:,5),yPred_sub_w);
% walking: acc = 0.6429, spec = 0.5714, sens = 0.7143, f1 = 0.6667

[acc_sub_s,spec_sub_s,sens_sub_s,f1_sub_s] = get_performance_metrics(summary_data(:,5),yPred_sub_s);
% standing: acc = 0.3214, spec = 0.2857, 0.3571, 0.3448
%% Look at fall risk based on quadrant for all bouts

% Based on both models (NF = quadrant 2), walking models (NF = 2,4),
% standing models (NF = 1,2)

for k = 1:length(clusterX)
    if clusterX(k) == 2
        yPred_overall(k) = 1;
    else
        yPred_overall(k) = 2;
    end
    % walking model
    if clusterX(k) == 2 || clusterX(k) == 4
        yPred_walking(k) = 1;
    else
        yPred_walking(k) = 2;
    end
    
    % standing model
    if clusterX(k) == 1 || clusterX(k) == 1
        yPred_standing(k) = 1;
    else
        yPred_standing(k) = 2;
    end
    
end

[acc_o,spec_o,sens_o,f1_o] = get_performance_metrics(cluster_fall_status,yPred_overall);
% overall acc = 0.6581, spec = 0.4181, sens = 0.8970, f1 = 0.7244

[acc_w,spec_w,sens_w,f1_w] = get_performance_metrics(cluster_fall_status,yPred_walking);
% walking: acc = 0.7634, spec = 0.7155, sens = 0.8112, f1 = 0.7746

[acc_s,spec_s,sens_s,f1_s] = get_performance_metrics(cluster_fall_status,yPred_standing);
% standing: acc = 0.3367, 0.1681, 0.5064, 0.4338