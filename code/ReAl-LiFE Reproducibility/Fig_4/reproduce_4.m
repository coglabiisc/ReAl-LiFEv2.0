addpath(genpath('.'));
addpath(genpath('/data/Fig_4/raw_data'));
mkdir('/results/Fig_4/')

% run ReAl-LiFE

Niter = 500;
use_gpu = 1;
lambda = 0.01;
alpha = 1;
gpudev = 1;

numparts = 10;

for ii = 1:numparts
    
    tck_file = sprintf('/data/Fig_4/raw_data/WB_25M_p%d.tck',ii);
    real_life_fig4(use_gpu, tck_file, Niter, lambda, alpha, gpudev, ii);
    load(sprintf('/results/Fig_4/weights_ReAl_LiFE_%d.mat',ii));
    
    % extract pruned connectome
    
    fg = fgRead(tck_file);
    f = find(weights == 0);
    fg.fibers(f) = [];
    fgWrite(fg, sprintf('/results/Fig_4/WB_25M_RL_p%d.tck',ii),'tck');
    
end