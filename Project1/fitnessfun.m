function [fitness,cost_mn] = fitnessfun(parents,voltage,temprature,G,Gmax)
%fitnessfun 计算种群适应度
% 按规则计算方案总体成本，并取其倒数作为适应度
[Nsample,Npoint] = size(voltage);  
est_tempr = zeros(Nsample,90); %温度插值误差
population = size(parents,1); %可采用的取点方案数
s = zeros(1,Npoint);  %各个点的误差成本
Q = 60;  %测定成本
cost_each = zeros(1,Nsample);  %在某种方案下各个样本的成本
cost_mn = zeros(population,1); %各个方案的成本
for i = 1:population %尝试第i个个体（第i种方案）
  if(sum(parents(i,:))<=2)
      cost_mn(i) = 2000;
      continue;
  end
  for j=1:Nsample %对第j组样本插值并计算成本
    %%%计算第j个个体的误差成本：
    premea_volt=voltage(j,parents(i,:)); %针对第j组样本点集，按第i个个体取出volt
    premea_tempr=temprature(j,parents(i,:)); %针对第j组样本点集，按第i个个体取出temp
    est_tempr(j,:)=interp1(premea_volt,premea_tempr,voltage(j,:),'spline'); %分段三次样条插值
    est_err = abs(est_tempr(j,:) - temprature(j,:));
    %根据规则对est_err各个点的温度误差计算误差成本：
    for k = 1:Npoint  
       if(est_err(k)<=0.5) 
           s(k) = 0;
       elseif(est_err(k)<=1.0) 
           s(k) = 1;
       elseif(est_err(k)<=1.5)
           s(k) = 8;
       elseif(est_err(k)<=2.0)
           s(k) = 30;
       else 
           s(k) = 20000;
       end  
    end
    %第j个样本的误差成本：
    err_cost = sum(s);
    %%%计算第j个个体的测定成本：
    mea_cost = sum(parents(i,:))*Q;
    %%%记下该方案下第j个样本的误差：
    cost_each(j) = err_cost + mea_cost;
  end
  %%%该方案下的方案成本：
  cost_mn(i) = mean(cost_each);
end
%%%取方案成本的倒数作为各方案的适应度:
fitness = 450./(cost_mn);
end

