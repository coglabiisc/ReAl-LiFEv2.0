addpath(genpath('.'));
addpath(genpath('/data/Fig_3/raw_data'));
mkdir('/results/Fig_3/')

datasets = {'SET','I','M'};
lambdavals = [0.01, 0.006, 0.01];

%% test for overfitting

for ii = 1:size(datasets,2)
    
    
    Niter = 500;
    use_gpu = 1;
    gpudev = 1;
    
    cdata = 1; % test for overfitting, fit connectome on dataset 1, evaluate with dataset 1
    mdata = 1;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_ET_320000.tck',datasets{ii},cdata);
    else
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_2M.tck',datasets{ii},cdata);
    end
    
    % run LiFE
    
    lambda = 0;
    alpha = 0;
    
    real_life_fig3cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, cdata, mdata, datasets{ii});
    load(sprintf('/results/Fig_3/fe_stats_LiFE_overfitting_%s_%d.mat',datasets{ii},cdata));
    rmse{ii}(:,1) = cv_rmse;
    
    % run ReAlLiFE
    
    lambda = lambdavals(ii);
    alpha = 1;
    
    real_life_fig3cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, cdata, mdata, datasets{ii});
    load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_overfitting_%s_%d.mat',datasets{ii},cdata));
    rmse{ii}(:,2) = cv_rmse;
    
    diff_rmse{ii} = rmse{ii}(:,2) - rmse{ii}(:,1); % ReAl-LiFE - LiFE;
    
    save(sprintf('/results/Fig_3/Overfitting_rmse.mat'),'rmse','diff_rmse');
    
    % reproduce Fig. 3C
    Fig_3C;
    
    
end

% test for consistency

for ii = 1:size(datasets,2)
    
    
    Niter = 500;
    use_gpu = 1;
    gpudev = 1;
    
    % run LiFE
    
    lambda = 0;
    alpha = 0;
    
    cdata = 1; % test for consistency, fit connectome on dataset 1, evaluate with dataset 2
    mdata = 2;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_ET_320000.tck',datasets{ii},cdata);
    else
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_2M.tck',datasets{ii},cdata);
    end
    
    real_life_fig3cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, cdata, mdata, datasets{ii});
    
    cdata = 2; % test for consistency, fit connectome on dataset 2, evaluate with dataset 1
    mdata = 1;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_ET_320000.tck',datasets{ii},cdata);
    else
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_2M.tck',datasets{ii},cdata);
    end
    
    real_life_fig3cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, cdata, mdata, datasets{ii});
    
    
    % run ReAlLiFE
    
    lambda = lambdavals(ii);
    alpha = 1;
    
    cdata = 1; % test for consistency, fit connectome on dataset 1, evaluate with dataset 2
    mdata = 2;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_ET_320000.tck',datasets{ii},cdata);
    else
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_2M.tck',datasets{ii},cdata);
    end
    
    real_life_fig3cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, cdata, mdata,datasets{ii});
    
    cdata = 2; % test for consistency, fit connectome on dataset 2, evaluate with dataset 1
    mdata = 1;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_ET_320000.tck',datasets{ii},cdata);
    else
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D%d/WB_2M.tck',datasets{ii},cdata);
    end
    
    real_life_fig3cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, cdata, mdata,datasets{ii});
    
    
end

% Take only top 50% weights
set_50p_weights;

% Compute error in predicting signal using LiFE and ReAl-LiFE
compute_error;

% reproduce Fig. 3D
Fig_3D;




