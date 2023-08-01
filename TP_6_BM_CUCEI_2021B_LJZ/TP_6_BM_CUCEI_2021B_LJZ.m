clc
close all
clear all

path=uigetdir('','Seleccione la ubicacion de la mascara a evaluar');
path_true=strcat(uigetdir,'\',uigefile);
mask_1=Seg_3D(path);
mask_true=nrrdread(path_true);

mask_1_max = max(max(max(mask_1)));
mask_true_max = max(max(max(mask_true)));
mask_1 = mask_1 > 0.5*double(mask_1_max);
mask_true = mask_true > 0.5*double(mask_true_max);

common = (mask_true & mask_1);
a = sum( common(:) );
b = sum( mask_true(:) );
c = sum( mask_1(:) );
dice = 2*a/(b+c);
jaccard= a/(b+c-a);
