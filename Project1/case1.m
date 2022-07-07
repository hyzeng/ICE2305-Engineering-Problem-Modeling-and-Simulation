clear;
tic;

%% 读入数据并预处理：
input=readmatrix('dataform_train.csv');
Nsample=size(input,1)/2;  %样本数量
Npoint=size(input,2);  %测试点数量
%提取电压值、温度值： 
voltage=input((2:2:size(input,1)),:);
temprature=input((1:2:size(input,1)),:);

%% 基于遗传算法搜索最优插值方案：
%初始化种群：
%%编码方式：用长为90的二进制数组，下标i对应第i个点，0/1表示是否被选中用于插值
%%%在初始种群中随机产生population个个体：
population = 250;
%%%随机初始化种群：
%ancestor = (rand(population,90)>rand(population,90));
Ntest_p = randi([3,9],population,1);
ancestor = zeros(population,Npoint);
for i = 1:population
    ancestor(i,1:Ntest_p(i))=ones(1,Ntest_p(i));
    ancestor(i,:)=(ancestor(i,randperm(Npoint))>0);
end
children = (zeros(population,Npoint)>0);
%%%允许繁衍的最多代数：
Gmax = 60;   
%%%存储各代种群适应度的情况：
fit_max=zeros(1,Gmax); %最佳适应度
fit_avg=zeros(1,Gmax); %平均适应度

%%%为第一轮迭代进行初始化：
G = 1;
parents = (ancestor>0);
%%%cost_path记录cost的变化
cost_path = zeros(1,Gmax);

while G<Gmax
  if(G<=Gmax/3)
      p_mutation = 0.05; 
  else
      p_mutation = 0.20; 
  end
  %适应度计算：
  %%注：优化目标为成本最小，为了方便计算，将指标正向化，即定义适应度为成本的倒数
  %%%计算个体适应度：
  [fitness,cost] = fitnessfun(parents,voltage,temprature,G,Gmax);
  cost_path(G)=min(cost);
  %%%记录第G代的平均适应度与最大适应度：
  fit_max(G) = max(fitness); 
  fit_avg(G) = mean(fitness);
  
  %精英保留机制：
  %%保留个数为 Nremain:
  Nremain = 4;
  [parents,fitness] = sorted(fitness,parents);  %升序排序
  Nrest = population - Nremain;
  % Nrest 必须偶数
  
  %%%归一化作为生存概率：
  p_living = fitness(1:Nrest)/sum(fitness(1:Nrest));
  
  %选择——赌轮选择法：
  %%计算累积概率：
  cumulated_p = zeros(Nrest,1);
  sum_tmp = 0;
  for i = 1:Nrest
    sum_tmp = p_living(i) + sum_tmp;
    cumulated_p(i) = sum_tmp;
  end
  %%%被选择的结果：
  selected_result = (zeros(Nrest,90)>0);
  for i = 1:Nrest  %第i次选择
    tmp = rand;
    %%%从小到大寻找第一个大于等于tmp的数，确定tmp的区间:
    for j = 1:Nrest  
        if(tmp<=cumulated_p(j))  %tmp小于等于第j个数，说明选中第j个个体
            selected_result(i,:) = parents(j,:);  %并记录下被选出的这个个体
            break;  %找到后跳出循环
        end
    end
  end
  
  %交叉产生后代：
  %%注：把自交的情况也考虑进去了
  %%%随机配对：随机打乱筛选结果的顺序再两两配对
  cross_result = (zeros(Nrest,90)>0);
  for i = 1:2:(Nrest-1)
    [cross_result(i,:),cross_result(i+1,:)] = crossover(selected_result(i,:),selected_result(i+1,:));
  end
  
  %变异：
  mutation_result = cross_result;
  for i = 1:Nrest
    p = rand;
    if p<=p_mutation 
        mutation_result(i,:) = mutation(cross_result(i,:));
    end
  end
  
  %更新：
  G = G + 1;
  children = [mutation_result ; parents(Nrest+1:population,:)];
  parents = children;
  
end

%%此时G=Gmax
%%%计算第Gmax代的适应度：
[fitness,cost] = fitnessfun(parents,voltage,temprature,G,Gmax);
cost_path(G)=min(cost);
lowest_cost = cost_path(G);
%%%记录第Gmax代的最佳适应度与平均适应度：
%%%此时fitness里存储的是最后一代的适应度：
max_value = 0;
best_choice = (zeros(1,90)>0);
for i=1:population
   if(fitness(i)>=max_value)
       max_value = fitness(i);
       best_choice = parents(i,:);
   end
end
fit_max(G) = max_value;
fit_avg(G) = mean(fitness);
figure(1);
plot(1:Gmax,fit_max,'r-',1:Gmax,fit_avg,'b-');
legend('最佳适应度','平均适应度');
xlabel('代数');
ylabel('适应度');
figure(2);
plot(1:Gmax,cost_path,'r-');
xlabel('代数');
ylabel('最小成本');
Npoint = sum(best_choice);
find(best_choice)
toc;