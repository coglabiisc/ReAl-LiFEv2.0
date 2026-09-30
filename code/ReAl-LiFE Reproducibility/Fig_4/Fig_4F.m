mkdir('/results/Fig_4/');
load('/data/Fig_4/histogram_distance.mat');

h = [hrl,hsift];
m = mean([hrl,hsift],2);

% normalizing histogram distance for each bundle by the max of the two

hrl = hrl./m; 
hsift = hsift./m;

numbund = length(hrl);
mhd = mean([hrl,hsift]);
stderr = std([hrl,hsift])/sqrt(numbund);

figure(1);
bar(1,mhd(1),'FaceColor',[0.4940 0.1840 0.5560],'EdgeColor','none'); hold on;
bar(2,mhd(2),'FaceColor',[0.9290 0.6940 0.1250],'EdgeColor','none');

errorbar(1,mhd(1),stderr(1),'k','Linestyle','none');
errorbar(2,mhd(2),stderr(2),'k','Linestyle','none');
xlim([0,3]);
ylim([0,1.4]);

for ii = 1:numbund
    
    plot([1,2],[hrl(ii),hsift(ii)],'o','MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','k');
    plot([1,2],[hrl(ii),hsift(ii)],'Color',[0.5,0.5,0.5]);
end

box off;
set(gca,'XTick',1:2,'XTickLabel',{'ReAl-LiFE','SIFT'});
ylabel('Histogram distance (norm)');
saveas(gcf, sprintf('/results/Fig_4/histogram_distance.png'));
