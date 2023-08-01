clc 
clear all
close all

path= uigetdir('','Seleccina las imagenes CT a trabajar');
path=strcat(path,'\');
[Imagen3D,global_min,global_max]=read_DICOM_3D(path);
[n_rows,n_cols,n_slices]= size(Imagen3D);
n_corte= 257; %Valor arbitrario;
slice_CT= permute(Imagen3D(:,:,n_corte),[1,2,3]);%Transversal
min_tejido=100;
%max_tejido=;
tejido=Imagen3D>min_tejido;%&Imagen3D<max_tejido;%Definir umbral intervalo de lectura para binarizacion
slice_tejido= permute(tejido(:,:,n_corte),[1,2,3]);%tranversal
figure(1)
imshow(slice_CT(:,:,1),[-160,240]);
%color=zeros(n_slices,n_rows,3);%Sagital,Coronal
color=zeros(n_rows,n_cols,3);%Transversal
color(:,:,1)=1;%red
color(:,:,2)=0.5686274509803922;%green
color(:,:,3)=0;%blue
hold all
h= imshow(color);
set(h,'AlphaData',slice_tejido(:,:,1))