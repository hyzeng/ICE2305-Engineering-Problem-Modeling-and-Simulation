indexB = (life_compB==timeB);  %找到发生故障的元件
PBcum = cumsum(PEB);  %状态转移的累计概率
rdmB = rand(1,n);  %产生随机数
% 状态转移：修改state_B,发生转移的元件原本状态必定为0
state_B(i,:) = (~indexB).*(state_B(i,:)) + (indexB).*((rdmB<=PBcum(1))*1+(rdmB>PBcum(1)&rdmB<=PBcum(2))*2);
% 已处理事件的发生时间修改为无穷大，相当于删除：
life_compB = (~indexB).*life_compB + (indexB)*1.0e+09;