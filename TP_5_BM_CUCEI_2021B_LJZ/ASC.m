function varargout = ASC(varargin)
% INTERFAZ_ASC MATLAB code for Interfaz_ASC.fig
%      INTERFAZ_ASC, by itself, creates a new INTERFAZ_ASC or raises the existing
%      singleton*.
%
%      H = INTERFAZ_ASC returns the handle to a new INTERFAZ_ASC or the handle to
%      the existing singleton*.
%
%      INTERFAZ_ASC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFAZ_ASC.M with the given input arguments.
%
%      INTERFAZ_ASC('Property','Value',...) creates a new INTERFAZ_ASC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interfaz_ASC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interfaz_ASC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interfaz_ASC

% Last Modified by GUIDE v2.5 21-Sep-2021 16:45:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interfaz_ASC_OpeningFcn, ...
                   'gui_OutputFcn',  @Interfaz_ASC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Interfaz_ASC is made visible.
function Interfaz_ASC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interfaz_ASC (see VARARGIN)

% Choose default command line output for Interfaz_ASC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes Interfaz_ASC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interfaz_ASC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  global Image valor_min valor_max
path=uigetdir;
filelistdcm=dir(path);
names={filelistdcm.name};
names= names(~strncmp(names,'.',1));
[X,n_img]=size(names); %Definicion del numero de columnas 'n_img' mediante la función 'size' en el arreglo/matriz 'names'
path_image=strcat(path,'\',char(names(1)));
I_base= dicomread(path_image);
[n_rows,n_cols]=size(I_base);
Image= zeros(n_rows,n_cols,n_img);
global_max = realmin;
global_min = realmax;

for i =1:1:n_img
   h=char(names(i));
   h=strcat(path,'\',h);         %Se soluciona un problema de lectura de la direccion que contiene los archivos
   DirInfo=dicominfo(h);
   n=DirInfo.InstanceNumber;
   current_data = dicomread(h);
   m=DirInfo.RescaleSlope; % se buscan los valores de rescaleSlope e Intercept para un futuro uso
   b=DirInfo.RescaleIntercept;
   current_data_corregido=m*current_data+b; %Regresion lineal necesaria para el mejoramiento de la imagen
   
   current_max = max(max(current_data_corregido));
   current_min = min(min(current_data_corregido));
   
   Image(:,:,n)= current_data_corregido;   %ORIGINAL
   if(current_min<global_min)
       global_min = current_min;
   end
   if(current_max>global_max)
       global_max=current_max;
   end
end
valor_min=-160;
valor_max=240;

    

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 global Image valor_min valor_max
 corte=get(handles.edit1,'String');
 corte=str2num(corte);
 if corte<865
 set(handles.edit1,'String',fix(corte));

Axial= permute(Image(:,:,fix(corte)+1),[1,2,3]);
axes(handles.axes1);
imshow(Axial(:,:,1),[valor_min,valor_max]);
 end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global Image valor_min valor_max
 corte2=get(handles.edit2,'String');
 corte2=str2num(corte2);
 
 if corte2<512
 set(handles.edit2,'String',fix(corte2));

Sagital= permute(Image(:,fix(corte2)+1,:),[2,1,2]);
axes(handles.axes2);
imshow(Sagital(:,:,1),[valor_min,valor_max]);
 end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global Image valor_min valor_max
 corte3=get(handles.edit3,'String');
 corte3=str2num(corte3);
 
 if corte3<512
 set(handles.edit3,'String',fix(corte3));

Sagital= permute(Image(fix(corte3)+1,:,:),[3,2,1]);
axes(handles.axes3);
imshow(Sagital(:,:,1),[valor_min,valor_max]);
 end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% set(handles.slider1,'Min',0,'Max',865,'Value',220,'SliderStep',[1 1]);

% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% pushbutton1_Callback(hObject, eventdata, handles);
% global corte;
global Image valor_min valor_max
 corte=get(handles.slider1,'Value');
 if corte<865
 set(handles.edit1,'String',fix(corte));

Axial= permute(Image(:,:,fix(corte)+1),[1,2,3]);
axes(handles.axes1);
imshow(Axial(:,:,1),[valor_min,valor_max]);
 end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Image valor_min valor_max
 corte2=get(handles.slider2,'Value');
 if corte2<512
 set(handles.edit3,'String',fix(corte2));

Sagital= permute(Image(:,fix(corte2)+1,:),[3,1,2]);
axes(handles.axes2);
imshow(Sagital(:,:,1),[valor_min,valor_max]);
 end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Image valor_min valor_max
 corte3=get(handles.slider3,'Value');
 if corte3<512
 set(handles.edit2,'String',fix(corte3));

Sagital= permute(Image(fix(corte3)+1,:,:),[3,2,1]);
axes(handles.axes3);
imshow(Sagital(:,:,1),[valor_min,valor_max]);
 end
