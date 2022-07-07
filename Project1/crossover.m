function [C1,C2] = crossover(A1,A2)
%crossover 两个个体繁衍，进行交叉互换
% 随机产生交叉点位：
len = length(A1);
point = randi(len-1);
% 交换[point+1，90]的基因片段:
C1 = [A1(1:point),A2(point+1:len)];
C2 = [A2(1:point),A1(point+1:len)];
end

