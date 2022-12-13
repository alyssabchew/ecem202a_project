function out = aprilupdate(x_phone, y_phone, z_phone)
    I = imread("waypoint1.jpg");
    tagFamily =["tag16h5", "tagCircle21h7", "tagStandard41h12", "tagStandard52h13", "tagCircle49h12"];
    focalLength = [1512.2571, 1512.2571];
    principalPoint = [971.5428, 721.83875];
    imageSize = [768, 1024];
    tagSize = 0.04;
    Truetag = [0,0];
    intrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
    %I = undistortImage(I, intrinsics, OutputView = "same");
    
    [id, loc, pose, fam] = readAprilTag(I, tagFamily, intrinsics, tagSize);
    worldPoints = [0 0 0; tagSize/2 0 0; 0 tagSize/2 0; 0 0 tagSize/2];
    for i = 1:length(pose)
        % Get image coordinates for axes.
        
        imagePoints = world2img(worldPoints,pose(i),intrinsics);
        
        x = pose(i).Translation(1);
        y = pose(i).Translation(2);
        z = pose(i).Translation(3);
        distance = (x)^2;
        distance = distance + (y)^2;
        distance = distance + (z)^2;
        distance = distance^.5;
        if(distance < 0.5) 
            d = distance;
            x_s = x;
            y_s = y;
            z_s = z;
            %roll = pose(i).R(1);
            %pitch = pose(i).R(2);
            %yaw = pose(i).R(3);
            uid = id(i);
            tagid = fam(i);
            %Truetag = [i, distance, roll, pitch, yaw];
            I = insertShape(I,Line=[imagePoints(1,:) imagePoints(2,:); ...
                imagePoints(1,:) imagePoints(3,:); imagePoints(1,:) imagePoints(4,:)], ...
                Color=["red","green","blue"],LineWidth=7);
        
        %I = insertText(I,loc(1,:,i),id(i),BoxOpacity=1,FontSize=25);
        end
    end
    imshow(I)
    out = [tagid, d, uid, x_phone + x_s, y_phone + y_s, z_phone + z_s];