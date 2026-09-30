datasets = {'SET','I','M'};

for ii = 1:size(datasets,2)
    
    cdata = 1;
    mdata = 2;
    
    load(sprintf('/results/Fig_3/fe_stats_LiFE_consistency_%s_%d.mat',datasets{ii},cdata));
    fel = fe;
    
    load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_consistency_%s_%d.mat',datasets{ii},cdata));
    ferl = fe;
    clear fe;
    
    wl = fel.life.fit.weights; % LiFE weights
    wrl = ferl.life.fit.weights; % ReAl-LiFE weights
    
    [al,bl] = sort(wl,'descend');
    [arl,brl] = sort(wrl,'descend');
    
    lifeindrem = bl(length(bl)/2+1:end); % bottom 50% of weights
    rlifeindrem = brl(length(brl)/2+1:end); % bottom 50% of weights
    
    wl(lifeindrem) = 0; % set bottom 50% of weights to 0
    wrl(rlifeindrem) = 0;  % set bottom 50% of weights to 0
    
    % re-write data
    
    fel.life.fit.weights = wl;
    fe = fel;
    save(sprintf('/results/Fig_3/fe_stats_LiFE_consistency_%s_%d_adj.mat',datasets{ii},cdata),'fe','-v7.3');
    clear fe;
    
    ferl.life.fit.weights = wrl;
    fe = ferl;
    save(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_consistency_%s_%d_adj.mat',datasets{ii},cdata),'fe','-v7.3');
    
    %-------------------------------------------------------------------------------------
    
    cdata = 2;
    mdata = 1;
    
    load(sprintf('/results/Fig_3/fe_stats_LiFE_consistency_%s_%d.mat',datasets{ii},cdata));
    fel = fe;
    
    load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_consistency_%s_%d.mat',datasets{ii},cdata));
    ferl = fe;
    clear fe;
    
    wl = fel.life.fit.weights; % LiFE weights
    wrl = ferl.life.fit.weights; % ReAl-LiFE weights
    
    [al,bl] = sort(wl,'descend');
    [arl,brl] = sort(wrl,'descend');
    
    lifeindrem = bl(length(bl)/2+1:end); % bottom 50% of weights
    rlifeindrem = brl(length(brl)/2+1:end); % bottom 50% of weights
    
    wl(lifeindrem) = 0; % set bottom 50% of weights to 0
    wrl(rlifeindrem) = 0;  % set bottom 50% of weights to 0
    
    % re-write data
    
    fel.life.fit.weights = wl;
    fe = fel;
    save(sprintf('/results/Fig_3/fe_stats_LiFE_consistency_%s_%d_adj.mat',datasets{ii},cdata),'fe','-v7.3');
    clear fe;
    
    ferl.life.fit.weights = wrl;
    fe = ferl;
    save(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_consistency_%s_%d_adj.mat',datasets{ii},cdata),'fe','-v7.3');
end

