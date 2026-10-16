% QTN1_Group12_Loops.m - Student Demographics (Full 10-Plot Loop Edition)
clear; clc; close all;

excelFile = 'STUDENT_DATA.xlsx'; 

% 1. CONTROL STRUCTURE: IF statement to manage spreadsheet template file safely
if exist(excelFile, 'file') == 2
    fprintf('Notice: "%s" already exists, loading data layers...\n\n', excelFile);
else
    fprintf('Creating fresh data input table : "%s"...\n', excelFile);
    S_N         = (1:10)';
    FirstName   = {'DEBORAH'; 'MERCY LEAN'; 'PRETTY'; 'ERASMUS WANDERA'; 'JONAH'; 'SOLOMON JAMES'; 'ELVIS'; 'GIFT OLIVER'; 'LAWYERS'; 'JONATHAN'};
    LastName    = {'AKITENG'; 'AKWIR AUMA'; 'AUMA'; 'ELEPOT'; 'OPUS'; 'KINOBE'; 'BWIRE'; 'ACHENG'; 'OKOU'; 'OLINGA'};
    REG_NO      = {'BU/UP/2025/1531'; 'BU/UP/2025/1532'; 'BU/UP/2025/2109'; 'BU/UP/2025/2113'; 'BU/UP/2025/2142'; 'BU/UP/2025/3265'; 'BU/UP/2025/2110'; 'BU/UP/2025/5144'; 'BU/UP/2025/1560'; 'BU/UP/2025/1562'};
    AGE         = [43; 26; 32; 23; 23; 24; 25; 21; 22; 21];
    SEX         = {'F'; 'F'; 'F'; 'M'; 'M'; 'M'; 'F'; 'F'; 'M'; 'M'};
    STATUS      = {'MARRIED'; 'SINGLE'; 'MARRIED'; 'SINGLE'; 'SINGLE'; 'SINGLE'; 'MARRIED'; 'SINGLE'; 'SINGLE'; 'SINGLE'};
    TRIBE       = {'TESO'; 'LANGI'; 'LANGI'; 'TESO'; 'TESO'; 'BAGANDA'; 'BASOGA'; 'TESO'; 'LANGI'; 'TESO'};
    ASSOCIATION = {'TESDA'; 'NUSA'; 'NUSA'; 'TESDA'; 'TESDA'; 'NKOBAZAMBOGO'; 'BANSA'; 'TESDA'; 'NUSA'; 'TESDA'};
    HALL        = {'NJUKI'; 'NJUKI'; 'JAMAICA'; 'AC'; 'JAMAICA'; 'KINGS&QUEENS'; 'KINGS&QUEENS'; 'KINGS&QUEENS'; 'OBURU'; 'LOGIN'};
    FRIEND      = {'Raphael'; 'Allan'; 'Raphael'; 'Deborah'; 'Allan'; 'Allan'; 'Raphael'; 'Deborah'; 'Florence'; 'Herbert'};

    STUDENTDATA = table(S_N, FirstName, LastName, REG_NO, AGE, SEX, STATUS, TRIBE, ASSOCIATION, HALL, FRIEND);
    writetable(STUDENTDATA, excelFile);
end

% LOAD REVISED DATA AND PREPARE VARIABLES
fprintf('Importing updated Excel data back into MATLAB...\n');
studentData = readtable(excelFile);
numStudents = height(studentData);
SN = studentData.S_N;
Age = studentData.AGE;

% 2. FOR loop calculating Gender with manual counters
maleCount = 0;
femaleCount = 0;

for idx = 1:numStudents
    if strcmp(studentData.SEX{idx}, 'M'),     maleCount = maleCount + 1;
    elseif strcmp(studentData.SEX{idx}, 'F'), femaleCount = femaleCount + 1;
    end
end
sexCounts = [maleCount; femaleCount];
sexCats = {'Male', 'Female'};

% 3. WHILE loop matching unique Association strings manually
assocList = {}; assocCounts = []; i = 1;
while i <= numStudents
    currentAssoc = studentData.ASSOCIATION{i}; found = false;
    for j = 1:length(assocList)
        if strcmp(assocList{j}, currentAssoc)
            assocCounts(j) = assocCounts(j) + 1; found = true; break;
        end
    end
    if ~found
        assocList{end+1} = currentAssoc; assocCounts(end+1) = 1;
    end
    i = i + 1;
end

% 4. FOR loop sorting Unique Residence Halls manually
hallList = {}; hallCounts = [];
for i = 1:numStudents
    currentHall = studentData.HALL{i}; found = false;
    for j = 1:length(hallList)
        if strcmp(hallList{j}, currentHall)
            hallCounts(j) = hallCounts(j) + 1; found = true; break;
        end
    end
    if ~found
        hallList{end+1} = currentHall; hallCounts(end+1) = 1;
    end
end

% 5. WHILE loop identifying Marital Status frequencies
statusList = {}; statusCounts = []; i = 1;
while i <= numStudents
    currentStatus = studentData.STATUS{i}; found = false;
    for j = 1:length(statusList)
        if strcmp(statusList{j}, currentStatus)
            statusCounts(j) = statusCounts(j) + 1; found = true; break;
        end
    end
    if ~found
        statusList{end+1} = currentStatus; statusCounts(end+1) = 1;
    end
    i = i + 1;
end

% ==================== GENERATING ALL 10 ASSIGNMENT PLOTS ====================
fprintf('Generating all 10 diagnostic figures using manual array paths...\n');

% Plot 1: Vertical Bar Chart for Association
f1 = figure('Name', 'Association_Distribution');
bar(categorical(assocList), assocCounts);
title('Student Distribution by Association'); xlabel('Student Association'); ylabel('Number of Students');
grid on; saveas(f1, 'Association_Bar.png');

% Plot 2: Horizontal Bar Chart for Residence
f2 = figure('Name', 'Residence_Distribution');
barh(categorical(hallList), hallCounts);
title('Student Distribution by Residence Hall'); xlabel('Number of Students'); ylabel('Residence Hall');
grid on; saveas(f2, 'Residence_BarH.png');

% Plot 3: Simple Pie Chart for Marital Status
f3 = figure('Name', 'Marital_Status_Pie');
pie(statusCounts, statusList);
title('Proportion of Students by Marital Status');
saveas(f3, 'Status_Pie.png');

% Plot 4: Pareto Chart for Associations
f4 = figure('Name', 'Association_Pareto');
pareto(assocCounts, categorical(assocList));
title('Pareto Analysis of Student Associations'); ylabel('Count / Cumulative Percentage');
grid on; saveas(f4, 'Pareto_Distribution.png');

% Plot 5: Histogram for Age Distribution
f5 = figure('Name', 'Age_Histogram');
histogram(Age);
title('Student Age Distribution'); xlabel('Age (Years)'); ylabel('Frequency');
grid on; saveas(f5, 'Age_Histogram.png');

% Plot 6: Standard Line Plot for Age
f6 = figure('Name', 'Line Plot');
plot(Age, 'o-');
title('Line Plot of Age'); xlabel('Student Index'); ylabel('Age');
grid on; saveas(f6, 'Line_Plot.png');

% Plot 7: Error Bar Plot for Age Variance by Gender
f7 = figure('Name', 'Error Bar Plot');
maleAges = []; femaleAges = [];
for idx = 1:numStudents
    if strcmp(studentData.SEX{idx}, 'M'),     maleAges(end+1) = Age(idx);
    elseif strcmp(studentData.SEX{idx}, 'F'), femaleAges(end+1) = Age(idx);
    end
end
meanAges = [mean(maleAges), mean(femaleAges)];
stdAges  = [std(maleAges),  std(femaleAges)];
errorbar([1, 2], meanAges, stdAges, 'd-', 'LineWidth', 1.5);
set(gca, 'XTick', [1, 2], 'XTickLabel', sexCats);
title('Age Variance by Gender'); xlabel('Gender'); ylabel('Age');
grid on; saveas(f7, 'Error_Plot.png');

% Plot 8: Box Plot for Age
f8 = figure('Name', 'Box Plot');
boxplot(Age);
title('Box Plot of Age Distribution');
grid on; saveas(f8, 'Box_Plot.png');

% Plot 9: Logarithmic Scale Plot for Age
f9 = figure('Name', 'Logarithmic Plot');
semilogy(SN, Age, 's-');
title('Semilogy Plot of Age'); xlabel('Student Index (S_N)'); ylabel('Age (Log Scale)');
grid on; saveas(f9, 'Logarithmic_Plot.png');

% Plot 10: Percentage Pie Chart for Gender
f10 = figure('Name', 'Gender_Pie_Chart');
pie(sexCounts, sexCats); 
title('Pie Chart of Student Distribution by Gender');
saveas(f10, 'Gender_Percent_Pie.png');

writetable(studentData, 'Group12.xlsx');
fprintf('Success: All 10 graphic panels compiled cleanly.\n');
