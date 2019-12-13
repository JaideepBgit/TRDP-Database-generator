# from voc_label import convert
import xml.etree.ElementTree as ET
import pickle
import os
from os import listdir, getcwd
from os.path import join


# read all images in a folder and create file with paths
cwd = os.getcwd()
path = '/home/pcl/img2pano_distortion/results/JPEGImages/'
# path = '/home/pcl/VOC/VOCdevkit/VOC2012/JPEGImages/'

file_names = os.listdir(path)
file_names.sort()
file_names_w_path = [path + s for s in file_names] # add path as a prefix

list_file = open('/home/pcl/img2pano_distortion/yolo_tests/' + 'dist_0.3_VOC2007_test.txt', 'w')
# list_file = open('/home/pcl/img2pano_distortion/' + 'orig_VOC2012_list.txt', 'w')

list_file.write('\n'.join(file_names_w_path))

