function img2pano_seg_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,ratio_X_shift,ratio_Y_shift)
% img2pano_dist takes all images in a path (with the VOC structure) and
% distort all images following the distortion in a ERP projection
% Inputs:
%   VOC_path: Input path. Assumes a dir structure as the VOC (/JPEGImages,/Annotations) 
%   results_path: Results path. Creates a dir structure such as the VOC (/JPEGImages,/Annotations) 
%   sphereH: Height of the ERP image 
%   sphereW: Width of the ERP image (must be 2 x sphereH) 
%   imHoriFOV: horizontal FOV of the original images (in radians)
%   ratio_X_shift: translation of the center of original image in the ERP image (x-axis). Ratio (sphereW) from center 
%   ratio_Y_shift: translation of the center of original image in the ERP image (y-axis). Ratio (sphereY) from center 
% Outputs:
%   Creates results in results_path

% TODO: there is a problem with very big objects, distorted bbox is wrong.
% check with image 000023 for example (im_id = 25)

    debug_flag = 0; % show images

    % shift in pixels
    X_shift = round(sphereW * ratio_X_shift);
    Y_shift = round(sphereH * ratio_Y_shift);
    
    % dir structure in the VOC style
    out_images_dir = [results_path '/dist_' num2str(ratio_Y_shift) '/JPEGImages/'];
    out_annotations_dir = [results_path '/dist_' num2str(ratio_Y_shift) '/Annotations/'];
    
    if ~exist(out_images_dir)
        mkdir(out_images_dir)
    end
    if ~exist(out_annotations_dir)
        mkdir(out_annotations_dir)
    end

    % read all images in VOC folder
    list_imgs = dir([VOC_path '/JPEGImages/']); 
    size(list_imgs,1)

    for ind_im = 3:size(list_imgs,1) % not . and ..

        im_id = list_imgs(ind_im).name(1:end-4); % remoce jpg extension
        im = double(imread([VOC_path '/JPEGImages/' im_id '.jpg'])); % seems im2Sphere does not accept uint8 data
        im_sz = size(im);

        if debug_flag
            h_im_orig = figure(1);
            imshow(uint8(im));
            hold on
        end

        % project image to panorama
        % set position of the center of the view in the panoramic image
        coords = [sphereW/2+X_shift sphereH/2+Y_shift];
        % transform to uv notation
        [ uv ] = coords2uv( coords, sphereW, sphereH );
        [sphereImg, validMap] = im2Sphere(im, imHoriFOV, sphereW, sphereH, uv(1), uv(2) );

        if debug_flag
            h_pano = figure(2);
            imshow(uint8(sphereImg));
            hold on
            figure
            imagesc(validMap);
        end

        % check if center of image in uv coords go to original location
        [ coords_check ] = uv2coords( uv, sphereW, sphereH);
        % convert center of image in xyz
        [ xyz ] = uv2xyzN(uv);

        % crop valid map of panorama image
        [row,col] = find(validMap (:,:,1) == 1);
        ymin_crop = min(row);
        ymax_crop = max(row);
        xmin_crop = min(col);
        xmax_crop = max(col);

        sphereImg_crop = imcrop(sphereImg, [xmin_crop ymin_crop xmax_crop-xmin_crop ymax_crop-ymin_crop ]);

        if debug_flag
            h_pano_crop = figure(3);
            imshow(uint8(sphereImg_crop));
            hold on
        end

        % save distorted image
        imwrite(uint8(sphereImg_crop), [out_images_dir im_id '.jpg'])

        % read image annotations
        annotations = VOCreadxml([VOC_path '/Annotations/' im_id '.xml']);

        % copy annotations to modify them
        annotations_dist = annotations;
        % annotations_dist.annotation.filename = [ im_id '_' num2str(abs(ratio_Y_shift)) '.jpg'];
        annotations_dist.annotation.size.width = xmax_crop-xmin_crop+1;
        annotations_dist.annotation.size.height = ymax_crop-ymin_crop+1;

        objects = annotations.annotation.object;
        for ind_obj = 1:size(objects,2)

            % bounding box coordinates 
            bbox = objects(ind_obj).bndbox;

            % paint bbox 
            if debug_flag
                figure(1),rectangle('Position', [str2num(bbox.xmin), str2num(bbox.ymin), str2num(bbox.xmax)-str2num(bbox.xmin), str2num(bbox.ymax)-str2num(bbox.ymin)],	'EdgeColor','r', 'LineWidth', 3)
            end
            
            bbx_points = [ str2num(bbox.xmin) str2num(bbox.xmax) str2num(bbox.xmin) str2num(bbox.xmax);
                           str2num(bbox.ymin) str2num(bbox.ymin) str2num(bbox.ymax) str2num(bbox.ymax)]; 
            bbx_points = bbx_points';

            % extract also upper and lower medium points (to avoid problems with big distorted objects)
            upper_middle_x = round((str2num(bbox.xmin) + str2num(bbox.xmax))/2);
            upper_middle_y = str2num(bbox.ymin);
            lower_middle_x = round((str2num(bbox.xmin) + str2num(bbox.xmax))/2);
            lower_middle_y = str2num(bbox.ymax);
            bbx_points(5,:) = [upper_middle_x upper_middle_y];
            bbx_points(6,:) = [lower_middle_x lower_middle_y];

            % project bbox points to panorama image
            [ out3DNorm, out3DPlane ] = projectPointFromSeparateView(  bbx_points, xyz, imHoriFOV, im_sz(2), im_sz(1));
            [ uv_bbox ] = xyz2uvN( out3DNorm);
            [ coord_bbox ] = uv2coords( uv_bbox, sphereW, sphereH);

            if debug_flag
                figure(2), plot(coord_bbox(:,1),coord_bbox(:,2),'r+', 'MarkerSize', 4);
                pause
            end

            % extract bounding rectangle of distorted bounding box
            xmin_brect = min(coord_bbox(:,1));
            xmax_brect = max(coord_bbox(:,1));
            ymin_brect = min(coord_bbox(:,2));
            ymax_brect = max(coord_bbox(:,2));
            
            if debug_flag
                rectangle('Position', [xmin_brect, ymin_brect, xmax_brect-xmin_brect,ymax_brect-ymin_brect],'EdgeColor','r', 'LineWidth', 3)
            end
            
            % take brect to cropped panorama
            xmin_brect_crop = xmin_brect - xmin_crop;
            xmax_brect_crop = xmax_brect - xmin_crop;
            ymin_brect_crop = ymin_brect - ymin_crop;
            ymax_brect_crop = ymax_brect - ymin_crop;
            
            if debug_flag
                figure(3),rectangle('Position', [xmin_brect_crop, ymin_brect_crop, xmax_brect_crop-xmin_brect_crop,ymax_brect_crop-ymin_brect_crop],'EdgeColor','r', 'LineWidth', 3)
                pause
            end

            % save new bbox to xml data
            annotations_dist.annotation.object(ind_obj).bndbox.xmax = xmax_brect_crop;
            annotations_dist.annotation.object(ind_obj).bndbox.xmin = xmin_brect_crop;
            annotations_dist.annotation.object(ind_obj).bndbox.ymax = ymax_brect_crop;
            annotations_dist.annotation.object(ind_obj).bndbox.ymin = ymin_brect_crop;

        end

        % write new xml
        VOCwritexml(annotations_dist, [ out_annotations_dir im_id '.xml'])

        if debug_flag
            figure(1), hold off
            figure(2), hold off
            figure(3), hold off
            pause
        end

    end
    
end