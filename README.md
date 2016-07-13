##wider2pascal

`wider2pascal` is a simple matlab script for converting the publicly available [WIDER faces database](http://mmlab.ie.cuhk.edu.hk/projects/WIDERFace/) into a simplified Pascal VOC devkit style structure.  It's a bit of a hack but it can be handy for getting up and running quickly with object detection libraries that are friendly to Pascal VOC style annotations (e.g. [py-faster-rcnn](https://github.com/rbgirshick/py-faster-rcnn)).  

To run the code, uncomment the file paths in `demo.m`.  

The resulting folder structure will look like this:

	WIDER_devkit/
		WIDER/
			Annotations/
				image_name1.xml
				...
			ImageSets/
				train.txt
				val.txt
			JPEGImages/
				image_name1.jpg
				....
				
**NOTES**: 

* Rather than save space with symlinks, this code keeps things simple and will duplicate the entire dataset on disk in the new folder structure (Note: the dataset is a few of GB in size).  
* Since annotations are only provided for the `train` and `val`  partitions (the `test` annotations are stored on a private evaluation server), only those partitions are used in the new folder structure.
* Only the bounding box annotations are used transferred from the WIDER meta data (other attributes such occlusion level are not used)				
