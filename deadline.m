%With different time constraints of SP 1
clear
close all
dl1_set = [0.005,0.01,0.02,0.05,0.1,0.2,0.5,1];

energy = zeros(size(dl1_set,2),1);
energy1 = zeros(size(dl1_set,2),1);
energy2 = zeros(size(dl1_set,2),1);

%delay for each strategy:
y1 = zeros(size(dl1_set,2),2);
y2 = zeros(size(dl1_set,2),2);
y3 = zeros(size(dl1_set,2),2);
dl2 = 1;


for iter = 1:size(dl1_set,2)
    dl1 = dl1_set(iter);
%arrival rate:
LambdaMicrophones = 20;

arrival_app1 = ones(1,5)*LambdaMicrophones;
arrival_app2 = ones(1,5)*LambdaMicrophones;

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

%beta: communication complexity : Bit/packets
beta1 = 85e3/2;
beta2 = 85e3; 

%alpha: computational complexity: instructions/packets  
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

%Objective function
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

opts = optimoptions('fmincon','Algorithm','sqp','ConstraintTolerance',1e-12);
opts = optimoptions(opts,'MaxFunctionEvaluations',9e6,'MaxIterations',10000, 'StepTolerance',1e-12,'OptimalityTolerance',1e-9,'PlotFcn',{@optimplotx,@optimplotfval,@optimplotfirstorderopt}); % Recommended

[x,fval] = fmincon(ObjFunc,x0,A,b,[],[],x_range_min,x_range_max, fun2, opts);
[res,] = delay(x,dl1,dl2,LambdaMicrophones);
[res_com,] = delay(x0,dl1,dl2,LambdaMicrophones);

energy(iter) = fval;
%for propotional strategy:
for i = 1:5
    x1(i) = (alpha1/(alpha1+alpha2))*RV/1e6;
    x1(i+15) = (alpha2/(alpha1+alpha2))*RV/1e6;
end
for i = 6:15
    x1(i) = (beta1/(beta1+beta2))*BW/1e6;
    x1(i+15) = (beta2/(beta1+beta2))*BW/1e6;
end
[res_pro,] = delay(x1,dl1,dl2,LambdaMicrophones);

%End-to-End delay for each strategy
y1(iter,1) = res(1)+dl1;
y1(iter,2) = res(2)+dl2;
y2(iter,1) = res_com(1)+dl1;
y2(iter,2) = res_com(2)+dl2;
y3(iter,1) = res_pro(1)+dl1;
y3(iter,2) = res_pro(2)+dl2;


%power consumption for MinRes and PropRes
energy1(iter) = ObjFunc(x0);
energy2(iter) = ObjFunc(x1);
end



figure;
plot(dl1_set,energy,'-k',dl1_set,energy1,'--k',dl1_set,energy2,':k');
xlabel('Deadline of application 1 (per second)');
ylabel('Energy consumption (Watts)');
ylim([0,650]);
legend('OptRes','MinRes','PropRes','Location','best');
x0=10;
y0=10;
width=250;
height=200;
set(gcf,'position',[x0,y0,width,height])

figure;
loglog(dl1_set,y1(:,1),'-ok',dl1_set,y1(:,2),'-.k',dl1_set,y2(:,1),'--xk',dl1_set,y2(:,2),'--k',dl1_set,y3(:,1),':k',dl1_set,y3(:,2),':sk');
%ylim([-1 9]);
%set(gca,'xtick',xti,'XTickLabel',dl1_set);
xlabel('Deadline of application 1 (per second)');
ylabel('Delay (per second)');
legend('OptRes Application 1', 'OptRes Application 2','MinRes Application 1','MinRes Application 2','PropRes Application 1','PropRes Application 2','Location','best');
x0=10;
y0=10;
width=450;
height=300;
set(gcf,'position',[x0,y0,width,height]);

save('deadline_and_energy.mat','y1','y2','y3','energy','energy1','energy2');
