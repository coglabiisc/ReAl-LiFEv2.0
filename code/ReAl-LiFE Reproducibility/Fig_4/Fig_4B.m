mkdir('/results/Fig_4/');

fileName = '/data/Fig_4/raw_data/WB_ReAlLiFE_part10_combined.json'; % filename in JSON extension

fid = fopen(fileName);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
data = jsondecode(str);

overlap_rl = data.mean_OL*100;
overreach_rl = data.mean_OR*100;
vb_rl = data.VB;
ib_rl = data.IB;

fileName = '/data/Fig_4/raw_data/WB_SIFT_part10_combined.json'; % filename in JSON extension

fid = fopen(fileName);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
data = jsondecode(str);

overlap_sift = data.mean_OL*100;
overreach_sift = data.mean_OR*100;
vb_sift = data.VB;
ib_sift = data.IB;

load('/data/Fig_4/OL_OR_teams');
load('/data/Fig_4/IB_VB_teams.mat');

figure(1);
h1 = plot(or_teams,ol_teams,'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',6,'MarkerEdgeColor','k','linestyle','none');
hold on;
h2 = plot(overreach_rl,overlap_rl,'Marker','.','MarkerSize',30,'Color',[0.4940 0.1840 0.5560],'linestyle','none'); hold on;
h3 = plot(overreach_sift,overlap_sift,'Marker','.','MarkerSize',30,'Color',[0.9290 0.6940 0.1250],'linestyle','none'); hold on;
box off;
axis equal; axis square;
xlim([0,120]); ylim([0,120]);
xlabel('Overreach'); ylabel('Overlap');
legend([h1,h2,h3],{'Teams','ReAl-LiFE','SIFT'},'Location','SouthEast');
saveas(gcf, sprintf('/results/Fig_4/Overlap_overreach.png'));

figure(2);
h1 = plot(ib_teams,vb_teams,'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',6,'MarkerEdgeColor','k','linestyle','none');
hold on;
h2 = plot(ib_rl,vb_rl,'Marker','.','MarkerSize',30,'Color',[0.4940 0.1840 0.5560],'linestyle','none'); hold on;
h3 = plot(ib_sift,vb_sift,'Marker','.','MarkerSize',30,'Color',[0.9290 0.6940 0.1250],'linestyle','none'); hold on;
box off;
axis equal; axis square;
xlim([0,400]); ylim([0,25]);
xlabel('# invalid bundles'); ylabel('# valid bundles');
legend([h1,h2,h3],{'Teams','ReAl-LiFE','SIFT'},'Location','SouthEast');
saveas(gcf, sprintf('/results/Fig_4/Valid_invalid.png'));
