% Build inputs for clustering

% Loop through each subject in walking data

% Use logical index to pick out walking and standing for specific subject

% Loop through each walking bout

% Use closest function to find closest standing bout
% sample without replacement from standing
% selected standing bouts must be after the previously selected
% bout and within 15mins of walking bout.

%% Load walking and standing data
clear;clc;close all
stand = load('April_28_21_home_standing_abc_wStartTime.mat');
walk = load('April_28_21_home_raw_walking_8str_all_bouts_wStartTime.mat');

w_subs = unique(walk.sub_name);
c = 1; cluster_inputs = [];cluster_subs = {};cluster_fall_status = [];used = 0;
for s = 1:length(w_subs)
    stand_ind = strcmp(stand.sub_name,w_subs(s));
    walk_ind = strcmp(walk.sub_name,w_subs(s));
    w_times = walk.startTime(walk_ind);
    w_scores = walk.test_scores(walk_ind,2);
    s_times = stand.startTime(stand_ind);
    
    % Need to sort standing and walking data
    
    [w_times,w_sInd] = sort(w_times);
    w_scores = w_scores(w_sInd);
    
    [s_times,~] = sort(s_times);
    if isempty(s_times)
    else
        for i = 1:sum(walk_ind)
            if i == 1
                w_time = w_times(i);
                w_score = w_scores(i);
                s_time = closest(s_times,w_time);
                s_ind = find(s_times == s_time);
                s_score = stand.test_scores(s_ind(end),2);
                if abs(w_time - s_time) < 3600 %900 is 15 mins, 3600 is 1 hour
                    cluster_inputs(c,:) = [double(w_score) double(s_score)];
                    cluster_fall_status(c) = mode(walk.test_total_labels(walk_ind));% want to add fall label and subject id
                    cluster_subs{c} = w_subs{s};
                    used = 1;
                    c = c + 1;
                    
                end
            else
                if used == 1
                    previous_stand = s_time;
                    ind = find(s_times > previous_stand);
                    s_times = s_times(ind);
                end
                used = 0;
                w_time = w_times(i);
                w_score = w_scores(i);
                s_time = closest(s_times,w_time);
                s_ind = find(s_times == s_time);
                if ~isempty(s_ind)
                    if abs(w_time - s_time) < 3600
                        s_score = stand.test_scores(s_ind(end),2);
                        cluster_inputs(c,:) = [double(w_score) double(s_score)];
                        cluster_fall_status(c) = mode(walk.test_total_labels(walk_ind));% want to add fall label and subject id
                        cluster_subs{c} = w_subs{s};
                        c = c + 1;
                        used = 1;
                    end
                end
            end
        end
    end
end

%% Export as csv

export_tbl = table(cluster_inputs(:,1),cluster_inputs(:,2),cluster_fall_status',cluster_subs','VariableNames',{'Walking Score','Standing Score','Fall Status','Subject Ind'});
%writetable(export_tbl,'clustering_tbl.csv')
%% Build clustering model in MATLAB using Gausian Mixture model

%% Evaluate optimal model
X = cluster_inputs;

[n,p] = size(X);
d = 500; % Grid length
x1 = linspace(min(X(:,1))-2, max(X(:,1))+2, d);
x2 = linspace(min(X(:,2))-2, max(X(:,2))+2, d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];
options = statset('MaxIter',100);

gmfit_opt = fitgmdist(X,4, ...
    'SharedCovariance',true,'Options',options,'Replicates',5); % Fitted GMM
[clusterX,nlogL,P] = cluster(gmfit_opt,X);
figure;
mahalDist = mahal(gmfit_opt,X0);
h_opt = gscatter(X(:,1),X(:,2),clusterX);
hold on
for m = 1:4
    idx = mahalDist(:,m)<=threshold;
    Color = h_opt(m).Color*0.75 - 0.5*(h_opt(m).Color - 1);
    h2_opt = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
    uistack(h2_opt,'bottom');
end
plot(gmfit_opt.mu(:,1),gmfit_opt.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
title('Clusters of PwMS with optimal K')
legend(h_opt,string(linspace(1,4,4)))
hold off
%% Explore optimal k number
figure(1); scatter(cluster_inputs(:,1),cluster_inputs(:,2))
xlabel('Walking Fall Classification Score');ylabel('Standing Fall Classification Score')

k = linspace(1,10,10); % Number of GMM components
options = statset('MaxIter',100);

Sigma = {'full'}; % Options for covariance matrix type
nSigma = numel(Sigma);

SharedCovariance = {true}; % Indicator for identical or nonidentical covariance matrices
SCtext = {'true'};
nSC = numel(SharedCovariance);

X = cluster_inputs;
[n,p] = size(X);
d = 500; % Grid length
x1 = linspace(min(X(:,1))-2, max(X(:,1))+2, d);
x2 = linspace(min(X(:,2))-2, max(X(:,2))+2, d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];

threshold = sqrt(chi2inv(0.99,2));


count = 1;
for i = 1:length(k)
    %     figure;
    for j = 1:nSC
        gmfit = fitgmdist(X,k(i),...
            'SharedCovariance',true,'Options',options,'Replicates',5); % Fitted GMM
        [clusterX(:,i),nlogL(:,i),P] = cluster(gmfit,X); % Cluster index
        mahalDist = mahal(gmfit,X0); % Distance from each grid point to each GMM component
        % Draw ellipsoids over each GMM component and show clustering result.
        %         h1 = gscatter(X(:,1),X(:,2),clusterX);
        %         hold on
        %         for m = 1:k(i)
        %             idx = mahalDist(:,m)<=threshold;
        %             Color = h1(m).Color*0.75 - 0.5*(h1(m).Color - 1);
        %             h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
        %             uistack(h2,'bottom');
        %         end
        %         plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
        %         title(sprintf('K is %d Sigma is %s\nSharedCovariance = %s',k(i),Sigma{1},SCtext{1}),'FontSize',8)
        %         legend(h1,string(linspace(1,k(i),k(i))))
        %         hold off
        count = count + 1;
    end
end

eva = evalclusters(X,clusterX(:,1:9),'CalinskiHarabasz');

figure; plot(linspace(1,10,10),nlogL); xlabel('K clusters'); ylabel('Negative Log Likelihood');title('4 is the optimal number of clusters')


%%
% myfunc = @(X,K)(kmeans(X, K, 'emptyaction','singleton',...
%     'replicate',5));
%
myfunc_clust = @(X,K)(gmdistribution(X, K, 'CovarianceType','full','SharedCovariance',true,...
    'Replicates',5,'Options',options));
optimal_k = zeros(100,1);
for q = 1:100
    
    eva = evalclusters(X,'gmdistribution','CalinskiHarabasz','KList',[1:15]);
    
    optimal_k(q) = eva.OptimalK;
    
end

fprintf('The mean optimal value of k is %d with std of %d \n',mean(optimal_k),std(optimal_k))

% initialCond1 = [ones(n-8,1); [2; 2; 2; 2]; [3; 3; 3; 3]]; % For the first GMM
% initialCond2 = randsample(1:k,n,true); % For the second GMM
% initialCond3 = randsample(1:k,n,true); % For the third GMM
% initialCond4 = 'plus'; % For the fourth GMM
% cluster0 = {initialCond1; initialCond2; initialCond3; initialCond4};
%
% converged = nan(4,1);
% for j = 1:4
%     gmfit = fitgmdist(X,k,'CovarianceType','full', ...
%         'SharedCovariance',false,'Start',cluster0{j}, ...
%         'Options',options);
%     clusterX = cluster(gmfit,X); % Cluster index
%     mahalDist = mahal(gmfit,X0); % Distance from each grid point to each GMM component
% %     Draw ellipsoids over each GMM component and show clustering result.
%     subplot(2,2,j);
%     h1 = gscatter(X(:,1),X(:,2),clusterX); % Distance from each grid point to each GMM component
%     hold on;
%     nK = numel(unique(clusterX));
%     for m = 1:nK
%         idx = mahalDist(:,m)<=threshold;
%         Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
%         h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
%         uistack(h2,'bottom');
%     end
% 	plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
%     legend(h1,{'1','2','3'});
%     hold off
%     converged(j) = gmfit.Converged; % Indicator for convergence
% end
