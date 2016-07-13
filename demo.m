%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Demo script for converting the WIDER faces database
% to a Pascal VOC devkit-style folder structure.

% Uncomment the next line and set path to WIDER root folder
% widerRootDir = 'path/to/wider/root'; 

% As a sanity check, visualize some annotations
visualizeWider(widerRootDir, 'train');

% Uncomment following line and set path to target folder location
% widerDevkitDir = 'target/path/to/wider/devkit-style/root';

% create new folder structure 
% (takes a couple of mins to generate the xml annotations)
wider2pascal(widerRootDir, widerDevkitDir);