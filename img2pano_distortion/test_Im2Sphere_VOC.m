%% pcl: test im2Sphere function for VOC images
clear all;
close all;

%%%%%%%%%%%%%%%%% path operations
% add Pano2Context and VOC paths
% addpath('/PanoBasic');
cd('../PanoBasic')
add_path; % Pano2Context functions
cd('../img2pano_distortion')
addpath([ '../VOCdevkit/VOCcode']);

%%%%%%%%%%%%%%%%%% common parameters
sphereH = 1500;
sphereW = 2 * sphereH; % indicated by im2Sphere documentation
imHoriFOV = pi/2;
% set position of the center of the image in the panorama
%ratio_X_shift = 0;
%ratio_Y_shift_array = -0.9:0.05:0.25;

%%%%%%%%%%%%%%%%% input/output paths
VOC_path = '/Users/jaideep/Documents/UAM/TRDP/code/SphereNet-pytorch-master/spherenet/trdp_database_code_org_copy/VOCdevkit/VOC2012';
results_path = '/Users/jaideep/Documents/UAM/TRDP/code/SphereNet-pytorch-master/spherenet/trdp_database_code_org_copy/VOCdevkit/VOC2012/results_Yshift/VOC2012';
dataset_file_ext =2;
img2pano_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,dataset_file_ext)


% %%%%%%%%%%%%%%%%% input/output paths
% VOC_path = '/home/pcl/darknet_AlexeyAB/build/darknet/x64/data/voc/VOCdevkit/VOC2007/';
% results_path = '~/img2pano_distortion/results_Yshift/VOC2007/';
% 
% for ind_ratio_Y_shift=1:numel(ratio_Y_shift_array)
%     img2pano_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,ratio_X_shift,ratio_Y_shift_array(ind_ratio_Y_shift))
% end








