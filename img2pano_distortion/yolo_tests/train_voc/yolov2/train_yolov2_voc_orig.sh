# train with yolo v2 configuration to see if the same detection results to those provided are obtained
# check if file yolov2-voc.cfg is correct

train_dir=/home/vpu/img2pano_distortion/yolo_tests/train_voc  

cd ~/darknet_AlexeyAB/ #build/darknet/x64

./darknet detector train $train_dir/yolov2/voc_train_orig.data $train_dir/yolov2/yolov2-voc.cfg darknet53.conv.74

cp $train_dir/yolov2/backup_orig/yolov2-voc_final.weights $train_dir/yolov2/yolov2_orig_final.weights

read -n1 -r -p "Press space to continue..." key




