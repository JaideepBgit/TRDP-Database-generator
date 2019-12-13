cd ~/darknet_AlexeyAB/ # build/darknet/x64

tests='-0.25 -0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2 0.25'
VOC_path='~/VOCdevkit'

# original test dataset. Should have same mAP results to those reported for VOC
rm -rf ./results/
mkdir ./results/
./darknet detector valid ~/img2pano_distortion/yolo_tests/train_voc/voc_train_orig.data ~/img2pano_distortion/yolo_tests/train_voc/yolov3-voc.cfg ~/img2pano_distortion/yolo_tests/train_voc/yolov3_orig_final.weights 
	
# fails trying to write detection results in a different folder
rm -rf ~/img2pano_distortion/yolo_tests/train_voc/results_det/results_det_voc_orig_final/
cp -r ./results ~/img2pano_distortion/yolo_tests/train_voc/results_det/results_det_voc_orig_final/
	
# python script fails if one class presents 0 detections TODO: modify
python3 ~/img2pano_distortion/yolo_tests/train_voc/reval_voc_py3.py  --year 2007 --classes /home/vpu/img2pano_distortion/yolo_tests/train_voc/voc.names --image_set test --voc_dir /home/vpu/VOCdevkit/VOC2007/ /home/vpu/img2pano_distortion/yolo_tests/train_voc/results_det/results_det_voc_orig_final > ~/img2pano_distortion/yolo_tests/train_voc/results_det/mAP_results_orig_final.txt
 	
read -n1 -r -p "Press space to continue..." key

# distorted test dataset
for test in $tests
do
	echo 'Test '$test

	# labels and lists are already created
	# TODO: automatize the creation data file	
	# this version writes detection results to a results folder
	rm -rf ./results/
	mkdir ./results/
	./darknet detector valid ~/img2pano_distortion/yolo_tests/train_voc/voc_Yshift_$test.data ~/img2pano_distortion/yolo_tests/train_voc/yolov3-voc.cfg ~/img2pano_distortion/yolo_tests/train_voc/yolov3_Yshift_final.weights 
	
	# fails trying to write detection results in a different folder
	rm -rf ~/img2pano_distortion/yolo_tests/train_voc/results_det/results_det_voc_Yshift_$test\_final/
	cp -r ./results ~/img2pano_distortion/yolo_tests/train_voc/results_det/results_det_voc_Yshift_$test\_final/
	
	# python script fails if one class presents 0 detections TODO: modify
	python3 ~/img2pano_distortion/yolo_tests/train_voc/reval_voc_py3.py  --year 2007 --classes /home/vpu/img2pano_distortion/yolo_tests/train_voc/voc.names --image_set test --voc_dir /home/vpu/img2pano_distortion/results_Yshift/VOC2007/dist_$test/  /home/vpu/img2pano_distortion/yolo_tests/train_voc/results_det/results_det_voc_Yshift_$test\_final > ~/img2pano_distortion/yolo_tests/train_voc/results_det/mAP_results_dist_$test\_final.txt
 	
done

read -n1 -r -p "Press space to continue..." key





