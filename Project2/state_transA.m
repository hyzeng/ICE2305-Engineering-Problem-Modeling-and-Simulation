indexA = (life_compA==timeA);  %找到发生故障的元件
PAcum = cumsum(PEA);  %状态转移的累计概率
rdmA = rand(1,n);  %产生随机数
% 状态转移：修改state_A,发生转移的元件原本状态必定为0
state_A(i,:) = (~indexA).*(state_A(i,:)) + (indexA).*((rdmA<=PAcum(1))*1+(rdmA>PAcum(1)&rdmA<=PAcum(2))*2+(rdmA>PAcum(2)&rdmA<=PAcum(3))*3);
% 已处理事件的发生时间修改为无穷大，相当于删除：
life_compA = (~indexA).*life_compA + (indexA)*1.0e+09;