
years='2012 2007'
#tests='-0.25 -0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2 0.25'

# files with training and val lists 
rm ~/VOCdevkit/train_only.txt
rm ~/VOCdevkit/train.txt
rm ~/VOCdevkit/val.txt
rm ~/VOCdevkit/test.txt

touch ~/VOCdevkit/train_only.txt
touch ~/VOCdevkit/train.txt
touch ~/VOCdevkit/val.txt
touch ~/VOCdevkit/test.txt

for year in $years
do

	# copy ImageSets folder to the appropiate folder
	# fails trying to write detection results in a different folder
	# rm -rf ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/ImageSets/
	# cp -r ~/VOCdevkit/VOC$year/ImageSets ~/img2pano_distortion/results_Yshift/VOC$year/dist_$test/ImageSets/

	# voc_label
	python3 ~/img2pano_distortion/voc_label_folders.py ~/VOCdevkit/VOC$year/ $year

	# fill training and val lists (train includes validation lists)	 	
	cat ~/VOCdevkit/VOC$year/$year\_train.txt >> ~/VOCdevkit/train_only.txt
	cat ~/VOCdevkit/VOC$year/$year\_train.txt >> ~/VOCdevkit/train.txt
	cat ~/VOCdevkit/VOC$year/$year\_val.txt >> ~/VOCdevkit/val.txt
	cat ~/VOCdevkit/VOC$year/$year\_val.txt >> ~/VOCdevkit/train.txt

	if [ $year = '2007' ]; then
		cat ~/VOCdevkit/VOC$year/$year\_test.txt >> ~/VOCdevkit/test.txt
	fi

done

read -n1 -r -p "Press space to continue..." key





