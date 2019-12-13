
years='2012 2007'
tests='-0.25 -0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2 0.25'

# files with training and val lists 
rm ~/img2pano_distortion/results_Yshift/train_only.txt
rm ~/img2pano_distortion/results_Yshift/train.txt
rm ~/img2pano_distortion/results_Yshift/val.txt
rm ~/img2pano_distortion/results_Yshift/test.txt

touch ~/img2pano_distortion/results_Yshift/train_only.txt
touch ~/img2pano_distortion/results_Yshift/train.txt
touch ~/img2pano_distortion/results_Yshift/val.txt
touch ~/img2pano_distortion/results_Yshift/test.txt

for year in $years
do
	for test in $tests
	do
	
	echo 'Test: '$year' '$test # repeat for all distorted sets
	
		# copy ImageSets folder to the appropiate folder
		# fails trying to write detection results in a different folder
		rm -rf ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/ImageSets/
		cp -r ~/VOCdevkit/VOC$year/ImageSets ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/ImageSets/

		# voc_label
		python3 ~/img2pano_distortion/voc_label_folders.py ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/ $year

		# fill training and val lists (train includes validation lists)	 	
		cat ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/$year\_train.txt >> ~/img2pano_distortion/results_Yshift/train_only.txt
		cat ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/$year\_train.txt >> ~/img2pano_distortion/results_Yshift/train.txt
		cat ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/$year\_val.txt >> ~/img2pano_distortion/results_Yshift/val.txt
		cat ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/$year\_val.txt >> ~/img2pano_distortion/results_Yshift/train.txt

		if [ $year = '2007' ]; then
			cat ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/$year\_test.txt >> ~/img2pano_distortion/results_Yshift/test.txt
		fi

	done
done

read -n1 -r -p "Press space to continue..." key





