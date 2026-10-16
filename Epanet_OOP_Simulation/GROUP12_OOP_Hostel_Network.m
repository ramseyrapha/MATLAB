clc; clear; close all;

% Start EPANET Toolkit
start_toolkit

%% Load hostel data

hostels(1) = Hostel("AC",180);
hostels(2) = Hostel("OGOOLA",220);
hostels(3) = Hostel("NYERERE",250);
hostels(4) = Hostel("NJUKI",200);

fprintf('HOSTEL WATER DEMANDS\n');

for i = 1:length(hostels)

    fprintf('%s : %.4f L/s\n', ...
        hostels(i).Name,...
        hostels(i).getDemand());

end

%% EPANET Part

d = epanet('Net1.inp');


d.openHydraulicAnalysis;
d.initializeHydraulicAnalysis;

tstep = 1;

while tstep > 0

    d.runHydraulicAnalysis();

    tstep = d.nextHydraulicAnalysisStep();

end

pressure = d.getNodePressure();
flow = d.getLinkFlows();

fprintf('\nNode Pressures\n');
disp(pressure)

fprintf('\nPipe Flows\n');
disp(flow)

d.closeHydraulicAnalysis();

figure('Name','Hostel Water Distribution Network');
d.plot;
title('Hostel Water Distribution Network')

d.unload