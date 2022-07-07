clear;
tic;

%%设定参数：
S = 1.0e+05;             %一共S套同型系统
w = 30000;               %感兴趣的时间段
Tmax = 200000;           %最大工作寿命
tuo = 1;                 %时间颗粒度1小时
k = 3;                   %系统至少需要k个节点才能正常工作
muA = 5.90e+04;  %元件A寿命指数分布参数
muB = 2.20e+05;  %元件B寿命指数分布参数
PEA1 = 0.20;             % A1故障的条件概率
PEA2 = 0.15;             % A2故障的条件概率
PEA3 = 0.65;             % A3故障的条件概率
PEA = [PEA1,PEA2,PEA3];
PEB1 = 0.45;             % B1故障的条件概率
PEB2 = 0.55;             % B2故障的条件概率
PEB = [PEB1,PEB2];
Reliability = zeros(20,1);
E_Tf = zeros(20,1);
Pr_revive_survive = zeros(20,1);
Pr_survive = zeros(20,1);

for n=3:20
    %% 初始化：
    %%%系统指标：
    Tf = zeros(S,1);           %系统首次失效时间
    %%%元件状态：
    state_A = zeros(S,n);
    state_B = zeros(S,n);
    %%%节点性能状态：
    state_node = zeros(S,n);
    %%%节点角色状态：0-非主节点，1-主节点
    role_node = zeros(S,n);
    %%%系统状态：
    state_system = 2*ones(S,1);
    %%%系统复活标志位1：0-没有复活，1-（t<=w）内复活
    revive_flag1 = zeros(S,1);
    %%%系统复活标志位2：0-没有复活，1- 复活
    revive_flag2 = zeros(S,1);
    %%%系统在t=w时正常工作的标志位：
    survive_flag = zeros(S,1);
    record_flag = zeros(S,1);  %%辅助变量

    %%仿真开始：
    for i = 1:S
      %%%随机选择主节点：
      setMaster;
      
      %%%随机生成各节点A、B发生故障的时间点：
      life_compA = exprnd(muA,1,n);
      life_compB = exprnd(muB,1,n);
      %%%进入仿真：
      clk = 0; %初始化系统时钟
      while (1)  
          %%%元件状态转移——更新state_A(i,:)和state_B(i,:)
          timeA = min(life_compA);
          timeB = min(life_compB);
          if (timeA<timeB)
              %%%元件A发生状态转移：
              if ((timeA >= w)&&(record_flag(i)==0))
                  survive_flag(i) = (state_system(i)==2||state_system(i)==3)*1;
                  record_flag(i) = 1;
              end
              if (timeA>Tmax) %%故障发生时间超出最大寿命
                  clk = Tmax;
                  if((state_system(i)==2||state_system(i)==3)&&(revive_flag2(i)==0))
                      Tf(i) = Tmax;
                  end
                  break;
              end
              clk = timeA;  %时钟拨到该时间点
              state_transA;  %A元件故障，状态转移
          elseif(timeA>timeB)
              %%%元件B发生状态转移：
              if ((timeB >= w)&&(record_flag(i)==0))
                  survive_flag(i) = (state_system(i)==2||state_system(i)==3)*1;
                  record_flag(i) = 1;
              end
              if (timeB>Tmax) %%故障发生时间是否超出最大寿命
                  clk = Tmax;
                  if((state_system(i)==2||state_system(i)==3)&&(revive_flag2(i)==0))
                      Tf(i) = Tmax;
                  end
                  break;
              end
              clk = timeB;  %时钟拨到该时间点
              state_transB;  %B元件故障，状态转移
          else
              %%%元件AB同时发生状态转移：
              if ((timeA >= w)&&(record_flag(i)==0))
                  survive_flag(i) = (state_system(i)==2||state_system(i)==3)*1;
                  record_flag(i) = 1;
              end              
              if (timeA>Tmax) %%故障发生时间是否超出最大寿命
                  clk = Tmax;
                  if((state_system(i)==2||state_system(i)==3)&&(revive_flag2(i)==0))
                      Tf(i) = Tmax;
                  end
                  break;
              end
              clk = timeB;  %时钟拨到该时间点
              state_transA;
              state_transB;
          end
          
          %%%节点状态转移——更新state_node(i,:)
          %%% 0-PF,1-SO,2-DM,3-MO,4-DN,5-FB
          state_node(i,:)= LUT(state_A(i,:),state_B(i,:));
          
          %%%节点有可能进行主节点重选：
          %%%先更新角色状态：
          master = find(role_node(i,:)==1);
          if (~isempty(master))  %有1个主节点
              state_ms = state_node(i,master);
              if(state_ms==1||state_ms==4||state_ms==5)
                  role_node(i,master) = 0;
              end
          end
          %%%再决定是否需要重选：
          if(sum(role_node(i,:))==0)
              setMaster;
          end
          
          %%%记录指标：
          pre_state_system = state_system(i);
          if ((pre_state_system==2||pre_state_system==3)&&(revive_flag2(i)==0))
              Tf(i) = clk;          
          end
              
          %%%系统状态转移——更新state_system(i)
          system_trans;
          if ((pre_state_system==1||pre_state_system==4)&&(state_system(i)==2||state_system(i)==3))
              revive_flag2(i) = 1;
              if (clk<=w)
                  revive_flag1(i) = 1;
              end
          end

      end
    end
    %%%% 注：系统一旦失效，就结束对该系统的仿真并记录其寿命，规避了“复活”的情况
    Reliability(n) = mean((Tf>=w));
    E_Tf(n) = mean(Tf);
    Pr_revive_survive(n) = mean((revive_flag1.*survive_flag));
    Pr_survive(n) = mean(survive_flag);
%     format long;
%     Reliability
%     E_Tf
    fprintf('\n正在运行node=%5.2f\n',n);
    fprintf('\n模型可靠性为：%5.2f\n',Reliability(n));
    fprintf('\n模型平均工作寿命：%5.2f\n',E_Tf(n));
    fprintf('\n模型发生复活且在t=w时刻正常工作的概率：%5.2f\n',Pr_revive_survive(n));
    fprintf('\n模型在t=w时刻正常工作的概率：%5.2f\n',Pr_survive(n));
end
figure(1);
plot(3:20,Reliability(3:20),'-*r');
xlabel('节点个数');
ylabel('系统可靠性');
figure(2);
plot(3:20,E_Tf(3:20),'-*r');
xlabel('节点个数');
ylabel('平均首次失效时间/h');
toc;