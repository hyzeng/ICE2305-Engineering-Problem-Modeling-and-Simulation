# ICE2305-Modeling and Simulation of Engineering Problem
ICE2305-工程问题建模与仿真

## Environment: MATLAB R2020b

## Project 1: Calibration of a Measuring Device in Manufacture
案例一：一个测量装置在大规模制造中的标定问题

### 求解思路
It is of great significance to propose a sensible calibration methodology to reduce cost and enhance accuracy in manufacture. A calibration methodology contains selected test-point sequence and interpolation method: for the latter one, Cubic Spline Interpolation is applied directly; while for the former, the classic Genetic Algorithm is promoted with regards to the features of the problem and applied to select a sensible sequence.At last, three interpolation methods:Cubic Spline Interpolation (spline), Piecewise Cubic Hermite Interpolation Polynomial (pchip) and Modified Akima Cubic Hermite Interpolation (makima) are compared, which leads to the conclusion that “pchip” and “makima” both perform better than “spline” in this problem.

在大规模制造的标定问题中，合理标定方案的选择对降低标定成本、提高标定精度起着至关重要的决定作用。其中标定方案包括了测试点的选取与插值方法的选择：对于后者,直接采用了分段三次样条插值；而对于前者，本文结合问题特征，在经典的遗传算法中引入了精英保留机制，从而搜寻出较优的标定方案。最后，比较了三次样条插值“spline”、分段三次Hermite插值“pchip”、修正Akima的分段三次Hermite插值“makima”三种方法，得出结论：本案例中采用“pchip”和“makima”两种方法效果更佳。

### 文件说明
案例一的说明文档、数据集与代码源文件均包含在文件夹Project1中。

运行case1.m，选择出训练集上最优的标定方案。

运行intp_fig.m，对比不同插值方法的标定效果。

- 工程问题建模与仿真之案例课题1_V2.3 20220213.pdf 为案例一说明文档
- dataform_train.csv 为案例一训练集
- dataform_testA.csv 为案例一测试集A
- case1.m 为案例一求解标定点的主程序
- crossover.m 执行基因链的交叉互换，由case1.m调用
- fitnessfun.m 计算每个个体的适应度，由case1.m调用
- mutation.m 执行个体的基因突变，由case1.m调用
- sorted.m 对每一代的个体按适应度排序，便于保留精英，由case1.m调用
- intp_fig.m 对比各种插值方法
- my_interpolation.m 按选定的标定点和插值方法进行插值，由intp_fig.m调用

## Project 2: Reliability Evaluation and Optimization of a Multi-node Sonar System with Synchronous Clock Mechanism
案例二：一个多节点声纳系统中同步时钟机制的可靠性评估和系统优化问题

### 求解思路
It is inconvenient to repair a multi-node sonar system, thus redundancy design is
applied to enhance its reliability, on which the amount of node has significant impact. In this
article, an ideal model of the system is established on three levels,”component--node--system”,
based Markov Chain, according to the characteristics of the system. The best amount of node is
determined by performing Monte Carlo Method to maximize Reliability and Average Lifespan
respectively. Moreover, as an approximation to Reliability, the numerical result of Availability is
derived theoretically with computer programming. In the end, system “revival” is considered
into the simulation process. The logical completion is examined on the results, and a conclusion
is drawn that Availability as an approximation to Reliability performs better with less amount of
node.

多节点声纳监听系统往往不便维修，因此采用冗余设计的方法以提高可靠性，其中
节点个数对系统的可靠性有显著影响。本文根据系统特性，在“元件——节点——系统”三
个层面分别基于马尔可夫链建立理想模型，并通过蒙特卡洛方法求解分别使系统可靠性最优
和平均寿命最长的节点个数。另外，本文以系统可用性指标作为可靠性的近似，用理论推导
辅以计算机编程的方法求得数值结果。最后，将系统“复活”机制引入仿真中，通过仿真结
果验证程序在逻辑上的完备性，并指出了节点个数较少时更适合用可用性代替可靠性。

### 文件说明
案例二的说明文档与代码源文件均包含在文件夹Project2中。

运行主程序main_v3.m，进行系统仿真。

运行Availability.m，求解可用性理论值。

- 工程问题建模与仿真之案例课题2_V2.12 20220305.pdf 为案例二说明文档
- Availability.m 求解系统可用性的理论值
- LUT.m 节点状态转移，由main_v3.m调用
- main_v3.m 仿真该系统的主程序
- setMaster.m 更新系统的主节点，由main_v3.m调用
- state_transA.m 元件A状态转移，由main_v3.m调用
- state_transB.m 元件B状态转移，由main_v3.m调用
- system_trans.m 系统状态转移，由main_v3.m调用

