# check if file cfg/yolov3-voc.cfg is correct
cd ~/darknet_AlexeyAB/ #build/darknet/x64

./darknet detector train ~/img2pano_distortion/yolo_tests/train_voc/voc_train_orig.data ~/img2pano_distortion/yolo_tests/train_voc/yolov3-voc.cfg darknet53.conv.74

cp ~/img2pano_distortion/yolo_tests/train_voc/backup_orig/yolov3-voc_final.weights ~/img2pano_distortion/yolo_tests/train_voc/yolov3_orig_final.weights

read -n1 -r -p "Press space to continue..." key




