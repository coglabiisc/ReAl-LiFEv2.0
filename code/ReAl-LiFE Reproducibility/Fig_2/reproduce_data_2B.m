% this code contains steps to run GPU-LiFE, ReAl-LiFE and compute zetas
% for a 1M fiber connectome.

% Add ReAl-LiFE to path
% Add ReAl-LiFE Scripts/Fig_1 to path
% Navigate to the folder containing data of interest in the demo data
% folder
% Execute the following
% To reproduce plots as in Fig. 2B, run Fig_2B.m

addpath(genpath('.'));
addpath(genpath('/data/Fig_2/raw_data_2B'));
mkdir('/results/Fig_2/')

tck_file = '/data/Fig_2/raw_data_2B/WB_1M.tck';
Niter = 500;

% run GPU-LiFE

use_gpu = 1;
lambda = 0;
alpha = 0;
gpudev = 1;

[fe, out] = real_life_fig2b(use_gpu, tck_file, Niter, lambda, alpha, gpudev);
load('/results/Fig_2/fe_stats_GPU_LiFE.mat');

w1L = weights(1:length(weights)/2);
w2L = weights(length(weights)/2+1:length(weights));

zeta(:,1) = abs(w1L-w2L)./(w1L+w2L);

% run ReAl-LiFE

use_gpu = 1;
lambda = 0.05; % regularization parameter
alpha = 1; % L1 regularization. See real_life.m for details

[fe, out] = real_life_fig2b(use_gpu, tck_file, Niter, lambda, alpha, gpudev);
load('/results/Fig_2/fe_stats_ReAl_LiFE.mat');

w1RL = weights(1:length(weights)/2);
w2RL = weights(length(weights)/2+1:length(weights));
zeta(:,2) = abs(w1RL-w2RL)./(w1RL+w2RL);

[p,h] = signrank(zeta(:,2),zeta(:,1),'tail','right');

% exclude fibers where both weights are equal

f1 = find(zeta(:,1) == 0);
f2 = find(zeta(:,2) == 0);
u = unique([f1;f2]);
zeta(u,:) = [];

save('/results/Fig_2/zeta_LiFE_vs_ReAl.mat','zeta');
clear zeta;
%----------------------------------------------------------------------------

% Load weights after SIFT. These are binary weights: 1 - fiber retained, 0
% - fiber discarded

siftc1 = importdata('/data/Fig_2/raw_data_2B/WB_01_SIFTweights.txt');
siftc2 = importdata('/data/Fig_2/raw_data_2B/WB_02_SIFTweights.txt');

% logical indices of all fibers retained after SIFT
sift_ret = [siftc1; siftc2];

w1S = zeros(length(siftc1),1);
w2S = zeros(length(siftc2),1);

% import SIFT2 weights (SIFT2 was run after SIFT to get weights for all fibers that were retained)

sift2 = importdata('/data/Fig_2/raw_data_2B/SIFT2_weights.txt');
sift2 = sift2.data;

w1S(find(siftc1)) = sift2(1:length(find(siftc1)));
w2S(find(siftc2)) = sift2(length(find(siftc1))+1:end);

zeta(:,1) = abs(w1S-w2S)./(w1S+w2S);

load('/results/Fig_2/fe_stats_ReAl_LiFE.mat');
w1RL = weights(1:length(weights)/2);
w2RL = weights(length(weights)/2+1:length(weights));
zeta(:,2) = abs(w1RL-w2RL)./(w1RL+w2RL);

save('/results/Fig_2/zeta_SIFT_vs_ReAl.mat','zeta');
clear zeta;

% reproduce Fig. 2B
Fig_2B;
