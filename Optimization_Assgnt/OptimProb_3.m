clc; clear; close all;
 
% PROBLEM 3: MINIMIZATION OF BEAM CROSS-SECTIONAL AREA
 
P = 20000;  L = 4;  E = 200e9;       % load, span, Young's modulus
sigma_allow = 150e6;  delta_allow = L/360;
 
f = @(x) x(1)*x(2);                  % area = width * depth
x0 = [0.2 0.2];                      % [width depth]
lb = [0.1 0.1];  ub = [0.5 0.5];
nvars = 2;
rng(1);
 
%% 1. Genetic Algorithm
tic;
[x1,f1] = ga(f,nvars,[],[],[],[],lb,ub,@beamConstraints, ...
    optimoptions('ga','Display','off'));
t1 = toc;
 
%% 2. fmincon
tic;
[x2,f2] = fmincon(f,x0,[],[],[],[],lb,ub,@beamConstraints, ...
    optimoptions('fmincon','Algorithm','sqp','Display','off'));
t2 = toc;
 
%% 3. Particle Swarm (penalty function)
tic;
x3 = particleswarm(@(x) penaltyObjective(x,f),nvars,lb,ub, ...
    optimoptions('particleswarm','Display','off'));
f3 = f(x3);
t3 = toc;
 
%% 4. Pattern Search
tic;
[x4,f4] = patternsearch(f,x0,[],[],[],[],lb,ub,@beamConstraints, ...
    optimoptions('patternsearch','Display','off'));
t4 = toc;
 
%% 5. Surrogate Optimization (penalty function)
tic;
x5 = surrogateopt(@(x) penaltyObjective(x,f),lb,ub, ...
    optimoptions('surrogateopt','Display','off', ...
    'MaxFunctionEvaluations',200));
f5 = f(x5);
t5 = toc;
 
%% 6. Simulated Annealing (penalty function)
tic;
x6 = simulannealbnd(@(x) penaltyObjective(x,f),x0,lb,ub, ...
    optimoptions('simulannealbnd','Display','off'));
f6 = f(x6);
t6 = toc;
 
%% Collect results
names = {'GA';'fmincon';'Particle Swarm';'Pattern Search'; ...
         'Surrogate';'Simulated Annealing'};
solutions = [x1;x2;x3;x4;x5;x6];
areas = [f1;f2;f3;f4;f5;f6];
times = [t1;t2;t3;t4;t5;t6];
 
Results = table(names,solutions(:,1),solutions(:,2),areas,times, ...
    'VariableNames',{'Optimizer','Width_m','Depth_m', ...
    'Area_m2','Time_seconds'});
disp(Results);
 
%% Check stress and deflection for every solution
for i = 1:6
    b = solutions(i,1);  h = solutions(i,2);
    stress = 3*P*L/(2*b*h^2);
    deflection = P*L^3/(4*E*b*h^3);
    fprintf('\n%s\n',names{i});
    fprintf('Stress = %.4f MPa\n',stress/1e6);
    fprintf('Deflection = %.6f m\n',deflection);
end
 
%% Plot 1: computation time
figure;
bar(times);
set(gca,'XTick',1:6,'XTickLabel',names); xtickangle(25);
ylabel('Time (seconds)'); xlabel('Optimization Algorithm');
title('Execution Time Comparison');
grid on;
 
%% Plot 2: optimal area
figure;
bar(areas);
set(gca,'XTick',1:6,'XTickLabel',names); xtickangle(25);
ylabel('Cross-sectional Area (m^2)'); xlabel('Optimization Algorithm');
title('Minimum Beam Area Comparison');
grid on;
 
%% Plot 3: contour of the objective with optimizer solutions
[B,H] = meshgrid(0.1:0.005:0.5);
Area = B.*H;
Fig = figure('Name', 'Structural Beam');
contourf(B,H,Area,20); colorbar; hold on;
plot(solutions(:,1),solutions(:,2),'ro','MarkerFaceColor','r');
xlabel('Beam width (m)'); ylabel('Beam depth (m)');
title('Structural Beam Optimization');
legend('Cross-sectional area','Optimizer solutions');
grid on;
saveas(Fig, 'Structural Beam Optimization.png');

%% Nonlinear constraints (c <= 0)
function [c,ceq] = beamConstraints(x)
    P = 20000;  L = 4;  E = 200e9;
    sigma_allow = 150e6;  delta_allow = L/360;
    b = x(1);  h = x(2);
    stress = 3*P*L/(2*b*h^2);
    deflection = P*L^3/(4*E*b*h^3);
    c = [stress/sigma_allow - 1;
         deflection/delta_allow - 1];
    ceq = [];
end
 
%% Penalty function
function value = penaltyObjective(x,f)
    [c,~] = beamConstraints(x);
    penalty = 1e6*sum(max(c,0).^2);
    value = f(x) + penalty;
end