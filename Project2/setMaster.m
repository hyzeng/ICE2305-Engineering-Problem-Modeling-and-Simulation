%% 0-PF,1-SO,2-DM,3-MO,4-DN,5-FB
judge_MO = (state_node(i,:)==3);
sum_MO = sum(judge_MO);
judge_PF_DM = (state_node(i,:)==0|state_node(i,:)==2);
sum_PF_DM = sum(judge_PF_DM);
if (sum_MO > 0)    %%存在MO
    tmp = role_node(i,judge_MO);
    rnd = randi(sum_MO);
    tmp(rnd) = 1;
%     tmp(1) = 1;
    role_node(i,judge_MO) = tmp;
elseif(sum_PF_DM > 0)
        tmp = role_node(i,judge_PF_DM);
        rnd = randi(sum_PF_DM);
        tmp(rnd) = 1;
%         tmp(1) = 1;
        role_node(i,judge_PF_DM) = tmp;
end