# Evaluates detection results for: detection in VOC images distorted with different ratios, in 2 cases:
#   1. YOLO trained with distorted dataset
#   2. YOLO trained with original dataset

import numpy as np
import csv
import matplotlib.pyplot as plt

results_dir = '/home/vpu/img2pano_distortion/yolo_tests/train_voc/results_det/csv_results/'
file_basename_Yshift = 'results_det_voc_Yshift_'
file_basename_orig = 'results_det_voc_orig_'

dist_array = np.around(np.arange(-0.25,0.30,0.05),2)
iter_array = range(10000, 60000, 10000)
num_classes = 20

# AP for all distortions, classes, training iterations
AP_Yshift_matrix = np.zeros((num_classes, dist_array.size, len(iter_array)))
AP_orig_matrix = np.zeros((num_classes, dist_array.size, len(iter_array)))
# AP undistorted dataset: classes, training iterations
AP_undist_orig_matrix = np.zeros((num_classes, len(iter_array)))
AP_undist_Yshift_matrix = np.zeros((num_classes, len(iter_array)))

# mAP for all dists an iterations
mAP_Yshift_matrix = np.zeros((dist_array.size, len(iter_array)))
mAP_orig_matrix = np.zeros((dist_array.size, len(iter_array)))
# mAP for undistorted dataset. Along iterations
mAP_undist_orig_array = np.zeros(len(iter_array))
mAP_undist_Yshift_array = np.zeros(len(iter_array))
# print(mAP_matrix)

for iter_idx, iter in enumerate(iter_array):
    # print(iter)
    # computations for undistorted dataset
    # results for YOLOv3 in undistorted dataset (trained with undistorted also)
    csv_filename_orig_undist = results_dir + file_basename_orig + str(iter) + '.csv'
    with open(csv_filename_orig_undist, 'r') as f:
        reader = csv.reader(f, delimiter=';')
        AP_undist_orig_str_list = list(reader)
        AP_undist_orig_str_nparray = np.array(AP_undist_orig_str_list)
        AP_undist_orig_np_array = AP_undist_orig_str_nparray.astype(np.float)
        print(AP_undist_orig_np_array)
        # fill AP matrix
        AP_undist_orig_matrix[:, iter_idx] = np.transpose(AP_undist_orig_np_array).ravel()
        print(AP_undist_orig_matrix[:, iter_idx])
    # results for YOLOv3 in undistorted dataset (trained with distorted)
    csv_filename_Yshift_undist = results_dir + file_basename_Yshift + str(iter) + '.csv'
    with open(csv_filename_Yshift_undist, 'r') as f:
        reader = csv.reader(f, delimiter=';')
        AP_undist_Yshift_str_list = list(reader)
        AP_undist_Yshift_str_nparray = np.array(AP_undist_Yshift_str_list)
        AP_undist_Yshift_np_array = AP_undist_Yshift_str_nparray.astype(np.float)
        print(AP_undist_Yshift_np_array)
        # fill AP matrix
        AP_undist_Yshift_matrix[:, iter_idx] = np.transpose(AP_undist_Yshift_np_array).ravel()
        print(AP_undist_Yshift_matrix[:, iter_idx])

    # compute mAP. Average through clases
    mAP_undist_orig_array[iter_idx] = np.mean(AP_undist_orig_matrix[:, iter_idx], axis=0)
    mAP_undist_Yshift_array[iter_idx] = np.mean(AP_undist_Yshift_matrix[:, iter_idx], axis=0)
    #print(mAP_undist_orig_array)

    for dist_idx, dist in enumerate(dist_array):
        # print(dist)

        # csv_filename = results_dir + file_basename + "{0:.2f}".format(dist) + '_' + str(iter) + '.csv'
        csv_filename_Yshift = results_dir + file_basename_Yshift + str(dist) + '_' + str(iter) + '.csv'
        csv_filename_orig = results_dir + file_basename_orig + str(dist) + '_' + str(iter) + '.csv'
        print(csv_filename_Yshift)
        print(csv_filename_orig)

        # results for YOLO trained with distorted dataset
        with open(csv_filename_Yshift, 'r') as f:
            reader = csv.reader(f,delimiter=';')
            AP_Yshift_str_list = list(reader)
            AP_Yshift_str_nparray = np.array(AP_Yshift_str_list)
            AP_Yshift_np_array = AP_Yshift_str_nparray.astype(np.float)
            print(AP_Yshift_np_array)
            # fill AP matrix
            AP_Yshift_matrix[:, dist_idx, iter_idx] = np.transpose(AP_Yshift_np_array).ravel()
            # print(AP_matrix[:,:,iter_idx])

         # results for YOLO trained with original dataset
        with open(csv_filename_orig, 'r') as f:
            reader = csv.reader(f, delimiter=';')
            AP_orig_str_list = list(reader)
            AP_orig_str_nparray = np.array(AP_orig_str_list)
            AP_orig_np_array = AP_orig_str_nparray.astype(np.float)
            print(AP_orig_np_array)
            # fill AP matrix
            AP_orig_matrix[:, dist_idx, iter_idx] = np.transpose(AP_orig_np_array).ravel()
            # print(AP_matrix[:,:,iter_idx])

    # compute mAP. Average through clases
    mAP_Yshift_matrix[:, iter_idx] = np.mean(AP_Yshift_matrix[:, :, iter_idx], axis=0)
    mAP_orig_matrix[:, iter_idx] = np.mean(AP_orig_matrix[:, :, iter_idx], axis=0)
    print(mAP_Yshift_matrix)


# plot results. mAP for different iterations. Original test dataset (undistorted training dataset)
plt.plot(iter_array, mAP_undist_orig_array,iter_array, mAP_undist_Yshift_array)
plt.legend(('Orig training','Distorted training'))
plt.xlabel("Training iteration")
plt.ylabel("mAP (all classes)")
plt.title('YOLO-V3 performance on 2007 test dataset')
plt.show()
# plot results. AP (all clases) for different iterations. Original test dataset (undistorted training dataset)
plt.plot(iter_array, np.transpose(AP_undist_orig_matrix))
#plt.legend(range(0,20))
plt.xlabel("Training iteration")
plt.ylabel("mAP (per class)")
plt.title('YOLO-V3 performance on 2007 test dataset (trained with original)')
plt.show()
# plot results. AP (all clases) for different iterations. Original test dataset (distorted training dataset)
plt.plot(iter_array, np.transpose(AP_undist_Yshift_matrix))
#plt.legend(range(0,20))
plt.xlabel("Training iteration")
plt.ylabel("mAP (per class)")
plt.title('YOLO-V3 performance on 2007 test dataset (trained with distorted)')
plt.show()

# plot results. mAP for different iterations. Distorted training dataset
plt.plot(dist_array, mAP_Yshift_matrix)
plt.legend(iter_array)
plt.xlabel("Yshift dist ratio")
plt.ylabel("mAP (all classes)")
plt.title('Trained with distorted VOC')
plt.show()

# plot results. mAP for different iterations. Undistorted training dataset
plt.plot(dist_array, mAP_orig_matrix)
plt.legend(iter_array)
plt.xlabel("Yshift dist ratio")
plt.ylabel("mAP (all classes)")
plt.title('Trained with original VOC')
plt.show()


#ind = np.arange(dist_array.size)
#plt.xticks(ind,dist_array)
#plt.axis([0, 6, 0, 20])

