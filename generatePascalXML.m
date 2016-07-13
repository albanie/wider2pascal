function generatePascalXML(imgName, bboxList, targetName)
%GENERATEPASCALXML a Pascal VOC syntax annotation generator
%   GENERATEPASCALXML(IMGNAME, BBOXLIST, TARGETNAME) generates
%   Pascal VOC compatible XML annotations where
%
%   `imgName` is the name of the image file (to be stored in the
%       xml annotation.
%   
%   `bboxList` is an n x 4 array of bounding box locations where 
%       each row has the format:
%           [top left x, top left y, width, height]
%
%   `targetName` the name which the annotation is saved with 
%   (should inculde an xml suffix e.g. 'annotation_1.xml'.
%
%   NOTE: Annotation bounding box values are rounded to the 
%   nearest pixel
%
%   Author: Samuel Albanie

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% <?xml version="1.0" encoding="utf-8"?>
% <annotation>
%    <folder>WIDER</folder>
%    <filename>0_Parade_marchingband_1_849.jpg</filename>
%    <source>
%       <database>The WIDER Face database</database>
%       <annotation>WIDER</annotation>
%    </source>
%    <owner>
%       <name>Multimedia Lab, Dept of Info Eng,The Chinese University of Hong Kong</name>
%    </owner>
%    <object>
%       <name>face</name>
%       <bndbox>
%          <xmin>449</xmin>
%          <ymin>330</ymin>
%          <xmax>570</xmax>
%          <ymax>478</ymax>
%       </bndbox>
%    </object>
% </annotation>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hardcoded values for WIDER database
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
objectName = 'face';
imgFolder = 'WIDER';
databaseName = 'The WIDER Face database';
annotationType = 'WIDER';
ownerName = strcat('Multimedia Lab, Dept of Info Eng, ',...
    'The Chinese University of Hong Kong');

% annotation (document) element
docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
docRootNode = docNode.getDocumentElement;

% folder element
elem = docNode.createElement('folder');
elem.appendChild...
    (docNode.createTextNode(sprintf('%s', imgFolder)));
docRootNode.appendChild(elem);

% filename element
elem = docNode.createElement('filename');
elem.appendChild...
    (docNode.createTextNode(sprintf('%s', imgName)));
docRootNode.appendChild(elem);

% source element
sourceElem = docNode.createElement('source');
docRootNode.appendChild(sourceElem);

% database element
databaseElem = docNode.createElement('database');
databaseElem.appendChild...
    (docNode.createTextNode(sprintf('%s', databaseName)));
sourceElem.appendChild(databaseElem);

% annotation element
annotationElem = docNode.createElement('annotation');
annotationElem.appendChild...
    (docNode.createTextNode(sprintf('%s', annotationType)));
sourceElem.appendChild(annotationElem);

% owner element
elem = docNode.createElement('owner');
docRootNode.appendChild(elem);

% name element
ownerNameElem = docNode.createElement('name');
ownerNameElem.appendChild...
    (docNode.createTextNode(sprintf('%s', ownerName)));
elem.appendChild(ownerNameElem);

% Loop over bounding boxes to produce annotations
for i = 1:size(bboxList, 1)
    
    % convert from 
    %   (minX, minY, width, height) (WIDER format)
    % to -> 
    %   (minX, minY, maxX, maxY) (Pascal VOC format)
    xmin = bboxList(i,1);
    ymin = bboxList(i,2);
    xmax = bboxList(i,1) + bboxList(i,3);
    ymax = bboxList(i,2) + bboxList(i,4);
    
    % object element
    objectElem = docNode.createElement('object');
    docRootNode.appendChild(objectElem);
    
    % name element
    elem = docNode.createElement('name');
    elem.appendChild...
        (docNode.createTextNode(sprintf('%s', objectName)));
    objectElem.appendChild(elem);
    
    % bounding box element
    bboxElem = docNode.createElement('bndbox');
    objectElem.appendChild(bboxElem);
    
    elem = docNode.createElement('xmin');
    elem.appendChild...
        (docNode.createTextNode(sprintf('%d', round(xmin))));
    bboxElem.appendChild(elem);
    
    elem = docNode.createElement('ymin');
    elem.appendChild...
        (docNode.createTextNode(sprintf('%d', round(ymin))));
    bboxElem.appendChild(elem);
    
    elem = docNode.createElement('xmax');
    elem.appendChild...
        (docNode.createTextNode(sprintf('%d', round(xmax))));
    bboxElem.appendChild(elem);
    
    elem = docNode.createElement('ymax');
    elem.appendChild...
        (docNode.createTextNode(sprintf('%d', round(ymax))));
    bboxElem.appendChild(elem);
end

xmlwrite(targetName, docNode);
type(targetName);