col(1,:) = [0 0 0]/255;
col(2,:) = [255,159,0]/255;
col(3,:) = [0,0,255]/255;

load('runtimes_Nf.mat');

% plot CPU runtimes

figure(1);
h1 = plot(Infibers, Icpu_time, 'Color',col(1,:), 'Marker','.','MarkerFaceColor','w','Markersize',30, 'linewidth',2); hold on;
h2 = plot(Hnfibers, Hcpu_time, 'Color',col(2,:), 'Marker','.','MarkerFaceColor','w','Markersize',30, 'linewidth',2); hold on;
h3 = plot(Snfibers, Scpu_time, 'Color',col(3,:), 'Marker','.','MarkerFaceColor','w','Markersize',30, 'linewidth',2); hold on;
set(gca, 'YScale','log');
box off;
xlim([0, 2000000]);
set(gca,'XTick', [0, 500000, 1000000, 1500000, 2000000], 'XTickLabel',{'0','0.5','1','1.5', '2'});
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Northwest');
xlabel('N_{f} (millions)');
ylabel('Time (hours)');
clear h1 h2 h3;

% plot GPU runtimes

figure(2);
errorbar(Infibers, Igpu_time, se_Igpu_time,'Color',col(1,:),'linewidth',1,'linestyle','none');
h1 = plot(Infibers, Igpu_time, 'Color',col(1,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
errorbar(Hnfibers, Hgpu_time, se_Hgpu_time,'Color',col(2,:),'linewidth',1,'linestyle','none');
h2 = plot(Hnfibers, Hgpu_time, 'Color',col(2,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
errorbar(Snfibers, Sgpu_time, se_Sgpu_time,'Color',col(3,:),'linewidth',1,'linestyle','none');
h3 = plot(Snfibers, Sgpu_time, 'Color',col(3,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
set(gca, 'YScale','log');
box off;
xlim([0, 2000000]);
set(gca,'XTick', [0, 500000, 1000000, 1500000, 2000000], 'XTickLabel',{'0','0.5','1','1.5', '2'});
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Northwest');
xlabel('N_{f} (millions)');
ylabel('Time (hours)');
clear h1 h2 h3;


% plot speedups

mm = 50000;
nn = 2000000;
  
figure(3);
h1 = plot(Infibers, I_speedup, 'MarkerEdgeColor',col(1,:),'Marker','.','MarkerSize',30,'LineStyle','none');
hold on;
errorbar(Infibers, I_speedup, se_I_speedup,'Color',col(1,:),'linewidth',2,'linestyle','none');
u = linspace(mm, nn, 1000);
v = interp1(Infibers,I_speedup, u);
vv = fit0_I.a + fit0_I.b*log(u);
int_I = fit0_I.a;
slope_I = fit0_I.b;
plot(u, vv, 'linewidth', 2, 'Color', col(1,:));

 
h2 = plot(Hnfibers, H_speedup, 'MarkerEdgeColor',col(2,:),'Marker','.','MarkerSize',30,'MarkerFaceColor','w','LineStyle','none','Linewidth',2);
hold on
errorbar(Hnfibers, H_speedup, se_H_speedup,'Color',col(2,:),'linewidth',2,'linestyle','none');
u = linspace(mm, nn, 1000);
v = interp1(Hnfibers,H_speedup, u);
vv = fit0_H.a + fit0_H.b*log(u);
int_H = fit0_H.a;
slope_H = fit0_H.b;
plot(u, vv, 'linewidth', 2, 'Color', col(2,:));
 
 
h3 = plot(Snfibers, S_speedup, 'MarkerEdgeColor',col(3,:),'Marker','.','MarkerSize',30,'MarkerFaceColor','w','LineStyle','none','Linewidth',2);
hold on;
errorbar(Snfibers, S_speedup, se_S_speedup,'Color',col(3,:),'linewidth',2,'linestyle','none');
u = linspace(mm, nn, 1000);
v = interp1(Snfibers,S_speedup, u);
vv = fit0_S.a + fit0_S.b*log(u);
int_S = fit0_S.a;
slope_S = fit0_S.b;
plot(u, vv, 'linewidth', 2, 'Color', col(3,:));
 
box off;
xlabel('N_{f} (millions)');
ylabel('Speedup');
ylim([0,200]);
set(gca,'XTick',[0,500000,1000000,1500000,2000000],'XTickLabel',{'0','0.5','1','1.5','2'});
box off;

set(gca,'XScale','log');
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Southeast');

