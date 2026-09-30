mkdir('/results/Fig_5/');

load('/data/Fig_5/overall_significance.mat');

figure(1);
plot(al,numsig_unpruned,'r.-','MarkerSize',20);
hold on;
plot(al,numsig_reallife,'Marker','.','Color',[0.4940 0.1840 0.5560],'MarkerSize',20);
set(gca,'XScale','log');
box off;
xlabel('p-value threshold');
ylabel('# scores');
legend('Unpruned','ReAl-LiFE');
saveas(gcf,'/results/numsig_overall.png');

figure(101);
plot(al,ravg_unpruned,'r.-','MarkerSize',20);
hold on;
plot(al,ravg_reallife,'Marker','.','Color',[0.4940 0.1840 0.5560],'MarkerSize',20);
set(gca,'XScale','log');
box off;
xlabel('p-value threshold');
ylabel('r_{avg}');
legend('Unpruned','ReAl-LiFE');
saveas(gcf,'/results/rvals_overall.png');
