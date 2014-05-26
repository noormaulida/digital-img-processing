function varargout = UserInterface(varargin)
% USERINTERFACE MATLAB code for UserInterface.fig
%      USERINTERFACE, by itself, creates a new USERINTERFACE or raises the existing
%      singleton*.
%
%      H = USERINTERFACE returns the handle to a new USERINTERFACE or the handle to
%      the existing singleton*.
%
%      USERINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERINTERFACE.M with the given input arguments.
%
%      USERINTERFACE('Property','Value',...) creates a new USERINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UserInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UserInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UserInterface

% Last Modified by GUIDE v2.5 11-Jan-2014 16:30:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UserInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @UserInterface_OutputFcn, ...
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


% --- Executes just before UserInterface is made visible.
function UserInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UserInterface (see VARARGIN)

% Choose default command line output for UserInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UserInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = UserInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtUrl_Callback(hObject, eventdata, handles)
% hObject    handle to txtUrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtUrl as text
%        str2double(get(hObject,'String')) returns contents of txtUrl as a double


% --- Executes during object creation, after setting all properties.
function txtUrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtUrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[fn pn]=uigetfile('*jpg', 'select .jpg file');
complete = strcat(pn, fn);
set(handles.txtUrl,'string', complete);
handles.I = imread(complete);
axes(handles.origIm);
%imshow (I, 'Parent', handles.origIm);
imshow(handles.I);
guidata(hObject,handles);


% --- Executes on button press in btnProcess.
function btnProcess_Callback(hObject, eventdata, handles)
% hObject    handle to btnProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
%handles.enhancedImage = enhancing(handles.I, handles.enhanceIm);
oriImage = im2double(handles.I);
%enhancement image
enhancedImage = enhancement(oriImage);
imshow(enhancedImage, 'Parent', handles.enhanceIm);

%segmentation
[segmented1, segmented2] = segmentation(enhancedImage);
imshow(segmented1, 'Parent', handles.segmenIm);
imshow(segmented2, 'Parent', handles.segmen2Im);

%feature extraction
[cont,vars, stds, kurt, men, smo]=feature_extraction(segmented2);
set(handles.txtContrast, 'String', cont);
set(handles.txtVariance, 'String', vars);
set(handles.txtStd, 'String', stds);
set(handles.txtCurtosis, 'String', kurt);
set(handles.txtMean, 'String', men);
set(handles.txtSmooth, 'String', smo);
%training
%net=training();

%classification
new_inputs=[cont vars stds kurt men smo]';

namafile=get(handles.txtUrl,'String') 
target = zeros(1,2);
if(strfind(namafile, 'normal'))
    target(1, 1) = 1;
    target(1, 2) = 0;
elseif(strfind(namafile, 'cancer'))
    target(1, 1) = 0;
    target(1, 2) = 1;
end
new_targets=target';
hMainMenu = getappdata(0,'hMainMenu');
netww = getappdata(hMainMenu, 'netw');
[result,c]=classification(netww, new_inputs, new_targets);
set(handles.txtResult, 'String',result);
fprintf('nilai %d\n',c);
fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);
guidata(hObject,handles);
