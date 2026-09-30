addpath(genpath('.'));
addpath(genpath('/data/Fig_2/raw_data_2CD'));
mkdir('/results/Fig_2');

datasets = {'SET','I','M'};

for ii = 1:size(datasets,2)
    
    % run LiFE
    Niter = 500;
    use_gpu = 1;
    gpudev = 1;
    
    lambda = 0;
    alpha = 0;
    
    cd (sprintf('/data/Fig_2/raw_data_2CD/dataset_%s/D1',datasets{ii}));
    
    if ii == 1
        tck_file = sprintf('/data/Fig_2/raw_data_2CD/dataset_%s/D1/WB_ET_160000.tck',datasets{ii});
    else
        tck_file = sprintf('/data/Fig_2/raw_data_2CD/dataset_%s/D1/WB_1M.tck',datasets{ii});
    end

    
    real_life_fig2cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, datasets{ii});
    load(sprintf('/results/Fig_2/fe_stats_LiFE_%s.mat', datasets{ii}));
    L1norm_L(:,ii) = wnorm;
    cvrmse_L(:,ii) = rmse_cv;
    
    % run ReAl-LiFE

    numlam = 30;
    lambda = logspace(-8,0,numlam);
    alpha = 1;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_2/raw_data_2CD/dataset_%s/D1/WB_ET_320000.tck',datasets{ii});
    else
        tck_file = sprintf('/data/Fig_2/raw_data_2CD/dataset_%s/D1/WB_2M.tck',datasets{ii});
    end
    
    real_life_fig2cd(use_gpu, tck_file, Niter, lambda, alpha, gpudev, datasets{ii});
    load(sprintf('/results/Fig_2/fe_stats_ReAl_LiFE_%s.mat', datasets{ii}));
    L1norm_RL(:,ii) = wnorm;
    cvrmse_RL(:,ii) = rmse_cv;
    
end

save('/results/Fig_2/L1_norm_cv_rmse.mat','L1norm_L','cvrmse_L','L1norm_L','cvrmse_RL','numlam');

% reproduce figs 2C, 2D

Fig_2C;
Fig_2D;
