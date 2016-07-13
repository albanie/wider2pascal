function visualizeWider(widerRootDir, partition)
%VISUALIZEWIDER displays WIDER images with annotations
%   VISUALIZEWIDER(widerRootDir) generates figures that
%   display the bounding box annotations provided with
%   the WIDER faces database
%
%   `widerRootDir` - a path to the WIDER dataset (contains
%       subfolders called WIDER_train, WIDER_val, WIDER_test
%       and wider_face_split
%
%   `partition` - the portion of the dataset to visualize
%   (can be "train" or "val")
%
%   Author: Samuel Albanie

% load data for partition
partitionData = load(fullfile(widerRootDir, ...
    'wider_face_split', ...
    sprintf('wider_face_%s.mat', ...
    partition)));

% create containers for the image paths and bounding boxes
imgList = {};
bboxList = {};

% Loop over WIDER "events"
for i = 1: numel(partitionData.event_list)
    eventImgList = cellfun(@(x) fullfile(widerRootDir, ...
        sprintf('WIDER_%s', partition), ...
        'images', ...
        partitionData.event_list{i}, ...
        strcat(x, '.jpg')), ...
        partitionData.file_list{i}, ...
        'UniformOutput', false);
    
    eventBboxList = partitionData.face_bbx_list{i};
    imgList = vertcat(imgList, eventImgList);
    bboxList = vertcat(bboxList, eventBboxList);
end

% Display annotations one image at a time
for i = 1:numel(imgList)
    
    % read in the image
    im = imread(imgList{i});
    
    % insert bounding boxes
    for j = 1: size(bboxList{i}, 1)
        im = insertShape(im, 'Rectangle', ...
            bboxList{i}(j,:), ...
            'LineWidth', 3);
    end
    
    % show image and wait for user
    imshow(im);
    disp('press any key to continue');
    pause;
end

