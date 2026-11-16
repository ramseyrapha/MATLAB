clc; clear; close all;
 
% PROBLEM 1: MAXIMIZATION OF RECTANGULAR PLOT AREA
% Comparison of six optimization solvers
 
% Objective function (negative sign converts maximization to minimization)
f = @(x) -(x(1)*(50 - x(1)));
 
nvars = 1;          % one design variable (length x)
lb = 0;  ub = 50;   % bounds
x0 = 20;            % initial guess
rng(1);             % reproducible random numbers
 
%% 1. Genetic Algorithm
tic;
[x_ga,f_ga] = ga(f,nvars,[],[],[],[],lb,ub,[], ...
    optimoptions('ga','Display','off'));
time_ga = toc;
 
%% 2. fmincon
tic;
[x_fmincon,f_fmincon] = fmincon(f,x0,[],[],[],[],lb,ub,[], ...
    optimoptions('fmincon','Algorithm','sqp','Display','off'));
time_fmincon = toc;
 
%% 3. Particle Swarm
tic;
[x_ps,f_ps] = particleswarm(f,nvars,lb,ub, ...
    optimoptions('particleswarm','Display','off', ...
    'SwarmSize',30,'MaxIterations',100));
time_ps = toc;
 
%% 4. Pattern Search
tic;
[x_pattern,f_pattern] = patternsearch(f,x0,[],[],[],[],lb,ub,[], ...
    optimoptions('patternsearch','Display','off','MaxIterations',200));
time_pattern = toc;
 
%% 5. Surrogate Optimization
tic;
[x_surrogate,f_surrogate] = surrogateopt(f,lb,ub, ...
    optimoptions('surrogateopt','Display','off', ...
    'MaxFunctionEvaluations',100));
time_surrogate = toc;
 
%% 6. Simulated Annealing
tic;
[x_sa,f_sa] = simulannealbnd(f,x0,lb,ub, ...
    optimoptions('simulannealbnd','Display','off','MaxIterations',200));
time_sa = toc;
 
%% Collect results
names = {'GA';'fmincon';'Particle Swarm';'Pattern Search'; ...
         'Surrogate';'Simulated Annealing'};
x_values = [x_ga;x_fmincon;x_ps;x_pattern;x_surrogate;x_sa];
areas    = -[f_ga;f_fmincon;f_ps;f_pattern;f_surrogate;f_sa];
times    = [time_ga;time_fmincon;time_ps;time_pattern;time_surrogate;time_sa];
widths   = 50 - x_values;
 
Results = table(names,x_values,widths,areas,times, ...
    'VariableNames',{'Optimizer','Length_m','Width_m','Area_m2','Time_seconds'});
disp('OPTIMIZATION COMPARISON RESULTS');
disp(Results);
 
%% Plot 1: objective function with optimizer solutions
x = linspace(0,50,200);
A = x.*(50 - x);
fig = figure('Name', 'Rectangular Plot Area Maxima');
plot(x,A,'b','LineWidth',2); hold on;
plot(x_values,areas,'ro','MarkerSize',8,'MarkerFaceColor','r');
xlabel('Length of plot (m)'); ylabel('Area (m^2)');
title('Maximization of Rectangular Plot Area');
legend('Objective function','Optimizer solutions','Location','best');
grid on;
saveas(fig, 'Rectangular_Plot_Area_Maxima.png');
 
%% Plot 2: computation time comparison
figure;
bar(times);
set(gca,'XTick',1:6,'XTickLabel',names); xtickangle(25);
xlabel('Optimization Algorithm'); ylabel('Computation Time (seconds)');
title('Comparison of Execution Time of Six Optimizers');
grid on;
 
%% Plot 3: optimal area comparison
figure;
bar(areas);
set(gca,'XTick',1:6,'XTickLabel',names); xtickangle(25);
xlabel('Optimization Algorithm'); ylabel('Maximum Area (m^2)');
title('Comparison of Optimal Areas');
grid on;
