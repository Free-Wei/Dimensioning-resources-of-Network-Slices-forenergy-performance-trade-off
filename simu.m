load('arrival_and_energy.mat');

% figure;
% h = bar(y1,'stacked');
% %applyhatch(gcf,'\x');
% set(h,{'FaceColor'},{'#808080';'k'});
% %set(h,{'linestyle'},{':';'-.'});
% set(h,'edgecolor','none');
% set(gca,'XTickLabel',{'V_1','V_2','V_3','V_4','V_5'});
% set(gca,'FontSize',18);
% set(gca,'YGrid','on','XGrid','off');
% xlabel('Nodes','FontSize',18);
% ylabel('Resouce utilization','FontSize',18);
% %legend('SP 1','SP 2','Location','best');
% ylim([0:1]);
% x0=10;
% y0=10;
% width=270;
% height=260;
% set(gcf,'position',[x0,y0,width,height]);
% 
% figure;
% h = bar(y2,'stacked');
% 
% set(h,{'FaceColor'},{'#808080';'k'});
% %set(h,{'linestyle'},{':';'-.'});
% set(gca,'XTickLabel',{});
% set(h,'edgecolor','none');
% set(gca,'FontSize',18);
% set(gca,'YGrid','on','XGrid','off');
% xlabel('Links','FontSize',18);
% ylabel('r_{u,u''}[Mb/s]','FontSize',18);
% %legend('SP s1','SP s2','Location','best');
% x0=10;
% y0=10;
% width=250;
% height=160;
% set(gcf,'position',[x0,y0,width,height]);



% dl1_set = [0.005,0.01,0.02,0.05,0.1,0.2,0.5,1];
% figure;
% plot(dl1_set,energy,'-k',dl1_set,energy1,'--k',dl1_set,energy2,'-.k','LineWidth',1.5);
% xlabel('D^{1} [Seconds]');
% ylabel('Power consumption [Watts]');
% ylim([0,450]);
% legend('OptRes','MinRes','PropRes','Location','best');
% x0=10;
% y0=10;
% width=250;
% height=200;
% set(gcf,'position',[x0,y0,width,height])
% %%
% fig = figure;
% left_color = [0,0,0];
% right_color = [0.5,0.5,0.5];
% set(fig,'defaultAxesColorOrder',[left_color;right_color]);
% yyaxis left;
% loglog(dl1_set,y1(:,1),'-k',dl1_set,y2(:,1),'--k',dl1_set,y3(:,1),'-.k','LineWidth',1.5);
% xlabel('D^{1}  [Seconds]');
% ylabel('End-to-End Delay for SP 1 [S]','Color','k');
% yyaxis right;
% loglog(dl1_set,y1(:,2),'-',dl1_set,y2(:,2),'--',dl1_set,y3(:,2),'-.','LineWidth',1.5);
% %ylim([-1 9]);
% %set(gca,'xtick',xti,'XTickLabel',dl1_set);
% xlabel('D^{1} [Seconds]');
% ylabel('End-to-End Delay for SP 2 [S]');
% legend('OptRes','MinRes','PropRes','Location','best');
% x0=10;
% y0=10;
% width=300;
% height=250;
% set(gcf,'position',[x0,y0,width,height]);
% % 
arrival_set = [1,5,10,20,50,60,80,100];

figure;
plot(arrival_set,energy,'-k',arrival_set,energy1,'--k',arrival_set,energy2,'-.k','LineWidth',1.5);
xlabel('\lambda_{v,in}^1 [Packets/s]');
ylabel('Power consumption [Watts]');
legend('OptRes','MinRes','PropRes','Location','best');
ylim([0,450])
x0=10;
y0=10;
width=250;
height=200;
set(gcf,'position',[x0,y0,width,height])

fig = figure;
left_color = [0,0,0];
right_color = [0.5,0.5,0.5];
set(fig,'defaultAxesColorOrder',[left_color;right_color]);
yyaxis left;
loglog(arrival_set,y1(:,1),'-k',arrival_set,y2(:,1),'--k',arrival_set,y3(:,1),'-.k','LineWidth',1.5);
%ylim([-1 9]);
%set(gca,'xtick',xti,'XTickLabel',dl1_set);
xlabel('\lambda_{v,in}^1 [Packets/s]');
ylabel('End-to-End Delay for SP 1 [S]','Color','k');
yyaxis right;
loglog(arrival_set,y1(:,2),'-',arrival_set,y2(:,2),'--',arrival_set,y3(:,2),'-.','LineWidth',1.5);
xlabel('\lambda_{v,in}^1 [Packets/s]');
ylabel('End-to-End Delay for SP 2 [S]');
legend('OptRes','MinRes','PropRes','Location','best');
x0=10;
y0=10;
width=300;
height=250;
set(gcf,'position',[x0,y0,width,height])