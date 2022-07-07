function [state_node] = LUT(A,B)
%LUT: 元件A、B到节点的映射关系 Look-up table
%   输入：A 1*n 数组
%         B 1*n 数组
%   输出：state_node 1*n 数组
% 0-PF,1-SO,2-DM,3-MO,4-DN,5-FB
state_node = (A==0&B==0)*0 + ((A==0&B==2)|(A==1&B==0)|(A==1&B==2))*1 + (A==2&B==0)*2 + ((A==0&B==1)|(A==2&B==1))*3 + ((A==2&B==2)|A==3)*4 + (A==1&B==1)*5;
end