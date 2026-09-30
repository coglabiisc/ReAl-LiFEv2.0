% zeta - LiFE vs ReAL-LiFE

load('/results/Fig_2/zeta_LiFE_vs_ReAl.mat');
cmap = b2r(0,2.5);

figure(1);
[n, ex, ey] = histcounts2(log(zeta(:,1)),log(zeta(:,2)),200);
imagesc(ex(1:end-1), ey(1:end-1), log10(n)'); hold on;
axis xy;
mmin = -7.5;
mmax = 0;
hold on;
plot([mmin, mmax],[mmin, mmax],'k');
box off;
colormap(cmap);
axis equal;
axis square;
xlim([mmin,mmax]);
ylim([mmin,mmax]);
caxis([0,2.5]);
colorbar;
xlabel('log(\zeta_{LiFE})');
ylabel('log(\zeta_{ReAl-LiFE})');
saveas(gcf,'/results/Fig_2/zeta_LiFE_vs_ReAlLiFE.png');

% zeta - LiFE vs ReAL-LiFE

load('/results/Fig_2/zeta_SIFT_vs_ReAl.mat');

figure(2);
[n, ex, ey] = histcounts2(log(zeta(:,1)),log(zeta(:,2)),[90,150]);
imagesc(ex(1:end-1), ey(1:end-1), log10(n)'); hold on;
axis xy;
mmin = -10;
mmax = 0;
hold on;
plot([mmin, mmax],[mmin, mmax],'k');
box off;
colormap(cmap);
axis equal;
axis square;
xlim([mmin,mmax]);
ylim([mmin,mmax]);
caxis([0,2.5]);
colorbar;
xlabel('log(\zeta_{SIFT})');
ylabel('log(\zeta_{ReAl-LiFE})');
saveas(gcf,'/results/Fig_2/zeta_SIFT_vs_ReAlLiFE.png');