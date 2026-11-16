clc; clear; close all;
 
% PROBLEM 2: MINIMIZATION OF MATERIAL USED IN AN OPEN-TOP WATER TANK
 
f = @(x) x(1)^2 + 40/x(1);   % surface area after eliminating h
 
nvars = 1;
lb = 1;  ub = 5;
x0 = 2.5;
rng(1);
 
%% 1. Genetic Algorithm
tic;
[x1,f1] = ga(f,nvars,[],[],[],[],lb,ub,[], ...
    optimoptions('ga','Display','off'));
t1 = toc;
 
%% 2. fmincon
tic;
[x2,f2] = fmincon(f,x0,[],[],[],[],lb,ub,[], ...
    optimoptions('fmincon','Display','off'));
t2 = toc;
 
%% 3. Particle Swarm
tic;
[x3,f3] = particleswarm(f,nvars,lb,ub, ...
    optimoptions('particleswarm','Display','off'));
t3 = toc;
 
%% 4. Pattern Search
tic;
[x4,f4] = patternsearch(f,x0,[],[],[],[],lb,ub,[], ...
    optimoptions('patternsearch','Display','off'));
t4 = toc;
 
%% 5. Surrogate Optimization
tic;
[x5,f5] = surrogateopt(f,lb,ub, ...
    optimoptions('surrogateopt','Display','off', ...
    'MaxFunctionEvaluations',100));
t5 = toc;
 
%% 6. Simulated Annealing
tic;
[x6,f6] = simulannealbnd(f,x0,lb,ub, ...
    optimoptions('simulannealbnd','Display','off'));
t6 = toc;
 
%% Results
names  = {'GA';'fmincon';'Particle Swarm';'Pattern Search'; ...
          'Surrogate';'Simulated Annealing'};
x      = [x1;x2;x3;x4;x5;x6];
area   = [f1;f2;f3;f4;f5;f6];
height = 10./x.^2;
times  = [t1;t2;t3;t4;t5;t6];
 
Results = table(names,x,height,area,times, ...
    'VariableNames',{'Optimizer','Base_m','Height_m', ...
    'SurfaceArea_m2','Time_seconds'});
disp(Results);
 
%% Plot 1: objective function
X = linspace(1,5,200);
A = X.^2 + 40./X;
fg = figure('Name', 'Water Tank Material Minima');
plot(X,A,'b','LineWidth',2); hold on;
plot(x,area,'ro','MarkerFaceColor','r');
xlabel('Base dimension (m)'); ylabel('Surface area (m^2)');
title('Water Tank Material Minimization');
legend('Objective function','Optimizer solutions');
grid on;
saveas(fg, 'Water Tank Material Minima.png');
 
%% Plot 2: computation time
figure;
bar(times);
set(gca,'XTick',1:6,'XTickLabel',names); xtickangle(25);
xlabel('Optimization Algorithm'); ylabel('Time (seconds)');
title('Execution Time Comparison');
grid on;
 
%% Plot 3: minimum surface area
figure;
bar(area);
set(gca,'XTick',1:6,'XTickLabel',names); xtickangle(25);
xlabel('Optimization Algorithm'); ylabel('Surface Area (m^2)');
title('Comparison of Minimum Surface Areas');
grid on;
