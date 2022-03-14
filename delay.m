function [out1,ceq] = delay(x,dl1,dl2,LambdaMicrophones)

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

beta1 = 85e3/2;
beta2 = 85e3; 

alpha1 = 3e9/2;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ;  
alpha2 = 3e9; 

c = zeros(1,30);
for i = 1:5
    c(i) = arrival_app1_inv*total_app1(i)/(x(i)*1e6/alpha1-total_app1(i)+1);
    c(i+15) = arrival_app2_inv*total_app2(i)/(x(i+15)*1e6/alpha2-total_app2(i)+1);
end
for i = 6:15
    c(i) = arrival_app1_inv*total_app1(i)/(x(i)*1e6/beta1-total_app1(i)+1);
    c(i+15) = arrival_app2_inv*total_app2(i)/(x(i+15)*1e6/beta2-total_app2(i)+1);
end
out1(1) =  sum(c(1:15)) - dl1;
out1(2) = sum(c(16:30)) - dl2;
ceq =[];
