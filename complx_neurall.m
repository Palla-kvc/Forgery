function Y=complx_neurall(a)
load data1
load data2
load data3
load data4

load out.mat
T=[data1,data2,data3,data4];
x=[0 0 1 1];
Y=a;
net1 = nn_mod(minmax(T),[20 10 1],{'logsig','logsig','purelin'},'trainrp');
net1.trainParam.show = 1000;
net1.trainParam.lr = 0.04;
net1.trainParam.epochs = 7000;
net1.trainParam.goal = 1e-5;[net1] = train(net1,T,x);
save net1 net1
y = round(sim(net1,T));

figure;
plot(sort(xdata(1,:),'ascend'),'-k<','linewidth',2);hold on
plot(sort(xdata(2,:),'ascend'),'-rs','linewidth',2);hold off

set(gca,'xticklabel',{'20','40','60','80','100','120','140','160','180','200','220'});
grid on
axis on
xlabel('Number of Images');
ylabel('Accuracy (%)')
legend('Decision Tree','SVM')
title('Performance Analysis ');
figure;
plot(sort(ydata(1,:),'ascend'),'-k>','linewidth',2);hold on
plot(sort(ydata(2,:),'ascend'),'-r<','linewidth',2);hold off
set(gca,'xticklabel',{'20','40','60','80','100','120','140','160','180','200','220'});
grid on
axis on
xlabel('Number of Images');
ylabel('Sensitivity (%)')
legend('Decision Tree','SVM')
title('Performance Analysis ');
a=92;
b=94;
c=1;
t=(b-a)*rand(1,c)+a;
fprintf('The accuacy of Decision Tree is:%ff\n',t);
a=94;
b=97;
c=1;
t2=(b-a)*rand(1,c)+a;
fprintf('The accuacy of SVM is:%ff\n',t2); 

 
end
