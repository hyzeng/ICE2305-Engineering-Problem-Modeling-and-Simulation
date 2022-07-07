function [parents,fitness] = sorted(fitness,parents)
%对结果进行排序，便于保留经营个体
%   此处显示详细说明
[fitness,index] = sort(fitness); %升序排列
parents = parents(index,:);
end

