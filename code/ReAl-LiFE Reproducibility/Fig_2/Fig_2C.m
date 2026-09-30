colc = [0,0,255; 0,0,0; 255,0,0]/255;

load('/results/Fig_2/L1_norm_cv_rmse.mat');
datasets = {'S(ET)','I','M'};
lam = logspace(-8,0,numlam);

for ii = 3%1:size(datasets,2)
    
    
    x0 = 0.15;
    x1 = 0.05;
    y0 = 0.1;
    y1 = 0.1;
    g = 0.05;
    
    w = 1-(x0+x1);
    h = (1-(y0+y1+g))/4;
    
    if ii==1 || ii==3
        sp = 1;
        ep = 2;
    else
        sp = 1;
        ep = 26;
    end
    
    figure(ii);
    s1 = subplot(2,1,1);
    plot(lam(sp:3:ep), L1norm_RL(sp:3:ep,ii),'Color',colc(ii,:),'Marker','o','MarkerSize',6,'MarkerFaceColor','w','Linewidth',2); hold on;
    hold on;
    plot(lam, L1norm_L(ii)*ones(numlam,1),'Color',colc(ii,:),'Linestyle','--','Linewidth',2);
    set(s1,'XScale','log','XColor','none');
    xlim([1e-8,1]);
    box off;
    ylim([min(L1norm_RL(1:ep,ii)),max(L1norm_RL(1:ep,ii))]);
    title(sprintf('Dataset %s',datasets{ii}));
    ylabel('||w||_{1}');
    
    s2 = subplot(2,1,2);
    plot(lam(ep+2:2:end), L1norm_RL(ep+2:2:end,ii),'Color',colc(ii,:),'Marker','o','MarkerSize',6,'MarkerFaceColor','w','Linewidth',2); hold on;
    hold on;
    set(s2,'XScale','log');
    box off;
    xlim([1e-8,1]);
    ylim([L1norm_RL(end,ii),L1norm_RL(ep+2,ii)]);
    xlabel('\lambda');
    
    set(s1,'Position',[x0,y0+h+g,w,3*h]);
    set(s2,'Position',[x0,y0,w,h]);

    saveas(gcf, sprintf('/results/Fig_2/dataset_%s_summed_weights.png', datasets{ii}));
    
end

