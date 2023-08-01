clc
clear
close all
%% Extracting Image from Directory
path=uigetdir;
Image=extract_dicom_3D(path);

%% Image Rotation to match with mask
% masked = nrrdread(filepath);
Image = flip(Image,3);
%Elimination of shoulders
Image=Image(1:375,:,:);
%%
% masked=load(filepath);
load("manchas_filtered_v2.mat")
%% Comparing with truth mask in order to get only the pixels of interest
Tainted_image=image_maskcomp(Image,manchas_filtered,1000);
%% Loading of 3D Viz settings
a=load(uigetfile());
b=load(uigetfile());
object=a.MRI_REN_object_dark;
scene=b.MRI_MIP_scene_1;
%% Creation of 3D Fig, layout and volume for Viz
% Changed Background color to white for better Visualization on Brigther
% environments
fig = uifigure(Name="MS Volume");
g = uigridlayout(fig,[1 1],Padding=[0 0 0 0]);
viewer=viewer3d(g,CameraPosition=scene.CameraPosition,CameraUpVector=scene.CameraUpVector,CameraTarget=scene.CameraTarget,BackgroundColor=scene.BackgroundColor,BackgroundGradient="off");
msvol=volshow(Tainted_image,Parent=viewer,RenderingStyle=object.RenderingStyle,Alphamap=object.Alphamap,Colormap=object.Colormap);