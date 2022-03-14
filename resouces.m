clear
close all
LambdaMicrophones = 100;
y1 = zeros(5,2);
y2 = zeros(10,2);
dl1 = 0.02;
dl2 = 0.1;
%arrival_app1 = random('Poisson', LambdaMicrophones,1,5);
%arrival_app2 = random('Poisson', LambdaMicrophones,1,5);
arrival_app1 = ones(1,5)*LambdaMicrophones;
arrival_app2 = ones(1,5)*20;

arrival_app1_inv = 1/sum(arrival_app1);
arrival_app2_inv = 1/sum(arrival_app2);

app1_path = [1 0 1 0 1 0 1 0 0 0 0 1 0 0 0;
             0 1 1 0 1 0 1 1 0 0 0 1 0 0 0;
             1 0 1 0 1 0 1 0 0 1 0 1 0 0 0;
             1 0 1 0 1 0 1 0 0 1 0 1 1 0 0;
             0 1 1 0 1 0 0 0 1 0 0 1 0 1 1];
app2_path = [1 0 0 1 1 0 1 0 0 0 1 1 0 0 1;
             1 0 0 1 1 0 1 1 0 0 1 1 0 0 1;
             1 0 0 1 1 0 1 0 0 1 1 1 0 0 1;
             1 0 0 1 1 0 1 0 0 1 1 1 1 0 1;
             1 0 0 1 1 0 1 1 0 0 1 1 0 1 1];

total_app1 = arrival_app1*app1_path;
total_app2 = arrival_app2*app2_path;



%RV capacity of computational resources per node:
%30 units of resources, one unit can handle 5kb kpps. so total is 1e8 kb.
%each bit needs 1000 operationss

RV = 1.2852e12;   %unit: operations 1000 operations/bit * 30 units * 20000 packets/s * 5000 bit/packets = 3e12 operations/s
BW = 1e10; % unit: 10Gb/s

%beta: communication complexity :
beta1 = 85e3/2;
beta2 = 85e3; 

%alpha: computational complexity- operations/packets   5000 bit/packets * 1000 operations/bit
alpha1 = 3e9/2;  
alpha2 = 3e9; 


Coeff = [RV*ones(1,5)/1e6 BW*ones(1,10)/1e6];
x_range = [];
for i = 1:5
    x_range_min(i) = (alpha1*total_app1(i)+1)/1e6;
    x_range_min(i+15) = (alpha2*total_app2(i)+1)/1e6;
end
for i = 6:15
    x_range_min(i) = (beta1*total_app1(i)+1)/1e6;
    x_range_min(i+15) = (beta2*total_app2(i)+1)/1e6;
end
x_range_max = [Coeff Coeff];
%% constarints like x1 + x16 <= RV
B = diag(ones(1,15));
A = [B B];
b = Coeff';
%% initialise x0\
%n = ones(1,15)*5e6;
%w1 = 0.999999;
%w2 = 0.999999;
% for i = 1:5
%     x0(i) = (alpha1*total_app1(i) + sqrt(alpha1*n(i)*w1*(total_app1(i)/arrival_app1_inv)/(1-w1)))/1e8 +1e-6;
%     x0(i+15) = (alpha2*total_app2(i) + sqrt(alpha2*n(i)*w2*(total_app2(i)/arrival_app2_inv)/(1-w2)))/1e8 +1e-6;
% end
% for i = 6:15
%     x0(i) = (beta1*total_app1(i) + sqrt(beta1*n(i)*w1*(total_app1(i)/arrival_app1_inv)/(1-w1)))/1e8 +1e-6;
%     x0(i+15) = (beta2*total_app2(i) + sqrt(beta2*n(i)*w2*(total_app2(i)/arrival_app2_inv)/(1-w2)))/1e8 +1e-6;
% end
% 
for i = 1:5
    x0(i) = (alpha1*total_app1(i)+1)/1e6;
    x0(i+15) = (alpha2*total_app2(i)+1)/1e6;
end
for i = 6:15
    x0(i) = (beta1*total_app1(i)+1)/1e6;
    x0(i+15) = (beta2*total_app2(i)+1)/1e6;
end
%x0 = (x_range_max+x_range_min)./2;
%%normolize when given r = 1e11, time = 1s = 1000ms, so to get the same
%%order, time needed * 1e8.   given bw = 1e9, time = 10ms, time needed
%%*1e8
w1 = 42.29*1e6/RV;
eps = 1e-4;
w2 = 19.055;

ObjFunc = @(x)w1*(x(1)+x(2)+x(3)+x(4)+x(5)+x(16)+x(17)+x(18)+x(19)+x(20))+(4.5+(14.555/550)*(x(6)+x(21))).*((x(6)+x(21))>=0&(x(6)+x(21))<550)+(w2+eps*((x(6)+x(21))-550)).*((x(6)+x(21))>=550)+...
    (4.5+(14.555/550)*(x(7)+x(22))).*((x(7)+x(22))>=0&(x(7)+x(22))<550)+(w2+eps*((x(7)+x(22))-550)).*((x(7)+x(22))>=550)+...
    (4.5+(14.555/550)*(x(8)+x(23))).*((x(8)+x(23))>=0&(x(8)+x(23))<550)+(w2+eps*((x(8)+x(23))-550)).*((x(8)+x(23))>=550)+...
    (4.5+(14.555/550)*(x(9)+x(24))).*((x(9)+x(24))>=0&(x(9)+x(24))<550)+(w2+eps*((x(9)+x(24))-550)).*((x(9)+x(24))>=550)+...
    (4.5+(14.555/550)*(x(10)+x(25))).*((x(10)+x(25))>=0&(x(10)+x(25))<550)+(w2+eps*((x(10)+x(25))-550)).*((x(10)+x(25))>=550)+...
    (4.5+(14.555/550)*(x(11)+x(26))).*((x(11)+x(26))>=0&(x(11)+x(26))<550)+(w2+eps*((x(11)+x(26))-550)).*((x(11)+x(26))>=550)+...
    (4.5+(14.555/550)*(x(12)+x(27))).*((x(12)+x(27))>=0&(x(12)+x(27))<550)+(w2+eps*((x(12)+x(27))-550)).*((x(12)+x(27))>=550)+...
    (4.5+(14.555/550)*(x(13)+x(28))).*((x(13)+x(28))>=0&(x(13)+x(28))<550)+(w2+eps*((x(13)+x(28))-550)).*((x(13)+x(28))>=550)+...
    (4.5+(14.555/550)*(x(14)+x(29))).*((x(14)+x(29))>=0&(x(14)+x(29))<550)+(w2+eps*((x(14)+x(29))-550)).*((x(14)+x(29))>=550)+...
    (4.5+(14.555/550)*(x(15)+x(30))).*((x(15)+x(30))>=0&(x(15)+x(30))<550)+(w2+eps*((x(15)+x(30))-550)).*((x(15)+x(30))>=550);
fun2 = @(x)delay(x,dl1,dl2,LambdaMicrophones);


opts = optimoptions('fmincon','Algorithm','sqp','ConstraintTolerance',1e-9);
opts = optimoptions(opts,'MaxFunctionEvaluations',9e6,'MaxIterations',10000, 'StepTolerance',1e-12,'PlotFcn',{@optimplotx,@optimplotfval,@optimplotfirstorderopt}); % Recommended

[x,fval] = fmincon(ObjFunc,x0,A,b,[],[],x_range_min,x_range_max, fun2, opts);
[res,] = delay(x,dl1,dl2,LambdaMicrophones);
% %for propotional strategy:
% for i = 1:5
%     x1(i) = (alpha1/(alpha1+alpha2))*RV/1e6;
%     x1(i+15) = (alpha2/(alpha1+alpha2))*RV/1e6;
% end
% for i = 6:15
%     x1(i) = (beta1/(beta1+beta2))*BW/1e6;
%     x1(i+15) = (beta2/(beta1+beta2))*BW/1e6;
% end

for i = 1:5
    y1(i,1) = x(i)/Coeff(i);
    y1(i,2) = x(i+15)/Coeff(i);
end
for i = 1:10
    y2(i,1) = x(i+5);
    y2(i,2) = x(i+20);
end
%%
% figure
% h = plotBarStackGroups(y1, {'V1','V2','V3','V4','V5','V1-V2','V1-V3','V2-V1','V2-V5','V3-V1','V3-V4','V3-V5','V4-V3','V5-V2','V5-V3'});
% set(gca,'DataAspectRatio',[1 1 1])
% nGroups = numel(h(1,1).YData);
% % Define labels for groups of 3 bars
% labels = {'0.005s','0.01s','0.1s','1s'};
% % Compute the height of each bar stack and add label to top
% offset = range(ylim)*1e-3; 
% for i = 1:size(h,1)
%     ysum = sum(reshape([h(i,:).YData],nGroups,[]),2);
%     text(h(i,1).XData,ysum+offset,labels{i},'HorizontalAlignment','left',...
%         'VerticalAlignment','middle','rotation',90)
% end


figure;
h = bar(y1,'stacked');
%applyhatch(gcf,'\x');
set(h,{'FaceColor'},{'#808080';'k'});
set(h,{'linestyle'},{':';'-.'});
set(gca,'XTickLabel',{'V1','V2','V3','V4','V5'});
xlabel('Nodes and links');
ylabel('Node utilization');
%legend('SP s1','SP s2','Location','best');
ylim([0:1]);
x0=10;
y0=10;
width=250;
height=160;
set(gcf,'position',[x0,y0,width,height]);

figure;
h = bar(y2,'stacked');
%applyhatch(gcf,'\x');
set(h,{'FaceColor'},{'#808080';'k'});
set(h,{'linestyle'},{':';'-.'});
set(gca,'XTickLabel',{'V1-V2','V1-V3','V2-V1','V2-V5','V3-V1','V3-V4','V3-V5','V4-V3','V5-V2','V5-V3'});
xlabel('Nodes and links');
ylabel('Allocated Bandwidth(Mb/s)');
%legend('SP s1','SP s2','Location','best');
x0=10;
y0=10;
width=250;
height=200;
set(gcf,'position',[x0,y0,width,height]);



save(['arrival1_1_',num2str(LambdaMicrophones),'.mat'],'y1','y2');

% bar3_stacked(result_set)
% xti = [1:1:8];
% yti = [1:1:15];
% xlabel('Deadline of application 1(per second)');
% ylabel('Nodes and Links');
% zlabel('resources utilization');
% legend('application 1', 'application 2','Location','best');
% set(gca,'xtick',xti,'XTickLabel', fliplr(dl1_set),'ytick',yti,'yticklabel',{'V1','V2','V3','V4','V5','V1-V2','V1-V3','V2-V1','V2-V5','V3-V1','V3-V4','V3-V5','V4-V3','V5-V2','V5-V3'})
% 
% figure;
% plot(fval_res);
% set(gca,'xtick',xti,'XTickLabel',dl1_set);
% xlabel('Deadline of application 1(per second)');
% ylabel('Total energy consumption(Watts)');