% QTN2_Group12.m - Academic Performance Analysis 
clear; clc; close all;

% Reading excel data
studentData = readtable('STUDENT_DATA.xlsx');
numStudents = height(studentData);

% DEFINING EXACT CREDIT WEIGHTS FROM EXCEL LEGEND
cu_Y1S1 = [4, 4, 3, 4, 4];          
cu_Y1S2 = [4, 4, 3, 4, 3, 3];      
totalCU_Y1S1 = sum(cu_Y1S1);           % 19 CU
totalCU_Y1S2 = sum(cu_Y1S2);             % 21 CU
totalCumulativeCU = totalCU_Y1S1 + totalCU_Y1S2; % 40 CU(Year 1)

% 3. EXTRACT MARKS MATRICES FROM TABLE
marks_Sem1 = [studentData.Y1S1_C1, studentData.Y1S1_C2, studentData.Y1S1_C3, ...
              studentData.Y1S1_C4, studentData.Y1S1_C5];

marks_Sem2 = [studentData.Y1S2_C1, studentData.Y1S2_C2, studentData.Y1S2_C3, ...
              studentData.Y1S2_C4, studentData.Y1S2_C5, studentData.Y1S2_C6];

% 4. COMPUTE GPA AND YEAR 1 CGPA
gpa_Sem1  = zeros(numStudents, 1);
gpa_Sem2  = zeros(numStudents, 1);
cgpa_Year1 = zeros(numStudents, 1);

for i = 1:numStudents
    % --- Semester 1 ---
    gp1 = convertMarksToGP(marks_Sem1(i, :));
    qp1 = sum(gp1 .* cu_Y1S1);
    gpa_Sem1(i) = qp1 / totalCU_Y1S1;
   
    % --- Semester 2 ---
    gp2 = convertMarksToGP(marks_Sem2(i, :));
    qp2 = sum(gp2 .* cu_Y1S2);
    gpa_Sem2(i) = qp2 / totalCU_Y1S2;
   
    % --- Year 1 Cumulative CGPA ---
    cgpa_Year1(i) = (qp1 + qp2) / totalCumulativeCU;
end

% 5. APPEND COLUMNS AND EXPORT UPDATED FILE
studentData.gpa_Sem1  = round(gpa_Sem1, 2);
studentData.gpa_Sem2  = round(gpa_Sem2, 2);
studentData.CGPA_Year1 = round(cgpa_Year1, 2);

% Save updated results to Excel
outputFile = 'STUDENT_DATA_WITH_CGPA.xlsx';
writetable(studentData, outputFile); 
fprintf('Calculated gpa and CGPA for %d students successfully.\n', numStudents);
fprintf('Exported updated table to: %s\n\n', outputFile);


%PERFORMANCE PLOTS
% --- Plot 1: Standard Line Plot ---
f1 = figure('Name', 'CGPA_LinePlot');
plot(cgpa_Year1);
title('Student CGPA');
xlabel('Student Index');
ylabel('CGPA');
grid on;
saveas(f1, 'CGPA_LinePlot.png');

% --- Plot 2: gpa vs CGPA Distribution ('boxplot') ---
f2 = figure('Name', 'GPA_Boxplot');
boxplot([gpa_Sem1, gpa_Sem2, cgpa_Year1], ...
    'Labels', {'Sem 1 gpa (19 CU)', 'Sem 2 gpa (21 CU)', 'Year 1 CGPA (40 CU)'});
title('1. Academic Performance Distribution Across Semesters');
ylabel('GPA (0.0 - 5.0 Scale)');
grid on;
saveas(f2, 'GPA_Boxplot.png');

% --- Plot 3: Semester 1 vs Semester 2 Correlation Scatter ('scatter') ---
f3 = figure('Name', 'Semester_Scatter');
scatter(gpa_Sem1, gpa_Sem2, 50, cgpa_Year1, 'filled');
cb = colorbar; cb.Label.String = 'Year 1 CGPA';
title('2. Sem 1 gpa vs. Sem 2 gpa (Color Scaled by Overall CGPA)');
xlabel('Sem 1 gpa (19 CU)'); ylabel('Sem 2 gpa (21 CU)');
grid on;
saveas(f3, 'Semester_Scatter.png');

% --- Plot 4: Class Mean & Std Dev Across All 11 Courses ('errorbar') ---
f4 = figure('Name', 'Course_Performance_Errorbar');
allMeans = [mean(marks_Sem1, 1), mean(marks_Sem2, 1)];
allCourseStds  = [std(marks_Sem1, 0, 1), std(marks_Sem2, 0, 1)];
courseNames = {'Eng Math I', 'Circuit Th', 'Comm Skills', 'Comp Apps', 'Eng Mech I', ...
               'Eng Math II', 'Eng Mech II', 'Thermo', 'Fluid Mech', 'Env Sci', 'Survey'};

errorbar(1:11, allMeans, allCourseStds, 's-', 'LineWidth', 1.5, ...
    'MarkerSize', 7, 'MarkerFaceColor', 'b');
set(gca, 'XTick', 1:11, 'XTickLabel', courseNames);
xtickangle(45);
title('3. Mean Marks and Standard Deviation Across All 11 Engineering Courses');
ylabel('Mean Mark (%)'); grid on;
saveas(f4, 'Course_Means_Errorbar.png');

% --- Plot 5: Standard Bar Chart ---
f5 = figure('Name', 'Mean Mark');
bar(allMeans);
set(gca, 'XTick', 1:11, 'XTickLabel', courseNames);
xtickangle(45);
title('Average Mark Per Course');
xlabel('Course Number');
ylabel('Average Mark (%)');
grid on;
saveas(f5, 'Mean_Mark_BarChart.png');

% --- Plot 6: Standard Stair Plot ---
f6 = figure('Name', 'Ranking Student CGPA');
stairs(sort(cgpa_Year1, 'descend'));
title('Ranked Class CGPA');
xlabel('Rank');
ylabel('CGPA');
grid on;
saveas(f6, 'StairPlot.png');

disp('Question 2 execution and plotting completed.');


% CONVERSION FUNCTION FOR MARKS TO GRADE POINTS
function gp = convertMarksToGP(marks)
    gp = zeros(size(marks));
    for k = 1:length(marks)
        m = marks(k);
        if m >= 80,      gp(k) = 5.0;
        elseif m >= 75,  gp(k) = 4.5;
        elseif m >= 70,  gp(k) = 4.0;
        elseif m >= 65,  gp(k) = 3.5;
        elseif m >= 60,  gp(k) = 3.0;
        elseif m >= 55,  gp(k) = 2.5;
        elseif m >= 50,  gp(k) = 2.0;
        else,            gp(k) = 1.5;
        end
    end
end
