col(1,:) = [0 0 0]/255;
col(2,:) = [255,159,0]/255;
col(3,:) = [0,0,255]/255;

load('runtimes_Ntheta.mat');

% plot CPU runtimes

figure(1);
h1 = plot(Inumdir, Icpu_time, 'Color',col(1,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
h2 = plot(Hnumdir, Hcpu_time, 'Color',col(2,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
h3 = plot(Snumdir, Scpu_time, 'Color',col(3,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
set(gca, 'YScale','log');
box off;
xlim([0, 270]);
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Southeast');
xlabel('N_{\theta}');
ylabel('Time (hours)');
clear h1 h2 h3;

% plot GPU runtimes

figure(2);
errorbar(Inumdir, Igpu_time, se_Igpu_time,'Color',col(1,:),'linewidth',1,'linestyle','none');
h1 = plot(Inumdir, Igpu_time, 'Color',col(1,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
errorbar(Hnumdir, Hgpu_time, se_Hgpu_time,'Color',col(2,:),'linewidth',1,'linestyle','none');
h2 = plot(Hnumdir, Hgpu_time, 'Color',col(2,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
errorbar(Snumdir, Sgpu_time, se_Sgpu_time,'Color',col(3,:),'linewidth',1,'linestyle','none');
h3 = plot(Snumdir, Sgpu_time, 'Color',col(3,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
set(gca, 'YScale','log');
box off;
xlim([0, 270]);
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Northwest');
xlabel('N_{\theta}');
ylabel('Time (hours)');
clear h1 h2 h3;


% plot speedups

mm = min([Inumdir,Snumdir,Hnumdir]);
nn = max([Inumdir,Snumdir,Hnumdir]);
  
figure(3);
h1 = plot(Inumdir, I_speedup, 'MarkerEdgeColor',col(1,:),'Marker','.','MarkerSize',30,'LineStyle','none');
hold on;
errorbar(Inumdir, I_speedup, se_I_speedup,'Color',col(1,:),'linewidth',2,'linestyle','none');
u = linspace(mm, nn, 1000);
v = interp1(Inumdir,I_speedup, u);
vv = fit0_I.a + fit0_I.b*log(u);
int_I = fit0_I.a;
slope_I = fit0_I.b;
plot(u, vv, 'linewidth', 2, 'Color', col(1,:));

 
h2 = plot(Hnumdir, H_speedup, 'MarkerEdgeColor',col(2,:),'Marker','.','MarkerSize',30,'MarkerFaceColor','w','LineStyle','none','Linewidth',2);
hold on
errorbar(Hnumdir, H_speedup, se_H_speedup,'Color',col(2,:),'linewidth',2,'linestyle','none');
u = linspace(mm, nn, 1000);
v = interp1(Hnumdir,H_speedup, u);
vv = fit0_H.a + fit0_H.b*log(u);
int_H = fit0_H.a;
slope_H = fit0_H.b;
plot(u, vv, 'linewidth', 2, 'Color', col(2,:));
 
 
h3 = plot(Snumdir, S_speedup, 'MarkerEdgeColor',col(3,:),'Marker','.','MarkerSize',30,'MarkerFaceColor','w','LineStyle','none','Linewidth',2);
hold on;
errorbar(Snumdir, S_speedup, se_S_speedup,'Color',col(3,:),'linewidth',2,'linestyle','none');
u = linspace(mm, nn, 1000);
v = interp1(Snumdir,S_speedup, u);
vv = fit0_S.a + fit0_S.b*log(u);
int_S = fit0_S.a;
slope_S = fit0_S.b;
plot(u, vv, 'linewidth', 2, 'Color', col(3,:));
box off;
xlabel('N_{\theta}');ylabel('Speedup');
ylim([0,200]);
box off;
set(gca,'XTick',[20,32,48,64,96,192,270]);
set(gca,'XScale','log');
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Southeast');

