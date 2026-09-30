function [meanpredscore, top_feature_positions, true_beta_average] = RFE_SVR(Pred, Behavscores, scorenum, N1, N2, number_runs, LiFEcondition, datadir, rseed)

% function RFE(filename_task, filename_resting, call_id, N1, N2, varargin)
%two level Rfe as implemented by De Martino and Srikanth Ryali
%

%%                      Input Arguments Format
%   1. filename_task should be a string containing the filename along with
%   '.mat' extension. The file should contain a matrix named 'GC_task_all'
%   with features X subjects, i.e., each column is a subject and each row
%   is a different feature.
%   2. filename_resting should be a string containing the filename along
%   with '.mat' extension. The file should conain a matrix named
%   'GC_resting_all' with features X subjects, i.e., each column is a
%   subject and each row is a feature.
%   3. call_id is an integer for storing the resulting data in a separate
%   file. This is useful in the case of multiple calls.
%   4. N1 is an integer. This is the number of first order folds.
%      Recommended value: 10.
%   5. N2 is an integer. This is the number of second order folds.
%      Recommended value: 5.
% For N1 & N2, constraint is that N2 should divide ((N1-1)*number_subjects)/N1.

%%                      Varargin Format
%        varargin{1} = array of strings with the optional name-value pairs
%                      arguments for fitclinear (specified consequtively).
%                      See fitclinear documentation for more details about
%                      these options.

%%                      Example function calls:
%   1. Vanilla (or) function call with no extra specifications:
%       RFE('task_spectrum.mat', 'resting_spectrum.mat', 15, 10, 5);
%   2. Specifying a few varargin options:
%         RFE('task_spectrum_data.mat', 'resting_spectrum_dat.mat', 17, 10, 5,...
%             {'Lambda', 1000, 'Learner', 'logistic', 'Regularization', 'ridge', ...
%             'Solver', 'asgd'});

%%                      Output:
%   The data required for plotting the accuracy plot will be stored in a
%   file named: strcat('for_plotting_', int2str(call_id));
%   For example, if call_id is 2, then file will be named:
%   'for_plotting_2.mat'

%% Checking if nargin is either 0 or 1

narginchk(5, inf);
%% load the data


% %AAL
% load(filename_task);
% load(filename_resting);


number_subjects = size(Pred,1);


if ~exist('number_runs', 'var')
    number_runs = 100;
end

for runNo = 1:number_runs
    
    rng(rseed(runNo));
    
    %% split into N1 folds, and call RFE repeatedly
    %
    
    %random permutation to get the N1 folds
    rand_perm_subjects = randperm(number_subjects);
    subject_groups = reshape(rand_perm_subjects, N1, number_subjects/N1);
    
    %the two sought after params across folds
    rval_N2_average = 0;
    discrimination_map_average = 0;
    
    for test_row = 1:N1 %the selected row will be sent in as testing
        
        fprintf('running for fold %d/%d \n',test_row,N1);
        
        train_subj_indices = subject_groups([1:test_row-1 test_row+1:N1],:);
        train_subj_indices = train_subj_indices(:);
        
        test_subj_indices = subject_groups(test_row,:);
        test_subj_indices = test_subj_indices(:);
        
        % Run RFE for each of the N1-1 folds as training data
        [ rval_N2(:,test_row,runNo), rval(:,:,test_row,runNo), pval(:,:,test_row,runNo), predictedscore(test_subj_indices,:),abs_beta_weights(:,:,test_row,runNo),true_beta_weights(:,:,test_row,runNo),number_of_features] = ...
            getRfeNumbers_SVR(Pred(train_subj_indices,:), Behavscores(train_subj_indices), Pred(test_subj_indices,:), Behavscores(test_subj_indices,:), N2);
    end
    
    % rval averaged across N1 folds, for each elimination and each run
    rval_N2_average = squeeze(nanmean(rval_N2,2));
    
    % beta weights averaged across N1 folds, for each elimination and each
    % run
    abs_beta_average = squeeze(nanmean(abs_beta_weights,3));
    true_beta_average = squeeze(nanmean(true_beta_weights,3));
    
    % choose elimination round that gave max correlation
    peak_corr_index = find(rval_N2_average(:,runNo) == max(rval_N2_average(:,runNo)));
    peak_predscore(:,runNo) = predictedscore(:,peak_corr_index);
    peak_number_features(runNo) = min(number_of_features(peak_corr_index));
    peak_abs_features(:,runNo) = abs_beta_average(:,peak_corr_index);
    peak_true_features(:,runNo) = true_beta_average(:,peak_corr_index);
    
    
    
end

% rval averaged across N1 folds, for each elimination and each run
rval_N2_average = squeeze(mean(rval_N2_average,2));

% beta weights averaged across N1 folds, for each elimination and each
% run
abs_beta_average = squeeze(mean(peak_abs_features,2));
true_beta_average = squeeze(mean(peak_true_features,2));
peak_num_features_average = round(mean(peak_number_features,2));
[~,sortedIndices] = sort(abs_beta_average,'descend');
top_feature_positions = sortedIndices(1:peak_num_features_average);
meanpredscore = mean(peak_predscore,2);
save(sprintf('%s/RFE_data_%s_%d.mat', datadir, LiFEcondition, scorenum));
