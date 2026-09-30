%% L1 vs rmse plot

dataset = {'S(ET)','I','M'};
colc = [0,0,255; 0,0,0; 255,0,0]/255;

% w_L1norm: L1 norm of weights when L1 regularization was done (column 1)
% and L2 regularization was done (column 2)
% w_L2norm: L2 norm of weights when L1 regularization was done (column 1)
% and L2 regularization was done (column 2)
% cv_rmse: cross-validated rmse when L1 regularization was done (column 1)
% and L2 regularization was done (column 2)

% Dataset SET

load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_regularizations_SET.mat'));

figure(1);
plot(w_L1norm(:,1),cv_rmse(:,1),'Marker','.','Color',colc(1,:),'MarkerSize',20); % L1 norm vs L1 reg cv rmse
hold on;
plot(w_L1norm(1:2:14,2),cv_rmse(1:2:14,2),'o-','Color',colc(1,:),'MarkerFaceColor','w'); % L1 norm vs L1 reg cv rmse
box off;
xlabel('Weights (L1 norm)');
ylabel('Cross-validated RMSE');
legend('L1 reg','L2 reg');
saveas(gcf, sprintf('/results/Fig_3/dataset_SET_L1norm.png'));

% Dataset I


load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_regularizations_I.mat'));
figure(2);
plot(w_L1norm(:,1),cv_rmse(:,1),'Marker','.','Color',colc(2,:),'MarkerSize',20); % L1 norm vs L1 reg cv rmse
hold on;
plot(w_L1norm(1:2:22,2),cv_rmse(1:2:22,2),'o-','Color',colc(2,:),'MarkerFaceColor','w'); % L1 norm vs L1 reg cv rmse
box off;
xlabel('Weights (L1 norm)');
ylabel('Cross-validated RMSE');
legend('L1 reg','L2 reg');
saveas(gcf, sprintf('/results/Fig_3/dataset_I_L1norm.png'));

% Dataset M

load(sprintf('/results/Fig_3/fe_stats_ReAl_LiFE_regularizations_M.mat'));
figure(3);
plot(w_L1norm(:,1),cv_rmse(:,1),'Marker','.','Color',colc(3,:),'MarkerSize',20); % L1 norm vs L1 reg cv rmse
hold on;
plot(w_L1norm(1:2:18,2),cv_rmse(1:2:18,2),'o-','Color',colc(3,:),'MarkerFaceColor','w'); % L1 norm vs L1 reg cv rmse
box off;
xlabel('Weights (L1 norm)');
ylabel('Cross-validated RMSE');
legend('L1 reg','L2 reg');
saveas(gcf, sprintf('/results/Fig_3/dataset_M_L1norm.png'));

