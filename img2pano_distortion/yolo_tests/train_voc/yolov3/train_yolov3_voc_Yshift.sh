# check if file cfg/yolov3-voc.cfg is correct
cd ~/darknet_AlexeyAB/ # build/darknet/x64

# train
./darknet detector train ~/img2pano_distortion/yolo_tests/train_voc/voc_train_Yshift.data ~/img2pano_distortion/yolo_tests/train_voc/yolov3-voc.cfg darknet53.conv.74
# ~/img2pano_distortion/yolo_tests/train_voc/backup_Yshift/yolov3-voc_15200.weights

cp ~/img2pano_distortion/yolo_tests/train_voc/backup_Yshift/yolov3-voc_final.weights ~/img2pano_distortion/yolo_tests/train_voc/yolov3_Yshift_final.weights

read -n1 -r -p "Press space to continue..." key




