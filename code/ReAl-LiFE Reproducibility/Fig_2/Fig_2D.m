colc = [0,0,255; 0,0,0; 255,0,0]/255;

load('/results/Fig_2/L1_norm_cv_rmse.mat');
numlam = length(lam);
datasets = {'S(ET)','I','M'};

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
    set(s1,'Position',[x0,y0+3*h+g,w,h])
    plot(lam(ep+2:2:numlam), cvrmse_RL(ep+2:2:numlam,ii),'Color',colc(ii,:),'Marker','o','MarkerSize',6,'MarkerFaceColor','w','Linewidth',2); hold on;
    hold on;
    xlim([1e-8,1]);
    ylim([cvrmse_RL(end,ii),cvrmse_RL(ep+2,ii)]);
    
    set(gca,'XScale','log','YScale','log','XColor','none');
    box off;
    ylim([min(cvrmse_RL(ep+2:numlam,ii)),max(cvrmse_RL(ep+1:numlam,ii))]);
    title(sprintf('Dataset %s',datasets{ii}));
    
    s2 = subplot(2,1,2);
    set(s2,'Position',[x0,y0,w,3*h]);
    plot(lam(sp:3:ep), cvrmse_RL(sp:3:ep,ii),'Color',colc(ii,:),'Marker','o','MarkerSize',6,'MarkerFaceColor','w','Linewidth',2); hold on;
    hold on;
    plot(lam, cvrmse_L(ii)*ones(numlam,1),'Color',colc(ii,:),'Linestyle','--','Linewidth',2);
    set(gca,'XScale','log');
    box off;
    xlim([1e-8,1]);
    xlabel('\lambda'); ylabel('Cross-validated rmse');

    saveas(gcf, sprintf('/results/Fig_2/dataset_%s_cvrmse.png', datasets{ii}));
    
end

