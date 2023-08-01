function [Image_final] = Seg_3D(path)
path=strcat(path,'\');
filelistdcm=dir(path);
names={filelistdcm.name};
names=names(~strncmp(names,'.',1));
[x,n_img]=size(names);
path_image=strcat(path,char(names(1)));
I_base=dicomread(path_image);
[n_rows,n_cols]=size(I_base);
Image=zeros(n_rows,n_cols,n_img);
global_max=realmin;
global_min=realmax;
valor_max=240;
valor_min=-160;
for i=n_img:-1:1
    h=char(names(i));
    h=strcat(path,'\',h);
    DirInfo=dicominfo(h);
    n=DirInfo.InstanceNumber;
    n=n_img-n+1;
    current_data=dicomread(h);
    m=DirInfo.RescaleSlope;
    b=DirInfo.RescaleIntercept;
    current_data_fixed=m.*current_data+b;
    current_max=max(max(current_data_fixed));
    current_min=min(min(current_data_fixed));
    Image(:,:,n)=current_data_fixed;
    
    if(current_min<global_min)
        global_min=current_min;
    end
    if(current_max>global_max)
        global_max=current_max;
    end
end
Image_BW=Image>5&Image<300;
SE=strel('sphere',5);
Image_BW_open=imopen(Image_BW,SE);
Image_BW_open_f=bwareaopen(Image_BW_open,500000);
CC=bwconncomp(Image_BW_open_f,26);
L=labelmatrix(CC);
n_obj=CC.NumObjects;
vol=regionprops3(CC,'Volume');
vol=table2array(vol);
vol_threshold_min=1.1;
vol_threshold_max=1.5;
Image_final=zeros(n_rows,n_cols,n_img,'logical');
for n=1:n_obj
    vol_L(n)=(vol(n)*DirInfo.PixelSpacing(1)*DirInfo.PixelSpacing(2)*DirInfo.SliceThickness)/(1000000);
    [vol_obj,x]=size(CC.PixelIdxList{n});
    
    if(vol_L(n)<vol_threshold_max && vol_L(n)>vol_threshold_min)%condicional de indentificacion de objetos
        for i=1:vol_obj
            [r,c,s]=IndexToCoordinates3D(CC.PixelIdxList{n}(i),n_rows,n_cols);
            Image_final(r,c,s)=1;
        end
    end
end
end

