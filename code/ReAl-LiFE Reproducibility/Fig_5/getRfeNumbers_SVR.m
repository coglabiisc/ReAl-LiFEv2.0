function [rval_N2, rval, pval, predictedscoret, abs_beta_weights, true_beta_weights, train_cv_number_features] = getRfeNumbers_SVR(Predtrain,Behavtrain,Predtest,Behavtest,N2)

%%                          GETRFENUMBERS
% This does second level N2-fold recursive feature elimination on the
% specified training and testing features
%
% The inputs are matrices with dimensions FeaturesXSubjects
%
% generalization_performance,Discrimination_map,train_cv_number_features are
% returned as 1XR, FeaturesXR and 1XR matrices
%
%% It is important that the number of training subjects is divisible by the N2 parameter that is passed

%% check number of variable arguments
% min = 0; max = 1

narginchk(5, inf);

%% inits

number_features = size(Predtrain,2);
number_training_subjects = size(Predtrain,1);


%% split training data further into N2 folds

%random permutation to get the N2 folds
rand_perm_subjects = randperm(number_training_subjects);
subject_groups = reshape(rand_perm_subjects, N2, floor(number_training_subjects/N2));


%% run recursive feature elimination

% %preparing cv labels
% rest_cv_set_labels = false(1,number_testing_subjects);
% task_cv_set_labels = true(1,number_testing_subjects);

remaining_features = 1:size(Predtrain,2);%remaining features
ranked_list = []; %ascending order with noisy in the left

%the three return params
train_cv_number_features = [];
abs_beta_weights = [];
true_beta_weights = [];
c = 1;

while ~isempty(remaining_features)
    
%     fprintf('remaining features : %d\n',length(remaining_features));
    
    Beta_average = 0;
    Beta_true_average = 0;
    
    %restrict to remaining dimensions
    curr = Predtrain(:,remaining_features);
    
    %N2-average of features for better estimates
    for test_row = 1:N2 %leave out that row of subject_groups
        
        train_subj_indices = subject_groups([1:test_row-1 test_row+1:N2],:);
        train_subj_indices = train_subj_indices(:);
        trainpred = (curr(train_subj_indices,:));
        trainbehav = Behavtrain(train_subj_indices);
        
        %-----------------------------------------------------------
        %train and test the svr model
        %-----------------------------------------------------------
        
        curr_mdl = fitrsvm(trainpred,trainbehav,'Kernelfunction', 'linear','Iterationlimit',1e3);
        
        % predict the scores of the test from the N1 folds
        predictedscoretemp(:,test_row) = predict(curr_mdl,Predtest(:,remaining_features));
        
        % correlate the predicted scores with the actual (only the tested ones)
        [rval(c,test_row), pval(c,test_row)] = corr(Behavtest,predictedscoretemp(:,test_row));

        % sum the absolute and true beta weights (take an average below)
        Beta_average = Beta_average + abs(curr_mdl.Beta); % this is only for elimination
        Beta_true_average = Beta_true_average + curr_mdl.Beta; % actual beta weights
        
    end
    
    % average the r values across all the N2 folds
    rval_N2(c) = mean(rval(c,:));
    
    % divide by N2 to get average beta weights
    Beta_average = Beta_average/N2;
    Beta_true_average = Beta_true_average/N2;

    % average predicted scores of tested subjects across the N2 folds
    predictedscoret(:,c) = mean(predictedscoretemp,2);

    % number of features at each elimination
    train_cv_number_features(c) = length(remaining_features);
     
    % Absolute beta weights for the features at each elimination
    curr_discrimination_map = zeros(number_features,1);
    curr_discrimination_map(remaining_features) = Beta_average;
    abs_beta_weights(:,c) = curr_discrimination_map;

    % True beta weights for the features at each elimination    
    curr_true_discrimination_map = zeros(number_features,1);  
    curr_true_discrimination_map(remaining_features) = Beta_true_average;
    true_beta_weights(:,c) = curr_true_discrimination_map;
    
    % lets discard the least 10% of features
    target_size = floor((length(remaining_features)) * 0.9);
    number_to_be_eliminated = length(remaining_features)-target_size;
    
    % eliminate the features from the remaining and add to ranked list
    [~,sortedIndices] = sort(Beta_average(:),'ascend');
    elimination_indices = sortedIndices(1:number_to_be_eliminated);
    ranked_list = [ranked_list elimination_indices'];
    remaining_features(elimination_indices) = [];

    c = c+1;

end

end


