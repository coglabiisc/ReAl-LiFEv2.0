mkdir('/results/Fig_5/');

% feature types
conditions = {'ReAlLiFE'};
LiFEcondition = conditions{1};
load(sprintf('/data/Fig_5/raw_data/Predictors_%s.mat',LiFEcondition));

% zscore
Pred = zscore(Pred);

% load scores, replace NaNs with mean
load('/data/Fig_5/raw_data/Scores_200_60.mat');

scores = table2array(scores200_60);

for ll = 1:size(scores,2)
    scores(isnan(scores(:,ll)),ll) = nanmean(scores(:,ll));
end


% z-score scores
scores = zscore(scores);

% initialize variables
N1 = 10;
N2 = 5;
number_runs = 100;

% make output data directory
datadir = sprintf('/results/Fig_5/Data_RFE_ReAlLiFE');
mkdir(datadir);


% initialize variables
predictedscores = nan(size(scores));
load('/data/Fig_5/raw_data/regression_prediction_seeds.mat');

parfor kk = 1:size(scores,2) % for each score
    
    rfeseed = RFEseeds(kk,:);
       
    % do the RFE and predictions. predt is the best predicted score
    [predictedscores(:,kk), top_feature_positions{kk,1}, true_beta_average{kk,1}] =...
        RFE_SVR(Pred, scores(:,kk), kk, N1, N2, number_runs, LiFEcondition, datadir,rfeseed);   
    fprintf('%d score complete \n', kk);
    
end

save(sprintf('%s/Predicted_Scores_%s.mat',datadir,LiFEcondition),...
    'predictedscores','top_feature_positions','true_beta_average');
