last_iter='50000'
step='1000'

dir=./yolov3/backup_Yshift/
new_dir=./yolov3/backup2_Yshift/

rm -rf $new_dir
mkdir $new_dir

for value in $( eval echo {$step..$last_iter..$step} )
do
	echo $value
	cp $dir/yolov3-voc_$value.weights $new_dir/yolov3-voc_$value.weights
done 
cp $dir/yolov3-voc_final.weights $new_dir/yolov3-voc_final.weights

rm -rf $dir
mv $new_dir $dir
