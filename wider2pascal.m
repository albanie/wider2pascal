function wider2pascal(widerRootDir, widerDevkitDir)
%WIDER2PASCAL converts the WIDER database into Pascal format
%   WIDER2PASCAL(widerDir, targetDir) generates a folder
%   structure mimicking the Pascal VOC 2007 devkit format
%   containing faces from the WIDER database
%
%   `widerRootDir` is a path to the WIDER dataset (contains
%       subfolders called WIDER_train, WIDER_val, WIDER_test
%       and wider_face_split
%
%   `widerDevkitDir` is a path to where the new VOCdevkit-style
%       folder structure will be generated
%
%   The generated folder structure contains only the subset of
%   files required for bounding box object detection:
%
%   widerDekitDir /
%               WIDER /
%                   Annotations /
%                   JPEGImages /
%                   ImageSets /
%
%
%   Author: Samuel Albanie

% create the target subdirectories
annotationsDir = fullfile(widerDevkitDir, 'WIDER', 'Annotations');
jpegImagesDir = fullfile(widerDevkitDir, 'WIDER', 'JPEGImages');
imageSetsDir = fullfile(widerDevkitDir, 'WIDER', 'ImageSets');

% the data structures are identical for the training and
% validation sets (the annotations for the test set are
% not publicly available and so are not used here

generateAnnotations(widerRootDir, annotationsDir, 'train');
generateAnnotations(widerRootDir, annotationsDir, 'val');

copyImages(widerRootDir, jpegImagesDir, 'train');
copyImages(widerRootDir, jpegImagesDir, 'val');

generateImageSets(widerRootDir, imageSetsDir, 'train');
generateImageSets(widerRootDir, imageSetsDir, 'val');

%-------------------------------------------------------------------
function generateAnnotations(widerRootDir, annotationsDir, partition)
%------------------------------------------------------------------
% generate the Pascal VOC-style xml annotation files
% for the given partition

% make sure that target directory exists
if ~exist(annotationsDir, 'dir')
    mkdir(annotationsDir);
end

% load data for partition
partitionData = load(fullfile(widerRootDir, ...
    'wider_face_split', ...
    sprintf('wider_face_%s.mat', ...
    partition)));
% loop over WIDER events
for i = 1: numel(partitionData.event_list)
    
    % extract images and bounding box per event
    files = partitionData.file_list{i};
    bboxList = partitionData.face_bbx_list{i};
    
    % loop over the images associated with each event
    for j = 1:numel(files)
        imgName = strcat(files{j}, '.jpg');
        annotationFileName = fullfile(annotationsDir, ...
            strcat(files{j}, '.xml'));
        generatePascalXML(imgName, bboxList{j}, annotationFileName);
    end
end

%-------------------------------------------------------------------
function copyImages(widerRootDir, jpegImagesDir, partition)
%------------------------------------------------------------------
% Copy the files from seperate WIDER "events" into a single
% directory, Pascal-style.

% make sure that target directory exists
if ~exist(jpegImagesDir, 'dir')
    mkdir(jpegImagesDir);
end

% load data for partition
partitionData = load(fullfile(widerRootDir, ...
    'wider_face_split', ...
    sprintf('wider_face_%s.mat', ...
    partition)));

% loop over WIDER events
for i = 1: numel(partitionData.event_list)
    
    imgPaths = cellfun(@(x) fullfile(widerRootDir, ...
        sprintf('WIDER_%s', partition), ...
        'images', ...
        partitionData.event_list{i}, ...
        strcat(x, '.jpg')), ...
        partitionData.file_list{i}, ...
        'UniformOutput', false);
    
    % copy the images to the target folder
    for j = 1:numel(imgPaths)
        copyfile(imgPaths{j}, jpegImagesDir);
    end
end

%-------------------------------------------------------------------
function generateImageSets(widerRootDir, imageSetsDir, partition)
%------------------------------------------------------------------
% Write the names of the images in the training and validation
% sets to files named 'train.txt' and 'val.txt'

% make sure that target directory exists
if ~exist(imageSetsDir, 'dir')
    mkdir(imageSetsDir);
end

% load data for partition
partitionData = load(fullfile(widerRootDir, ...
    'wider_face_split', ...
    sprintf('wider_face_%s.mat', ...
    partition)));

% write to file
targetPath = fullfile(imageSetsDir, sprintf('%s.txt', partition));
files = vertcat(partitionData.file_list{:});
fileID = fopen(targetPath, 'w');
for i = 1:numel(files)
    fprintf(fileID, '%s\n', files{i});
end
fclose(fileID);