% clear;
tic;
PEA1 = 0.20;             % A1故障的条件概率
PEA2 = 0.15;             % A2故障的条件概率
PEA3 = 0.65;             % A3故障的条件概率
PEB1 = 0.45;             % B1故障的条件概率
PEB2 = 0.55;             % B2故障的条件概率
lambdaA = 1/(5.9e+04);   % 元件A指数分布参数
lambdaB = 1/(2.2e+05);   % 元件B指数分布参数
w = 30000;
k = 3;
%%元件处于各状态的概率(t=w)：
PA0 = exp(-lambdaA*w);
PA1 = PEA1*(1-PA0);
PA2 = PEA2*(1-PA0);
PA3 = PEA3*(1-PA0);
PB0 = exp(-lambdaB*w);
PB1 = PEB1*(1-PB0);
PB2 = PEB2*(1-PB0);
%%节点处于各状态的概率(t=w)：
PPF = PA0*PB0;
PMO = PA0*PB1+PA2*PB1;
PSO = PA0*PB2+PA1*PB0+PA1*PB2;
PFB = PA1*PB1;
PDM = PA2*PB0;
PDN = PA2*PB2+PA3;

availability = zeros(20,1);
%%系统处于各状态的概率(t=w)：
%%系统的状态由节点的状态组合而成，首先要通过穷举找出n个节点一共有哪些组合：
for n=3:20
    table = zeros(100,6); 
    i = 1;
    %%%穷举所有情况：
    for a=n:-1:0
        for b=(n-a):-1:0
           for c=(n-a-b):-1:0
              for d=(n-a-b-c):-1:0
                 for e=(n-a-b-c-d):-1:0
                     f = n-a-b-c-d-e;
                     table(i,:)=[a,b,c,d,e,f];
                     i = i+1;
                 end
              end
           end
        end
    end
    [M,N] = size(table);
    %%%一共M种情况：
    Pr_nodes = zeros(M,1); %存放每种情况出现的概率
    Pr_system = zeros(1,4); %存放系统各种状态的概率
    %%%对应关系：Q0-1-PF Q1-2-SO Q2-3-DM Q3-4-MO Q4-5-DN Q5-6-FB
    for i=1:M
        %%%%计算每一种情况出现的概率：
        tmp = table(i,:);
        tmp_sum = cumsum(tmp);
        Pr_nodes(i) = nchoosek(n,tmp(1)) * nchoosek(n-tmp_sum(1),tmp(2)) * nchoosek(n-tmp_sum(2),tmp(3))...
            * nchoosek(n-tmp_sum(3),tmp(4)) * nchoosek(n-tmp_sum(4),tmp(5)) * nchoosek(n-tmp_sum(5),tmp(6))...
            * PPF^(tmp(1)) * PSO^(tmp(2)) * PDM^(tmp(3)) * PMO^(tmp(4)) * PDN^(tmp(5)) * PFB^(tmp(6));
        %%%%根据条件C1至C9判断每一种情况分别对应哪一种系统状态，将此组合的概率计入系统处于相应状态的概率：
        Q0 = tmp(1); Q1 = tmp(2); Q2 = tmp(3); Q3 = tmp(4); Q4 = tmp(5); Q5 = tmp(6); %这里赋值是为了代码复用
        %%%%条件C1至C9：
        C1 = (Q5>=1);
        C2 = (Q3>=2);
        C3 = (Q0+Q3+Q2==0);
        C4 = (Q0+Q1+(Q3+Q2>0)<k);
        C5 = (Q5==0);
        C6 = ((Q3==1)&(Q0+Q1>=k-1));
        C7 = ((Q3==0 & Q0>=1 & Q0+Q1>=k)|(Q3==0 & Q0==0 & Q2>=1 & Q1>=k-1));
        C8 = (Q5+Q3==0);
        C9 = (Q0>=1 & Q0+Q1==k-1 & Q2>=1);
        %%%%Pr3为满足C8&C9时，系统工作在状态3的概率：
        if (C8&C9)==1
           Pr3 = Q2/(Q0+Q2);
        else
           Pr3 = 0;
        end
        %Remark:在仿真中，系统总是从正常状态开始演化，直至失效，因此不会出现Q2=0且Q0=0的极端情况
        %但是在理论计算中，需要考虑到每一种情况，Q2=0且Q0=0这种情况会使表达式无意义
        %因此若系统不满足 C8&C9，直接将 Pr3 赋值为0，避免无意义表达式
        
        %%%%Pr_judge用于判断该组合对应哪种情况，采用向量化编程：
        Pr_judge = [(C1|C2|C3|C4),(C5&(C6|C7)),(C8&C9)*Pr3,(C8&C9)*(1-Pr3)];
        Pr_system = Pr_system + Pr_nodes(i)*Pr_judge;
%         Pr_system(1) = Pr_system(1) + (C1|C2|C3|C4)*Pr_nodes(i);
%         Pr_system(2) = Pr_system(2) + (C5&(C6|C7)))*Pr_nodes(i);
%         Pr_system(3) = Pr_system(3) + (C8&C9)*Pr*Pr_nodes(i);
%         Pr_system(4) = Pr_system(4) + (C8&C9)*(1-Pr)*Pr_nodes(i);
    end
    availability(n) = Pr_system(2)+Pr_system(3);  %系统可用性
    fprintf('\n正在运行node=%5.2f\n',n);
    fprintf('\n模型可用性为：%5.2f\n',availability(n));
end
plot(3:20,availability(3:20),'-*r');
xlabel('节点个数');
ylabel('系统可用性');
toc;