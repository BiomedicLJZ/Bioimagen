clc
clear all
close all

path =uigetdir('','Seleccione el fichero con las imagenes originales');
pathor=path;%Creacion de Variable para reseteo del path en for
pathor =strcat(pathor,'\');%Concatenacion de un '\' para completar la direccion
path =strcat(path,'\');%Concatenacion de un '\' para completar la direccion
path2 =uigetdir('','Seleccione el fichero destino');%Seleccion de la carpeta destino de las imagenes anonimizadas
path2 =strcat(path2,'\');%Concatenacion de un '\' para completar la direccion
filelistdcm = dir(path);%Obtencion del tamaño del fichero
names={filelistdcm.name};

for i=1:length(filelistdcm)
    if ~strcmp(filelistdcm(i).name,'.',1)&& ~strcmp(filelistdcm(i).name,'..')
% if  ~strcmp(filelistdcm(i).isdir==0)
        path=strcat(path,char(names(i)));%filtrado por nombre
        DCMinfo=dicominfo(path);%Lectura de los datos DICOM las lineas subsecuentes se dedican a la edicion de metadatos especificos
        DCMinfo.PatientName='REDACTED';
        DCMinfo.StudyID='';
        DCMinfo.InstitutionName='REDACTED';
        DCMinfo.AdditionalPatient='REDACTED';
        DCMinfo.OtherPatientID='REDACTED';
        DCMinfo.PatientID='REDACTED';
        DCMinfo.OperatorName='REDACTED';
        DCMinfo.PhysicianReadingStudy='REDACTED';
        DCMinfo.PerformingPhysicianName='REDACTED';
        DCMinfo.ReferringPhysicianName='REDACTED';
        DCMinfo.StationName='Ing. Biomedica 2021B';
        DCMinfo.PatientBirthDate=(1:4);
        num=DCMinfo.InstanceNumber;%Esta linea se dedica a obtener el numero de instancia para que el programa peda ordenar las imagenes por orden de instancia y adquisicion
        num=string(num);
        % nombre=(strcat(path2,'\','Img_',num,'_REDACTED_Image'),;
        data=dicomread(path);
        dicomwrite(data,strcat(path2,'\','Img_',num,'_REDACTED'),DCMinfo,'CreateMode','copy');%Esta linea guarda la version editada con los metadatos nuevos en la carpeta destino
        i=i+1;
        path=pathor;%reset de la variable path para evitar errores con las iteraciones subsecuentes
    else
        
        
    end
end
