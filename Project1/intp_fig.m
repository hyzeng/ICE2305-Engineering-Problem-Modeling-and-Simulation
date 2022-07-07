clear;
ans_makima=[4    25    50    68    87];%把选点组合填写在此
ans_spline=[5  25  36  72  88];%把选点组合填写在此
ans_pchip = [4    21    48    64    90];%把选点组合填写在此
% 标准样本原始数据读入
minput=dlmread('dataform_train.csv');
[M,N]=size(minput);
Nsample=M/2; Npoint=N;
volt=zeros(Nsample,Npoint);
tempr=zeros(Nsample,Npoint);
est_tempr1=zeros(Nsample,Npoint);
est_tempr2=zeros(Nsample,Npoint);
est_tempr3=zeros(Nsample,Npoint);
for i=1:Nsample
    volt(i,:)=minput(2*i,:);
    tempr(i,:)=minput(2*i-1,:);
end

% 定标计算
for sample=1:Nsample
    premea_volt=volt(sample,ans_makima);
    premea_tempr=tempr(sample,ans_makima);
    est_tempr1(sample,:)=my_interpolation(premea_volt,premea_tempr,volt(sample,:),0);
end

for sample=1:Nsample
    premea_volt=volt(sample,ans_spline);
    premea_tempr=tempr(sample,ans_spline);
    est_tempr2(sample,:)=my_interpolation(premea_volt,premea_tempr,volt(sample,:),1);
end

for sample=1:Nsample
    premea_volt=volt(sample,ans_pchip);
    premea_tempr=tempr(sample,ans_pchip);
    est_tempr3(sample,:)=my_interpolation(premea_volt,premea_tempr,volt(sample,:),2);
end

d = 3;
k = 4;
plot(volt(k,1:d:90),tempr(k,1:d:90),'*',volt(k,:),est_tempr1(k,:),'-',volt(k,:),est_tempr2(k,:),'-',volt(k,:),est_tempr3(k,:));
hold on;
k = 100;
plot(volt(k,1:d:90),tempr(k,1:d:90),'*',volt(k,:),est_tempr1(k,:),'-',volt(k,:),est_tempr2(k,:),'-',volt(k,:),est_tempr3(k,:));
hold on;
k = 203;
plot(volt(k,1:d:90),tempr(k,1:d:90),'*',volt(k,:),est_tempr1(k,:),'-',volt(k,:),est_tempr2(k,:),'-',volt(k,:),est_tempr3(k,:));
legend('样本4','makima','spline','pchip','样本100','makima','spline','pchip','样本203','makima','spline','pchip');
xlabel('电压/mV');
ylabel('温度/℃');