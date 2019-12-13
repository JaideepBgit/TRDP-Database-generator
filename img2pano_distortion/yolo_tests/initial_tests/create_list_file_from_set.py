# from voc_label import convert
import xml.etree.ElementTree as ET
import pickle
import os
from os import listdir, getcwd
from os.path import join


# read all images in a folder and create file with paths
cwd = os.getcwd()
# path = '/home/pcl/img2pano_distortion/results/JPEGImages/'
path = '/home/pcl/VOC/'

sets=[('2007', 'test')]

# original set. Non- distorted
for year, image_set in sets:
    image_ids = open( path + 'VOCdevkit/VOC%s/ImageSets/Main/%s.txt'%(year, image_set)).read().strip().split()
    list_file = open('orig_VOC%s_%s.txt'%(year, image_set), 'w')
    for image_id in image_ids:
        list_file.write(path + 'VOCdevkit/VOC%s/JPEGImages/%s.jpg\n'%(year, image_id))
        #convert_annotation(year, image_id)
    list_file.close()



