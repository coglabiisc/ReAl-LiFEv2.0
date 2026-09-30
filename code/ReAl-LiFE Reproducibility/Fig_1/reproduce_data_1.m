% this code contains steps to run CPU-LiFE, GPU-LiFE and compute speedups
% for all connectome sizes (N_f) for datasets H, I and S.
% This code runs GPU-LiFE and CPU-LiFE once. Numbers reported in the paper
% correspond to an average across 10 runs of GPU-LiFE.

% Add ReAl-LiFE to path
% Add ReAl-LiFE Scripts/Fig_1 to path
% Navigate to the folder containing data of interest in the demo data
% folder
% Execute the following

addpath(genpath('.'));
addpath(genpath('/data/Fig_1/raw_data'));
mkdir('/results/Fig_1/')

Niter = 500;
gpudev = 1;
numfib = [50000, 100000, 200000, 250000, 500000, 1000000, 1500000, 2000000];
datasets = {'H','I','S'};

for d = 1:size(datasets,2)
    
    for ii = 1:length(numfib)
        
        lambda = 0;
        alpha = 0;
        
        % run CPU-LiFE
        
        use_gpu = 0; % no use of GPU
        
        tck_file = sprintf('/data/Fig_1/raw_data/dataset_%s/WB_%d.tck',datasets{d},numfib(ii));
        [fe,out] = real_life_fig1(use_gpu, tck_file, Niter, lambda, alpha, gpudev,datasets{d});
        cpu_time(ii,d) = out.iterTime;
        
        % run GPU-LiFE
        
        use_gpu = 1;
        
        tck_file = sprintf('/data/Fig_1/raw_data/dataset_%s/WB_%d.tck',datasets{d},numfib(ii));
        [fe,out] = real_life_fig1(use_gpu, tck_file, Niter, lambda, alpha, gpudev,datasets{d});
        gpu_time(ii,d) = out.iterTime;
        gpu_overhead(ii,d) = out.ppTime;
        gpu_tot(ii,d) = out.time;
    end
    
end
col(1,:) = [0 0 0]/255;
col(2,:) = [255,159,0]/255;
col(3,:) = [0,0,255]/255;

figure(1);
h1 = plot(numfib, cpu_time(:,1), 'Color',col(1,:), 'Marker','.','MarkerFaceColor','w','Markersize',30, 'linewidth',2); hold on;
h2 = plot(numfib, cpu_time(:,2), 'Color',col(2,:), 'Marker','.','MarkerFaceColor','w','Markersize',30, 'linewidth',2); hold on;
h3 = plot(numfib, cpu_time(:,3), 'Color',col(3,:), 'Marker','.','MarkerFaceColor','w','Markersize',30, 'linewidth',2); hold on;
set(gca, 'YScale','log');
box off;
xlim([0, 2000000]);
set(gca,'XTick', [0, 500000, 1000000, 1500000, 2000000], 'XTickLabel',{'0','0.5','1','1.5', '2'});
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Northwest');
xlabel('N_{f} (millions)');
ylabel('Time (hours)');
clear h1 h2 h3;
saveas(gcf,'/results/Fig_1/CPU_time.png');

figure(2);
h1 = plot(numfib, gpu_time(:,1), 'Color',col(1,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
h2 = plot(numfib, gpu_time(:,2), 'Color',col(2,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
h3 = plot(numfib, gpu_time(:,3), 'Color',col(3,:), 'Marker','o','MarkerFaceColor','w','Markersize',10, 'linewidth',2); hold on;
set(gca, 'YScale','log');
box off;
xlim([0, 2000000]);
set(gca,'XTick', [0, 500000, 1000000, 1500000, 2000000], 'XTickLabel',{'0','0.5','1','1.5', '2'});
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Northwest');
xlabel('N_{f} (millions)');
ylabel('Time (hours)');
clear h1 h2 h3;
saveas(gcf,'/results/Fig_1/GPU_time.png');

% plot speedups
speedup = cpu_time./gpu_tot;

u = linspace(min(numfib), max(numfib), 1000);
v = interp1(numfib,speedup(:,1), u);
f0 = fittype('a + b*log(x)');
fit0 = fit(u', v', f0);
vv = fit0.a + fit0.b*log(u);

figure(3);
h1 = plot(numfib, speedup(:,1), 'MarkerEdgeColor',col(1,:),'Marker','.','MarkerSize',30,'LineStyle','none');
hold on;
plot(u, vv, 'linewidth', 2, 'Color', col(1,:));

u = linspace(min(numfib), max(numfib), 1000);
v = interp1(numfib,speedup(:,1), u);
f0 = fittype('a + b*log(x)');
fit0 = fit(u', v', f0);
vv = fit0.a + fit0.b*log(u);

figure(3);
h2 = plot(numfib, speedup(:,2), 'MarkerEdgeColor',col(2,:),'Marker','.','MarkerSize',30,'LineStyle','none');
hold on;
plot(u, vv, 'linewidth', 2, 'Color', col(2,:));

u = linspace(min(numfib), max(numfib), 1000);
v = interp1(numfib,speedup(:,3), u);
f0 = fittype('a + b*log(x)');
fit0 = fit(u', v', f0);
vv = fit0.a + fit0.b*log(u);

figure(3);
h3 = plot(numfib, speedup(:,3), 'MarkerEdgeColor',col(3,:),'Marker','.','MarkerSize',30,'LineStyle','none');
hold on;
plot(u, vv, 'linewidth', 2, 'Color', col(3,:));


box off;
xlabel('N_{f} (millions)');
ylabel('Speedup');
ylim([0,200]);
set(gca,'XTick',[0,500000,1000000,1500000,2000000],'XTickLabel',{'0','0.5','1','1.5','2'});
box off;

set(gca,'XScale','log');
legend([h2 h1 h3],{'H','I','S'},'FontSize',10,'Location','Southeast');
saveas(gcf,'/results/Fig_1/speedups.png');
