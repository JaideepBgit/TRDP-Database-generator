# TRDP-Database-generator
Spherical/Omnidirectional Images creation of various distortion and labelling.

Kindly download the required VOC dataset and VOCDevKit to generate the dataset.


Kindly download the PanoBasic Code in the link here: [PanoBasic](https://drive.google.com/drive/folders/1X2AB3FmeSr3eSPeiLO4CSWP-1iOdJKHd?usp=sharing), and save it in the folder where img2pano_distortion, else add path of this folder in the test_Im2Sphere_VOC.m matlab script.

**Running the code**
1. Kindly store the background images in the required path of the VOC dataset. (Create a file in VOC dataset and save it accordingly.)(Sample background images are given)(Format: jpg and Size: 1500x3000)
2. To generate the dataset kindly run test_Im2Sphere_VOC.m matlab script, after setting appropriate paths of the VOC dataset and path where the results should be saved to. 
3. You may give the maximum distortion in test_Im2Sphere_VOC.m to generate various distortion images. Negative distortion values can also be given to generate an inverted image, or continuous inverted image across the panorama depending on the  given distortion value.

