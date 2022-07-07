function B = mutation(A)
%mutation 对个体进行变异
% 此处只考虑一个点位发生变异
len = length(A);
B = A;
%随机产生变异位点
point = randi(len);
%变异：
B(point) = ~A(point);
end

