close all
clear all
clc

trial = 5;
t = [1,2,3,4,5];
%s = [15,20,25,30,35,40,45,50,55,60];
time_tensor = [0,0,0,0,0];
quality_tensor = [0,0,0,0,0];
time_local = [0,0,0,0,0];
quality_local = [0,0,0,0,0];
time_offline = [0,0,0,0,0];
quality_offline = [0,0,0,0,0];
E_tensor = [0,0,0,0,0];
E_local = [0,0,0,0,0];
E_offline = [0,0,0,0,0];

for k=1:6

%Test(20,20,20);
for j=1:trial
    %Test(10+5*i,10+5*i,10+5*i);
    E_tensor(j) = 0;
    E_local(j) = 0;
    E_offline(j) = 0;
    for i=1:trial
        Test(20+5*(k-1),20+5*(k-1),20+5*(k-1));
        real_max = find_real_max();
        [time_tensor(i),quality_tensor(i)] = tensor_update();
        [time_local(i),quality_local(i)] = local_update();
        [time_offline(i),quality_offline(i)] = offline();
        E_tensor(j) = E_tensor(j)+(real_max-quality_tensor(i))^2;
        E_local(j) = E_local(j)+(real_max-quality_local(i))^2;
        E_offline(j) = E_offline(j)+(real_max-quality_offline(i))^2;
    end
end

% quality
c=gray(4);
figure(k);
hold on;
set (gcf,'Position',[100,100,450,300])
plot(t,E_offline,'Color',c(3,:),'LineStyle','-.','LineWidth',3,'Marker','s','MarkerSize',10);
plot(t,E_local,'Color',c(2,:),'LineStyle','--','LineWidth',3,'Marker','x','MarkerSize',12);
plot(t,E_tensor,'Color',c(1,:),'LineWidth',3,'Marker','o','MarkerSize',10);
ylabel('Link Quality (Normalized)','FontName','Arial','fontsize',14);
xlabel('Trial No.','FontName','Arial','fontsize',14);
legend('TR','KNN','POTU',1);
%set(gca,'FontName','Arial','fontsize',12,'position',[0.15 0.15 0.8 0.8],'YTick',[0 0.03 0.06 0.09 0.12],'XTick',[1 1.5 2 2.5 3]);
%xlim([1 10]);
%ylim([0 1]);
box on;
grid on;
hold off;

end
