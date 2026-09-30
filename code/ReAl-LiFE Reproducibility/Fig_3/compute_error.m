datasets = {'SET','I','M'};
numdir = [96,64,32];

for ii = 1:size(datasets,2)
    
    
    % LiFE
    load(sprintf('/results/Fig_3/fe_stats_LiFE_consistency_%s_1_adj.mat',datasets{ii}));
    fe12 = fe;
    load(sprintf('/results/Fig_3/fe_stats_LiFE_consistency_%s_2_adj.mat',datasets{ii}));
    fe21 = fe;
    
    coords12 = feGet(fe12,'roi coords');
    coords21 = feGet(fe21,'roi coords');
    unioncoords = union(coords12,coords21,'rows');
    
    lia_12 = ismember(unioncoords,coords12,'rows');
    lia_21 = ismember(unioncoords,coords21,'rows');
    
    pred12 = reshape(feGet(fe12,'psigfiber'),[size(coords12,1),numdir(ii)]);
    pred21 = reshape(feGet(fe21,'psigfiber'),[size(coords21,1),numdir(ii)]);
    
    pred_union12 = nan(size(unioncoords,1),numdir(ii));
    pred_union21 = nan(size(unioncoords,1),numdir(ii));
    
    pred_union12(lia_12,:) = pred12;
    pred_union21(lia_21,:) = pred21;
    
    p12 = nanmean(pred_union12,2);
    p21 = nanmean(pred_union21,2);
    
    rmse{ii}(:,1) = rms(p12-p21,2);

    
    % ReAl-LiFE
    load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_consistency_%s_1_adj.mat',datasets{ii}));
    fe12 = fe;
    load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_consistency_%s_2_adj.mat',datasets{ii}));
    fe21 = fe;
    
    
    coords12 = feGet(fe12,'roi coords');
    coords21 = feGet(fe21,'roi coords');
    unioncoords = union(coords12,coords21,'rows');
    
    lia_12 = ismember(unioncoords,coords12,'rows');
    lia_21 = ismember(unioncoords,coords21,'rows');
    
    pred12 = reshape(feGet(fe12,'psigfiber'),[size(coords12,1),numdir(ii)]);
    pred21 = reshape(feGet(fe21,'psigfiber'),[size(coords21,1),numdir(ii)]);
    
    pred_union12 = nan(size(unioncoords,1),numdir(ii));
    pred_union21 = nan(size(unioncoords,1),numdir(ii));
    
    pred_union12(lia_12,:) = pred12;
    pred_union21(lia_21,:) = pred21;
    
    p12 = nanmean(pred_union12,2);
    p21 = nanmean(pred_union21,2);
    
    rmse{ii}(:,2) = rms(p12-p21,2);
    
    diff_rmse{ii} = rmse{ii}(:,2) - rmse{ii}(:,1); % ReAl-LiFE - LiFE
    
end

save(sprintf('/results/Fig_3/Consistency_rmse.mat'),'rmse','diff_rmse');
