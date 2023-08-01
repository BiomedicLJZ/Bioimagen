function [Image] = openDicom(path)
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
end

