datasets = {'S(ET)','I','M'};
colc = [0,0,255; 0,0,0; 255,0,0]/255;

load('/results/Fig_3/Consistency_rmse.mat');
% rmse has the voxelwise RMS errors: column 1 for LiFE, column 2 for
% ReAl-LiFE

binnum = [50,50,50];
ll = [-2.5,-0.3,-0.6];
ul = -ll;

for ii  = 1:size(dataset,2)
    
    figure(ii);
    
    [n,e,b] = histcounts(diff_rmse{ii},binnum(ii));
    x = 0.5*(e(1:end-1) + e(2:end));
    plot(x,n,'Color',colc(ii,:),'linewidth',2);hold on;
    nmax = max(n);
    nmin = min(n);
    plot([0,0],[nmin,nmax],'Color',[0.5,0.5,0.5],'Linestyle','--','linewidth',1.5);
    xlim([ll(ii),ul(ii)]);
    symlog('x');
    box off;
    
    xlabel('\Delta RMSE: ReAL-LiFE - LiFE');
    ylabel('# voxels');
    title(sprintf('Dataset %s',datasets{ii}));

    saveas(gcf, sprintf('/results/Fig_3/dataset_%s_consistency.png', datasets{ii}));
    
end