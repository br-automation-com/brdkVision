# brdkVision
brdkVision libraries

This repository contains many different vision libraies for the PLC.

It also contains a solution to show images with overlay on mappView. 

## Use widget
To use the widget you need to copy the "brdk" folder from the mapp View widget folder into the same folder of you AS project and then restart AS.

![image](https://user-images.githubusercontent.com/36692577/176134242-2c4f525f-f2f1-4be3-b9a0-d789f5d263d8.png)

## Use Libraires
Each of the brdkVi libraries have a have a help file with some documentation for the functions and function blocks

* **brdkViBase** - This library contains base functions to be used in vision applications
* **brdkViImg** - This library contains functions for decoding and encoding image data to and from different types and show image on HMI widget (Depends on brdkViBase and BRSE_RTK)
* **brdkViGeom** - This library contains functions for drawing and checking geometries (Depends on brdkViBase and brdkViCal)
* **brdkViMapp** - This library contains functions to get and set vision function data (Depends on brdkViBase and brdkViCal)
* **brdkViVF** - This library contains functions for shaping BLOBs used in vision functions (Depends on brdkViBase, brdkViImg, brdkViCal, brdkViGeom)
* **brdkViCal** - This library contains functions to calibrate camera and calculate projection matrices (Depends on brdkViBase)
* **BRSE_RTK** - This library gives you access to fundamental system functionality 

The libraris can be found in the export folder

## brdkServices 
The project also contains a folder called brdkServices this is **not** need but it contains a Python script to create referenced configurations of an exsisting configuration in your project.

![image](https://user-images.githubusercontent.com/36692577/176138493-00d7701b-e772-4cdd-9349-9c26ae1d949a.png)






