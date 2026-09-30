mkdir('/results/Fig_4/');

load('/data/Fig_4/Superfibers_MD.mat'); % cores of all 25 ground-truth bundles

ii = 22; % left SLF

load(sprintf('/data/Fig_4/raw_data/distribution_ReAlLiFE_split10_MD_SLF_left.mat'));
life = mean_dist_alt;
load(sprintf('/data/Fig_4/raw_data/distribution_SIFT_split10_MD_SLF_left.mat'));
sift = mean_dist_alt;
edges = linspace(min([mean_dist_null{ii},life,sift]),max([mean_dist_null{ii},life,sift]),10);
bincent = [0,(edges(1:end-1) + edges(2:end))/2,edges(end)];

N_gt = [0,histcounts(mean_dist_null{ii},edges),0];
N_alt_life = [0,histcounts(life,edges),0];
N_alt_sift = [0,histcounts(sift,edges),0];


figure(1);
plot(bincent,N_gt,'Color',[0.5,0.5,0.5],'Linestyle','--','linewidth',2);
hold on;
plot(bincent,N_alt_life,'Color',[0.4940 0.1840 0.5560],'Linestyle','-','linewidth',2)
plot(bincent,N_alt_sift,'Color',[0.9290 0.6940 0.1250],'Linestyle','-','linewidth',2)
box off;
legend('Ground-truth','ReA-LiFE','SIFT');
xlabel('d_{M}');
ylabel('# fibers');
saveas(gcf, sprintf('/results/Fig_4/distance_distribution.png'));
