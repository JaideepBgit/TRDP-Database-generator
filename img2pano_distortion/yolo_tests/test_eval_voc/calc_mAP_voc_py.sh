# rem C:\Users\Alex\AppData\Local\Programs\Python\Python36\Scripts\pip install numpy
# rem C:\Users\Alex\AppData\Local\Programs\Python\Python36\Scripts\pip install cPickle
# rem C:\Users\Alex\AppData\Local\Programs\Python\Python36\Scripts\pip install _pickle
# rem darknet.exe detector valid data/voc.data cfg/yolov2-tiny-voc.cfg yolov2-tiny-voc.weights

cd ~/darknet_AlexeyAB/build/darknet/x64

tests='0 0.1 0.2 0.3 0.4 0.5'
VOC_path='/home/pcl/darknet_AlexeyAB/build/darknet/x64/data/voc'
for test in $tests
do
	echo 'Test '$test

	# copy ImageSet folder to the appropiate dir
	cp -Tr $VOC_path/VOCdevkit/VOC2007/ImageSets	/home/pcl/img2pano_distortion/results_loop/dist$test/VOCdevkit/VOC2007/ImageSets
	# read -n1 -r -p "Press space to continue..." key
	
	# create list file with voc_label
	python3 /home/pcl/img2pano_distortion/voc_label_input.py /home/pcl/img2pano_distortion/results_loop/dist$test
	python3 /home/pcl/img2pano_distortion/voc_label_difficult_input.py /home/pcl/img2pano_distortion/results_loop/dist$test 
	# read -n1 -r -p "Press space to continue..." key
	 
	# TODO: create data file	
	# this version writes detection results to a results folder
	./darknet detector valid /home/pcl/img2pano_distortion/yolo_tests/test_eval_voc/voc_dist$test.data ./cfg/yolov2-voc.cfg ./yolo-voc.weights
	
	# fails trying to write detection results in a different folder
	rm -rf ~/img2pano_distortion/yolo_tests/test_eval_voc/results_det_voc_dist$test/
	cp -r ./results ~/img2pano_distortion/yolo_tests/test_eval_voc/results_det_voc_dist$test/
	
	# python script fails if one class presents 0 detections
	python3 reval_voc_py3.py --year 2007 --classes ./data/voc.names --image_set test --voc_dir /home/pcl/img2pano_distortion/results_loop/dist$test/VOCdevkit ./results > ~/img2pano_distortion/yolo_tests/test_eval_voc/mAP_results_dist$test.txt
	
done

read -n1 -r -p "Press space to continue..." key





