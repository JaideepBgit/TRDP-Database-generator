cd ~/darknet_AlexeyAB/build/darknet/x64/ 

# test using yolo v2 (weights trained for VOC database), there are not weights for VOC in YOLOV3
./darknet detector test ./data/voc.data ./cfg/yolov2-voc.cfg ./yolo-voc.weights -ext_output < ./data/voc/2007_test.txt > ~/img2pano_distortion/yolo_tests/initial_tests/results_baseline_v2VOC_VOC2007.txt

# tests using yolo v3 (weights trained for COCO database)
# ./darknet detector test ./cfg/coco.data ./cfg/yolov3.cfg ./yolov3.weights -ext_output < ~/img2pano_distortion/yolo_tests/initial_tests/orig_VOC2007_test.txt > ~/img2pano_distortion/yolo_tests/initial_tests/results_baseline_v3COCO_VOC2007.txt
# ./darknet detector test ./cfg/coco.data ./cfg/yolov3.cfg ./yolov3.weights -ext_output < ~/img2pano_distortion/yolo_tests/initial_tests/dist_0.3_VOC2007_test.txt > ~/img2pano_distortion/yolo_tests/initial_tests/results_dist_0.3_v3COCO_VOC2007.txt
