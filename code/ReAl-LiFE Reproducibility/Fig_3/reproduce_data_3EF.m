addpath('./');
addpath(genpath('/data/Fig_3/raw_data'));
mkdir('/results/Fig_3/')

datasets = {'SET','I','M'};

alpha = [1,0]; % 1-L1, 0-L2 regularization
numlam = 30;
lambda = logspace(-8,0,numlam);

for ii = 1:size(datasets,2)
    
    Niter = 500;
    use_gpu = 1;
    gpudev = 1;
    
    if ii == 1
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D1/WB_ET_320000.tck',datasets{ii});
    else
        tck_file = sprintf('/data/Fig_3/raw_data/dataset_%s/D1/WB_2M.tck',datasets{ii});
    end
    
    real_life_fig3ef(use_gpu, tck_file, Niter, lambda, alpha, gpudev, datasets{ii});
   
    
end

% reproduce Fig. 3E
Fig_3E;

% reproduce Fig. 3F
Fig_3F;


    