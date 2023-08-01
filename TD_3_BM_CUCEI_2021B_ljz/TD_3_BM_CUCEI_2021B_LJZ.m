clc
close all
clear all


%%
%circ_holed.png
%cropped_CT.png
%cropped_PET.png
%jointed_circ_trang.png
%jointed_circs.png
%%Procesamiento de imagenes  PET p2
I=imread('cropped_PET.png');
I=I(:,:,1);
I_BW=I>30;% & I<150;
SE=strel('disk',30);
I_close=imclose(I_BW,SE);
I_close_f=bwareaopen(I_close,30000);

%%Visualizacion
figure(1)
subplot(2,4,1)
imshow(I)
subplot(2,4,2)
imshow(I_BW)
subplot(2,4,3)
imshow(I_close)
subplot(2,4,4)
imshow(I_close_f)
%Segmentacion de Imagen CT
I=imread('cropped_CT.png');
I=I(:,:,1);
I_BW=I>30 & I<190;
SE=strel('disk',20);
I_open=imopen(I_BW,SE);
I_open_f=bwareaopen(I_open,9000);

%%Visualizacion 2
figure(2)
subplot(2,4,1)
imshow(I)
subplot(2,4,2)
imshow(I_BW)
subplot(2,4,3)
imshow(I_open)
subplot(2,4,4)
imshow(I_open_f)

I=I>255/2;
%PROCESAMIENTO DE IMAGENES MORFOLOGICAS figuras geometricas P1
SE=strel('disk',100);
% SE=strel('line',100,45);
I_dilate=imdilate(I,SE);
I_erode=imerode(I,SE);
I_dilate_erode=imerode(I_dilate,SE);
I_erode_dilate=imdilate(I_erode,SE);
I_open=imopen(I,SE);
I_close=imclose(I,SE);
%%
figure (3)
subplot(3,3,1)
imshow(I)
subplot(3,3,2)
imshow(I_erode)
subplot(3,3,3)
imshow(I_dilate)
subplot(3,3,5)
imshow(I_erode_dilate)
subplot(3,3,6)
imshow(I_dilate_erode)
subplot(3,3,8)
imshow(I_open)
subplot(3,3,9)
imshow(I_close)
%%
%%Segmentacion de Imagenes 3D

path=uigetdir;
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
Image_BW=Image>10&Image<300;
SE=strel('sphere',4);
Image_BW_open=imopen(Image_BW,SE);
Image_BW_open_f=bwareaopen(Image_BW_open,500000,6);
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
volumeViewer(Image_final)
%%