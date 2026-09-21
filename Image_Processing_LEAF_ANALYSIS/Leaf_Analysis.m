% Clean working environment
clear; clc; close all;

% 1. CREATE BIOLOGY EXCEL SHEET
excelFile = 'leaf_properties.xlsx';
inputFolder = 'Leaves';         % <--- Folder where your original photos are
outputFolder = 'ProcessedImages'; % <--- Folder where processed photos will go

imageFiles = {'img01_banana.png'; 'img02_cassava.png'; 'img03_coffee.png'; 'img04_solanum.png'; 'img05_jackfruit.png'; 'img06_hazelnut.png'; 'img07_pterygota.png'; 'img08_duranta.png'; 'img09_jatropha.png'; 'img10_sida.png'; 'img11_solanum_incanum.png'; 'img12_peanut.png'; 'img13_eggplant.png'; 'img14_oleander.png'; 'img15_silky_oak.png'; 'img16_malvaceae.png'; 'img17_mulberry.png'; 'img18_mango.png'; 'img19_neem.png'; 'img20_yam.png'};
leafTypes  = {'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Compound'; 'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Compound'; 'Simple'; 'Simple'; 'Compound'; 'Simple'; 'Simple'; 'Simple'; 'Compound'; 'Simple'};
venations  = {'Parallel'; 'Palmate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Palmate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Parallel-like'; 'Pinnate'; 'Palmate'; 'Palmate'; 'Pinnate'; 'Pinnate'; 'Palmate'};
margins    = {'Entire'; 'Deeply Lobed'; 'Entire (Wavy)'; 'Lobed'; 'Entire'; 'Serrate'; 'Entire'; 'Serrate'; 'Lobed'; 'Serrate'; 'Lobed/Sinuate'; 'Entire'; 'Lobed'; 'Entire'; 'Deeply Cleft'; 'Serrate'; 'Serrate/Dentate'; 'Entire'; 'Serrate'; 'Entire'};
shapes     = {'Oblong'; 'Palmatipartite'; 'Elliptic'; 'Ovate'; 'Obovate'; 'Ovate-Cordate'; 'Oblong-Elliptic'; 'Elliptic'; 'Cordate/Palmate'; 'Oblong'; 'Ovate'; 'Obovate'; 'Ovate'; 'Linear-Lanceolate'; 'Pinnatifid'; 'Cordate'; 'Ovate'; 'Lanceolate'; 'Lanceolate'; 'Cordate'};
phyllotaxy = {'Radical'; 'Alternate'; 'Opposite'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Opposite'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Whorled'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'};
apexes     = {'Obtuse'; 'Acuminate'; 'Acuminate'; 'Acute'; 'Obtuse'; 'Acute'; 'Acute'; 'Acute'; 'Acute'; 'Acute'; 'Obtuse'; 'Rounded'; 'Acute'; 'Acute'; 'Acute'; 'Acute'; 'Acuminate'; 'Acute'; 'Acuminate'; 'Acuminate'};
textures   = {'Glabrous/Waxy'; 'Glabrous'; 'Coriaceous/Shiny'; 'Pubescent'; 'Coriaceous'; 'Pubescent/Rough'; 'Glabrous'; 'Glabrous'; 'Glabrous'; 'Pubescent'; 'Pubescent/Prickly'; 'Glabrous'; 'Pubescent'; 'Coriaceous/Leathery'; 'Glabrous'; 'Pubescent'; 'Rough/Scabrous'; 'Coriaceous'; 'Glabrous'; 'Glabrous/Waxy'};

propTable = table(imageFiles, leafTypes, venations, margins, shapes, phyllotaxy, apexes, textures, ...
    'VariableNames', {'originalImage', 'LeafType', 'venetion', 'margin', 'shape', 'phyllotaxy', 'apex', 'texture'});

writetable(propTable, excelFile);
fprintf('Excel file successfully created for %d leaf types.\n', height(propTable));

% Automatically create the output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 2. READ EXCEL DATA AND PROCESS IMAGES
leavesData = table2struct(propTable); 

for i = 1:length(leavesData)
    % Grab the filename from our list (e.g., 'img01_banana.png')
    currentImageName = leavesData(i).originalImage;
    
    % Combine folder name and filename to create the path (e.g., 'Leaves/img01_banana.png')
    inputPath = fullfile(inputFolder, currentImageName);
    
    imgOriginal = imread(inputPath);
    imgGray = rgb2gray(imgOriginal);
    thresholdValue = graythresh(imgGray);
    imgBinary = imbinarize(imgGray, thresholdValue);
    
    % Direct the processed image into the 'ProcessedImages' folder
    outputName = fullfile(outputFolder, strrep(currentImageName, '.png', '-processed.png'));
    imwrite(imgBinary, outputName);
end
fprintf('All images successfully processed! Stored in "%s".\n', outputFolder);
