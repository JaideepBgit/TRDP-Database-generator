function img2pano_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,ratio_X_shift,ratio_Y_shift)
% img2pano_dist takes all images in a path (with the VOC structure) and
% distort all images following the distortion in a ERP projection
% Inputs:
%   VOC_path: Input path. Assumes a dir structure as the VOC (/JPEGImages,/Annotations) 
%   results_path: Results path. Creates a dir structure such as the VOC (/JPEGImages,/Annotations) 
%   sphereH: Height of the ERP image 
%   sphereW: Width of the ERP image (must be 2 x sphereH) 
%   imHoriFOV: horizontal FOV of the original images (in radians)
%   ratio_X_ shift: translation of the center of original image in the ERP image (x-axis). Ratio (sphereW) from center 
%   ratio_Y_shift: translation of the center of original image in the ERP image (y-axis). Ratio (sphereY) from center 
% Outputs:
%   Creates results in results_path

% TODO: there is a problem with very big objects, distorted bbox is wrong.
% check with image 000023 for example (im_id = 25)
    resize_ratio = 0.5;
    debug_flag = 0; % show images
    sphereW_large = 2*sphereW;
    sphereH_large = 2*sphereH;
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
    % read background image
    bkg_img = dir([VOC_path '/background_image/']);
    im_bkg_id = bkg_img(3).name(1:end-4); % remove jpg extension
    im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    im_bkg_sz = size(im_bkg);
    size(list_imgs,1)
    coords_large = [sphereW_large/2+X_shift sphereH_large/2+Y_shift];
    % transform to uv notation
    [ uv_large ] = coords2uv( coords_large, sphereW_large, sphereH_large );
    [sphereBkgImg, validBkgMap] = im2Sphere(im_bkg, imHoriFOV, sphereW_large, sphereH_large, uv_large(1), uv_large(2) );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    im_store=0;
    flag_flag=0;
    prev_im = 0;
    Index=0;
    Index_cla=0;Index_obj=0;
    for ind_im = 4:size(list_imgs,1) % not . and ..
        %ind_im=4;
    numvalreq = 6575;
    if(numvalreq==num2str(ind_im))
    asd=1;
    end
        im_id = list_imgs(ind_im).name(1:end-4); % remoce jpg extension
        im = double(imread([VOC_path '/JPEGImages/' im_id '.jpg'])); % seems im2Sphere does not accept uint8 data
        im_sz = size(im);
    % read the segmentation mask
    seg_img = dir([VOC_path '/SegmentationObject/']);
    seg_img_class = dir([VOC_path '/SegmentationClass/']);
    seg_obj_ids = extractfield(seg_img,'name')';
    seg_cla_ods = extractfield(seg_img_class,'name')';
    Index_obj = find(contains(seg_obj_ids,im_id));
    if (isequal(Index_obj,double.empty(0,1)))
      Index_cla = find(contains(seg_cla_ods,im_id));
      flag_flag=1;
    else
      flag_flag=0;
    end

%     if(im_store==0)
%     im_store = ind_im;   
%     elseif(flag_flag==1)
%     im_store = prev_im;
%     else
%     im_store = ind_im;
%     end
%     disp([' Class value ','Object value',' Image ID value '])
%     disp([Index_cla,' ',Index_obj,' ',num2str(im_id)])

if(flag_flag==1 && ~isequal(Index_cla,double.empty(0,1)))
        im_seg_id = seg_img(Index_cla).name(1:end-4); % remoce jpg extension
elseif(flag_flag==0 && ~isequal(Index_obj,double.empty(0,1)))
        im_seg_id = seg_img(Index_obj).name(1:end-4); % remoce jpg extension
else
        continue;    
end
%     disp([' Class value ','Object value',' Image ID value ',' BKG ID value '])
%     disp([Index_cla,' ',Index_obj,' ',num2str(im_id),' ',num2str(im_seg_id)])
   
%     if(strcmp(im_id,im_seg_id)==0 )
%                 flag_flag=1;
%                 prev_im = im_store;
%         continue;
%         %im_store = ind_im-1;
%     else
%         im_store = ind_im;
%         flag_flag=0;
%     end
    im_seg = double(imread([VOC_path '/SegmentationClass/' im_seg_id '.png'])); % seems im2Sphere does not accept uint8 data
    im_seg_sz = size(im_bkg);
    % transfrom the image
    coords = [sphereW/2+X_shift sphereH/2+Y_shift];
    % transform to uv notation
    [ uv ] = coords2uv( coords, sphereW, sphereH );
    [sphereSegImg, validSegMap] = im2Sphere(im_seg, imHoriFOV, sphereW, sphereH, uv(1), uv(2));
    sphereSegImg_r = imresize(sphereSegImg,resize_ratio);   
    validSegMap_r= imresize(validSegMap,resize_ratio); 
%         if debug_flag
%             h_im_orig = figure(1);
%             imshow(uint8(im));
%             hold on
%         end
        
        % project image to panorama
        % set position of the center of the view in the panoramic image
        coords = [sphereW/2+X_shift sphereH/2+Y_shift];
        % transform to uv notation
        [ uv ] = coords2uv( coords, sphereW, sphereH );
        [sphereImg, validMap] = im2Sphere(im, imHoriFOV, sphereW, sphereH, uv(1), uv(2));
        
%         keeperIndexes = find(AR(i) >= 5);
%         labeledImage = bwlabel(img2);
%         newBinaryImage = ismember(labeledImage, keeperIndexes);
%         % Now measure the image again, this time without the bad blobs.
%         labeledImage = bwlabel(newBinaryImage);
%         RP = regionprops(img2,'BoundingBox','PixelList');
%         
        
        sphereImg_r = imresize(sphereImg,resize_ratio);
        validMap_r = imresize(validMap,resize_ratio);
        szRim = size(sphereImg_r);
%         figure;
%         imshow(uint8(sphereImg_r.*validMap_r));
%         figure;
%         imshow(uint8(sphereBkgImg.*validBkgMap));
        [a1,b1] = find(validBkgMap(:,:,1)>0);
        %let's find a position to place the 
        flag =0;
        while(flag==0)
            rand_no = rand(1);
            start_xyz = round(im_bkg_sz.*rand_no);
            start_xyz(1) = start_xyz(1)+a1(1);start_xyz(2) = start_xyz(2)+b1(1);
            if(((start_xyz(1)+szRim(1))<max(a1)) && ((start_xyz(2)+szRim(2))<max(b1)))
                if(start_xyz(1)~=0 && start_xyz(2)~=0 && start_xyz(3)~=0)
                    flag=1;
                end
            end
        end
        %multiply segmentation mask and others to get the something
        sphereImg_r_v = sphereImg_r.*validMap_r;
        sphereSegImg_r_v = sphereSegImg_r.*validSegMap_r;
        SegImg1 = zeros(size(sphereSegImg_r_v));
        CutImageSeg = zeros(size(sphereImg_r_v));
         for i = 1:size(SegImg1,1)
             for j = 1:size(SegImg1,2)
                 if(sphereSegImg_r_v(i,j)~= str2double(NaN) && sphereSegImg_r_v(i,j)>0)
                     SegImg1(i,j) = 1;
                 end
             end
         end
        CutImageSeg(:,:,1)=  SegImg1;
        CutImageSeg(:,:,2)=  SegImg1;
        CutImageSeg(:,:,3)=  SegImg1;
        negCutImageSeg = ~CutImageSeg;
        CutImage =  sphereImg_r_v.*CutImageSeg;
        CutImage_8 = uint8(CutImage);
        sphereBkgImg_8 = uint8(sphereBkgImg.*validBkgMap);
        sbi_sz = size(sphereBkgImg_8);
        %jaideep
        validMap_cut = ~isnan(CutImage);

        % view direction: [alpha belta gamma]
        % contacting point direction: [x0 y0 z0]
        % so division>0 are valid region
        %validMap_cut(division<0) = false;  
        %validMap_cut = repmat(validMap_cut, [1 1 size(CutImage,3)]);
        
        
        [row,col] = find(validSegMap_r (:,:,1) == 1);
        ymin_crop = min(row);
        ymax_crop = max(row);
        xmin_crop = min(col);
        xmax_crop = max(col);

        CutImage_8_crop = imcrop(CutImage_8, [xmin_crop ymin_crop xmax_crop-xmin_crop ymax_crop-ymin_crop ]);

        
        %figure;
        %imshow(uint8(CutImage));
        i1=start_xyz(1);j1=start_xyz(2);k1=1;
         for k=1:size(CutImage_8_crop,3)
             i1=start_xyz(1);
          for i = 1:size(CutImage_8_crop,1)
              j1=start_xyz(2);
              for j = 1:size(CutImage_8_crop,2)
                  if(CutImage_8_crop(i,j,k)~= 0)
                    sphereBkgImg_8(i1,j1,k1) = CutImage_8_crop(i,j,k);
                  end
                  j1=j1+1;
              end
              i1=i1+1;
          end
          k1=k1+1;
         end
         
        if debug_flag
            h_pano = figure(2);
            %imshow(uint8(sphereBkgImg_8));
            imshow(sphereBkgImg_8);
            hold on
            figure
            imagesc(validBkgMap);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% till here the image segmentation and placing the image is done.
% Let's continue with the annotations part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % check if center of image in uv coords go to original location
        coords = [sphereW_large/2+X_shift sphereH_large/2+Y_shift];
        % transform to uv notation
        [ uv ] = coords2uv( coords, sphereW_large, sphereH_large );

        [ coords_check ] = uv2coords( uv, sphereW_large, sphereH_large);
        % convert center of image in xyz
        [ xyz ] = uv2xyzN(uv);

        % crop valid map of panorama image; doesn't relate to bounding
        % boxes
        [row,col] = find(validBkgMap (:,:,1) == 1);
        ymin_crop = min(row);
        ymax_crop = max(row);
        xmin_crop = min(col);
        xmax_crop = max(col);

        sphereImg_crop = imcrop(sphereBkgImg_8, [xmin_crop ymin_crop xmax_crop-xmin_crop ymax_crop-ymin_crop ]);

        if debug_flag
            h_pano_crop = figure(3);
            imshow(uint8(sphereImg_crop));
            hold on
        end

        % save distorted image
        imwrite(sphereImg_crop, [out_images_dir im_id '.jpg'])
        %imwrite(uint8(sphereImg_crop), [out_images_dir im_id '.jpg'])
        % read image annotations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Annotations read
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        annotations = VOCreadxml([VOC_path '/Annotations/' im_id '.xml']);

        % copy annotations to modify them
        annotations_dist = annotations;
        % annotations_dist.annotation.filename = [ im_id '_' num2str(abs(ratio_Y_shift)) '.jpg'];
        annotations_dist.annotation.size.width = start_xyz(2)+xmax_crop-xmin_crop+1;
        annotations_dist.annotation.size.height = start_xyz(1)+ymax_crop-ymin_crop+1;

        objects = annotations.annotation.object;
        for ind_obj = 1:size(objects,2)

            % bounding box coordinates 
            bbox = objects(ind_obj).bndbox;
            %jaideep
            bbox.xmin = num2str(start_xyz(2));
            bbox.xmax = num2str(round(str2num(bbox.xmax)*(resize_ratio)) + start_xyz(2)+(30*resize_ratio));
            bbox.ymax = num2str(round(str2num(bbox.ymax)*(resize_ratio)) + start_xyz(1));
            bbox.ymin =  num2str(start_xyz(1));
            
            % paint bbox 
            if debug_flag
                figure(2),rectangle('Position', [str2num(bbox.xmin), str2num(bbox.ymin), str2num(bbox.xmax)-str2num(bbox.xmin), str2num(bbox.ymax)-str2num(bbox.ymin)],	'EdgeColor','r', 'LineWidth', 3)
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
            %[ out3DNorm, out3DPlane ] = projectPointFromSeparateView(  bbx_points, xyz, imHoriFOV, im_sz(2), im_sz(1));
            % check 181 line for xyz 
            [ out3DNorm, out3DPlane ] = projectPointFromSeparateView(  bbx_points, xyz, imHoriFOV, sbi_sz(2), sbi_sz(1));
            [ uv_bbox ] = xyz2uvN( out3DNorm);
            %[ coord_bbox ] = uv2coords( uv_bbox, sphereW, sphereH);
            [ coord_bbox ] = uv2coords( uv_bbox, sphereW_large, sphereH_large);

            if debug_flag
                figure(2), plot(coord_bbox(:,1),coord_bbox(:,2),'r+', 'MarkerSize', 4);
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
        end

    end%for all images
    
end