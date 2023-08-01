clc
clear all
close all
%%

im=imread('Figuras.png');
%%


im=im(:,:,1);
[nrows,ncols]=size(im);
i_max=max(max(im));im=im>0.5*i_max;i_max=max(max(im));
i_min=min(min(im));
[L,n_o]=bwlabel(im,8);
i_max_label=max(max(L));
i_min_label=min(min(L));
figure(1)
subplot(1,2,1)
imshow(im)
colorbar
subplot(1,2,2)
imshow(L,[0,n_o]);
colormap(gca,'jet');
colorbar
%%
CC=bwconncomp(im,8);
n_obj=CC.NumObjects;
pixels_obj_1_=CC.PixelIdxList{1};%Lista de los index de los pixeles del objeto
im_copy=im;
area_threshold=1500;
for n=1:n_obj
    [area_obj,x]=size(CC.PixelIdxList{n});
    if(area_obj<area_threshold)%condicional de indentificacion de objetos
        for i=1:area_obj
            [r,c]=IndexToCoordinates(CC.PixelIdxList{n}(i),nrows);
            im_copy(r,c)=0;
        end
    end
end
%%
imfil=im_copy;
figure(2)
subplot(1,2,1)
imshow(im)
subplot(1,2,2)
imshow(im_copy)
new_CC=bwconncomp(im_copy,8);
new_n_obj=new_CC.NumObjects;
%%
seg=im_copy;
CC_boundaries=bwboundaries(im_copy,8);
stats=regionprops(imfil,'BoundingBox');
areafig=(482-111)*(422-137);%Medidas tomadas de la bounding box correspondiente al rectangulo
for n=1:new_n_obj
    %%calculo de parametros de identificacion de figuras
    [area_obj_filtered,x]=size(new_CC.PixelIdxList{n});
    [perimeter,x]=size(CC_boundaries{n});
%     compacity_coeficient=(2*pi*sqrt(area_obj_filtered/pi))/perimeter;
    compacity_coeficcient = ((sqrt(area_obj_filtered))*4)/perimeter;   %Cuadrado
    %%Segmentacion
    %     if(compacity_coeficient>0.41)%%Condicional para identificar objetos
    %         for i=1:area_obj_filtered
    %             [r,c]=IndexToCoordinates(new_CC.PixelIdxList{n}(i),nrows);
    %             im_copy(r,c)=0;
%    if(compacity_coeficcient>1.01 || compacity_coeficcient < 1) %Condicional para identificar cuadrado
if(area_obj_filtered>areafig-20000)
        for i=1:area_obj_filtered
            [r,c]=IndexToCoordinates(new_CC.PixelIdxList{n}(i),nrows);
            im_copy(r,c)=0;
        end
    end
end
figure(3)
imshow(im_copy)
%%