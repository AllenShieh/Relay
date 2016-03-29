close all
clear all
clc

trial = 10;
t = [1,2,3,4,5,6,7,8,9,10];
time_tensor = [];
quality_tensor = [];
time_local = [];
quality_local = [];

%Test(15,15,15);
for i=1:trial
    Test(30,30,30);
    [time_tensor(i),quality_tensor(i)] = tensor_update();
    [time_local(i),quality_local(i)] = local_update();
end

% ylim([0,100]);
% plot(t,time_tensor,'r');
% hold on;
% plot(t,time_local,'b');
% legend('a','b');

ylim([0,1]);
plot(t,quality_tensor,'r');
hold on;
plot(t,quality_local,'b');
legend('a','b');
%fprintf('%f %f\n%f %f\n',time1,quality1,time2,quality2);