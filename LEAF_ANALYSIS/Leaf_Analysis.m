% Clean working environment
clear;
clc;
close all;

% 1. AUTOMATICALLY CREATE BIOLOGY EXCEL SHEET
excelFile = 'leaf_properties.xlsx';
imageFolder = 'Leaves'; % Target folder leaves are stored

fprintf('Step 1: Generating expanded botanical database sheet...\n');

% Expanded descriptive properties for Senior 4 Biology classification
imageFiles    = {'img01_banana.png'; 'img02_cassava.png'; 'img03_coffee.png'; 'img04_solanum.png'; 'img05_jackfruit.png'; 'img06_hazelnut.png'; 'img07_pterygota.png'; 'img08_duranta.png'; 'img09_jatropha.png'; 'img10_sida.png'; 'img11_solanum_incanum.png'; 'img12_peanut.png'; 'img13_eggplant.png'; 'img14_oleander.png'; 'img15_silky_oak.png'; 'img16_malvaceae.png'; 'img17_mulberry.png'; 'img18_mango.png'; 'img19_neem.png'; 'img20_yam.png'};
leafTypes     = {'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Compound'; 'Simple'; 'Simple'; 'Simple'; 'Simple'; 'Compound'; 'Simple'; 'Simple'; 'Compound'; 'Simple'; 'Simple'; 'Simple'; 'Compound'; 'Simple'};
venations     = {'Parallel'; 'Palmate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Palmate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Pinnate'; 'Parallel-like'; 'Pinnate'; 'Palmate'; 'Palmate'; 'Pinnate'; 'Pinnate'; 'Palmate'};
margins       = {'Entire'; 'Deeply Lobed'; 'Entire (Wavy)'; 'Lobed'; 'Entire'; 'Serrate'; 'Entire'; 'Serrate'; 'Lobed'; 'Serrate'; 'Lobed/Sinuate'; 'Entire'; 'Lobed'; 'Entire'; 'Deeply Cleft'; 'Serrate'; 'Serrate/Dentate'; 'Entire'; 'Serrate'; 'Entire'};
shapes        = {'Oblong'; 'Palmatipartite'; 'Elliptic'; 'Ovate'; 'Obovate'; 'Ovate-Cordate'; 'Oblong-Elliptic'; 'Elliptic'; 'Cordate/Palmate'; 'Oblong'; 'Ovate'; 'Obovate'; 'Ovate'; 'Linear-Lanceolate'; 'Pinnatifid'; 'Cordate'; 'Ovate'; 'Lanceolate'; 'Lanceolate'; 'Cordate'};
phyllotaxy    = {'Radical'; 'Alternate'; 'Opposite'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Opposite'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Whorled'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'; 'Alternate'};
apexes        = {'Obtuse'; 'Acuminate'; 'Acuminate'; 'Acute'; 'Obtuse'; 'Acute'; 'Acute'; 'Acute'; 'Acute'; 'Acute'; 'Obtuse'; 'Rounded'; 'Acute'; 'Acute'; 'Acute'; 'Acute'; 'Acuminate'; 'Acute'; 'Acuminate'; 'Acuminate'};
textures      = {'Glabrous/Waxy'; 'Glabrous'; 'Coriaceous/Shiny'; 'Pubescent'; 'Coriaceous'; 'Pubescent/Rough'; 'Glabrous'; 'Glabrous'; 'Glabrous'; 'Pubescent'; 'Pubescent/Prickly'; 'Glabrous'; 'Pubescent'; 'Coriaceous/Leathery'; 'Glabrous'; 'Pubescent'; 'Rough/Scabrous'; 'Coriaceous'; 'Glabrous'; 'Glabrous/Waxy'};

% Build table matrix structure
propTable = table(imageFiles, leafTypes, venations, margins, shapes, phyllotaxy, apexes, textures, ...
    'VariableNames', {'imageFiles', 'LeafType', 'VenationPattern', 'LeafMargin', 'LeafShape', 'Phyllotaxy', 'LeafApex', 'SurfaceTexture'});

% Write to working folder directory
writetable(propTable, excelFile);
fprintf('Successfully built Excel database: "%s"\n\n', excelFile);

% 2. READ EXCEL DATA AND PERFORM IMAGE PROCESSING ONRAMP ROUTINES
fprintf('Step 2: Parsing sheet values and executing image analysis from folder "%s"...\n', imageFolder);
leafTable = readtable(excelFile, 'TextType', 'string');

% Setup data structure array layout
leafDataset = struct();

for i = 1:height(leafTable)
    baseFileName = leafTable.imageFiles(i);
    % Combine folder name and filename to create the full path (e.g., 'Leaves/img01_banana.png')
    fullFilePath = fullfile(imageFolder, baseFileName); 
    imgIndexStr = sprintf('%02d', i);
    
    % Store structural variables from spreadsheet
    leafDataset(i).ID              = ['img', imgIndexStr];
    leafDataset(i).Label           = strrep(strrep(char(baseFileName), '.png', ''), ['img', imgIndexStr, '_'], '');
    leafDataset(i).LeafType        = char(leafTable.LeafType(i));
    leafDataset(i).VenationPattern = char(leafTable.VenationPattern(i));
    leafDataset(i).LeafMargin      = char(leafTable.LeafMargin(i));
    leafDataset(i).LeafShape       = char(leafTable.LeafShape(i));
    leafDataset(i).Phyllotaxy      = char(leafTable.Phyllotaxy(i));
    leafDataset(i).LeafApex        = char(leafTable.LeafApex(i));
    leafDataset(i).SurfaceTexture  = char(leafTable.SurfaceTexture(i));
    
    if exist(fullFilePath, 'file') == 2
        % Read original photo from the Leaves/ subfolder
        rgbImg = imread(char(fullFilePath));
        
        % Onramp Processing Suite
        grayImg = rgb2gray(rgbImg);
        binImg  = imbinarize(grayImg);
        binImgClean = bwareaopen(binImg, 150); % Filter micro noise fragments
        
        % Extract Area metrics
        stats = regionprops(binImgClean, 'Area', 'Perimeter');
        if ~isempty(stats)
            [~, maxIdx] = max([stats.Area]);
            leafDataset(i).Area = stats(maxIdx).Area;
            leafDataset(i).Perimeter = stats(maxIdx).Perimeter;
        else
            leafDataset(i).Area = NaN;
            leafDataset(i).Perimeter = NaN;
        end
        
        % Save image state matrices inside struct row block
        leafDataset(i).OriginalImage = rgbImg;
        leafDataset(i).GrayImage     = grayImg;
        leafDataset(i).BinaryImage   = binImgClean;
    else
        % Fallbacks if localized file missing
        fprintf('Warning: Could not find "%s"\n', fullFilePath);
        leafDataset(i).OriginalImage = [];
        leafDataset(i).GrayImage     = [];
        leafDataset(i).BinaryImage   = [];
        leafDataset(i).Area          = NaN;
        leafDataset(i).Perimeter     = NaN;
    end
end
save('S4_Expanded_Leaf_Database.mat', 'leafDataset');

% 3. INTERACTIVE VISUAL INSPECTION DASHBOARD
fprintf('\nStep 3: Launching Visual Inspection Dashboard...\n');
fprintf('Showing leaves in batches of 5 to preserve screen layout readability.\n');

leavesPerWindow = 5;
totalLeaves = numel(leafDataset);
numWindows = ceil(totalLeaves / leavesPerWindow);

for w = 1:numWindows
    fig = figure('Name', sprintf('Leaf Processing Dashboard - Batch %d', w), ...
                 'NumberTitle', 'off', 'Position', [100, 100, 1100, 850]);
    
    startIdx = (w-1) * leavesPerWindow + 1;
    endIdx = min(w * leavesPerWindow, totalLeaves);
    activeCount = endIdx - startIdx + 1;
    
    rowCounter = 1;
    for idx = startIdx:endIdx
        % Verify if image files are present before drawing plots
        if ~isempty(leafDataset(idx).OriginalImage)
            % Plot 1: Original Image
            subplot(activeCount, 4, (rowCounter-1)*4 + 1);
            imshow(leafDataset(idx).OriginalImage);
            title(sprintf('[%s] %s', leafDataset(idx).ID, upper(leafDataset(idx).Label)), 'FontSize', 10);
            
            % Plot 2: Grayscale Transform Image
            subplot(activeCount, 4, (rowCounter-1)*4 + 2);
            imshow(leafDataset(idx).GrayImage);
            title('Grayscale Matrix', 'FontSize', 9);
            
            % Plot 3: Binarized Isolated Mask Image
            subplot(activeCount, 4, (rowCounter-1)*4 + 3);
            imshow(leafDataset(idx).BinaryImage);
            title('Binary Segmentation Mask', 'FontSize', 9);
            
            % Plot 4: Dynamic Biology & Extraction Text Card Window Area
            subPlt = subplot(activeCount, 4, (rowCounter-1)*4 + 4);
            axis off;
            
            % Format detailed info text string block
            % Column 1: Botanical Properties
        infoTextCol1 = sprintf(...
            ['\\bfBotanical Properties:\\rm\n', ...
            '• Type: %s\n', ...
            '• Venation: %s\n', ...
            '• Margin: %s\n', ...
            '• Shape: %s\n', ...
            '• Phyllotaxy: %s\n', ...
            '• Apex: %s\n', ...
            '• Texture: %s'], ...
            leafDataset(idx).LeafType, ...
            leafDataset(idx).VenationPattern, ...
            leafDataset(idx).LeafMargin, ...
            leafDataset(idx).LeafShape, ...
            leafDataset(idx).Phyllotaxy, ...
            leafDataset(idx).LeafApex, ...
            leafDataset(idx).SurfaceTexture);
            % Column 2: Onramp Metrics
        infoTextCol2 = sprintf(...
            ['\\bfOnramp Metrics:\\rm\n', ...
            '• Pixel Area: %d px\n', ...
            '• Perimeter: %.1f px'], ...
            int32(leafDataset(idx).Area), ...
            leafDataset(idx).Perimeter);

        % Render Column 1 (Left side - X: 0.05)
             text(0.05, 0.5, infoTextCol1, 'FontSize', 9.5, 'VerticalAlignment', 'middle', 'Interpreter', 'tex');
    
       % Render Column 2 (Right side - X: 0.55)
           text(0.55, 0.5, infoTextCol2, 'FontSize', 9.5, 'VerticalAlignment', 'middle', 'Interpreter', 'tex');

        else
            % Display warning text inside block array index if files missing
            subplot(activeCount, 4, (rowCounter-1)*4 + 1); axis off;
            text(0.1, 0.5, sprintf('Image %s missing in Leaves/', leafDataset(idx).ID), 'Color', 'r');
        end
        rowCounter = rowCounter + 1;
    end
end
fprintf('\nAll dashboards generated successfully! Review your figure windows to view images alongside properties.\n');
