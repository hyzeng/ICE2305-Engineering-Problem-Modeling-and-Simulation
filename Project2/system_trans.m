%%统计各状态节点的个数：
Q0 = sum(state_node(i,:)==0);
Q1 = sum(state_node(i,:)==1);
Q2 = sum(state_node(i,:)==2);
Q3 = sum(state_node(i,:)==3);
Q4 = sum(state_node(i,:)==4);
Q5 = sum(state_node(i,:)==5);
%%判断条件C1到C9是否被满足：
C1 = (Q5>=1);
C2 = (Q3>=2);
C3 = (Q0+Q3+Q2==0);
C4 = (Q0+Q1+(Q3+Q2>0)<k);
C5 = (Q5==0);
C6 = ((Q3==1)&(Q0+Q1>=k-1));
C7 = ((Q3==0 & Q0>=1 & Q0+Q1>=k)|(Q3==0 & Q0==0 & Q2>=1 & Q1>=k-1));
C8 = (Q5+Q3==0);
C9 = (Q0>=1 & Q0+Q1==k-1 & Q2>=1);
%%状态转移：
% rnd = rand;
% Pr = Q2/(Q0+Q2);
% state_system(i) = (C1|C2|C3|C4)*1 + (C5&(C6|C7))*2 + (C8&C9)*((rnd<=Pr)*3+(rnd>Pr)*4);
if(C1||C2||C3||C4)
    state_system(i) = 1;
elseif(C5 && (C6||C7))
    state_system(i) = 2;
elseif(C8 && C9)
    master = find(role_node(i,:)==1);
    if(state_node(i,master)==0)
        state_system(i) = 4;
    elseif(state_node(i,master)==2)
        state_system(i) = 3;
    end
end