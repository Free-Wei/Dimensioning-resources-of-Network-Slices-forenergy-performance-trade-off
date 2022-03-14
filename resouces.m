%resource allocation for each SP with different arrival rate or deadline
clear
close all
LambdaMicrophones = 100;
%computational resources
y1 = zeros(5,2);
%bandwidth resources
y2 = zeros(10,2);
%deadline for sp1
dl1 = 0.02;
%deadline for sp2
dl2 = 0.1;

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
%BW capacity of communication resources per link:
 
RV = 1.2852e12;   %unit: IPS(instructions per second)
BW = 1e10; % unit: 10Gb/s

%beta: communication complexity : bit/packet
beta1 = 85e3/2;
beta2 = 85e3; 

%alpha: computational complexity- instrcution/packet
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

%% initialise x0
for i = 1:5
    x0(i) = (alpha1*total_app1(i)+1)/1e6;
    x0(i+15) = (alpha2*total_app2(i)+1)/1e6;
end
for i = 6:15
    x0(i) = (beta1*total_app1(i)+1)/1e6;
    x0(i+15) = (beta2*total_app2(i)+1)/1e6;
end

%parameter for computing power consumption
w1 = 42.29*1e6/RV;
eps = 1e-4;
w2 = 19.055;
% objective function
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
% resource utilization
for i = 1:5
    y1(i,1) = x(i)/Coeff(i);
    y1(i,2) = x(i+15)/Coeff(i);
end
% allocated bandwidth
for i = 1:10
    y2(i,1) = x(i+5);
    y2(i,2) = x(i+20);
end

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

