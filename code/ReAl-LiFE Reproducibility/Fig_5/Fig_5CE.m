mkdir('/results/Fig_5/');

load('/data/Fig_5/groupwise_significance.mat');
cats = {'Cognition','Personality','Emotion'};

for ii = 1:3
    
    figure(ii);
    plot(al,numsig_unpruned{ii},'r.-','MarkerSize',20);
    hold on;
    plot(al,numsig_reallife{ii},'Marker','.','Color',[0.4940 0.1840 0.5560],'MarkerSize',20);
    set(gca,'XScale','log');
    box off;
    xlabel('p-value threshold');
    ylabel('# scores');
    title(sprintf('%s',cats{ii}));
    saveas(gcf, sprintf('/results/Fig_5/numsig_%s.png',cats{ii}));
    
    figure(ii+100);
    plot(al,ravg_unpruned{ii},'r.-','MarkerSize',20);
    hold on;
    plot(al,ravg_reallife{ii},'Marker','.','Color',[0.4940 0.1840 0.5560],'MarkerSize',20);
    set(gca,'XScale','log');
    box off;
    xlabel('p-value threshold');
    ylabel('r_{avg}');
    title(sprintf('%s',cats{ii}));
    saveas(gcf, sprintf('/results/Fig_5/rvals_%s.png',cats{ii}));
    
end