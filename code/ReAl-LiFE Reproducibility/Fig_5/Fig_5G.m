mkdir('/results/Fig_5/');

load('/data/Fig_5/fraction_features.mat');

figure(1);
set(gcf,'Position',[0,0,1920,500])
bar(1:13,fraccog,'EdgeColor',[0,0.1373,0.4],'FaceColor','w','Linewidth',1.5);
hold on;
bar(15:37, fracemo,'EdgeColor',[0.6784,0.0275,0.4471],'FaceColor','w','Linewidth',1.5);
bar(39:62, fracpers,'EdgeColor',[0.1333,0.5451,0.1333],'FaceColor','w','Linewidth',1.5);
hold on;
plot([0,63],[0.5,0.5],'k--','Linewidth',1.5);
box off;
set(gca,'XTick',[1:13,15:37,39:62],'XTicklabel',scorenamessort);
xticklabel_rotate([],45);
ylim([0.4,0.9]);

saveas(gcf, sprintf('/results/Fig_5/fraction_features.png'));