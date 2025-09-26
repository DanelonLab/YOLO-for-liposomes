# YOLO-for-liposomes
Training and testing the neural network model YOLO for the segmentation and classification of liposomes from microscopy images
# Training and testing YOLO

## Purpose

Google Colab notebook for training and testing YOLO (e.g., YOLOv7-tiny) in the detection of liposomes from fluorescence microscopy images. Two applications were tested: identification of liposome-like objects, classification of different phenotypes in a liposome population. 

This code was developed by: https://github.com/theAIGuysCode/YOLOv3-Cloud-Tutorial, and adjusted by the Danelon Lab.

## Installation of the required software for image analysis using YOLO

_Last update: December 2022_

**Requirements for YOLO** (retrieved in December 2022 from: https://github.com/AlexeyAB/darknet#requirements-for-windows-linux-and-macos):
- CUDA >= 10.2
- OpenCV >= 2.4
- cuDNN >= 8.0.2
- GPU with CC >= 3.0 (but you can also run without GPU)

1.	**Install Visual Studio 2019** (tutorial: https://www.youtube.com/watch?v=mwN8CuazY9E)
Visual Studio 2019 was installed with ‘Desktop development with C++’ and ‘.NET desktop development’.

2.	**Install CUDA** (tutorial: https://www.youtube.com/watch?v=2TcnIzJ1RQs)
The version of CUDA that needs to be installed depends on the GPU. To find the correct CUDA version, check https://en.wikipedia.org/wiki/CUDA.
Quadro RTX 4000 > Compute capability 7.5 (Turing) > CUDA SDK 10.0 – 10.2. CUDA 10.2 was installed.

3.	**Install cuDNN** (tutorial: https://www.youtube.com/watch?v=2TcnIzJ1RQs) 
cuDNN >= 8.0.2 https://developer.nvidia.com/rdp/cudnn-archive, on Windows follow steps described here https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#installwindows). 
cuDNN version 8.0.2 was installed.

4.	**Install OpenCV** (tutorial: https://www.youtube.com/watch?v=wBtiGTToVEE&t=295s)
OpenCV version: 4.2.0 was installed.

5.	**Make solution using Visual Studio 2019** (tutorial: https://www.youtube.com/watch?v=wBtiGTToVEE&t=295s)
There is a ‘gpu’ and ‘no gpu’ version that can be built as two separate exe files.
Check supported sm variation here: https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/.

6.	Lastly, the batch scripts for automated image analysis by YOLO require the installation of **ImageMagick** from https://imagemagick.org/script/download.php. Version ‘ImageMagick-7.1.1-18-Q16-HDRI-x64-dll.exe’ was downloaded.

## How to run the code

1.	Copy all required files to a folder in your Google Drive (listed below).
2.	In the first line of the code, define the path to your folder.
3.	Run the code.
4.	After training, test the model using various detection thresholds (-thresh parameter) to obtain the corresponding precision and recall values. Choose a suitable threshold based on the tradeoff between precision and recall.

## Required files
-	Create an empty folder named ‘backup’, where the training weights will be stored after every 1000 epochs
-	obj.data
-	obj.names
-	obj.zip
-	val.zip
-	yolov7-tiny-training.cfg (or similar)
-	generate_train.py
-	generate_test.py

You can find the required files (to be adjusted to your application) in the two subfolders.

## Explanation of required files

#### obj.data
contains number of classes and directions to files. Adjust only the number of classes and the path to the backup folder.

#### obj.names
contains list of class names.

#### obj.zip and val.zip
contain jpg images and txt files with bounding box labels for training and testing, respectively. Two corresponding jpg and txt files should have the same name. Example:

<img width="142" height="95" alt="image" src="https://github.com/user-attachments/assets/5561a1b5-0eca-4d3c-a953-e9b89c5b7631" />

These files can be created with labelling software, for example Label Studio (https://labelstud.io). Example of file:

<img width="270" height="180" alt="image" src="https://github.com/user-attachments/assets/f012c5a2-f42e-4ee3-8187-91e3b5f17662" />

The _input_ labelled data for training YOLO is the in following format: **class x y width height**

#### Image
YOLO default image input size is 640x640 pixels. When using large resolution images or detecting very small objects, increasing the width and height values in the .cfg file is recommended, at the cost of resources. 
Alternatively, large images can be sectioned into smaller sized tiles. An ImageJ/FIJI macro for cropping large images into 512X512 pixels sized tiles is provided.

-	with _class_ being the number of the class (e.g., 0, 1, 2, ...)
-	with _x_ and _y_ being the center xy coordinate of the bounding box, normalized from 0 to 1 relative to the image size
-	with _width_ and _height_ being the width and height of the bounding box, normalized from 0 to 1 relative to the image size

The _output_ bounding box data is in the following format: **class x y width height**
-	with _class_ being the name of the class and its probability
-	with _x_ and _y_ being the top left xy coordinate of the bounding box, in pixels
-	with _width_ and _height_ being the width and height of the bounding box, in pixels


#### yolov7-tiny-training.cfg
The configuration file is specific for the YOLO version. You can download the configuration files here: https://github.com/AlexeyAB/darknet/tree/master/cfg. Here, we use YOLOv7-tiny as example. Open the .cfg file with TextEdit, Notepad, Visual Code Studio or any other software where you can edit the content. The configuration files contain the following information that can be adjusted:
1.	If not already, comment (add # before line) the first lines with “**batch**” and “**subdivisions**” and uncomment (remove #) “batch=64” and the second lines with “**batch**” and “**subdivisions**”. Example:

<img width="172" height="131" alt="image" src="https://github.com/user-attachments/assets/262f9553-e469-4fc6-8445-717ac4f61620" />

2.	Set **max_batches** to 2000*number of classes, but not less than number of training images and not less than 6000.
3.	Change **steps** to 80% and 90% of max_batches, i.e., steps=4800,5400 if max_batches is 6000.
4.	Change **classes**=80 to your number of classes. Do this **in each of 3 [yolo]-layers**. (With Ctrl-F, search for “yolo” or “classes”).
5.	Change [filters=255] to **filters=(classes + 5)x3** in the 3 [convolutional] before each [yolo] layer, keep in mind that it only has to be the **last [convolutional] before each of the [yolo] layers**. So if classes=1 then should be filters=18. If classes=2 then write filters=21. (Do not write in the cfg-file: filters=(classes + 5)x3).

Optionally change:
1.	Width and height
2.	Data augmentation
- Hue: If you want to train based on colors, set to 0 instead of 0.1 to disable color augmentation
- Saturation, set to 0 instead of 1.5 to disable saturation augmentation
- Exposure, set to 0 instead of 1.5 to disable exposure (brightness) augmentation
- Angle. Augment image by rotation up to this angle (in degree). By default, the degree of angle is 0.
3.	Random. Yolo resizes networks size (input and output) for each 10 iterations if random=1 to make the model robust for different image sizes. If random=1, images will be scaled up and down so YOLO is trained on different image sizes. Random set to 0 leads to faster training time and might solve “out of memory” error.

For more information and FAQs:
-	https://medium.com/nerd-for-tech/yolo-v2-configuration-file-explained-879e2219191
-	https://www.ccoderun.ca/programming/2020-09-25_Darknet_FAQ/
