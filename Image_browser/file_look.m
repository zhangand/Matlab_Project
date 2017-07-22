function varargout = file_look(varargin)
% FILE_LOOK M-file for file_look.fig
%      FILE_LOOK, by itself, creates a new FILE_LOOK or raises the existing
%      singleton*.
%
%      H = FILE_LOOK returns the handle to a new FILE_LOOK or the handle to
%      the existing singleton*.
%
%      FILE_LOOK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILE_LOOK.M with the given input arguments.
%
%      FILE_LOOK('Property','Value',...) creates a new FILE_LOOK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before file_look_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to file_look_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help file_look

% Last Modified by GUIDE v2.5 17-Jul-2017 23:01:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @file_look_OpeningFcn, ...
                   'gui_OutputFcn',  @file_look_OutputFcn, ...
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

function file_look_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

function varargout = file_look_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function sel_dir_Callback(hObject, eventdata, handles)
global str str2 index
str=uigetdir('.\');
str_tif=dir([str '\*.tif']);
str_jpg=dir([str '\*.jpg']);
str_bmp=dir([str '\*.bmp']);
str_gif=dir([str '\*.gif']);
str1=[str_jpg;str_bmp;str_gif];
str2=struct2cell(str1);
if ~isempty(str1)
    n=find(str2{4}==1);
    str2(:,n)=[];
end
index=1;
set(handles.pic_name,'string',str2{1,1})
M=imread([str '\' str2{index,1}]);
image(M);
axis off

function continue_play_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    t=timer('Period',2.5,'TimerFcn',{@con_play,handles},'BusyMode',...
        'queue','ExecutionMode','fixedSpacing','startDelay',2.5);
    start(t);
else
    t=timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
        clear t
    end
end

function con_play(obj,event,handles)
global str str2 index
n=size(str2,2);
if index==n
    index=1;
else
    index=index+1;
end
old_pic=findobj(handles.axes1,'type','image');
delete(old_pic);
clear old_pic
M=imread([str '\' str2{1,index}]);
image('parent',handles.axes1,'CData',M);
set(handles.pic_name,'string',str2{1,index})

function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
pos=get(handles.axes1,'currentpoint');
xLim=get(handles.axes1,'xlim');
yLim=get(handles.axes1,'ylim');
if (pos(1,1)>=xLim(1)&&pos(1,1)<=xLim(2))&&(pos(1,2)>=yLim(1)&&pos(1,2)<=yLim(2))
    set(gcf,'Pointer','hand')
else
    set(gcf,'Pointer','arrow')
end

function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
global str str2 index
if strcmp(get(gcf,'Pointer'),'hand')
    if strcmp(get(gcf,'SelectionType'),'alt')
        pos=get(gcf,'currentpoint');
        set(handles.pic_sel,'position',[pos(1,1) pos(1,2)],'visible','on')
    elseif strcmp(get(gcf,'SelectionType'),'normal')
        n=size(str2,2);
        if index==n
            index=1;
        else
            index=index+1;
        end
        axes(handles.axes1);
        cla;
        M=imread([str '\' str2{1,index}]);
        image(M);
        axis off
        set(handles.pic_name,'string',str2{1,index})
    end
end

function pic_sel_Callback(hObject, eventdata, handles)

function last_pic_Callback(hObject, eventdata, handles)
global str str2 index
n=size(str2,2);
if index==1
    index=n;
else
    index=index-1;
end
axes(handles.axes1);
cla;
M=imread([str '\' str2{1,index}]);
image(M);
axis off
set(handles.pic_name,'string',str2{1,index})

function next_pic_Callback(hObject, eventdata, handles)
global str str2 index
n=size(str2,2);
if index==n
    index=1;
else
    index=index+1;
end
axes(handles.axes1);
cla;
M=imread([str '\' str2{1,index}]);
image(M);
axis off
set(handles.pic_name,'string',str2{1,index})

function size3_2_Callback(hObject, eventdata, handles)
global str str2 index
set(handles.size3_2,'checked','on')
set(handles.size2_3,'checked','off')
set(handles.axes1,'position',[15,116,600,400])
axes(handles.axes1);
cla;
M=imread([str '\' str2{1,index}]);
image(M);
axis off

function size2_3_Callback(hObject, eventdata, handles)
global str str2 index
set(handles.size3_2,'checked','off')
set(handles.size2_3,'checked','on')
set(handles.axes1,'position',[165,81,300,450])
axes(handles.axes1);
cla;
M=imread([str '\' str2{1,index}]);
image(M);
axis off



% --------------------------------------------------------------------
function Folder_Open_Callback(hObject, eventdata, handles)
% hObject    handle to Folder_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global str str2 index
str=uigetdir('.\');
str_tif=dir([str '\*.tif']);
str_jpg=dir([str '\*.jpg']);
str_bmp=dir([str '\*.bmp']);
str_gif=dir([str '\*.gif']);
str1=[str_jpg;str_bmp;str_gif];
str2=struct2cell(str1);
if ~isempty(str1)
    n=find(str2{4}==1);
    str2(:,n)=[];
end
index=1;
set(handles.pic_name,'string',str2{1,1})
M=imread([str '\' str2{index,1}]);
image(M);

axis off

% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis off


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis off