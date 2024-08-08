function varargout = GNSS_PRODUCTS_DIFF(varargin)
% GNSS_PRODUCTS_DIFF MATLAB code for GNSS_PRODUCTS_DIFF.fig
%      GNSS_PRODUCTS_DIFF, by itself, creates a new GNSS_PRODUCTS_DIFF or raises the existing
%      singleton*.
%
%      H = GNSS_PRODUCTS_DIFF returns the handle to a new GNSS_PRODUCTS_DIFF or the handle to
%      the existing singleton*.
%
%      GNSS_PRODUCTS_DIFF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GNSS_PRODUCTS_DIFF.M with the given input arguments.
%
%      GNSS_PRODUCTS_DIFF('Property','Value',...) creates a new GNSS_PRODUCTS_DIFF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GNSS_PRODUCTS_DIFF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GNSS_PRODUCTS_DIFF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GNSS_PRODUCTS_DIFF

% Last Modified by GUIDE v2.5 09-Nov-2021 11:50:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GNSS_PRODUCTS_DIFF_OpeningFcn, ...
                   'gui_OutputFcn',  @GNSS_PRODUCTS_DIFF_OutputFcn, ...
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


% --- Executes just before GNSS_PRODUCTS_DIFF is made visible.
function GNSS_PRODUCTS_DIFF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GNSS_PRODUCTS_DIFF (see VARARGIN)

% Choose default command line output for GNSS_PRODUCTS_DIFF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GNSS_PRODUCTS_DIFF wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GNSS_PRODUCTS_DIFF_OutputFcn(hObject, eventdata, handles) 
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
global C FileName full_file_name num_of_files GPS GLONASS GALILEO BEIDOU QZSS IRNSS extension

% reference product button (pushbutton1) .....

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    errordlg('Define the GNSS constellation before reading the products', 'Error!', 'modal')
return
end
%================  !!!!!  sp3 && eph only !!!!!!! ===================================

%======  reading data files  ===========================
[FileName,pathname,d] = uigetfile('*.sp3;*.SP3;*.EPH;*.EPH_M;*.clk;*.CLK;*.eph;*_05s;*_30s;*CLK_M','Choose the products','MultiSelect','on');
h = waitbar(0,'Please wait...');
if ischar(FileName)==1
    num_of_files=1; %single
else
    num_of_files=length(FileName);
end

if num_of_files==1 %============ single file  ===================
full_file_name = fullfile(pathname,FileName);
Str = fileread(full_file_name);
C   = strsplit(Str, '\n');   % line by line ;  \n == new line
extension=FileName(end-2:end);  % last 3 characters of FileName

% check non-standard format
if strcmp(extension,'sp3')==0 && strcmp(extension,'SP3')==0 && strcmp(extension,'EPH')==0 && strcmp(extension,'H_M')==0 && strcmp(extension,'CLK')==0 && strcmp(extension,'clk')==0 && strcmp(extension,'eph')==0 && strcmp(extension,'h_m')==0 && strcmp(extension,'05s')==0 && strcmp(extension,'30s')==0 && strcmp(extension,'K_M')==0   
errordlg('Non-standard format', 'Error!', 'modal')
return
end
end

if num_of_files>1 %========== multiple files ==================
for i=1:num_of_files
full_file_namee(:,i) = fullfile(pathname,FileName(:,i)); %1x2 cell array
end
% check mix type of format
FileNameinCell=cellfun(@(x) x(end-2:end), FileName, 'UniformOutput', false);
extension=char(FileNameinCell);
extension_cell=cellstr(extension);

if isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'sp3')))==0
    errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'SP3')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'EPH')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'eph')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'H_M')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'h_m')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
end


% check non-standard format
for i=1:num_of_files
    if strcmp(extension(i,:),'sp3')==0 && strcmp(extension(i,:),'SP3')==0 && strcmp(extension(i,:),'EPH')==0 && strcmp(extension(i,:),'H_M')==0 && strcmp(extension(i,:),'CLK')==0 && strcmp(extension(i,:),'clk')==0 && strcmp(extension(i,:),'eph')==0 && strcmp(extension(i,:),'h_m')==0 && strcmp(extension(i,:),'05s')==0 && strcmp(extension(i,:),'30s')==0 && strcmp(extension(i,:),'K_M')==0 
errordlg('Non-standard format', 'Error!', 'modal')
return
    end
end

full_file_name=char(full_file_namee);  % 2xn char array
% for i=1:num_of_files
% Str{i,:} = fileread(full_file_name(i,:)); % 2xn cell array  ......   OKED    ...........
% CC{i,:}   = strsplit(Str{i,:}, '\n');   % line by line ;  \n == new line % 2xn cell array
% end
% C=CC;
end

close(h)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global C2 FileName FileName2 full_file_name2 num_of_files num_of_files_2 extension2 

%(target product)

if isempty(FileName)==1
    errordlg('Read the reference products before reading the target the products', 'Error!', 'modal')
return
end
    
%================  !!!!!  sp3 && eph only !!!!!!! ===================================

%======  reading data files  ===========================
[FileName2,pathname2,d] = uigetfile('*.sp3;*.SP3;*.EPH;*.EPH_M;*.clk;*.CLK;*.eph;*_05s;*_30s;*CLK_M','Choose the products','MultiSelect','on');
h = waitbar(0,'Please wait...');
if ischar(FileName2)==1
    num_of_files_2=1; %single
else
    num_of_files_2=length(FileName2);
end

if num_of_files_2==1 %============ single file  ===================     
full_file_name2 = fullfile(pathname2,FileName2);
Str2 = fileread(full_file_name2);
C2   = strsplit(Str2, '\n');   % line by line ;  \n == new line
extension2=FileName2(end-2:end);  % last 3 characters of FileName

if strcmp(extension2,'sp3')==0 && strcmp(extension2,'SP3')==0 && strcmp(extension2,'EPH')==0 && strcmp(extension2,'H_M')==0 && strcmp(extension2,'CLK')==0 && strcmp(extension2,'clk')==0 && strcmp(extension2,'eph')==0 && strcmp(extension2,'h_m')==0 && strcmp(extension2,'05s')==0 && strcmp(extension2,'30s')==0 && strcmp(extension2,'K_M')==0     
errordlg('Non-standard format', 'Error!', 'modal')
return
end
end

if num_of_files_2>1 %========== multiple files ==================
    for i=1:num_of_files_2
        full_file_namee2(:,i) = fullfile(pathname2,FileName2(:,i)); %1x2 cell array
    end
    % check mix type of format
FileNameinCell=cellfun(@(x) x(end-2:end), FileName2, 'UniformOutput', false);
extension=char(FileNameinCell);
extension_cell=cellstr(extension);

if isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'sp3')))==0
    errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'SP3')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'EPH')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'eph')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'H_M')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
    elseif isempty(find(contains(extension_cell,'CLK')))==0 && isempty(find(contains(extension_cell,'h_m')))==0
     errordlg('Orbit and clock data format is not allowed for multiple reference products', 'Error!', 'modal')
    return
end

    FileName2inCell2=cellfun(@(x) x(end-2:end), FileName2, 'UniformOutput', false);
        extension2=char(FileName2inCell2);
        % check non-standard format
        for i=1:num_of_files_2
            if strcmp(extension2(i,:),'sp3')==0 && strcmp(extension2(i,:),'SP3')==0 && strcmp(extension2(i,:),'EPH')==0 && strcmp(extension2(i,:),'H_M')==0 && strcmp(extension2(i,:),'CLK')==0 && strcmp(extension2(i,:),'clk')==0 && strcmp(extension2(i,:),'eph')==0 && strcmp(extension2(i,:),'h_m')==0 && strcmp(extension2(i,:),'05s')==0 && strcmp(extension2(i,:),'30s')==0 && strcmp(extension2(i,:),'K_M')==0
                errordlg('Non-standard format', 'Error!', 'modal')
                return
    end
        end
    full_file_name2=char(full_file_namee2);  % 2xn char array   
end

%======  check the number of files for reference and target products ======

if num_of_files ~= num_of_files_2
    errordlg('The file numbers for reference and target products are not equal', 'Error!', 'modal')
                return
end
close(h)
        
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
global GPS 

GPS=get(gcbo, 'Value');





% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
global GLONASS 
GLONASS=get(gcbo, 'Value');

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global GALILEO 
GALILEO=get(gcbo, 'Value');

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
global BEIDOU 
BEIDOU=get(gcbo, 'Value');



% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
global QZSS 
QZSS=get(gcbo, 'Value');

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, ~, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
global IRNSS 
IRNSS=get(gcbo, 'Value');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GPS GLONASS GALILEO BEIDOU QZSS IRNSS FileName nPC01 nPC02 nPC03 nPC04 nPC05 nPC06 nPC07 nPC08 nPC09 nPC10 nPC11 nPC12 nPC13 nPC14 nPC16
global nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC31 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC38 nPC39 nPC40 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46 nPC56 nPC59 nPC60 nPC61
global nPC2_GEO nPC2_IGSO nPC2_MEO nPC3_GEO nPC3_IGSO nPC3_MEO full_file_name
global FileName2 full_file_name2 extension extension2 num_of_files C C2

% data availability button (pushbutton3) .....

% check the GNSS constellations .....
% GPS
h = waitbar(0,'Please wait...');
if exist('extension') == 1
if strcmp(extension(1,:),'H_M')==1 || strcmp(extension(1,:),'sp3')==1 || strcmp(extension(1,:),'SP3')==1 || strcmp(extension(1,:),'EPH')==1 || strcmp(extension(1,:),'eph')==1 || strcmp(extension(1,:),'K_M')==1 
%========= BDS-2 & BDS-3 IGSO/MEO/GEO CLASSIFICATIONS (https://www.glonass-iac.ru/en/BEIDOU/)======

if num_of_files==1 %============ single file  ===================     
% BDS-2
nPC01 = sum(strncmp(C, 'PC01', 4)); % BDS-2 GEO
nPC02 = sum(strncmp(C, 'PC02', 4)); % BDS-2 GEO
nPC03 = sum(strncmp(C, 'PC03', 4)); % BDS-2 GEO
nPC04 = sum(strncmp(C, 'PC04', 4)); % BDS-2 GEO
nPC05 = sum(strncmp(C, 'PC05', 4)); % BDS-2 GEO
nPC06 = sum(strncmp(C, 'PC06', 4)); % BDS-2 IGSO
nPC07 = sum(strncmp(C, 'PC07', 4)); % BDS-2 IGSO
nPC08 = sum(strncmp(C, 'PC08', 4)); % BDS-2 IGSO
nPC09 = sum(strncmp(C, 'PC09', 4)); % BDS-2 IGSO
nPC10 = sum(strncmp(C, 'PC10', 4)); % BDS-2 IGSO
nPC11 = sum(strncmp(C, 'PC11', 4)); % BDS-2 MEO
nPC12 = sum(strncmp(C, 'PC12', 4)); % BDS-2 MEO
nPC13 = sum(strncmp(C, 'PC13', 4)); % BDS-2 IGSO
nPC14 = sum(strncmp(C, 'PC14', 4)); % BDS-2 MEO
nPC16 = sum(strncmp(C, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3
nPC19 = sum(strncmp(C, 'PC19', 4)); % BDS-3 MEO
nPC20 = sum(strncmp(C, 'PC20', 4)); % BDS-3 MEO
nPC21 = sum(strncmp(C, 'PC21', 4)); % BDS-3 MEO
nPC22 = sum(strncmp(C, 'PC22', 4)); % BDS-3 MEO
nPC23 = sum(strncmp(C, 'PC23', 4)); % BDS-3 MEO
nPC24 = sum(strncmp(C, 'PC24', 4)); % BDS-3 MEO
nPC25 = sum(strncmp(C, 'PC25', 4)); % BDS-3 MEO
nPC26 = sum(strncmp(C, 'PC26', 4)); % BDS-3 MEO
nPC27 = sum(strncmp(C, 'PC27', 4)); % BDS-3 MEO
nPC28 = sum(strncmp(C, 'PC28', 4)); % BDS-3 MEO
nPC29 = sum(strncmp(C, 'PC29', 4)); % BDS-3 MEO
nPC30 = sum(strncmp(C, 'PC30', 4)); % BDS-3 MEO
nPC31 = sum(strncmp(C, 'PC31', 4)); % BDS-3 MEO
nPC32 = sum(strncmp(C, 'PC32', 4)); % BDS-3 MEO
nPC33 = sum(strncmp(C, 'PC33', 4)); % BDS-3 MEO
nPC34 = sum(strncmp(C, 'PC34', 4)); % BDS-3 MEO
nPC35 = sum(strncmp(C, 'PC35', 4)); % BDS-3 MEO
nPC36 = sum(strncmp(C, 'PC36', 4)); % BDS-3 MEO
nPC37 = sum(strncmp(C, 'PC37', 4)); % BDS-3 MEO
nPC38 = sum(strncmp(C, 'PC38', 4)); % BDS-3 IGSO
nPC39 = sum(strncmp(C, 'PC39', 4)); % BDS-3 IGSO
nPC40 = sum(strncmp(C, 'PC40', 4)); % BDS-3 IGSO
nPC41 = sum(strncmp(C, 'PC41', 4)); % BDS-3 MEO
nPC42 = sum(strncmp(C, 'PC42', 4)); % BDS-3 MEO
nPC43 = sum(strncmp(C, 'PC43', 4)); % BDS-3 MEO
nPC44 = sum(strncmp(C, 'PC44', 4)); % BDS-3 MEO
nPC45 = sum(strncmp(C, 'PC45', 4)); % BDS-3 MEO
nPC46 = sum(strncmp(C, 'PC46', 4)); % BDS-3 MEO
nPC56 = sum(strncmp(C, 'PC56', 4)); % BDS-3 MEO
nPC59 = sum(strncmp(C, 'PC59', 4)); % BDS-3 GEO
nPC60 = sum(strncmp(C, 'PC60', 4)); % BDS-3 GEO
nPC61 = sum(strncmp(C, 'PC61', 4)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
end

%===============non-availability-check===================================

%========= BDS-2 & BDS-3 IGSO/MEO/GEO CLASSIFICATIONS (https://www.glonass-iac.ru/en/BEIDOU/)======
if num_of_files==1 %============ single file  ===================    
%data_non_availability=readfile(full_file_name);
fileID = fopen(full_file_name);
%data_non_availability_0=textscan(fileID, '%[^,\n]');
data_non_availability_0=textscan(fileID, '%[^\n]');
fclose(fileID);
data_non_availability=data_non_availability_0{1,1};
data_non_availability_new=data_non_availability(cellfun(@(x) contains(x,'999999.99999'),data_non_availability));
% BDS-2 non_clk
nPC01_non_clk = sum(strncmp(data_non_availability_new, 'PC01', 4)); % BDS-2 GEO
nPC02_non_clk = sum(strncmp(data_non_availability_new, 'PC02', 4)); % BDS-2 GEO
nPC03_non_clk = sum(strncmp(data_non_availability_new, 'PC03', 4)); % BDS-2 GEO
nPC04_non_clk = sum(strncmp(data_non_availability_new, 'PC04', 4)); % BDS-2 GEO
nPC05_non_clk = sum(strncmp(data_non_availability_new, 'PC05', 4)); % BDS-2 GEO
nPC06_non_clk = sum(strncmp(data_non_availability_new, 'PC06', 4)); % BDS-2 IGSO
nPC07_non_clk = sum(strncmp(data_non_availability_new, 'PC07', 4)); % BDS-2 IGSO
nPC08_non_clk = sum(strncmp(data_non_availability_new, 'PC08', 4)); % BDS-2 IGSO
nPC09_non_clk = sum(strncmp(data_non_availability_new, 'PC09', 4)); % BDS-2 IGSO
nPC10_non_clk = sum(strncmp(data_non_availability_new, 'PC10', 4)); % BDS-2 IGSO
nPC11_non_clk = sum(strncmp(data_non_availability_new, 'PC11', 4)); % BDS-2 MEO
nPC12_non_clk = sum(strncmp(data_non_availability_new, 'PC12', 4)); % BDS-2 MEO
nPC13_non_clk = sum(strncmp(data_non_availability_new, 'PC13', 4)); % BDS-2 IGSO
nPC14_non_clk = sum(strncmp(data_non_availability_new, 'PC14', 4)); % BDS-2 MEO
nPC16_non_clk = sum(strncmp(data_non_availability_new, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3 non_clk
nPC19_non_clk = sum(strncmp(data_non_availability_new, 'PC19', 4)); % BDS-3 MEO
nPC20_non_clk = sum(strncmp(data_non_availability_new, 'PC20', 4)); % BDS-3 MEO 
nPC21_non_clk = sum(strncmp(data_non_availability_new, 'PC21', 4)); % BDS-3 MEO 
nPC22_non_clk = sum(strncmp(data_non_availability_new, 'PC22', 4)); % BDS-3 MEO 
nPC23_non_clk = sum(strncmp(data_non_availability_new, 'PC23', 4)); % BDS-3 MEO 
nPC24_non_clk = sum(strncmp(data_non_availability_new, 'PC24', 4)); % BDS-3 MEO 
nPC25_non_clk = sum(strncmp(data_non_availability_new, 'PC25', 4)); % BDS-3 MEO 
nPC26_non_clk = sum(strncmp(data_non_availability_new, 'PC26', 4)); % BDS-3 MEO 
nPC27_non_clk = sum(strncmp(data_non_availability_new, 'PC27', 4)); % BDS-3 MEO 
nPC28_non_clk = sum(strncmp(data_non_availability_new, 'PC28', 4)); % BDS-3 MEO 
nPC29_non_clk = sum(strncmp(data_non_availability_new, 'PC29', 4)); % BDS-3 MEO 
nPC30_non_clk = sum(strncmp(data_non_availability_new, 'PC30', 4)); % BDS-3 MEO 
nPC31_non_clk = sum(strncmp(data_non_availability_new, 'PC31', 4)); % BDS-3 MEO 
nPC32_non_clk = sum(strncmp(data_non_availability_new, 'PC32', 4)); % BDS-3 MEO 
nPC33_non_clk = sum(strncmp(data_non_availability_new, 'PC33', 4)); % BDS-3 MEO 
nPC34_non_clk = sum(strncmp(data_non_availability_new, 'PC34', 4)); % BDS-3 MEO 
nPC35_non_clk = sum(strncmp(data_non_availability_new, 'PC35', 4)); % BDS-3 MEO 
nPC36_non_clk = sum(strncmp(data_non_availability_new, 'PC36', 4)); % BDS-3 MEO 
nPC37_non_clk = sum(strncmp(data_non_availability_new, 'PC37', 4)); % BDS-3 MEO 
nPC38_non_clk = sum(strncmp(data_non_availability_new, 'PC38', 4)); % BDS-3 IGSO 
nPC39_non_clk = sum(strncmp(data_non_availability_new, 'PC39', 4)); % BDS-3 IGSO 
nPC40_non_clk = sum(strncmp(data_non_availability_new, 'PC40', 4)); % BDS-3 IGSO 
nPC41_non_clk = sum(strncmp(data_non_availability_new, 'PC41', 4)); % BDS-3 MEO 
nPC42_non_clk = sum(strncmp(data_non_availability_new, 'PC42', 4)); % BDS-3 MEO 
nPC43_non_clk = sum(strncmp(data_non_availability_new, 'PC43', 4)); % BDS-3 MEO 
nPC44_non_clk = sum(strncmp(data_non_availability_new, 'PC44', 4)); % BDS-3 MEO 
nPC45_non_clk = sum(strncmp(data_non_availability_new, 'PC45', 4)); % BDS-3 MEO 
nPC46_non_clk = sum(strncmp(data_non_availability_new, 'PC46', 4)); % BDS-3 MEO 
nPC56_non_clk = sum(strncmp(data_non_availability_new, 'PC56', 4)); % BDS-3 MEO 
nPC59_non_clk = sum(strncmp(data_non_availability_new, 'PC59', 4)); % BDS-3 GEO 
nPC60_non_clk = sum(strncmp(data_non_availability_new, 'PC60', 4)); % BDS-3 GEO 
nPC61_non_clk = sum(strncmp(data_non_availability_new, 'PC61', 4)); % BDS-3 GEO 

nPC2_GEO_non_clk=[nPC01_non_clk nPC02_non_clk nPC03_non_clk nPC04_non_clk nPC05_non_clk];
nPC2_IGSO_non_clk=[nPC06_non_clk nPC07_non_clk nPC08_non_clk nPC09_non_clk nPC10_non_clk nPC13_non_clk nPC16_non_clk];
nPC2_MEO_non_clk=[nPC11_non_clk nPC12_non_clk nPC14_non_clk];

nPC3_GEO_non_clk=[nPC59_non_clk nPC60_non_clk nPC61_non_clk];
nPC3_IGSO_non_clk=[nPC38_non_clk nPC39_non_clk nPC40_non_clk nPC31_non_clk nPC56_non_clk];
nPC3_MEO_non_clk=[nPC19_non_clk nPC20_non_clk nPC21_non_clk nPC22_non_clk nPC23_non_clk nPC24_non_clk nPC25_non_clk...
    nPC26_non_clk nPC27_non_clk nPC28_non_clk nPC29_non_clk nPC30_non_clk nPC32_non_clk nPC33_non_clk nPC34_non_clk...
    nPC35_non_clk nPC36_non_clk nPC37_non_clk nPC41_non_clk nPC42_non_clk nPC43_non_clk nPC44_non_clk nPC45_non_clk nPC46_non_clk];
end
if num_of_files>1 %========== multiple files ==================
    for j=1:num_of_files
    %data_non_availability{:,j}=readfile(full_file_name(j,:));
    fileID{j,:} = fopen(full_file_name(j,:));
    data_non_availability_0{j,:}=textscan(fileID{j,:}, '%[^\n]');
    fclose(fileID{j,:});
data_non_availability_neww{j,:}=data_non_availability_0{j,:}{1,1}(cellfun(@(x) contains(x,'999999.99999'),data_non_availability_0{j,:}{1,1}));
data_non_availability_new=data_non_availability_neww';
data_non_availability_0{j,:}=[]; %!!!!!!
% BDS-2 non_clk
nPC01_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC01', 4)); % BDS-2 GEO
nPC02_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC02', 4)); % BDS-2 GEO
nPC03_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC03', 4)); % BDS-2 GEO
nPC04_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC04', 4)); % BDS-2 GEO
nPC05_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC05', 4)); % BDS-2 GEO
nPC06_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC06', 4)); % BDS-2 IGSO
nPC07_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC07', 4)); % BDS-2 IGSO
nPC08_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC08', 4)); % BDS-2 IGSO
nPC09_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC09', 4)); % BDS-2 IGSO
nPC10_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC10', 4)); % BDS-2 IGSO
nPC11_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC11', 4)); % BDS-2 MEO
nPC12_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC12', 4)); % BDS-2 MEO
nPC13_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC13', 4)); % BDS-2 IGSO
nPC14_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC14', 4)); % BDS-2 MEO
nPC16_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3 non_clk
nPC19_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC19', 4)); % BDS-3 MEO
nPC20_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC20', 4)); % BDS-3 MEO 
nPC21_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC21', 4)); % BDS-3 MEO 
nPC22_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC22', 4)); % BDS-3 MEO 
nPC23_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC23', 4)); % BDS-3 MEO 
nPC24_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC24', 4)); % BDS-3 MEO 
nPC25_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC25', 4)); % BDS-3 MEO 
nPC26_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC26', 4)); % BDS-3 MEO 
nPC27_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC27', 4)); % BDS-3 MEO 
nPC28_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC28', 4)); % BDS-3 MEO 
nPC29_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC29', 4)); % BDS-3 MEO 
nPC30_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC30', 4)); % BDS-3 MEO 
nPC31_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC31', 4)); % BDS-3 MEO 
nPC32_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC32', 4)); % BDS-3 MEO 
nPC33_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC33', 4)); % BDS-3 MEO 
nPC34_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC34', 4)); % BDS-3 MEO 
nPC35_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC35', 4)); % BDS-3 MEO 
nPC36_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC36', 4)); % BDS-3 MEO 
nPC37_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC37', 4)); % BDS-3 MEO 
nPC38_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC38', 4)); % BDS-3 IGSO 
nPC39_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC39', 4)); % BDS-3 IGSO 
nPC40_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC40', 4)); % BDS-3 IGSO 
nPC41_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC41', 4)); % BDS-3 MEO 
nPC42_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC42', 4)); % BDS-3 MEO 
nPC43_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC43', 4)); % BDS-3 MEO 
nPC44_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC44', 4)); % BDS-3 MEO 
nPC45_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC45', 4)); % BDS-3 MEO 
nPC46_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC46', 4)); % BDS-3 MEO 
nPC56_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC56', 4)); % BDS-3 MEO 
nPC59_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC59', 4)); % BDS-3 GEO 
nPC60_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC60', 4)); % BDS-3 GEO 
nPC61_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC61', 4)); % BDS-3 GEO 
    end
nPC2_GEO_non_clk=[nPC01_non_clk nPC02_non_clk nPC03_non_clk nPC04_non_clk nPC05_non_clk];
nPC2_IGSO_non_clk=[nPC06_non_clk nPC07_non_clk nPC08_non_clk nPC09_non_clk nPC10_non_clk nPC13_non_clk nPC16_non_clk];
nPC2_MEO_non_clk=[nPC11_non_clk nPC12_non_clk nPC14_non_clk];

nPC3_GEO_non_clk=[nPC59_non_clk nPC60_non_clk nPC61_non_clk];
nPC3_IGSO_non_clk=[nPC38_non_clk nPC39_non_clk nPC40_non_clk nPC31_non_clk nPC56_non_clk];
nPC3_MEO_non_clk=[nPC19_non_clk nPC20_non_clk nPC21_non_clk nPC22_non_clk nPC23_non_clk nPC24_non_clk nPC25_non_clk...
    nPC26_non_clk nPC27_non_clk nPC28_non_clk nPC29_non_clk nPC30_non_clk nPC32_non_clk nPC33_non_clk nPC34_non_clk...
    nPC35_non_clk nPC36_non_clk nPC37_non_clk nPC41_non_clk nPC42_non_clk nPC43_non_clk nPC44_non_clk nPC45_non_clk nPC46_non_clk];
    
end
        if num_of_files==1
nPG = sum(strncmp(C, 'PG', 2)); 
nPR = sum(strncmp(C, 'PR', 2));
nPE = sum(strncmp(C, 'PE', 2));
nPJ = sum(strncmp(C, 'PJ', 2)); 
nPI = sum(strncmp(C, 'PI', 2));    
X = ~cellfun(@isempty,regexp(C,'^\*  \d{4}')); % example: *  2021  3 28
number_of_epochs=numel(find(1==X));
reference_average_GPS_number_reference=nPG/number_of_epochs;
reference_average_GALILEO_number_reference=nPE/number_of_epochs;
reference_average_GLONASS_number_reference=nPR/number_of_epochs;
reference_average_QZSS_number_reference=nPJ/number_of_epochs;
reference_average_IRNSS_number_reference=nPI/number_of_epochs;
for i=1:numel(nPC2_GEO)
reference_average_BDS2_number_GEO(i)=nPC2_GEO(i)/number_of_epochs;
end
reference_average_BDS2_number_sum_GEO_reference=sum(reference_average_BDS2_number_GEO);

for i=1:numel(nPC2_IGSO)
    reference_average_BDS2_number_IGSO(i)=nPC2_IGSO(i)/number_of_epochs;
end
reference_average_BDS2_number_sum_IGSO_reference=sum(reference_average_BDS2_number_IGSO);

for i=1:numel(nPC2_MEO)
reference_average_BDS2_number_MEO(i)=nPC2_MEO(i)/number_of_epochs;
end
reference_average_BDS2_number_sum_MEO_reference=sum(reference_average_BDS2_number_MEO);

for i=1:numel(nPC3_GEO)
reference_average_BDS3_number_GEO(i)=nPC3_GEO(i)/number_of_epochs;
end
reference_average_BDS3_number_sum_GEO_reference=sum(reference_average_BDS3_number_GEO);

for i=1:numel(nPC3_IGSO)
    reference_average_BDS3_number_IGSO(i)=nPC3_IGSO(i)/number_of_epochs;
end
reference_average_BDS3_number_sum_IGSO_reference=sum(reference_average_BDS3_number_IGSO);

for i=1:numel(nPC3_MEO)
reference_average_BDS3_number_MEO(i)=nPC3_MEO(i)/number_of_epochs;
end
reference_average_BDS3_number_sum_MEO_reference=sum(reference_average_BDS3_number_MEO);
nPG_non_clk = sum(strncmp(data_non_availability_new, 'PG', 2));
nPR_non_clk = sum(strncmp(data_non_availability_new, 'PR', 2));
nPE_non_clk = sum(strncmp(data_non_availability_new, 'PE', 2));
nPJ_non_clk=sum(strncmp(data_non_availability_new, 'PJ', 2));
nPI_non_clk=sum(strncmp(data_non_availability_new, 'PI', 2));
nPG_non_clk_ratio_reference=(100*nPG_non_clk)/nPG;
nPR_non_clk_ratio_reference=(100*nPR_non_clk)/nPR;
nPE_non_clk_ratio_reference=(100*nPE_non_clk)/nPE;
nPJ_non_clk_ratio_reference=(100*nPJ_non_clk)/nPJ;
nPI_non_clk_ratio_reference=(100*nPI_non_clk)/nPI;

nPC2_GEO_non_clk_ratio_reference=(100*sum(nPC2_GEO_non_clk))/sum(nPC2_GEO);
nPC2_IGSO_non_clk_ratio_reference=(100*sum(nPC2_IGSO_non_clk))/sum(nPC2_IGSO);
nPC2_MEO_non_clk_ratio_reference=(100*sum(nPC2_MEO_non_clk))/sum(nPC2_MEO);

nPC3_GEO_non_clk_ratio_reference=(100*sum(nPC3_GEO_non_clk))/sum(nPC3_GEO);
nPC3_IGSO_non_clk_ratio_reference=(100*sum(nPC3_IGSO_non_clk))/sum(nPC3_IGSO);
nPC3_MEO_non_clk_ratio_reference=(100*sum(nPC3_MEO_non_clk))/sum(nPC3_MEO);
        end      
if num_of_files>1
    for j=1:num_of_files
Str{j,:} = fileread(full_file_name(j,:)); % 2xn cell array  ......   OKED    ...........
CC{j,:}   = strsplit(Str{j,:}, '\n');   % line by line ;  \n == new line % 2xn cell array
nPC01(j) = sum(strncmp(CC{j,:}, 'PC01', 4)); % BDS-2 GEO
nPC02(j) = sum(strncmp(CC{j,:}, 'PC02', 4)); % BDS-2 GEO
nPC03(j) = sum(strncmp(CC{j,:}, 'PC03', 4)); % BDS-2 GEO
nPC04(j) = sum(strncmp(CC{j,:}, 'PC04', 4)); % BDS-2 GEO
nPC05(j) = sum(strncmp(CC{j,:}, 'PC05', 4)); % BDS-2 GEO
nPC06(j) = sum(strncmp(CC{j,:}, 'PC06', 4)); % BDS-2 IGSO
nPC07(j) = sum(strncmp(CC{j,:}, 'PC07', 4)); % BDS-2 IGSO
nPC08(j) = sum(strncmp(CC{j,:}, 'PC08', 4)); % BDS-2 IGSO
nPC09(j) = sum(strncmp(CC{j,:}, 'PC09', 4)); % BDS-2 IGSO
nPC10(j) = sum(strncmp(CC{j,:}, 'PC10', 4)); % BDS-2 IGSO
nPC11(j) = sum(strncmp(CC{j,:}, 'PC11', 4)); % BDS-2 MEO
nPC12(j) = sum(strncmp(CC{j,:}, 'PC12', 4)); % BDS-2 MEO
nPC13(j) = sum(strncmp(CC{j,:}, 'PC13', 4)); % BDS-2 IGSO
nPC14(j) = sum(strncmp(CC{j,:}, 'PC14', 4)); % BDS-2 MEO
nPC16(j) = sum(strncmp(CC{j,:}, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3
nPC19(j)=  sum(strncmp(CC{j,:}, 'PC19', 4)); % BDS-3 MEO
nPC20(j) = sum(strncmp(CC{j,:}, 'PC20', 4)); % BDS-3 MEO
nPC21(j) = sum(strncmp(CC{j,:}, 'PC21', 4)); % BDS-3 MEO
nPC22(j) = sum(strncmp(CC{j,:}, 'PC22', 4)); % BDS-3 MEO
nPC23(j) = sum(strncmp(CC{j,:}, 'PC23', 4)); % BDS-3 MEO
nPC24(j) = sum(strncmp(CC{j,:}, 'PC24', 4)); % BDS-3 MEO
nPC25(j) = sum(strncmp(CC{j,:}, 'PC25', 4)); % BDS-3 MEO
nPC26(j) = sum(strncmp(CC{j,:}, 'PC26', 4)); % BDS-3 MEO
nPC27(j) = sum(strncmp(CC{j,:}, 'PC27', 4)); % BDS-3 MEO
nPC28(j) = sum(strncmp(CC{j,:}, 'PC28', 4)); % BDS-3 MEO
nPC29(j) = sum(strncmp(CC{j,:}, 'PC29', 4)); % BDS-3 MEO
nPC30(j) = sum(strncmp(CC{j,:}, 'PC30', 4)); % BDS-3 MEO
nPC31(j) = sum(strncmp(CC{j,:}, 'PC31', 4)); % BDS-3 MEO
nPC32(j) = sum(strncmp(CC{j,:}, 'PC32', 4)); % BDS-3 MEO
nPC33(j) = sum(strncmp(CC{j,:}, 'PC33', 4)); % BDS-3 MEO
nPC34(j) = sum(strncmp(CC{j,:}, 'PC34', 4)); % BDS-3 MEO
nPC35(j) = sum(strncmp(CC{j,:}, 'PC35', 4)); % BDS-3 MEO
nPC36(j) = sum(strncmp(CC{j,:}, 'PC36', 4)); % BDS-3 MEO
nPC37(j) = sum(strncmp(CC{j,:}, 'PC37', 4)); % BDS-3 MEO
nPC38(j) = sum(strncmp(CC{j,:}, 'PC38', 4)); % BDS-3 IGSO
nPC39(j) = sum(strncmp(CC{j,:}, 'PC39', 4)); % BDS-3 IGSO
nPC40(j) = sum(strncmp(CC{j,:}, 'PC40', 4)); % BDS-3 IGSO
nPC41(j) = sum(strncmp(CC{j,:}, 'PC41', 4)); % BDS-3 MEO
nPC42(j) = sum(strncmp(CC{j,:}, 'PC42', 4)); % BDS-3 MEO
nPC43(j) = sum(strncmp(CC{j,:}, 'PC43', 4)); % BDS-3 MEO
nPC44(j) = sum(strncmp(CC{j,:}, 'PC44', 4)); % BDS-3 MEO
nPC45(j) = sum(strncmp(CC{j,:}, 'PC45', 4)); % BDS-3 MEO
nPC46(j) = sum(strncmp(CC{j,:}, 'PC46', 4)); % BDS-3 MEO
nPC56(j) = sum(strncmp(CC{j,:}, 'PC56', 4)); % BDS-3 MEO
nPC59(j) = sum(strncmp(CC{j,:}, 'PC59', 4)); % BDS-3 GEO
nPC60(j) = sum(strncmp(CC{j,:}, 'PC60', 4)); % BDS-3 GEO
nPC61(j) = sum(strncmp(CC{j,:}, 'PC61', 4)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
    nPG(j) = sum(strncmp(CC{j,:}, 'PG', 2)); 
nPR(j) = sum(strncmp(CC{j,:}, 'PR', 2));
nPE(j) = sum(strncmp(CC{j,:}, 'PE', 2));
nPJ(j) = sum(strncmp(CC{j,:}, 'PJ', 2)); 
nPI(j) = sum(strncmp(CC{j,:}, 'PI', 2));    
X{j,:} = ~cellfun(@isempty,regexp(CC{j,:},'^\*  \d{4}')); % example: *  2021  3 28
number_of_epochs(j)=numel(find(1==X{j,:}));
reference_average_GPS_number_reference(j)=nPG(j)/number_of_epochs(j);
reference_average_GALILEO_number_reference(j)=nPE(j)/number_of_epochs(j);
reference_average_GLONASS_number_reference(j)=nPR(j)/number_of_epochs(j);
reference_average_QZSS_number_reference(j)=nPJ(j)/number_of_epochs(j);
reference_average_IRNSS_number_reference(j)=nPI(j)/number_of_epochs(j);
reference_GPS_number=mean(reference_average_GPS_number_reference);
reference_GALILEO_number=mean(reference_average_GALILEO_number_reference);
reference_GLONASS_number=mean(reference_average_GLONASS_number_reference);
reference_QZSS_number=mean(reference_average_QZSS_number_reference);
reference_IRNSS_number=mean(reference_average_IRNSS_number_reference);
    end
nPC2_GEO=[nPC01;nPC02;nPC03;nPC04;nPC05];
    [a,b]=size(nPC2_GEO);
    for j=1:num_of_files
    for i=1:a  
reference_average_BDS2_number_GEO(i,j)=nPC2_GEO(i,j)/number_of_epochs(j);
    end
    end
    for j=1:num_of_files  
reference_average_BDS2_number_sum_GEO_reference(j)=sum(reference_average_BDS2_number_GEO(:,j));
    end
    reference_BDS2_GEO_number=mean(reference_average_BDS2_number_sum_GEO_reference);
    nPC2_IGSO=[nPC06;nPC07;nPC08;nPC09;nPC10;nPC13;nPC16];
    [a,b]=size(nPC2_IGSO);
    for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_IGSO(i,j)=nPC2_IGSO(i,j)/number_of_epochs(j);
    end
    end
    for j=1:num_of_files  
        reference_average_BDS2_number_sum_IGSO_reference(j)=sum(reference_average_BDS2_number_IGSO(:,j));
    end
    reference_BDS2_IGSO_number=mean(reference_average_BDS2_number_sum_IGSO_reference);
    nPC2_MEO=[nPC11;nPC12;nPC14];
[a,b]=size(nPC2_MEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_MEO(i,j)=nPC2_MEO(i,j)/number_of_epochs(j);
    end
end
for j=1:num_of_files 
    reference_average_BDS2_number_sum_MEO_reference(j)=sum(reference_average_BDS2_number_MEO(:,j));
end
reference_BDS2_MEO_number=mean(reference_average_BDS2_number_sum_MEO_reference);
nPC3_GEO=[nPC59;nPC60;nPC61];
[a,b]=size(nPC3_GEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_GEO(i,j)=nPC3_GEO(i,j)/number_of_epochs(j);
    end
end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_GEO_reference(j)=sum(reference_average_BDS3_number_GEO(:,j));
end
reference_BDS3_GEO_number=mean(reference_average_BDS3_number_sum_GEO_reference);
nPC3_IGSO=[nPC38;nPC39;nPC40;nPC31;nPC56];
        [a,b]=size(nPC3_IGSO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_IGSO(i,j)=nPC3_IGSO(i,j)/number_of_epochs(j);
    end
end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_IGSO_reference(j)=sum(reference_average_BDS3_number_IGSO(:,j));
end
reference_BDS3_IGSO_number=mean(reference_average_BDS3_number_sum_IGSO_reference);        
nPC3_MEO=[nPC19;nPC20;nPC21;nPC22;nPC23;nPC24;nPC25;nPC26;nPC27;nPC28;nPC29;nPC30;nPC32;nPC33;nPC34;nPC35;nPC36;nPC37;nPC41;nPC42;nPC43;nPC44;nPC45;nPC46];
        [a,b]=size(nPC3_MEO);
        for j=1:num_of_files
    for i=1:a 
        reference_average_BDS3_number_MEO(i,j)=nPC3_MEO(i,j)/number_of_epochs(j);
    end
        end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_MEO_reference(j)=sum(reference_average_BDS3_number_MEO(:,j));
end
reference_BDS3_MEO_number=mean(reference_average_BDS3_number_sum_MEO_reference);   

nPC2_GEO_non_clk=cell2mat([nPC01_non_clk;nPC02_non_clk;nPC03_non_clk;nPC04_non_clk;nPC05_non_clk]);
nPC2_IGSO_non_clk=cell2mat([nPC06_non_clk;nPC07_non_clk;nPC08_non_clk;nPC09_non_clk;nPC10_non_clk;nPC13_non_clk;nPC16_non_clk]);
nPC2_MEO_non_clk=cell2mat([nPC11_non_clk;nPC12_non_clk;nPC14_non_clk]);
nPC3_GEO_non_clk=cell2mat([nPC59_non_clk;nPC60_non_clk;nPC61_non_clk]);
nPC3_IGSO_non_clk=cell2mat([nPC38_non_clk;nPC39_non_clk;nPC40_non_clk;nPC31_non_clk;nPC56_non_clk]);
nPC3_MEO_non_clk=cell2mat([nPC19_non_clk;nPC20_non_clk;nPC21_non_clk;nPC22_non_clk;nPC23_non_clk;nPC24_non_clk;nPC25_non_clk...
    ;nPC26_non_clk;nPC27_non_clk;nPC28_non_clk;nPC29_non_clk;nPC30_non_clk;nPC32_non_clk;nPC33_non_clk;nPC34_non_clk...
    ;nPC35_non_clk;nPC36_non_clk;nPC37_non_clk;nPC41_non_clk;nPC42_non_clk;nPC43_non_clk;nPC44_non_clk;nPC45_non_clk;nPC46_non_clk]);
for j=1:num_of_files 
nPC2_GEO_non_clk_ratio_reference(j)=(100*sum(nPC2_GEO_non_clk(:,j)))/sum(nPC2_GEO(:,j));
nPC2_IGSO_non_clk_ratio_reference(j)=(100*sum(nPC2_IGSO_non_clk(:,j)))/sum(nPC2_IGSO(:,j));
nPC2_MEO_non_clk_ratio_reference(j)=(100*sum(nPC2_MEO_non_clk(:,j)))/sum(nPC2_MEO(:,j));

nPC3_GEO_non_clk_ratio_reference(j)=(100*sum(nPC3_GEO_non_clk(:,j)))/sum(nPC3_GEO(:,j));
nPC3_IGSO_non_clk_ratio_reference(j)=(100*sum(nPC3_IGSO_non_clk(:,j)))/sum(nPC3_IGSO(:,j));
nPC3_MEO_non_clk_ratio_reference(j)=(100*sum(nPC3_MEO_non_clk(:,j)))/sum(nPC3_MEO(:,j));

nPG_non_clk(j) = sum(strncmp(data_non_availability_new{:,j}, 'PG', 2));
nPR_non_clk(j) = sum(strncmp(data_non_availability_new{:,j}, 'PR', 2));
nPE_non_clk(j) = sum(strncmp(data_non_availability_new{:,j}, 'PE', 2));
nPJ_non_clk(j)=sum(strncmp(data_non_availability_new{:,j}, 'PJ', 2));
nPI_non_clk(j)=sum(strncmp(data_non_availability_new{:,j}, 'PI', 2));
nPG_non_clk_ratio_reference(j)=(100*nPG_non_clk(j))/nPG(j);
nPR_non_clk_ratio_reference(j)=(100*nPR_non_clk(j))/nPR(j);
nPE_non_clk_ratio_reference(j)=(100*nPE_non_clk(j))/nPE(j);
nPJ_non_clk_ratio_reference(j)=(100*nPJ_non_clk(j))/nPJ(j);
nPI_non_clk_ratio_reference(j)=(100*nPI_non_clk(j))/nPI(j);
Str{j,:}=[];
CC{j,:}=[];
end
    reference_BDS2_GEO_non_clk=mean(nPC2_GEO_non_clk_ratio_reference);
    reference_BDS2_IGSO_non_clk=mean(nPC2_IGSO_non_clk_ratio_reference);
    reference_BDS2_MEO_non_clk=mean(nPC2_MEO_non_clk_ratio_reference);
    reference_BDS3_GEO_non_clk=mean(nPC3_GEO_non_clk_ratio_reference);
    reference_BDS3_IGSO_non_clk=mean(nPC3_IGSO_non_clk_ratio_reference);
    reference_BDS3_MEO_non_clk=mean(nPC3_MEO_non_clk_ratio_reference);
    reference_GPS_non_clk=mean(nPG_non_clk_ratio_reference);
    reference_GLONASS_non_clk=mean(nPR_non_clk_ratio_reference);
    reference_GALILEO_non_clk=mean(nPE_non_clk_ratio_reference);
    reference_QZSS_non_clk=mean(nPJ_non_clk_ratio_reference);
    reference_IRNSS_non_clk=mean(nPI_non_clk_ratio_reference);
end

end
end

% check the GNSS constellations .....
% GPS
%=============  target product ============================================
if exist('extension2') == 1
if strcmp(extension2(1,:),'H_M')==1 || strcmp(extension2(1,:),'sp3')==1 || strcmp(extension2(1,:),'SP3')==1 || strcmp(extension2(1,:),'EPH')==1 || strcmp(extension2(1,:),'eph')==1 || strcmp(extension2(1,:),'K_M')==1
%========= BDS-2 & BDS-3 IGSO/MEO/GEO CLASSIFICATIONS (https://www.glonass-iac.ru/en/BEIDOU/)======
if num_of_files==1 %============ single file  =================== 
% BDS-2
nPC01 = sum(strncmp(C2, 'PC01', 4)); % BDS-2 GEO
nPC02 = sum(strncmp(C2, 'PC02', 4)); % BDS-2 GEO
nPC03 = sum(strncmp(C2, 'PC03', 4)); % BDS-2 GEO
nPC04 = sum(strncmp(C2, 'PC04', 4)); % BDS-2 GEO
nPC05 = sum(strncmp(C2, 'PC05', 4)); % BDS-2 GEO
nPC06 = sum(strncmp(C2, 'PC06', 4)); % BDS-2 IGSO
nPC07 = sum(strncmp(C2, 'PC07', 4)); % BDS-2 IGSO
nPC08 = sum(strncmp(C2, 'PC08', 4)); % BDS-2 IGSO
nPC09 = sum(strncmp(C2, 'PC09', 4)); % BDS-2 IGSO
nPC10 = sum(strncmp(C2, 'PC10', 4)); % BDS-2 IGSO
nPC11 = sum(strncmp(C2, 'PC11', 4)); % BDS-2 MEO
nPC12 = sum(strncmp(C2, 'PC12', 4)); % BDS-2 MEO
nPC13 = sum(strncmp(C2, 'PC13', 4)); % BDS-2 IGSO
nPC14 = sum(strncmp(C2, 'PC14', 4)); % BDS-2 MEO
nPC16 = sum(strncmp(C2, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3
nPC19 = sum(strncmp(C2, 'PC19', 4)); % BDS-3 MEO
nPC20 = sum(strncmp(C2, 'PC20', 4)); % BDS-3 MEO
nPC21 = sum(strncmp(C2, 'PC21', 4)); % BDS-3 MEO
nPC22 = sum(strncmp(C2, 'PC22', 4)); % BDS-3 MEO
nPC23 = sum(strncmp(C2, 'PC23', 4)); % BDS-3 MEO
nPC24 = sum(strncmp(C2, 'PC24', 4)); % BDS-3 MEO
nPC25 = sum(strncmp(C2, 'PC25', 4)); % BDS-3 MEO
nPC26 = sum(strncmp(C2, 'PC26', 4)); % BDS-3 MEO
nPC27 = sum(strncmp(C2, 'PC27', 4)); % BDS-3 MEO
nPC28 = sum(strncmp(C2, 'PC28', 4)); % BDS-3 MEO
nPC29 = sum(strncmp(C2, 'PC29', 4)); % BDS-3 MEO
nPC30 = sum(strncmp(C2, 'PC30', 4)); % BDS-3 MEO
nPC31 = sum(strncmp(C2, 'PC31', 4)); % BDS-3 MEO
nPC32 = sum(strncmp(C2, 'PC32', 4)); % BDS-3 MEO
nPC33 = sum(strncmp(C2, 'PC33', 4)); % BDS-3 MEO
nPC34 = sum(strncmp(C2, 'PC34', 4)); % BDS-3 MEO
nPC35 = sum(strncmp(C2, 'PC35', 4)); % BDS-3 MEO
nPC36 = sum(strncmp(C2, 'PC36', 4)); % BDS-3 MEO
nPC37 = sum(strncmp(C2, 'PC37', 4)); % BDS-3 MEO
nPC38 = sum(strncmp(C2, 'PC38', 4)); % BDS-3 IGSO
nPC39 = sum(strncmp(C2, 'PC39', 4)); % BDS-3 IGSO
nPC40 = sum(strncmp(C2, 'PC40', 4)); % BDS-3 IGSO
nPC41 = sum(strncmp(C2, 'PC41', 4)); % BDS-3 MEO
nPC42 = sum(strncmp(C2, 'PC42', 4)); % BDS-3 MEO
nPC43 = sum(strncmp(C2, 'PC43', 4)); % BDS-3 MEO
nPC44 = sum(strncmp(C2, 'PC44', 4)); % BDS-3 MEO
nPC45 = sum(strncmp(C2, 'PC45', 4)); % BDS-3 MEO
nPC46 = sum(strncmp(C2, 'PC46', 4)); % BDS-3 MEO
nPC56 = sum(strncmp(C2, 'PC56', 4)); % BDS-3 MEO
nPC59 = sum(strncmp(C2, 'PC59', 4)); % BDS-3 GEO
nPC60 = sum(strncmp(C2, 'PC60', 4)); % BDS-3 GEO
nPC61 = sum(strncmp(C2, 'PC61', 4)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
end

if num_of_files>1 %========== multiple files ==================
% BDS-2
    for j=1:num_of_files
Str2{j,:} = fileread(full_file_name2(j,:));
CC2{j,:}   = strsplit(Str2{j,:}, '\n');
nPC01(j) = sum(strncmp(CC2{j,:}, 'PC01', 4)); % BDS-2 GEO
nPC02(j) = sum(strncmp(CC2{j,:}, 'PC02', 4)); % BDS-2 GEO
nPC03(j) = sum(strncmp(CC2{j,:}, 'PC03', 4)); % BDS-2 GEO
nPC04(j) = sum(strncmp(CC2{j,:}, 'PC04', 4)); % BDS-2 GEO
nPC05(j) = sum(strncmp(CC2{j,:}, 'PC05', 4)); % BDS-2 GEO
nPC06(j) = sum(strncmp(CC2{j,:}, 'PC06', 4)); % BDS-2 IGSO
nPC07(j) = sum(strncmp(CC2{j,:}, 'PC07', 4)); % BDS-2 IGSO
nPC08(j) = sum(strncmp(CC2{j,:}, 'PC08', 4)); % BDS-2 IGSO
nPC09(j) = sum(strncmp(CC2{j,:}, 'PC09', 4)); % BDS-2 IGSO
nPC10(j) = sum(strncmp(CC2{j,:}, 'PC10', 4)); % BDS-2 IGSO
nPC11(j) = sum(strncmp(CC2{j,:}, 'PC11', 4)); % BDS-2 MEO
nPC12(j) = sum(strncmp(CC2{j,:}, 'PC12', 4)); % BDS-2 MEO
nPC13(j) = sum(strncmp(CC2{j,:}, 'PC13', 4)); % BDS-2 IGSO
nPC14(j) = sum(strncmp(CC2{j,:}, 'PC14', 4)); % BDS-2 MEO
nPC16(j) = sum(strncmp(CC2{j,:}, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3
nPC19(j)=  sum(strncmp(CC2{j,:}, 'PC19', 4)); % BDS-3 MEO
nPC20(j) = sum(strncmp(CC2{j,:}, 'PC20', 4)); % BDS-3 MEO
nPC21(j) = sum(strncmp(CC2{j,:}, 'PC21', 4)); % BDS-3 MEO
nPC22(j) = sum(strncmp(CC2{j,:}, 'PC22', 4)); % BDS-3 MEO
nPC23(j) = sum(strncmp(CC2{j,:}, 'PC23', 4)); % BDS-3 MEO
nPC24(j) = sum(strncmp(CC2{j,:}, 'PC24', 4)); % BDS-3 MEO
nPC25(j) = sum(strncmp(CC2{j,:}, 'PC25', 4)); % BDS-3 MEO
nPC26(j) = sum(strncmp(CC2{j,:}, 'PC26', 4)); % BDS-3 MEO
nPC27(j) = sum(strncmp(CC2{j,:}, 'PC27', 4)); % BDS-3 MEO
nPC28(j) = sum(strncmp(CC2{j,:}, 'PC28', 4)); % BDS-3 MEO
nPC29(j) = sum(strncmp(CC2{j,:}, 'PC29', 4)); % BDS-3 MEO
nPC30(j) = sum(strncmp(CC2{j,:}, 'PC30', 4)); % BDS-3 MEO
nPC31(j) = sum(strncmp(CC2{j,:}, 'PC31', 4)); % BDS-3 MEO
nPC32(j) = sum(strncmp(CC2{j,:}, 'PC32', 4)); % BDS-3 MEO
nPC33(j) = sum(strncmp(CC2{j,:}, 'PC33', 4)); % BDS-3 MEO
nPC34(j) = sum(strncmp(CC2{j,:}, 'PC34', 4)); % BDS-3 MEO
nPC35(j) = sum(strncmp(CC2{j,:}, 'PC35', 4)); % BDS-3 MEO
nPC36(j) = sum(strncmp(CC2{j,:}, 'PC36', 4)); % BDS-3 MEO
nPC37(j) = sum(strncmp(CC2{j,:}, 'PC37', 4)); % BDS-3 MEO
nPC38(j) = sum(strncmp(CC2{j,:}, 'PC38', 4)); % BDS-3 IGSO
nPC39(j) = sum(strncmp(CC2{j,:}, 'PC39', 4)); % BDS-3 IGSO
nPC40(j) = sum(strncmp(CC2{j,:}, 'PC40', 4)); % BDS-3 IGSO
nPC41(j) = sum(strncmp(CC2{j,:}, 'PC41', 4)); % BDS-3 MEO
nPC42(j) = sum(strncmp(CC2{j,:}, 'PC42', 4)); % BDS-3 MEO
nPC43(j) = sum(strncmp(CC2{j,:}, 'PC43', 4)); % BDS-3 MEO
nPC44(j) = sum(strncmp(CC2{j,:}, 'PC44', 4)); % BDS-3 MEO
nPC45(j) = sum(strncmp(CC2{j,:}, 'PC45', 4)); % BDS-3 MEO
nPC46(j) = sum(strncmp(CC2{j,:}, 'PC46', 4)); % BDS-3 MEO
nPC56(j) = sum(strncmp(CC2{j,:}, 'PC56', 4)); % BDS-3 MEO
nPC59(j) = sum(strncmp(CC2{j,:}, 'PC59', 4)); % BDS-3 GEO
nPC60(j) = sum(strncmp(CC2{j,:}, 'PC60', 4)); % BDS-3 GEO
nPC61(j) = sum(strncmp(CC2{j,:}, 'PC61', 4)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
    end
end

%===============non-availability-check===================================

%========= BDS-2 & BDS-3 IGSO/MEO/GEO CLASSIFICATIONS (https://www.glonass-iac.ru/en/BEIDOU/)======
if num_of_files==1 %============ single file  ===================
%data_non_availability=readfile(full_file_name2);
fileID = fopen(full_file_name2);
% data_non_availability_0=textscan(fileID, '%[^,\n]');
data_non_availability_0=textscan(fileID, '%[^\n]');
fclose(fileID);
data_non_availability=data_non_availability_0{1,1};
data_non_availability_new=data_non_availability(cellfun(@(x) contains(x,'999999.99999'),data_non_availability));

% BDS-2 non_clk
nPC01_non_clk = sum(strncmp(data_non_availability_new, 'PC01', 4)); % BDS-2 GEO
nPC02_non_clk = sum(strncmp(data_non_availability_new, 'PC02', 4)); % BDS-2 GEO
nPC03_non_clk = sum(strncmp(data_non_availability_new, 'PC03', 4)); % BDS-2 GEO
nPC04_non_clk = sum(strncmp(data_non_availability_new, 'PC04', 4)); % BDS-2 GEO
nPC05_non_clk = sum(strncmp(data_non_availability_new, 'PC05', 4)); % BDS-2 GEO
nPC06_non_clk = sum(strncmp(data_non_availability_new, 'PC06', 4)); % BDS-2 IGSO
nPC07_non_clk = sum(strncmp(data_non_availability_new, 'PC07', 4)); % BDS-2 IGSO
nPC08_non_clk = sum(strncmp(data_non_availability_new, 'PC08', 4)); % BDS-2 IGSO
nPC09_non_clk = sum(strncmp(data_non_availability_new, 'PC09', 4)); % BDS-2 IGSO
nPC10_non_clk = sum(strncmp(data_non_availability_new, 'PC10', 4)); % BDS-2 IGSO
nPC11_non_clk = sum(strncmp(data_non_availability_new, 'PC11', 4)); % BDS-2 MEO
nPC12_non_clk = sum(strncmp(data_non_availability_new, 'PC12', 4)); % BDS-2 MEO
nPC13_non_clk = sum(strncmp(data_non_availability_new, 'PC13', 4)); % BDS-2 IGSO
nPC14_non_clk = sum(strncmp(data_non_availability_new, 'PC14', 4)); % BDS-2 MEO
nPC16_non_clk = sum(strncmp(data_non_availability_new, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3 non_clk
nPC19_non_clk = sum(strncmp(data_non_availability_new, 'PC19', 4)); % BDS-3 MEO
nPC20_non_clk = sum(strncmp(data_non_availability_new, 'PC20', 4)); % BDS-3 MEO 
nPC21_non_clk = sum(strncmp(data_non_availability_new, 'PC21', 4)); % BDS-3 MEO 
nPC22_non_clk = sum(strncmp(data_non_availability_new, 'PC22', 4)); % BDS-3 MEO 
nPC23_non_clk = sum(strncmp(data_non_availability_new, 'PC23', 4)); % BDS-3 MEO 
nPC24_non_clk = sum(strncmp(data_non_availability_new, 'PC24', 4)); % BDS-3 MEO 
nPC25_non_clk = sum(strncmp(data_non_availability_new, 'PC25', 4)); % BDS-3 MEO 
nPC26_non_clk = sum(strncmp(data_non_availability_new, 'PC26', 4)); % BDS-3 MEO 
nPC27_non_clk = sum(strncmp(data_non_availability_new, 'PC27', 4)); % BDS-3 MEO 
nPC28_non_clk = sum(strncmp(data_non_availability_new, 'PC28', 4)); % BDS-3 MEO 
nPC29_non_clk = sum(strncmp(data_non_availability_new, 'PC29', 4)); % BDS-3 MEO 
nPC30_non_clk = sum(strncmp(data_non_availability_new, 'PC30', 4)); % BDS-3 MEO 
nPC31_non_clk = sum(strncmp(data_non_availability_new, 'PC31', 4)); % BDS-3 MEO 
nPC32_non_clk = sum(strncmp(data_non_availability_new, 'PC32', 4)); % BDS-3 MEO 
nPC33_non_clk = sum(strncmp(data_non_availability_new, 'PC33', 4)); % BDS-3 MEO 
nPC34_non_clk = sum(strncmp(data_non_availability_new, 'PC34', 4)); % BDS-3 MEO 
nPC35_non_clk = sum(strncmp(data_non_availability_new, 'PC35', 4)); % BDS-3 MEO 
nPC36_non_clk = sum(strncmp(data_non_availability_new, 'PC36', 4)); % BDS-3 MEO 
nPC37_non_clk = sum(strncmp(data_non_availability_new, 'PC37', 4)); % BDS-3 MEO 
nPC38_non_clk = sum(strncmp(data_non_availability_new, 'PC38', 4)); % BDS-3 IGSO 
nPC39_non_clk = sum(strncmp(data_non_availability_new, 'PC39', 4)); % BDS-3 IGSO 
nPC40_non_clk = sum(strncmp(data_non_availability_new, 'PC40', 4)); % BDS-3 IGSO 
nPC41_non_clk = sum(strncmp(data_non_availability_new, 'PC41', 4)); % BDS-3 MEO 
nPC42_non_clk = sum(strncmp(data_non_availability_new, 'PC42', 4)); % BDS-3 MEO 
nPC43_non_clk = sum(strncmp(data_non_availability_new, 'PC43', 4)); % BDS-3 MEO 
nPC44_non_clk = sum(strncmp(data_non_availability_new, 'PC44', 4)); % BDS-3 MEO 
nPC45_non_clk = sum(strncmp(data_non_availability_new, 'PC45', 4)); % BDS-3 MEO 
nPC46_non_clk = sum(strncmp(data_non_availability_new, 'PC46', 4)); % BDS-3 MEO 
nPC56_non_clk = sum(strncmp(data_non_availability_new, 'PC56', 4)); % BDS-3 MEO 
nPC59_non_clk = sum(strncmp(data_non_availability_new, 'PC59', 4)); % BDS-3 GEO 
nPC60_non_clk = sum(strncmp(data_non_availability_new, 'PC60', 4)); % BDS-3 GEO 
nPC61_non_clk = sum(strncmp(data_non_availability_new, 'PC61', 4)); % BDS-3 GEO 

nPC2_GEO_non_clk=[nPC01_non_clk nPC02_non_clk nPC03_non_clk nPC04_non_clk nPC05_non_clk];
nPC2_IGSO_non_clk=[nPC06_non_clk nPC07_non_clk nPC08_non_clk nPC09_non_clk nPC10_non_clk nPC13_non_clk nPC16_non_clk];
nPC2_MEO_non_clk=[nPC11_non_clk nPC12_non_clk nPC14_non_clk];

nPC3_GEO_non_clk=[nPC59_non_clk nPC60_non_clk nPC61_non_clk];
nPC3_IGSO_non_clk=[nPC38_non_clk nPC39_non_clk nPC40_non_clk nPC31_non_clk nPC56_non_clk];
nPC3_MEO_non_clk=[nPC19_non_clk nPC20_non_clk nPC21_non_clk nPC22_non_clk nPC23_non_clk nPC24_non_clk nPC25_non_clk...
    nPC26_non_clk nPC27_non_clk nPC28_non_clk nPC29_non_clk nPC30_non_clk nPC32_non_clk nPC33_non_clk nPC34_non_clk...
    nPC35_non_clk nPC36_non_clk nPC37_non_clk nPC41_non_clk nPC42_non_clk nPC43_non_clk nPC44_non_clk nPC45_non_clk nPC46_non_clk];
end

if num_of_files>1 %========== multiple files ==================
    for j=1:num_of_files
    %data_non_availability{:,j}=readfile(full_file_name2(j,:));
    fileID{j,:} = fopen(full_file_name2(j,:));
    data_non_availability_0{j,:}=textscan(fileID{j,:}, '%[^\n]');
    fclose(fileID{j,:});
    data_non_availability_neww{j,:}=data_non_availability_0{j,:}{1,1}(cellfun(@(x) contains(x,'999999.99999'),data_non_availability_0{j,:}{1,1}));
    data_non_availability_new=data_non_availability_neww';
data_non_availability_0{j,:}=[];
% BDS-2 non_clk
nPC01_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC01', 4)); % BDS-2 GEO
nPC02_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC02', 4)); % BDS-2 GEO
nPC03_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC03', 4)); % BDS-2 GEO
nPC04_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC04', 4)); % BDS-2 GEO
nPC05_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC05', 4)); % BDS-2 GEO
nPC06_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC06', 4)); % BDS-2 IGSO
nPC07_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC07', 4)); % BDS-2 IGSO
nPC08_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC08', 4)); % BDS-2 IGSO
nPC09_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC09', 4)); % BDS-2 IGSO
nPC10_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC10', 4)); % BDS-2 IGSO
nPC11_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC11', 4)); % BDS-2 MEO
nPC12_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC12', 4)); % BDS-2 MEO
nPC13_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC13', 4)); % BDS-2 IGSO
nPC14_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC14', 4)); % BDS-2 MEO
nPC16_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3 non_clk
nPC19_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC19', 4)); % BDS-3 MEO
nPC20_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC20', 4)); % BDS-3 MEO 
nPC21_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC21', 4)); % BDS-3 MEO 
nPC22_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC22', 4)); % BDS-3 MEO 
nPC23_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC23', 4)); % BDS-3 MEO 
nPC24_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC24', 4)); % BDS-3 MEO 
nPC25_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC25', 4)); % BDS-3 MEO 
nPC26_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC26', 4)); % BDS-3 MEO 
nPC27_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC27', 4)); % BDS-3 MEO 
nPC28_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC28', 4)); % BDS-3 MEO 
nPC29_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC29', 4)); % BDS-3 MEO 
nPC30_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC30', 4)); % BDS-3 MEO 
nPC31_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC31', 4)); % BDS-3 MEO 
nPC32_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC32', 4)); % BDS-3 MEO 
nPC33_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC33', 4)); % BDS-3 MEO 
nPC34_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC34', 4)); % BDS-3 MEO 
nPC35_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC35', 4)); % BDS-3 MEO 
nPC36_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC36', 4)); % BDS-3 MEO 
nPC37_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC37', 4)); % BDS-3 MEO 
nPC38_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC38', 4)); % BDS-3 IGSO 
nPC39_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC39', 4)); % BDS-3 IGSO 
nPC40_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC40', 4)); % BDS-3 IGSO 
nPC41_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC41', 4)); % BDS-3 MEO 
nPC42_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC42', 4)); % BDS-3 MEO 
nPC43_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC43', 4)); % BDS-3 MEO 
nPC44_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC44', 4)); % BDS-3 MEO 
nPC45_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC45', 4)); % BDS-3 MEO 
nPC46_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC46', 4)); % BDS-3 MEO 
nPC56_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC56', 4)); % BDS-3 MEO 
nPC59_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC59', 4)); % BDS-3 GEO 
nPC60_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC60', 4)); % BDS-3 GEO 
nPC61_non_clk{:,j} = sum(strncmp(data_non_availability_new{:,j}, 'PC61', 4)); % BDS-3 GEO 
    end
nPC2_GEO_non_clk=[nPC01_non_clk nPC02_non_clk nPC03_non_clk nPC04_non_clk nPC05_non_clk];
nPC2_IGSO_non_clk=[nPC06_non_clk nPC07_non_clk nPC08_non_clk nPC09_non_clk nPC10_non_clk nPC13_non_clk nPC16_non_clk];
nPC2_MEO_non_clk=[nPC11_non_clk nPC12_non_clk nPC14_non_clk];

nPC3_GEO_non_clk=[nPC59_non_clk nPC60_non_clk nPC61_non_clk];
nPC3_IGSO_non_clk=[nPC38_non_clk nPC39_non_clk nPC40_non_clk nPC31_non_clk nPC56_non_clk];
nPC3_MEO_non_clk=[nPC19_non_clk nPC20_non_clk nPC21_non_clk nPC22_non_clk nPC23_non_clk nPC24_non_clk nPC25_non_clk...
    nPC26_non_clk nPC27_non_clk nPC28_non_clk nPC29_non_clk nPC30_non_clk nPC32_non_clk nPC33_non_clk nPC34_non_clk...
    nPC35_non_clk nPC36_non_clk nPC37_non_clk nPC41_non_clk nPC42_non_clk nPC43_non_clk nPC44_non_clk nPC45_non_clk nPC46_non_clk];
    
end

     if num_of_files==1
    nPG = sum(strncmp(C2, 'PG', 2)); 
nPR = sum(strncmp(C2, 'PR', 2));
nPE = sum(strncmp(C2, 'PE', 2));
nPJ = sum(strncmp(C2, 'PJ', 2)); 
nPI = sum(strncmp(C2, 'PI', 2));    
X = ~cellfun(@isempty,regexp(C2,'^\*  \d{4}')); % example: *  2021  3 28
number_of_epochs=numel(find(1==X));
reference_average_GPS_number=nPG/number_of_epochs;
reference_average_GALILEO_number=nPE/number_of_epochs;
reference_average_GLONASS_number=nPR/number_of_epochs;
reference_average_QZSS_number=nPJ/number_of_epochs;
reference_average_IRNSS_number=nPI/number_of_epochs;
for i=1:numel(nPC2_GEO)
reference_average_BDS2_number_GEO(i)=nPC2_GEO(i)/number_of_epochs;
end
reference_average_BDS2_number_sum_GEO=sum(reference_average_BDS2_number_GEO);

for i=1:numel(nPC2_IGSO)
    reference_average_BDS2_number_IGSO(i)=nPC2_IGSO(i)/number_of_epochs;
end
reference_average_BDS2_number_sum_IGSO=sum(reference_average_BDS2_number_IGSO);

for i=1:numel(nPC2_MEO)
reference_average_BDS2_number_MEO(i)=nPC2_MEO(i)/number_of_epochs;
end
reference_average_BDS2_number_sum_MEO=sum(reference_average_BDS2_number_MEO);

for i=1:numel(nPC3_GEO)
reference_average_BDS3_number_GEO(i)=nPC3_GEO(i)/number_of_epochs;
end
reference_average_BDS3_number_sum_GEO=sum(reference_average_BDS3_number_GEO);

for i=1:numel(nPC3_IGSO)
    reference_average_BDS3_number_IGSO(i)=nPC3_IGSO(i)/number_of_epochs;
end
reference_average_BDS3_number_sum_IGSO=sum(reference_average_BDS3_number_IGSO);

for i=1:numel(nPC3_MEO)
reference_average_BDS3_number_MEO(i)=nPC3_MEO(i)/number_of_epochs;
end
reference_average_BDS3_number_sum_MEO=sum(reference_average_BDS3_number_MEO);
nPG_non_clk = sum(strncmp(data_non_availability_new, 'PG', 2));
nPR_non_clk = sum(strncmp(data_non_availability_new, 'PR', 2));
nPE_non_clk = sum(strncmp(data_non_availability_new, 'PE', 2));
nPJ_non_clk=sum(strncmp(data_non_availability_new, 'PJ', 2));
nPI_non_clk=sum(strncmp(data_non_availability_new, 'PI', 2));
nPG_non_clk_ratio=(100*nPG_non_clk)/nPG;
nPR_non_clk_ratio=(100*nPR_non_clk)/nPR;
nPE_non_clk_ratio=(100*nPE_non_clk)/nPE;
nPJ_non_clk_ratio=(100*nPJ_non_clk)/nPJ;
nPI_non_clk_ratio=(100*nPI_non_clk)/nPI;

nPC2_GEO_non_clk_ratio=(100*sum(nPC2_GEO_non_clk))/sum(nPC2_GEO);
nPC2_IGSO_non_clk_ratio=(100*sum(nPC2_IGSO_non_clk))/sum(nPC2_IGSO);
nPC2_MEO_non_clk_ratio=(100*sum(nPC2_MEO_non_clk))/sum(nPC2_MEO);

nPC3_GEO_non_clk_ratio=(100*sum(nPC3_GEO_non_clk))/sum(nPC3_GEO);
nPC3_IGSO_non_clk_ratio=(100*sum(nPC3_IGSO_non_clk))/sum(nPC3_IGSO);
nPC3_MEO_non_clk_ratio=(100*sum(nPC3_MEO_non_clk))/sum(nPC3_MEO);
end


%if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
if num_of_files>1
    for j=1:num_of_files
Str2{j,:} = fileread(full_file_name(j,:)); % 2xn cell array  ......   OKED    ...........
CC2{j,:}   = strsplit(Str2{j,:}, '\n');   % line by line ;  \n == new line % 2xn cell array
nPC01(j) = sum(strncmp(CC2{j,:}, 'PC01', 4)); % BDS-2 GEO
nPC02(j) = sum(strncmp(CC2{j,:}, 'PC02', 4)); % BDS-2 GEO
nPC03(j) = sum(strncmp(CC2{j,:}, 'PC03', 4)); % BDS-2 GEO
nPC04(j) = sum(strncmp(CC2{j,:}, 'PC04', 4)); % BDS-2 GEO
nPC05(j) = sum(strncmp(CC2{j,:}, 'PC05', 4)); % BDS-2 GEO
nPC06(j) = sum(strncmp(CC2{j,:}, 'PC06', 4)); % BDS-2 IGSO
nPC07(j) = sum(strncmp(CC2{j,:}, 'PC07', 4)); % BDS-2 IGSO
nPC08(j) = sum(strncmp(CC2{j,:}, 'PC08', 4)); % BDS-2 IGSO
nPC09(j) = sum(strncmp(CC2{j,:}, 'PC09', 4)); % BDS-2 IGSO
nPC10(j) = sum(strncmp(CC2{j,:}, 'PC10', 4)); % BDS-2 IGSO
nPC11(j) = sum(strncmp(CC2{j,:}, 'PC11', 4)); % BDS-2 MEO
nPC12(j) = sum(strncmp(CC2{j,:}, 'PC12', 4)); % BDS-2 MEO
nPC13(j) = sum(strncmp(CC2{j,:}, 'PC13', 4)); % BDS-2 IGSO
nPC14(j) = sum(strncmp(CC2{j,:}, 'PC14', 4)); % BDS-2 MEO
nPC16(j) = sum(strncmp(CC2{j,:}, 'PC16', 4)); % BDS-2 IGSO
 % BDS-3
nPC19(j)=  sum(strncmp(CC2{j,:}, 'PC19', 4)); % BDS-3 MEO
nPC20(j) = sum(strncmp(CC2{j,:}, 'PC20', 4)); % BDS-3 MEO
nPC21(j) = sum(strncmp(CC2{j,:}, 'PC21', 4)); % BDS-3 MEO
nPC22(j) = sum(strncmp(CC2{j,:}, 'PC22', 4)); % BDS-3 MEO
nPC23(j) = sum(strncmp(CC2{j,:}, 'PC23', 4)); % BDS-3 MEO
nPC24(j) = sum(strncmp(CC2{j,:}, 'PC24', 4)); % BDS-3 MEO
nPC25(j) = sum(strncmp(CC2{j,:}, 'PC25', 4)); % BDS-3 MEO
nPC26(j) = sum(strncmp(CC2{j,:}, 'PC26', 4)); % BDS-3 MEO
nPC27(j) = sum(strncmp(CC2{j,:}, 'PC27', 4)); % BDS-3 MEO
nPC28(j) = sum(strncmp(CC2{j,:}, 'PC28', 4)); % BDS-3 MEO
nPC29(j) = sum(strncmp(CC2{j,:}, 'PC29', 4)); % BDS-3 MEO
nPC30(j) = sum(strncmp(CC2{j,:}, 'PC30', 4)); % BDS-3 MEO
nPC31(j) = sum(strncmp(CC2{j,:}, 'PC31', 4)); % BDS-3 MEO
nPC32(j) = sum(strncmp(CC2{j,:}, 'PC32', 4)); % BDS-3 MEO
nPC33(j) = sum(strncmp(CC2{j,:}, 'PC33', 4)); % BDS-3 MEO
nPC34(j) = sum(strncmp(CC2{j,:}, 'PC34', 4)); % BDS-3 MEO
nPC35(j) = sum(strncmp(CC2{j,:}, 'PC35', 4)); % BDS-3 MEO
nPC36(j) = sum(strncmp(CC2{j,:}, 'PC36', 4)); % BDS-3 MEO
nPC37(j) = sum(strncmp(CC2{j,:}, 'PC37', 4)); % BDS-3 MEO
nPC38(j) = sum(strncmp(CC2{j,:}, 'PC38', 4)); % BDS-3 IGSO
nPC39(j) = sum(strncmp(CC2{j,:}, 'PC39', 4)); % BDS-3 IGSO
nPC40(j) = sum(strncmp(CC2{j,:}, 'PC40', 4)); % BDS-3 IGSO
nPC41(j) = sum(strncmp(CC2{j,:}, 'PC41', 4)); % BDS-3 MEO
nPC42(j) = sum(strncmp(CC2{j,:}, 'PC42', 4)); % BDS-3 MEO
nPC43(j) = sum(strncmp(CC2{j,:}, 'PC43', 4)); % BDS-3 MEO
nPC44(j) = sum(strncmp(CC2{j,:}, 'PC44', 4)); % BDS-3 MEO
nPC45(j) = sum(strncmp(CC2{j,:}, 'PC45', 4)); % BDS-3 MEO
nPC46(j) = sum(strncmp(CC2{j,:}, 'PC46', 4)); % BDS-3 MEO
nPC56(j) = sum(strncmp(CC2{j,:}, 'PC56', 4)); % BDS-3 MEO
nPC59(j) = sum(strncmp(CC2{j,:}, 'PC59', 4)); % BDS-3 GEO
nPC60(j) = sum(strncmp(CC2{j,:}, 'PC60', 4)); % BDS-3 GEO
nPC61(j) = sum(strncmp(CC2{j,:}, 'PC61', 4)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
    nPG(j) = sum(strncmp(CC2{j,:}, 'PG', 2)); 
nPR(j) = sum(strncmp(CC2{j,:}, 'PR', 2));
nPE(j) = sum(strncmp(CC2{j,:}, 'PE', 2));
nPJ(j) = sum(strncmp(CC2{j,:}, 'PJ', 2)); 
nPI(j) = sum(strncmp(CC2{j,:}, 'PI', 2));    
X{j,:} = ~cellfun(@isempty,regexp(CC2{j,:},'^\*  \d{4}')); % example: *  2021  3 28
number_of_epochs(j)=numel(find(1==X{j,:}));
reference_average_GPS_number(j)=nPG(j)/number_of_epochs(j);
reference_average_GALILEO_number(j)=nPE(j)/number_of_epochs(j);
reference_average_GLONASS_number(j)=nPR(j)/number_of_epochs(j);
reference_average_QZSS_number(j)=nPJ(j)/number_of_epochs(j);
reference_average_IRNSS_number(j)=nPI(j)/number_of_epochs(j);
    end
    GPS_number=mean(reference_average_GPS_number);
    GALILEO_number=mean(reference_average_GALILEO_number);
    GLONASS_number=mean(reference_average_GLONASS_number);
    QZSS_number=mean(reference_average_QZSS_number);
    IRNSS_number=mean(reference_average_IRNSS_number);
nPC2_GEO=[nPC01;nPC02;nPC03;nPC04;nPC05];
    [a,b]=size(nPC2_GEO);
    for j=1:num_of_files
    for i=1:a  
reference_average_BDS2_number_GEO(i,j)=nPC2_GEO(i,j)/number_of_epochs(j);
    end
    end
    for j=1:num_of_files  
reference_average_BDS2_number_sum_GEO(j)=sum(reference_average_BDS2_number_GEO(:,j));
    end
   BDS2_GEO_number=mean(reference_average_BDS2_number_sum_GEO);
    nPC2_IGSO=[nPC06;nPC07;nPC08;nPC09;nPC10;nPC13;nPC16];
    [a,b]=size(nPC2_IGSO);
    for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_IGSO(i,j)=nPC2_IGSO(i,j)/number_of_epochs(j);
    end
    end
    for j=1:num_of_files  
        reference_average_BDS2_number_sum_IGSO(j)=sum(reference_average_BDS2_number_IGSO(:,j));
    end
    BDS2_IGSO_number=mean(reference_average_BDS2_number_sum_IGSO);
    nPC2_MEO=[nPC11;nPC12;nPC14];
[a,b]=size(nPC2_MEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_MEO(i,j)=nPC2_MEO(i,j)/number_of_epochs(j);
    end
end
for j=1:num_of_files 
    reference_average_BDS2_number_sum_MEO(j)=sum(reference_average_BDS2_number_MEO(:,j));
end
BDS2_MEO_number=mean(reference_average_BDS2_number_sum_MEO);
nPC3_GEO=[nPC59;nPC60;nPC61];
[a,b]=size(nPC3_GEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_GEO(i,j)=nPC3_GEO(i,j)/number_of_epochs(j);
    end
end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_GEO(j)=sum(reference_average_BDS3_number_GEO(:,j));
end
BDS3_GEO_number=mean(reference_average_BDS3_number_sum_GEO);
nPC3_IGSO=[nPC38;nPC39;nPC40;nPC31;nPC56];
        [a,b]=size(nPC3_IGSO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_IGSO(i,j)=nPC3_IGSO(i,j)/number_of_epochs(j);
    end
end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_IGSO(j)=sum(reference_average_BDS3_number_IGSO(:,j));
end
BDS3_IGSO_number=mean(reference_average_BDS3_number_sum_IGSO);          
nPC3_MEO=[nPC19;nPC20;nPC21;nPC22;nPC23;nPC24;nPC25;nPC26;nPC27;nPC28;nPC29;nPC30;nPC32;nPC33;nPC34;nPC35;nPC36;nPC37;nPC41;nPC42;nPC43;nPC44;nPC45;nPC46];
        [a,b]=size(nPC3_MEO);
        for j=1:num_of_files
    for i=1:a 
        reference_average_BDS3_number_MEO(i,j)=nPC3_MEO(i,j)/number_of_epochs(j);
    end
        end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_MEO(j)=sum(reference_average_BDS3_number_MEO(:,j));
end
BDS3_MEO_number=mean(reference_average_BDS3_number_sum_MEO);     
nPC2_GEO_non_clk=cell2mat([nPC01_non_clk;nPC02_non_clk;nPC03_non_clk;nPC04_non_clk;nPC05_non_clk]);
nPC2_IGSO_non_clk=cell2mat([nPC06_non_clk;nPC07_non_clk;nPC08_non_clk;nPC09_non_clk;nPC10_non_clk;nPC13_non_clk;nPC16_non_clk]);
nPC2_MEO_non_clk=cell2mat([nPC11_non_clk;nPC12_non_clk;nPC14_non_clk]);
nPC3_GEO_non_clk=cell2mat([nPC59_non_clk;nPC60_non_clk;nPC61_non_clk]);
nPC3_IGSO_non_clk=cell2mat([nPC38_non_clk;nPC39_non_clk;nPC40_non_clk;nPC31_non_clk;nPC56_non_clk]);
nPC3_MEO_non_clk=cell2mat([nPC19_non_clk;nPC20_non_clk;nPC21_non_clk;nPC22_non_clk;nPC23_non_clk;nPC24_non_clk;nPC25_non_clk...
    ;nPC26_non_clk;nPC27_non_clk;nPC28_non_clk;nPC29_non_clk;nPC30_non_clk;nPC32_non_clk;nPC33_non_clk;nPC34_non_clk...
    ;nPC35_non_clk;nPC36_non_clk;nPC37_non_clk;nPC41_non_clk;nPC42_non_clk;nPC43_non_clk;nPC44_non_clk;nPC45_non_clk;nPC46_non_clk]);
for j=1:num_of_files 
nPC2_GEO_non_clk_ratio(j)=(100*sum(nPC2_GEO_non_clk(:,j)))/sum(nPC2_GEO(:,j));
nPC2_IGSO_non_clk_ratio(j)=(100*sum(nPC2_IGSO_non_clk(:,j)))/sum(nPC2_IGSO(:,j));
nPC2_MEO_non_clk_ratio(j)=(100*sum(nPC2_MEO_non_clk(:,j)))/sum(nPC2_MEO(:,j));

nPC3_GEO_non_clk_ratio(j)=(100*sum(nPC3_GEO_non_clk(:,j)))/sum(nPC3_GEO(:,j));
nPC3_IGSO_non_clk_ratio(j)=(100*sum(nPC3_IGSO_non_clk(:,j)))/sum(nPC3_IGSO(:,j));
nPC3_MEO_non_clk_ratio(j)=(100*sum(nPC3_MEO_non_clk(:,j)))/sum(nPC3_MEO(:,j));

nPG_non_clk(j) = sum(strncmp(data_non_availability_new{:,j}, 'PG', 2));
nPR_non_clk(j) = sum(strncmp(data_non_availability_new{:,j}, 'PR', 2));
nPE_non_clk(j) = sum(strncmp(data_non_availability_new{:,j}, 'PE', 2));
nPJ_non_clk(j)=sum(strncmp(data_non_availability_new{:,j}, 'PJ', 2));
nPI_non_clk(j)=sum(strncmp(data_non_availability_new{:,j}, 'PI', 2));
nPG_non_clk_ratio(j)=(100*nPG_non_clk(j))/nPG(j);
nPR_non_clk_ratio(j)=(100*nPR_non_clk(j))/nPR(j);
nPE_non_clk_ratio(j)=(100*nPE_non_clk(j))/nPE(j);
nPJ_non_clk_ratio(j)=(100*nPJ_non_clk(j))/nPJ(j);
nPI_non_clk_ratio(j)=(100*nPI_non_clk(j))/nPI(j);
Str2{j,:}=[];
CC2{j,:}=[];
end
BDS2_GEO_non_clk=mean(nPC2_GEO_non_clk_ratio);
BDS2_IGSO_non_clk=mean(nPC2_IGSO_non_clk_ratio);
BDS2_MEO_non_clk=mean(nPC2_MEO_non_clk_ratio);
BDS3_GEO_non_clk=mean(nPC3_GEO_non_clk_ratio);
BDS3_IGSO_non_clk=mean(nPC3_IGSO_non_clk_ratio);
BDS3_MEO_non_clk=mean(nPC3_MEO_non_clk_ratio);
GPS_non_clk=mean(nPG_non_clk_ratio);
GLONASS_non_clk=mean(nPR_non_clk_ratio);
GALILEO_non_clk=mean(nPE_non_clk_ratio);
QZSS_non_clk=mean(nPJ_non_clk_ratio);
IRNSS_non_clk=mean(nPI_non_clk_ratio);
end
end
end

if exist('extension')==1
if strcmp(extension(1,:),'clk')==1 || strcmp(extension(1,:),'CLK')==1 || strcmp(extension(1,:),'05s')==1 || strcmp(extension(1,:),'30s')==1 
    if num_of_files==1
    % constant
        %===== check the line number of "END OF HEADER"===========
        fileID = fopen(full_file_name);
%         line_check=textscan(fileID, '%[^,\n]', 250);
          line_check=textscan(fileID, '%[^\n]', 500);
        fclose(fileID);
        line_check_header=line_check{1,1};
        end_of_header_line=find(contains(line_check_header,'END OF HEADER'));
%     line_check = regexp(fileread(full_file_name),'\n','split');
%     end_of_header_line = find(contains(line_check,'END OF HEADER')); % for clock files only...
tCOD=readtable(full_file_name,'FileType','text', ...
                                            'headerlines',end_of_header_line(1),'readvariablenames',0,'MultipleDelimsAsOne', true);
    all_time=tCOD{:,3:8}; % double all times y/m/d/h/m/s
    all_time_second= all_time(:,4)*3600+all_time(:,5)*60+all_time(:,6); % seconds
    unique_seconds=unique(all_time_second);    % number of different epochs
    end  
    if num_of_files>1
        for j=1:num_of_files
    % constant
        %===== check the line number of "END OF HEADER"===========
        fileID{j,:} = fopen(full_file_name(j,:));               %oked
        line_check{j,:}=textscan(fileID{j,:}, '%[^\n]', 500);  %oked
        fclose(fileID{j,:});
        end_of_header_line(j)=find(contains(line_check{j,:}{1,1},'END OF HEADER'));
%         line_check{j,:} = regexp(fileread(full_file_name(j,:)),'\n','split');
%         end_of_header_line(j) = find(contains(line_check{j,:},'END OF HEADER')); % for clock files only...
        tCOD{j,:}=readtable(full_file_name(j,:),'FileType','text', ...
                                            'headerlines',end_of_header_line(j),'readvariablenames',0,'MultipleDelimsAsOne', true);
        all_time{j,:}=tCOD{j,:}(:,3:8);   
        all_time_second{j,:}=table2array(all_time{1}(:,4))*3600+table2array(all_time{1}(:,5))*60+table2array(all_time{1}(:,6));  % seconds
        unique_seconds{j,:}=unique(all_time_second{1,:});
        tCOD{j,:}=[];
        line_check{j,:}=[];
        end
    end
    
    %========= BDS-2 & BDS-3 IGSO/MEO/GEO CLASSIFICATIONS (https://www.glonass-iac.ru/en/BEIDOU/)======
    if num_of_files==1 %============ single file  =================== 
% BDS-2
    nPC01 = sum(strncmp(C, 'AS C01', 6)); % BDS-2 GEO
    nPC02 = sum(strncmp(C, 'AS C02', 6)); % BDS-2 GEO
    nPC03 = sum(strncmp(C, 'AS C03', 6)); % BDS-2 GEO
    nPC04 = sum(strncmp(C, 'AS C04', 6)); % BDS-2 GEO
    nPC05 = sum(strncmp(C, 'AS C05', 6)); % BDS-2 GEO
    nPC06 = sum(strncmp(C, 'AS C06', 6)); % BDS-2 IGSO
    nPC07 = sum(strncmp(C, 'AS C07', 6)); % BDS-2 IGSO
    nPC08 = sum(strncmp(C, 'AS C08', 6)); % BDS-2 IGSO
    nPC09 = sum(strncmp(C, 'AS C09', 6)); % BDS-2 IGSO
    nPC10 = sum(strncmp(C, 'AS C10', 6)); % BDS-2 IGSO
    nPC11 = sum(strncmp(C, 'AS C11', 6)); % BDS-2 MEO
    nPC12 = sum(strncmp(C, 'AS C12', 6)); % BDS-2 MEO
    nPC13 = sum(strncmp(C, 'AS C13', 6)); % BDS-2 IGSO
    nPC14 = sum(strncmp(C, 'AS C14', 6)); % BDS-2 MEO
    nPC16 = sum(strncmp(C, 'AS C16', 6)); % BDS-2 IGSO
 % BDS-3
 nPC19 = sum(strncmp(C, 'AS C19', 6)); % BDS-3 MEO
 nPC20 = sum(strncmp(C, 'AS C20', 6)); % BDS-3 MEO   
 nPC21 = sum(strncmp(C, 'AS C21', 6)); % BDS-3 MEO   
 nPC22 = sum(strncmp(C, 'AS C22', 6)); % BDS-3 MEO
 nPC23 = sum(strncmp(C, 'AS C23', 6)); % BDS-3 MEO
 nPC24 = sum(strncmp(C, 'AS C24', 6)); % BDS-3 MEO
 nPC25 = sum(strncmp(C, 'AS C25', 6)); % BDS-3 MEO
 nPC26 = sum(strncmp(C, 'AS C26', 6)); % BDS-3 MEO
 nPC27 = sum(strncmp(C, 'AS C27', 6)); % BDS-3 MEO
 nPC28 = sum(strncmp(C, 'AS C28', 6)); % BDS-3 MEO
 nPC29 = sum(strncmp(C, 'AS C29', 6)); % BDS-3 MEO
 nPC30 = sum(strncmp(C, 'AS C30', 6)); % BDS-3 MEO
 nPC31 = sum(strncmp(C, 'AS C31', 6)); % BDS-3 MEO
 nPC32 = sum(strncmp(C, 'AS C32', 6)); % BDS-3 MEO
 nPC33 = sum(strncmp(C, 'AS C33', 6)); % BDS-3 MEO
 nPC34 = sum(strncmp(C, 'AS C34', 6)); % BDS-3 MEO
 nPC35 = sum(strncmp(C, 'AS C35', 6)); % BDS-3 MEO
 nPC36 = sum(strncmp(C, 'AS C36', 6)); % BDS-3 MEO
 nPC37 = sum(strncmp(C, 'AS C37', 6)); % BDS-3 MEO
 nPC38 = sum(strncmp(C, 'AS C38', 6)); % BDS-3 IGSO
 nPC39 = sum(strncmp(C, 'AS C39', 6)); % BDS-3 IGSO
 nPC40 = sum(strncmp(C, 'AS C40', 6)); % BDS-3 IGSO
 nPC41 = sum(strncmp(C, 'AS C41', 6)); % BDS-3 MEO
 nPC42 = sum(strncmp(C, 'AS C42', 6)); % BDS-3 MEO
 nPC43 = sum(strncmp(C, 'AS C43', 6)); % BDS-3 MEO
 nPC44 = sum(strncmp(C, 'AS C44', 6)); % BDS-3 MEO
 nPC45 = sum(strncmp(C, 'AS C45', 6)); % BDS-3 MEO
 nPC46 = sum(strncmp(C, 'AS C46', 6)); % BDS-3 MEO
 nPC56 = sum(strncmp(C, 'AS C56', 6)); % BDS-3 MEO
 nPC59 = sum(strncmp(C, 'AS C59', 6)); % BDS-3 GEO
 nPC60 = sum(strncmp(C, 'AS C60', 6)); % BDS-3 GEO
 nPC61 = sum(strncmp(C, 'AS C61', 6)); % BDS-3 GEO
 
nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
    end

if num_of_files>1 %========== multiple files ==================
    % BDS-2
    for j=1:num_of_files
        Str{j,:} = fileread(full_file_name(j,:)); % 2xn cell array  ......   OKED    ...........
        CC{j,:}   = strsplit(Str{j,:}, '\n');   % line by line ;  \n == new line % 2xn cell array
% BDS-2
    nPC01(j) = sum(strncmp(CC{j,:}, 'AS C01', 6)); % BDS-2 GEO
    nPC02(j) = sum(strncmp(CC{j,:}, 'AS C02', 6)); % BDS-2 GEO
    nPC03(j) = sum(strncmp(CC{j,:}, 'AS C03', 6)); % BDS-2 GEO
    nPC04(j) = sum(strncmp(CC{j,:}, 'AS C04', 6)); % BDS-2 GEO
    nPC05(j) = sum(strncmp(CC{j,:}, 'AS C05', 6)); % BDS-2 GEO
    nPC06(j) = sum(strncmp(CC{j,:}, 'AS C06', 6)); % BDS-2 IGSO
    nPC07(j) = sum(strncmp(CC{j,:}, 'AS C07', 6)); % BDS-2 IGSO
    nPC08(j) = sum(strncmp(CC{j,:}, 'AS C08', 6)); % BDS-2 IGSO
    nPC09(j) = sum(strncmp(CC{j,:}, 'AS C09', 6)); % BDS-2 IGSO
    nPC10(j) = sum(strncmp(CC{j,:}, 'AS C10', 6)); % BDS-2 IGSO
    nPC11(j) = sum(strncmp(CC{j,:}, 'AS C11', 6)); % BDS-2 MEO
    nPC12(j) = sum(strncmp(CC{j,:}, 'AS C12', 6)); % BDS-2 MEO
    nPC13(j) = sum(strncmp(CC{j,:}, 'AS C13', 6)); % BDS-2 IGSO
    nPC14(j) = sum(strncmp(CC{j,:}, 'AS C14', 6)); % BDS-2 MEO
    nPC16(j) = sum(strncmp(CC{j,:}, 'AS C16', 6)); % BDS-2 IGSO
 % BDS-3
 nPC19(j) = sum(strncmp(CC{j,:}, 'AS C19', 6)); % BDS-3 MEO
 nPC20(j) = sum(strncmp(CC{j,:}, 'AS C20', 6)); % BDS-3 MEO   
 nPC21(j) = sum(strncmp(CC{j,:}, 'AS C21', 6)); % BDS-3 MEO   
 nPC22(j) = sum(strncmp(CC{j,:}, 'AS C22', 6)); % BDS-3 MEO
 nPC23(j) = sum(strncmp(CC{j,:}, 'AS C23', 6)); % BDS-3 MEO
 nPC24(j) = sum(strncmp(CC{j,:}, 'AS C24', 6)); % BDS-3 MEO
 nPC25(j) = sum(strncmp(CC{j,:}, 'AS C25', 6)); % BDS-3 MEO
 nPC26(j) = sum(strncmp(CC{j,:}, 'AS C26', 6)); % BDS-3 MEO
 nPC27(j) = sum(strncmp(CC{j,:}, 'AS C27', 6)); % BDS-3 MEO
 nPC28(j) = sum(strncmp(CC{j,:}, 'AS C28', 6)); % BDS-3 MEO
 nPC29(j) = sum(strncmp(CC{j,:}, 'AS C29', 6)); % BDS-3 MEO
 nPC30(j) = sum(strncmp(CC{j,:}, 'AS C30', 6)); % BDS-3 MEO
 nPC31(j) = sum(strncmp(CC{j,:}, 'AS C31', 6)); % BDS-3 MEO
 nPC32(j) = sum(strncmp(CC{j,:}, 'AS C32', 6)); % BDS-3 MEO
 nPC33(j) = sum(strncmp(CC{j,:}, 'AS C33', 6)); % BDS-3 MEO
 nPC34(j) = sum(strncmp(CC{j,:}, 'AS C34', 6)); % BDS-3 MEO
 nPC35(j) = sum(strncmp(CC{j,:}, 'AS C35', 6)); % BDS-3 MEO
 nPC36(j) = sum(strncmp(CC{j,:}, 'AS C36', 6)); % BDS-3 MEO
 nPC37(j) = sum(strncmp(CC{j,:}, 'AS C37', 6)); % BDS-3 MEO
 nPC38(j) = sum(strncmp(CC{j,:}, 'AS C38', 6)); % BDS-3 IGSO
 nPC39(j) = sum(strncmp(CC{j,:}, 'AS C39', 6)); % BDS-3 IGSO
 nPC40(j) = sum(strncmp(CC{j,:}, 'AS C40', 6)); % BDS-3 IGSO
 nPC41(j) = sum(strncmp(CC{j,:}, 'AS C41', 6)); % BDS-3 MEO
 nPC42(j) = sum(strncmp(CC{j,:}, 'AS C42', 6)); % BDS-3 MEO
 nPC43(j) = sum(strncmp(CC{j,:}, 'AS C43', 6)); % BDS-3 MEO
 nPC44(j) = sum(strncmp(CC{j,:}, 'AS C44', 6)); % BDS-3 MEO
 nPC45(j) = sum(strncmp(CC{j,:}, 'AS C45', 6)); % BDS-3 MEO
 nPC46(j) = sum(strncmp(CC{j,:}, 'AS C46', 6)); % BDS-3 MEO
 nPC56(j) = sum(strncmp(CC{j,:}, 'AS C56', 6)); % BDS-3 MEO
 nPC59(j) = sum(strncmp(CC{j,:}, 'AS C59', 6)); % BDS-3 GEO
 nPC60(j) = sum(strncmp(CC{j,:}, 'AS C60', 6)); % BDS-3 GEO
 nPC61(j) = sum(strncmp(CC{j,:}, 'AS C61', 6)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
   nPG(j) = sum(strncmp(CC{j,:}, 'AS G', 4)); % 2==  first 2 characters ; find all PG (2) in C 
     reference_average_GPS_number_reference(j)=nPG(j)/numel(unique_seconds{j,:});
nPR(j) = sum(strncmp(CC{j,:}, 'AS R', 4));
      reference_average_GLONASS_number_reference(j)=nPR(j)/numel(unique_seconds{j,:});
nPE(j) = sum(strncmp(CC{j,:}, 'AS E', 4));
     reference_average_GALILEO_number_reference(j)=nPE(j)/numel(unique_seconds{j,:});
nPJ(j) = sum(strncmp(CC{j,:}, 'AS J', 4));
     reference_average_QZSS_number_reference(j)=nPJ(j)/numel(unique_seconds{j,:}); 
nPI(j) = sum(strncmp(CC{j,:}, 'AS I', 4)); 
     reference_average_IRNSS_number_reference(j)=nPI(j)/numel(unique_seconds{j,:});
     Str{j,:}=[];
     CC{j,:}=[];
    end
        reference_GPS_number=mean(reference_average_GPS_number_reference);
        reference_GALILEO_number=mean(reference_average_GALILEO_number_reference);
        reference_GLONASS_number=mean(reference_average_GLONASS_number_reference);
        reference_QZSS_number=mean(reference_average_QZSS_number_reference);
        reference_IRNSS_number=mean(reference_average_IRNSS_number_reference);
         nPC2_GEO=[nPC01;nPC02;nPC03;nPC04;nPC05];
    [a,b]=size(nPC2_GEO);
         for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_GEO(i,j)=nPC2_GEO(i,j)/numel(unique_seconds{j,:});
    end
         end
             
    for j=1:num_of_files  
reference_average_BDS2_number_sum_GEO_reference(j)=sum(reference_average_BDS2_number_GEO(:,j));
    end
    reference_BDS2_GEO_number=mean(reference_average_BDS2_number_sum_GEO_reference);
    nPC2_IGSO=[nPC06;nPC07;nPC08;nPC09;nPC10;nPC13;nPC16];
    [a,b]=size(nPC2_IGSO);
    for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_IGSO(i,j)=nPC2_IGSO(i,j)/numel(unique_seconds{j,:});
    end
    end
    for j=1:num_of_files  
        reference_average_BDS2_number_sum_IGSO_reference(j)=sum(reference_average_BDS2_number_IGSO(:,j));
    end
    reference_BDS2_IGSO_number=mean(reference_average_BDS2_number_sum_IGSO_reference);
    nPC2_MEO=[nPC11;nPC12;nPC14];
    [a,b]=size(nPC2_MEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_MEO(i,j)=nPC2_MEO(i,j)/numel(unique_seconds{j,:});
    end
end
    for j=1:num_of_files 
    reference_average_BDS2_number_sum_MEO_reference(j)=sum(reference_average_BDS2_number_MEO(:,j));
    end
    reference_BDS2_MEO_number=mean(reference_average_BDS2_number_sum_MEO_reference);
    nPC3_GEO=[nPC59;nPC60;nPC61];
[a,b]=size(nPC3_GEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_GEO(i,j)=nPC3_GEO(i,j)/numel(unique_seconds{j,:});
    end
end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_GEO_reference(j)=sum(reference_average_BDS3_number_GEO(:,j));
end
reference_BDS3_GEO_number=mean(reference_average_BDS3_number_sum_GEO_reference);
nPC3_IGSO=[nPC38;nPC39;nPC40;nPC31;nPC56];
        [a,b]=size(nPC3_IGSO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_IGSO(i,j)=nPC3_IGSO(i,j)/numel(unique_seconds{j,:});
    end
end
    for j=1:num_of_files 
    reference_average_BDS3_number_sum_IGSO_reference(j)=sum(reference_average_BDS3_number_IGSO(:,j));
    end
    reference_BDS3_IGSO_number=mean(reference_average_BDS3_number_sum_IGSO_reference); 
    nPC3_MEO=[nPC19;nPC20;nPC21;nPC22;nPC23;nPC24;nPC25;nPC26;nPC27;nPC28;nPC29;nPC30;nPC32;nPC33;nPC34;nPC35;nPC36;nPC37;nPC41;nPC42;nPC43;nPC44;nPC45;nPC46];
[a,b]=size(nPC3_MEO);
        for j=1:num_of_files
    for i=1:a 
        reference_average_BDS3_number_MEO(i,j)=nPC3_MEO(i,j)/numel(unique_seconds{j,:});
    end
        end
    for j=1:num_of_files 
    reference_average_BDS3_number_sum_MEO_reference(j)=sum(reference_average_BDS3_number_MEO(:,j));
    end
    reference_BDS3_MEO_number=mean(reference_average_BDS3_number_sum_MEO_reference);  
end
     if num_of_files==1
     nPG = sum(strncmp(C, 'AS G', 4)); % 2==  first 2 characters ; find all PG (2) in C 
     reference_average_GPS_number_reference=nPG/numel(unique_seconds);
nPR = sum(strncmp(C, 'AS R', 4));
      reference_average_GLONASS_number_reference=nPR/numel(unique_seconds);
nPE = sum(strncmp(C, 'AS E', 4));
     reference_average_GALILEO_number_reference=nPE/numel(unique_seconds);
nPJ = sum(strncmp(C, 'AS J', 4));
     reference_average_QZSS_number_reference=nPJ/numel(unique_seconds);	 
nPI = sum(strncmp(C, 'AS I', 4)); 
     reference_average_IRNSS_number_reference=nPI/numel(unique_seconds);	
     
     for i=1:numel(nPC2_IGSO)
    reference_average_BDS2_number_IGSO(i)=nPC2_IGSO(i)/numel(unique_seconds);
end
reference_average_BDS2_number_sum_IGSO_reference=sum(reference_average_BDS2_number_IGSO);

 for i=1:numel(nPC2_GEO)
    reference_average_BDS2_number_GEO(i)=nPC2_GEO(i)/numel(unique_seconds);
end
reference_average_BDS2_number_sum_GEO_reference=sum(reference_average_BDS2_number_GEO);

for i=1:numel(nPC2_MEO)
reference_average_BDS2_number_MEO(i)=nPC2_MEO(i)/numel(unique_seconds);
end
reference_average_BDS2_number_sum_MEO_reference=sum(reference_average_BDS2_number_MEO);

for i=1:numel(nPC3_GEO)
reference_average_BDS3_number_GEO(i)=nPC3_GEO(i)/numel(unique_seconds);
end
reference_average_BDS3_number_sum_GEO_reference=sum(reference_average_BDS3_number_GEO);

for i=1:numel(nPC3_IGSO)
    reference_average_BDS3_number_IGSO(i)=nPC3_IGSO(i)/numel(unique_seconds);
end
reference_average_BDS3_number_sum_IGSO_reference=sum(reference_average_BDS3_number_IGSO);

for i=1:numel(nPC3_MEO)
reference_average_BDS3_number_MEO(i)=nPC3_MEO(i)/numel(unique_seconds);
end
reference_average_BDS3_number_sum_MEO_reference=sum(reference_average_BDS3_number_MEO);
nPG_non_clk_ratio_reference=NaN;
nPR_non_clk_ratio_reference=NaN;
nPE_non_clk_ratio_reference=NaN;
nPJ_non_clk_ratio_reference=NaN;
nPI_non_clk_ratio_reference=NaN;
nPC2_GEO_non_clk_ratio_reference=NaN;
nPC2_IGSO_non_clk_ratio_reference=NaN;
nPC2_MEO_non_clk_ratio_reference=NaN;
nPC3_GEO_non_clk_ratio_reference=NaN;
nPC3_IGSO_non_clk_ratio_reference=NaN;
nPC3_MEO_non_clk_ratio_reference=NaN;
     end
if num_of_files>1
    for j=1:num_of_files
nPG_non_clk_ratio_reference(j)=NaN;
nPR_non_clk_ratio_reference(j)=NaN;
nPE_non_clk_ratio_reference(j)=NaN;
nPJ_non_clk_ratio_reference(j)=NaN;
nPI_non_clk_ratio_reference(j)=NaN;
nPC2_GEO_non_clk_ratio_reference(j)=NaN;
nPC2_IGSO_non_clk_ratio_reference(j)=NaN;
nPC2_MEO_non_clk_ratio_reference(j)=NaN;
nPC3_GEO_non_clk_ratio_reference(j)=NaN;
nPC3_IGSO_non_clk_ratio_reference(j)=NaN;
nPC3_MEO_non_clk_ratio_reference(j)=NaN;
    end
reference_GPS_non_clk=NaN;
reference_GLONASS_non_clk=NaN;
reference_GALILEO_non_clk=NaN;
reference_QZSS_non_clk=NaN;
reference_IRNSS_non_clk=NaN;
reference_BDS2_GEO_non_clk=NaN;
reference_BDS2_IGSO_non_clk=NaN;
reference_BDS2_MEO_non_clk=NaN;
reference_BDS3_GEO_non_clk=NaN;
reference_BDS3_IGSO_non_clk=NaN;
reference_BDS3_MEO_non_clk=NaN;
end
end

end

if exist('extension2')==1
if strcmp(extension2(1,:),'clk')==1 || strcmp(extension2(1,:),'CLK')==1 || strcmp(extension2(1,:),'05s')==1 || strcmp(extension2(1,:),'30s')==1 || strcmp(extension2(1,:),'K_M')==1
    if num_of_files==1
    % constant
        %===== check the line number of "END OF HEADER"===========
fileID = fopen(full_file_name2);
% line_check=textscan(fileID, '%[^,\n]', 250);
line_check=textscan(fileID, '%[^\n]', 500);
fclose(fileID);
line_check_header=line_check{1,1};
end_of_header_line=find(contains(line_check_header,'END OF HEADER')); 
%     line_check = regexp(fileread(full_file_name2),'\n','split');
%     end_of_header_line = find(contains(line_check,'END OF HEADER')); % for clock files only...
tCOD=readtable(full_file_name2,'FileType','text', ...
                                            'headerlines',end_of_header_line,'readvariablenames',0,'MultipleDelimsAsOne', true);
    all_time=tCOD{:,3:8}; % double all times y/m/d/h/m/s
    all_time_second= all_time(:,4)*3600+all_time(:,5)*60+all_time(:,6); % seconds
    unique_seconds=unique(all_time_second);    % number of different epochs
    end
    
    if num_of_files>1
        for j=1:num_of_files
            % constant
        %===== check the line number of "END OF HEADER"===========
        fileID{j,:} = fopen(full_file_name2(j,:));               %oked
        line_check{j,:}=textscan(fileID{j,:}, '%[^\n]', 500);  %oked
        fclose(fileID{j,:});
        end_of_header_line(j)=find(contains(line_check{j,:}{1,1},'END OF HEADER'));       
%         line_check{j,:} = regexp(fileread(full_file_name2(j,:)),'\n','split');
%         end_of_header_line(j) = find(contains(line_check{j,:},'END OF HEADER')); % for clock files only...
        tCOD{j,:}=readtable(full_file_name2(j,:),'FileType','text', ...
                                            'headerlines',end_of_header_line(j),'readvariablenames',0,'MultipleDelimsAsOne', true);
        all_time{j,:}=tCOD{j,:}(:,3:8);   
        all_time_second{j,:}=table2array(all_time{1}(:,4))*3600+table2array(all_time{1}(:,5))*60+table2array(all_time{1}(:,6));  % seconds
        unique_seconds{j,:}=unique(all_time_second{1,:});
        tCOD{j,:}=[];
        line_check{j,:}=[];
        end
          end

    %========= BDS-2 & BDS-3 IGSO/MEO/GEO CLASSIFICATIONS (https://www.glonass-iac.ru/en/BEIDOU/)======
    if num_of_files==1 %============ single file  =================== 
% BDS-2
    nPC01 = sum(strncmp(C2, 'AS C01', 6)); % BDS-2 GEO
    nPC02 = sum(strncmp(C2, 'AS C02', 6)); % BDS-2 GEO
    nPC03 = sum(strncmp(C2, 'AS C03', 6)); % BDS-2 GEO
    nPC04 = sum(strncmp(C2, 'AS C04', 6)); % BDS-2 GEO
    nPC05 = sum(strncmp(C2, 'AS C05', 6)); % BDS-2 GEO
    nPC06 = sum(strncmp(C2, 'AS C06', 6)); % BDS-2 IGSO
    nPC07 = sum(strncmp(C2, 'AS C07', 6)); % BDS-2 IGSO
    nPC08 = sum(strncmp(C2, 'AS C08', 6)); % BDS-2 IGSO
    nPC09 = sum(strncmp(C2, 'AS C09', 6)); % BDS-2 IGSO
    nPC10 = sum(strncmp(C2, 'AS C10', 6)); % BDS-2 IGSO
    nPC11 = sum(strncmp(C2, 'AS C11', 6)); % BDS-2 MEO
    nPC12 = sum(strncmp(C2, 'AS C12', 6)); % BDS-2 MEO
    nPC13 = sum(strncmp(C2, 'AS C13', 6)); % BDS-2 IGSO
    nPC14 = sum(strncmp(C2, 'AS C14', 6)); % BDS-2 MEO
    nPC16 = sum(strncmp(C2, 'AS C16', 6)); % BDS-2 IGSO
 % BDS-3
 nPC19 = sum(strncmp(C2, 'AS C19', 6)); % BDS-3 MEO
 nPC20 = sum(strncmp(C2, 'AS C20', 6)); % BDS-3 MEO   
 nPC21 = sum(strncmp(C2, 'AS C21', 6)); % BDS-3 MEO   
 nPC22 = sum(strncmp(C2, 'AS C22', 6)); % BDS-3 MEO
 nPC23 = sum(strncmp(C2, 'AS C23', 6)); % BDS-3 MEO
 nPC24 = sum(strncmp(C2, 'AS C24', 6)); % BDS-3 MEO
 nPC25 = sum(strncmp(C2, 'AS C25', 6)); % BDS-3 MEO
 nPC26 = sum(strncmp(C2, 'AS C26', 6)); % BDS-3 MEO
 nPC27 = sum(strncmp(C2, 'AS C27', 6)); % BDS-3 MEO
 nPC28 = sum(strncmp(C2, 'AS C28', 6)); % BDS-3 MEO
 nPC29 = sum(strncmp(C2, 'AS C29', 6)); % BDS-3 MEO
 nPC30 = sum(strncmp(C2, 'AS C30', 6)); % BDS-3 MEO
 nPC31 = sum(strncmp(C2, 'AS C31', 6)); % BDS-3 MEO
 nPC32 = sum(strncmp(C2, 'AS C32', 6)); % BDS-3 MEO
 nPC33 = sum(strncmp(C2, 'AS C33', 6)); % BDS-3 MEO
 nPC34 = sum(strncmp(C2, 'AS C34', 6)); % BDS-3 MEO
 nPC35 = sum(strncmp(C2, 'AS C35', 6)); % BDS-3 MEO
 nPC36 = sum(strncmp(C2, 'AS C36', 6)); % BDS-3 MEO
 nPC37 = sum(strncmp(C2, 'AS C37', 6)); % BDS-3 MEO
 nPC38 = sum(strncmp(C2, 'AS C38', 6)); % BDS-3 IGSO
 nPC39 = sum(strncmp(C2, 'AS C39', 6)); % BDS-3 IGSO
 nPC40 = sum(strncmp(C2, 'AS C40', 6)); % BDS-3 IGSO
 nPC41 = sum(strncmp(C2, 'AS C41', 6)); % BDS-3 MEO
 nPC42 = sum(strncmp(C2, 'AS C42', 6)); % BDS-3 MEO
 nPC43 = sum(strncmp(C2, 'AS C43', 6)); % BDS-3 MEO
 nPC44 = sum(strncmp(C2, 'AS C44', 6)); % BDS-3 MEO
 nPC45 = sum(strncmp(C2, 'AS C45', 6)); % BDS-3 MEO
 nPC46 = sum(strncmp(C2, 'AS C46', 6)); % BDS-3 MEO
 nPC56 = sum(strncmp(C2, 'AS C56', 6)); % BDS-3 MEO
 nPC59 = sum(strncmp(C2, 'AS C59', 6)); % BDS-3 GEO
 nPC60 = sum(strncmp(C2, 'AS C60', 6)); % BDS-3 GEO
 nPC61 = sum(strncmp(C2, 'AS C61', 6)); % BDS-3 GEO
 
nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
    end
    
    if num_of_files>1 %========== multiple files ==================
    % BDS-2
    for j=1:num_of_files
        Str2{j,:} = fileread(full_file_name2(j,:)); % 2xn cell array  ......   OKED    ...........
        CC2{j,:}   = strsplit(Str2{j,:}, '\n');   % line by line ;  \n == new line % 2xn cell array
% BDS-2
    nPC01(j) = sum(strncmp(CC2{j,:}, 'AS C01', 6)); % BDS-2 GEO
    nPC02(j) = sum(strncmp(CC2{j,:}, 'AS C02', 6)); % BDS-2 GEO
    nPC03(j) = sum(strncmp(CC2{j,:}, 'AS C03', 6)); % BDS-2 GEO
    nPC04(j) = sum(strncmp(CC2{j,:}, 'AS C04', 6)); % BDS-2 GEO
    nPC05(j) = sum(strncmp(CC2{j,:}, 'AS C05', 6)); % BDS-2 GEO
    nPC06(j) = sum(strncmp(CC2{j,:}, 'AS C06', 6)); % BDS-2 IGSO
    nPC07(j) = sum(strncmp(CC2{j,:}, 'AS C07', 6)); % BDS-2 IGSO
    nPC08(j) = sum(strncmp(CC2{j,:}, 'AS C08', 6)); % BDS-2 IGSO
    nPC09(j) = sum(strncmp(CC2{j,:}, 'AS C09', 6)); % BDS-2 IGSO
    nPC10(j) = sum(strncmp(CC2{j,:}, 'AS C10', 6)); % BDS-2 IGSO
    nPC11(j) = sum(strncmp(CC2{j,:}, 'AS C11', 6)); % BDS-2 MEO
    nPC12(j) = sum(strncmp(CC2{j,:}, 'AS C12', 6)); % BDS-2 MEO
    nPC13(j) = sum(strncmp(CC2{j,:}, 'AS C13', 6)); % BDS-2 IGSO
    nPC14(j) = sum(strncmp(CC2{j,:}, 'AS C14', 6)); % BDS-2 MEO
    nPC16(j) = sum(strncmp(CC2{j,:}, 'AS C16', 6)); % BDS-2 IGSO
 % BDS-3
 nPC19(j) = sum(strncmp(CC2{j,:}, 'AS C19', 6)); % BDS-3 MEO
 nPC20(j) = sum(strncmp(CC2{j,:}, 'AS C20', 6)); % BDS-3 MEO   
 nPC21(j) = sum(strncmp(CC2{j,:}, 'AS C21', 6)); % BDS-3 MEO   
 nPC22(j) = sum(strncmp(CC2{j,:}, 'AS C22', 6)); % BDS-3 MEO
 nPC23(j) = sum(strncmp(CC2{j,:}, 'AS C23', 6)); % BDS-3 MEO
 nPC24(j) = sum(strncmp(CC2{j,:}, 'AS C24', 6)); % BDS-3 MEO
 nPC25(j) = sum(strncmp(CC2{j,:}, 'AS C25', 6)); % BDS-3 MEO
 nPC26(j) = sum(strncmp(CC2{j,:}, 'AS C26', 6)); % BDS-3 MEO
 nPC27(j) = sum(strncmp(CC2{j,:}, 'AS C27', 6)); % BDS-3 MEO
 nPC28(j) = sum(strncmp(CC2{j,:}, 'AS C28', 6)); % BDS-3 MEO
 nPC29(j) = sum(strncmp(CC2{j,:}, 'AS C29', 6)); % BDS-3 MEO
 nPC30(j) = sum(strncmp(CC2{j,:}, 'AS C30', 6)); % BDS-3 MEO
 nPC31(j) = sum(strncmp(CC2{j,:}, 'AS C31', 6)); % BDS-3 MEO
 nPC32(j) = sum(strncmp(CC2{j,:}, 'AS C32', 6)); % BDS-3 MEO
 nPC33(j) = sum(strncmp(CC2{j,:}, 'AS C33', 6)); % BDS-3 MEO
 nPC34(j) = sum(strncmp(CC2{j,:}, 'AS C34', 6)); % BDS-3 MEO
 nPC35(j) = sum(strncmp(CC2{j,:}, 'AS C35', 6)); % BDS-3 MEO
 nPC36(j) = sum(strncmp(CC2{j,:}, 'AS C36', 6)); % BDS-3 MEO
 nPC37(j) = sum(strncmp(CC2{j,:}, 'AS C37', 6)); % BDS-3 MEO
 nPC38(j) = sum(strncmp(CC2{j,:}, 'AS C38', 6)); % BDS-3 IGSO
 nPC39(j) = sum(strncmp(CC2{j,:}, 'AS C39', 6)); % BDS-3 IGSO
 nPC40(j) = sum(strncmp(CC2{j,:}, 'AS C40', 6)); % BDS-3 IGSO
 nPC41(j) = sum(strncmp(CC2{j,:}, 'AS C41', 6)); % BDS-3 MEO
 nPC42(j) = sum(strncmp(CC2{j,:}, 'AS C42', 6)); % BDS-3 MEO
 nPC43(j) = sum(strncmp(CC2{j,:}, 'AS C43', 6)); % BDS-3 MEO
 nPC44(j) = sum(strncmp(CC2{j,:}, 'AS C44', 6)); % BDS-3 MEO
 nPC45(j) = sum(strncmp(CC2{j,:}, 'AS C45', 6)); % BDS-3 MEO
 nPC46(j) = sum(strncmp(CC2{j,:}, 'AS C46', 6)); % BDS-3 MEO
 nPC56(j) = sum(strncmp(CC2{j,:}, 'AS C56', 6)); % BDS-3 MEO
 nPC59(j) = sum(strncmp(CC2{j,:}, 'AS C59', 6)); % BDS-3 GEO
 nPC60(j) = sum(strncmp(CC2{j,:}, 'AS C60', 6)); % BDS-3 GEO
 nPC61(j) = sum(strncmp(CC2{j,:}, 'AS C61', 6)); % BDS-3 GEO

nPC2_GEO=[nPC01 nPC02 nPC03 nPC04 nPC05];
nPC2_IGSO=[nPC06 nPC07 nPC08 nPC09 nPC10 nPC13 nPC16];
nPC2_MEO=[nPC11 nPC12 nPC14];

nPC3_GEO=[nPC59 nPC60 nPC61];
nPC3_IGSO=[nPC38 nPC39 nPC40 nPC31 nPC56];
nPC3_MEO=[nPC19 nPC20 nPC21 nPC22 nPC23 nPC24 nPC25 nPC26 nPC27 nPC28 nPC29 nPC30 nPC32 nPC33 nPC34 nPC35 nPC36 nPC37 nPC41 nPC42 nPC43 nPC44 nPC45 nPC46];
nPG(j) = sum(strncmp(CC2{j,:}, 'AS G', 4)); % 2==  first 2 characters ; find all PG (2) in C 
     reference_average_GPS_number(j)=nPG(j)/numel(unique_seconds{j,:});
nPR(j) = sum(strncmp(CC2{j,:}, 'AS R', 4));
      reference_average_GLONASS_number(j)=nPR(j)/numel(unique_seconds{j,:});
nPE(j) = sum(strncmp(CC2{j,:}, 'AS E', 4));
     reference_average_GALILEO_number(j)=nPE(j)/numel(unique_seconds{j,:});
nPJ(j) = sum(strncmp(CC2{j,:}, 'AS J', 4));
     reference_average_QZSS_number(j)=nPJ(j)/numel(unique_seconds{j,:}); 
nPI(j) = sum(strncmp(CC2{j,:}, 'AS I', 4)); 
     reference_average_IRNSS_number(j)=nPI(j)/numel(unique_seconds{j,:});
     Str2{j,:}=[];
     CC2{j,:}=[];
    end
    GPS_number=mean(reference_average_GPS_number);
    GALILEO_number=mean(reference_average_GALILEO_number);
    GLONASS_number=mean(reference_average_GLONASS_number);
    QZSS_number=mean(reference_average_QZSS_number);
    IRNSS_number=mean(reference_average_IRNSS_number);
         nPC2_GEO=[nPC01;nPC02;nPC03;nPC04;nPC05];
    [a,b]=size(nPC2_GEO);
         for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_GEO(i,j)=nPC2_GEO(i,j)/numel(unique_seconds{j,:});
    end
             end
    for j=1:num_of_files  
reference_average_BDS2_number_sum_GEO(j)=sum(reference_average_BDS2_number_GEO(:,j));
    end
    BDS2_GEO_number=mean(reference_average_BDS2_number_sum_GEO);
    nPC2_IGSO=[nPC06;nPC07;nPC08;nPC09;nPC10;nPC13;nPC16];
    [a,b]=size(nPC2_IGSO);
    for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_IGSO(i,j)=nPC2_IGSO(i,j)/numel(unique_seconds{j,:});
    end
    end
    for j=1:num_of_files  
        reference_average_BDS2_number_sum_IGSO(j)=sum(reference_average_BDS2_number_IGSO(:,j));
    end
    BDS2_IGSO_number=mean(reference_average_BDS2_number_sum_IGSO);
    nPC2_MEO=[nPC11;nPC12;nPC14];
    [a,b]=size(nPC2_MEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS2_number_MEO(i,j)=nPC2_MEO(i,j)/numel(unique_seconds{j,:});
    end
end
    for j=1:num_of_files 
    reference_average_BDS2_number_sum_MEO(j)=sum(reference_average_BDS2_number_MEO(:,j));
    end
    BDS2_MEO_number=mean(reference_average_BDS2_number_sum_MEO);
    nPC3_GEO=[nPC59;nPC60;nPC61];
[a,b]=size(nPC3_GEO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_GEO(i,j)=nPC3_GEO(i,j)/numel(unique_seconds{j,:});
    end
end
for j=1:num_of_files 
    reference_average_BDS3_number_sum_GEO(j)=sum(reference_average_BDS3_number_GEO(:,j));
end
BDS3_GEO_number=mean(reference_average_BDS3_number_sum_GEO);
nPC3_IGSO=[nPC38;nPC39;nPC40;nPC31;nPC56];
        [a,b]=size(nPC3_IGSO);
for j=1:num_of_files
    for i=1:a  
        reference_average_BDS3_number_IGSO(i,j)=nPC3_IGSO(i,j)/numel(unique_seconds{j,:});
    end
end
    for j=1:num_of_files 
    reference_average_BDS3_number_sum_IGSO(j)=sum(reference_average_BDS3_number_IGSO(:,j));
    end
    BDS3_IGSO_number=mean(reference_average_BDS3_number_sum_IGSO);
    nPC3_MEO=[nPC19;nPC20;nPC21;nPC22;nPC23;nPC24;nPC25;nPC26;nPC27;nPC28;nPC29;nPC30;nPC32;nPC33;nPC34;nPC35;nPC36;nPC37;nPC41;nPC42;nPC43;nPC44;nPC45;nPC46];
[a,b]=size(nPC3_MEO);
        for j=1:num_of_files
    for i=1:a 
        reference_average_BDS3_number_MEO(i,j)=nPC3_MEO(i,j)/numel(unique_seconds{j,:});
    end
        end
    for j=1:num_of_files 
    reference_average_BDS3_number_sum_MEO(j)=sum(reference_average_BDS3_number_MEO(:,j));
    end
BDS3_MEO_number=mean(reference_average_BDS3_number_sum_MEO);   
    end
    
     if num_of_files==1
     nPG = sum(strncmp(C2, 'AS G', 4)); % 2==  first 2 characters ; find all PG (2) in C 
     reference_average_GPS_number=nPG/numel(unique_seconds);
nPR = sum(strncmp(C2, 'AS R', 4));
      reference_average_GLONASS_number=nPR/numel(unique_seconds);
nPE = sum(strncmp(C2, 'AS E', 4));
     reference_average_GALILEO_number=nPE/numel(unique_seconds);
nPJ = sum(strncmp(C2, 'AS J', 4));
     reference_average_QZSS_number=nPJ/numel(unique_seconds);	 
nPI = sum(strncmp(C2, 'AS I', 4)); 
     reference_average_IRNSS_number=nPI/numel(unique_seconds);	
     
     for i=1:numel(nPC2_IGSO)
    reference_average_BDS2_number_IGSO(i)=nPC2_IGSO(i)/numel(unique_seconds);
end
reference_average_BDS2_number_sum_IGSO=sum(reference_average_BDS2_number_IGSO);

for i=1:numel(nPC2_MEO)
reference_average_BDS2_number_MEO(i)=nPC2_MEO(i)/numel(unique_seconds);
end
reference_average_BDS2_number_sum_MEO=sum(reference_average_BDS2_number_MEO);

 for i=1:numel(nPC2_GEO)
    reference_average_BDS2_number_GEO(i)=nPC2_GEO(i)/numel(unique_seconds);
end
reference_average_BDS2_number_sum_GEO=sum(reference_average_BDS2_number_GEO);

for i=1:numel(nPC3_GEO)
reference_average_BDS3_number_GEO(i)=nPC3_GEO(i)/numel(unique_seconds);
end
reference_average_BDS3_number_sum_GEO=sum(reference_average_BDS3_number_GEO);

for i=1:numel(nPC3_IGSO)
    reference_average_BDS3_number_IGSO(i)=nPC3_IGSO(i)/numel(unique_seconds);
end
reference_average_BDS3_number_sum_IGSO=sum(reference_average_BDS3_number_IGSO);

for i=1:numel(nPC3_MEO)
reference_average_BDS3_number_MEO(i)=nPC3_MEO(i)/numel(unique_seconds);
end
reference_average_BDS3_number_sum_MEO=sum(reference_average_BDS3_number_MEO);
nPG_non_clk_ratio=NaN;
nPR_non_clk_ratio=NaN;
nPE_non_clk_ratio=NaN;
nPJ_non_clk_ratio=NaN;
nPI_non_clk_ratio=NaN;
nPC2_GEO_non_clk_ratio=NaN;
nPC2_IGSO_non_clk_ratio=NaN;
nPC2_MEO_non_clk_ratio=NaN;
nPC3_GEO_non_clk_ratio=NaN;
nPC3_IGSO_non_clk_ratio=NaN;
nPC3_MEO_non_clk_ratio=NaN;
     end
     
if num_of_files>1
    for j=1:num_of_files
nPG_non_clk_ratio(j)=NaN;
nPR_non_clk_ratio(j)=NaN;
nPE_non_clk_ratio(j)=NaN;
nPJ_non_clk_ratio(j)=NaN;
nPI_non_clk_ratio(j)=NaN;
nPC2_GEO_non_clk_ratio(j)=NaN;
nPC2_IGSO_non_clk_ratio(j)=NaN;
nPC2_MEO_non_clk_ratio(j)=NaN;
nPC3_GEO_non_clk_ratio(j)=NaN;
nPC3_IGSO_non_clk_ratio(j)=NaN;
nPC3_MEO_non_clk_ratio(j)=NaN;
    end
GPS_non_clk=NaN;
GLONASS_non_clk=NaN;
GALILEO_non_clk=NaN;
QZSS_non_clk=NaN;
IRNSS_non_clk=NaN;
BDS2_GEO_non_clk=NaN;
BDS2_IGSO_non_clk=NaN;
BDS2_MEO_non_clk=NaN;
BDS3_GEO_non_clk=NaN;
BDS3_IGSO_non_clk=NaN;
BDS3_MEO_non_clk=NaN;
end

end
end
close(h)
%===========         print the results      ==============================
addSpace = @(n,str)[char(32*ones(1,n)),str]; 
%===== for reference products ===========
if num_of_files==1
[a,b]=size(FileName);
[c,d]=size(FileName2);
first_space=b+4;
second_space=d+8;
end
if num_of_files>1
    for j=1:num_of_files
[a(j),b(j)]=size(char(FileName(:,j))); % cell
[c(j),d(j)]=size(char(FileName2(:,j)));
    end
first_space=38;  %max
second_space=38;
    % to keep aligned FileNames with different lenghts...
    for j=1:num_of_files
    if b(j)<38   % 38 assume max lenght....
        for i=1:(38-b(j))
            FileName(:,j)=strcat(FileName(:,j),'*');
        end
    end
    end
    for j=1:num_of_files
        if d(j)<38
     for i=1:(38-d(j))
         FileName2(:,j)=strcat(FileName2(:,j),'*');
     end
        end
    end
end

if num_of_files>1
    Average='Average';
    for i=1:31
        Average=strcat(Average,'*');
    end
end

startingFolder='C:\Program Files\MATLAB';
 if ~exist(startingFolder, 'dir')
    startingFolder = pwd;
 end
 defaultFileName=fullfile(startingFolder, '*.txt');
 [baseFileName, folder]=uiputfile(defaultFileName, 'Select a file');
  if baseFileName == 0
    return
  end
  fullFileName = fullfile(folder, baseFileName);   %fullfile=building file
  fid = fopen(fullFileName, 'w');
if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
fprintf(fid,'%*s %*s\n',first_space,'  G',second_space,'   G');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName, reference_average_GPS_number_reference, FileName2, reference_average_GPS_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName, nPG_non_clk_ratio_reference, FileName2, nPG_non_clk_ratio);
fclose(fid); 
    end
end

if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s\n',max(first_space)+4,'  G',max(second_space)+7,'   G');
fprintf(fid, '\n\n');
for j=1:num_of_files
fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_GPS_number, addSpace((second_space)+7-16,'Average:'), GPS_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_GPS_non_clk, addSpace((second_space)+7-16,'Average:'), GPS_non_clk);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
fprintf(fid,'%*s %*s\n',first_space,'  R',second_space,'   R');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName, reference_average_GLONASS_number_reference, FileName2, reference_average_GLONASS_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName, nPR_non_clk_ratio_reference, FileName2, nPR_non_clk_ratio);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s\n',max(first_space)+4,'  R',max(second_space+7),'   R');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName{:,j}, reference_average_GLONASS_number_reference(j), FileName2{:,j}, reference_average_GLONASS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_GLONASS_number, addSpace((second_space)+7-16,'Average:'), GLONASS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName{:,j}, nPR_non_clk_ratio_reference(j), FileName2{:,j}, nPR_non_clk_ratio(j));
end
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_GLONASS_non_clk, addSpace((second_space)+7-16,'Average:'), GLONASS_non_clk);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
fprintf(fid,'%*s %*s\n',first_space,'  E',second_space,'   E');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName, reference_average_GALILEO_number_reference, FileName2, reference_average_GALILEO_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName, nPE_non_clk_ratio_reference, FileName2, nPE_non_clk_ratio);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s\n',max(first_space)+4,'  E',max(second_space)+7,'   E');
fprintf(fid, '\n\n');
for j=1:num_of_files
   fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName{:,j}, reference_average_GALILEO_number_reference(j), FileName2{:,j}, reference_average_GALILEO_number(j)); 
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_GALILEO_number, addSpace((second_space)+7-16,'Average:'), GALILEO_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space+20)),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName{:,j}, nPE_non_clk_ratio_reference(j), FileName2{:,j}, nPE_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_GALILEO_non_clk, addSpace((second_space)+7-16,'Average:'), GALILEO_non_clk);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
fprintf(fid,'%*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',(second_space-1),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s %*s %*s',(max(first_space)+4),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',(max(second_space)+7),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
    for j=1:num_of_files
        fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j));
    end
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk);
    fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s\n',first_space,'  J',(second_space-2),'   J');
    fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName, reference_average_QZSS_number_reference, FileName2, reference_average_QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName, nPJ_non_clk_ratio_reference, FileName2, nPJ_non_clk_ratio);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files>1
        fprintf(fid,'%*s %*s\n',max(first_space)+4,'  J',(max(second_space)+7),'   J');
    fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName{:,j}, reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_QZSS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_QZSS_number, addSpace((second_space)+7-16,'Average:'), QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName{:,j}, nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_QZSS_non_clk, addSpace((second_space)+7-16,'Average:'), QZSS_non_clk);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files==1
    fprintf(fid,'%*s %*s\n',first_space,'  I',(second_space-2),'   I');
    fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName, reference_average_IRNSS_number_reference, FileName2, reference_average_IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName, nPI_non_clk_ratio_reference, FileName2, nPI_non_clk_ratio);
fclose(fid); 
    end
end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files>1
fprintf(fid,'%*s %*s\n',max(first_space)+4,'  I',(max(second_space)+7),'   I');
    fprintf(fid, '\n\n');
    for j=1:num_of_files
        fprintf(fid,'%s  %.1f  %s  %.1f\n', FileName{:,j}, reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_IRNSS_number(j));
    end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_IRNSS_number, addSpace((second_space)+7-16,'Average:'), IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
    for j=1:num_of_files
        fprintf(fid,'%s  %.1f  %s   %.1f\n', FileName{:,j}, nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPI_non_clk_ratio(j));
    end
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %s   %.1f\n', addSpace((first_space+4-12),'Average:'), reference_IRNSS_non_clk, addSpace((second_space)+7-16,'Average:'), IRNSS_non_clk);
    fclose(fid); 
    end
end
    
if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  G',4,'R',(second_space-2),'   G',4,'R');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f', FileName, reference_average_GPS_number_reference,reference_average_GLONASS_number_reference, FileName2, reference_average_GPS_number,reference_average_GLONASS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference, FileName2, nPG_non_clk_ratio,nPR_non_clk_ratio);
    fclose(fid); 
    end
end

if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s\n',max(first_space)+4,'  G',4,'R',(max(second_space)+7),'   G',4,'R');
    fprintf(fid, '\n\n');
        for j=1:num_of_files
          fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GLONASS_number(j));
        end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GPS_number,reference_GLONASS_number, Average, GPS_number,GLONASS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
        for j=1:num_of_files
            fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPR_non_clk_ratio(j));
        end
        fprintf(fid, '\n\n');
        fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GLONASS_non_clk, Average, GPS_non_clk,GLONASS_non_clk);
        fclose(fid); 
    end
end

if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  G',4,'E',(second_space-2),'   G',4,'E');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GPS_number_reference,reference_average_GALILEO_number_reference, FileName2, reference_average_GPS_number,reference_average_GALILEO_number);
     fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPE_non_clk_ratio_reference, FileName2, nPG_non_clk_ratio,nPE_non_clk_ratio);
 fclose(fid); 
    end
end
if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s\n',max(first_space)+4,'  G',4,'E',(max(second_space)+7),'   G',4,'E');
    fprintf(fid, '\n\n');
    for j=1:num_of_files
        fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GALILEO_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GALILEO_number(j));
    end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GPS_number,reference_GALILEO_number, Average, GPS_number,GALILEO_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPE_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GALILEO_non_clk, Average, GPS_non_clk,GALILEO_non_clk);
fclose(fid); 
    end
end

if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',(second_space+1),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GPS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GPS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPG_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPG_non_clk_ratio);
fclose(fid); 
    end
end
if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(max(first_space)+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',(max(second_space)+10),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G');
    fprintf(fid, '\n\n');
for j=1:num_of_files
        fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GPS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GPS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GPS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GPS_non_clk);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(max(first_space)+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPG_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPG_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GPS_non_clk, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GPS_non_clk);
fclose(fid); 
    end
end

if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  G',4,'J',(second_space-2),'   G',4,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f', FileName, reference_average_GPS_number_reference,reference_average_QZSS_number_reference, FileName2, reference_average_GPS_number,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2, nPG_non_clk_ratio,nPJ_non_clk_ratio);
 fclose(fid); 
    end
end
   
if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  G',4,'J',(second_space+7),'   G',4,'J');
    fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_QZSS_number(j));
end
     fprintf(fid, '\n\n');
   fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GPS_number,reference_QZSS_number, Average, GPS_number,QZSS_number);  
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_QZSS_non_clk, Average, GPS_non_clk,QZSS_non_clk);
 fclose(fid); 
    end
end
    
if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  G',4,'I',(second_space-2),'   G',4,'I');
     fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GPS_number_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_GPS_number,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2, nPG_non_clk_ratio,nPI_non_clk_ratio);
 fclose(fid); 
    end
end
   if isempty(GPS)~=1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  G',4,'I',(second_space+7),'   G',4,'I');
     fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_IRNSS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GPS_number,reference_IRNSS_number, Average, GPS_number,IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_IRNSS_non_clk, Average, GPS_non_clk,IRNSS_non_clk);
fclose(fid); 
    end
   end

if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  R',4,'E',(second_space-2),'   R',4,'E');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference, FileName2, reference_average_GLONASS_number,reference_average_GALILEO_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference, FileName2, nPR_non_clk_ratio,nPE_non_clk_ratio);
    fclose(fid); 
    end
end
    if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  R',4,'E',(second_space+7),'   R',4,'E');
    fprintf(fid, '\n\n');
    for j=1:num_of_files
       fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j), FileName2{:,j}, reference_average_GLONASS_number(j),reference_average_GALILEO_number(j));
    end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GLONASS_number,reference_GALILEO_number, Average, GLONASS_number,GALILEO_number);
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j), FileName2{:,j}, nPR_non_clk_ratio(j),nPE_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GLONASS_non_clk,reference_GALILEO_non_clk, Average, GLONASS_non_clk,GALILEO_non_clk);
fclose(fid); 
    end
    end
    
if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'R',(second_space+1),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'R');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GLONASS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GLONASS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPR_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPR_non_clk_ratio);
fclose(fid); 
end
end
if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
if num_of_files>1
    fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'R',(second_space+10),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'R');
    fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GLONASS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GLONASS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GLONASS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GLONASS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPR_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GLONASS_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,GLONASS_non_clk);
fclose(fid);
end
end

if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files==1
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  G',4,'J',(second_space-2),'   G',4,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GLONASS_number_reference,reference_average_QZSS_number_reference, FileName2, reference_average_GLONASS_number,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPR_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2, nPR_non_clk_ratio,nPJ_non_clk_ratio);
    fclose(fid); 
    end
end
   if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files>1
        fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  G',4,'J',(second_space+7),'   G',4,'J');
    fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GLONASS_number_reference(j),reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_GLONASS_number(j),reference_average_QZSS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GLONASS_number,reference_QZSS_number, Average, GLONASS_number,QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPR_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPR_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GLONASS_non_clk, reference_QZSS_non_clk, Average, GLONASS_non_clk, QZSS_non_clk);
fclose(fid);
    end
   end

if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files==1
     fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  R',4,'I',(second_space-2),'   R',4,'I');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GLONASS_number_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_GLONASS_number,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPR_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2, nPR_non_clk_ratio,nPI_non_clk_ratio);
    fclose(fid); 
    end
end
if isempty(GPS)==1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files>1
fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  R',4,'I',(second_space+7),'   R',4,'I');
    fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GLONASS_number_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_GLONASS_number(j),reference_average_IRNSS_number(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GLONASS_number,reference_IRNSS_number, Average, GLONASS_number,IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPR_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPR_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GLONASS_non_clk,reference_IRNSS_non_clk, Average, GLONASS_non_clk,IRNSS_non_clk);
fclose(fid); 
    end
end

  if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'E',(second_space+1),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'E');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GALILEO_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GALILEO_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPE_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPE_non_clk_ratio);
fclose(fid); 
      end
  end
if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
      if num_of_files>1
   fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'E',(second_space+10),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'E');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GALILEO_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GALILEO_number(j));
  end
    fprintf(fid, '\n\n');
   fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GALILEO_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GALILEO_number); 
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPE_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GALILEO_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,GALILEO_non_clk);
    fclose(fid); 
      end
  end
    
  if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  E',4,'J',(second_space-2),'   E',4,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GALILEO_number_reference,reference_average_QZSS_number_reference, FileName2, reference_average_GALILEO_number,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPE_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2, nPE_non_clk_ratio,nPJ_non_clk_ratio);
    fclose(fid); 
    end
  end
   if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
    if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  E',4,'J',(second_space+7),'   E',4,'J');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_GALILEO_number,reference_QZSS_number, FileName2{:,j}, GALILEO_number,QZSS_number);
  end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_average_GALILEO_number_reference(j),reference_average_QZSS_number_reference(j), Average, reference_average_GALILEO_number(j),reference_average_QZSS_number(j));
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPE_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPE_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GALILEO_non_clk, reference_QZSS_non_clk, Average, GALILEO_non_clk, QZSS_non_clk);
 fclose(fid); 
    end
  end

if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files==1 
    fprintf(fid,'%*s %*s %*s %*s\n',first_space,'  E',4,'I',(second_space-2),'   E',4,'I');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName, reference_average_GALILEO_number_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_GALILEO_number,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName, nPE_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2, nPE_non_clk_ratio,nPI_non_clk_ratio);
    fclose(fid); 
    end
end
  if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
    if num_of_files>1 
fprintf(fid,'%*s %*s %*s %*s\n',first_space+4,'  E',4,'I',(second_space+7),'   E',4,'I');
    fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', FileName{:,j}, reference_average_GALILEO_number_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_GALILEO_number(j),reference_average_IRNSS_number(j));
end
     fprintf(fid, '\n\n');
     fprintf(fid,'%s  %.1f %.1f  %s %.1f %.1f\n', Average, reference_GALILEO_number,reference_IRNSS_number, Average, GALILEO_non_clk, IRNSS_non_clk);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', FileName{:,j}, nPE_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPE_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid,'%s  %.1f %.1f  %s   %.1f  %.1f\n', Average, reference_GALILEO_non_clk, reference_IRNSS_non_clk, Average, GALILEO_non_clk, IRNSS_non_clk);
 fclose(fid); 
    end
end

  if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'J',(second_space+1),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_QZSS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPJ_non_clk_ratio);
fclose(fid); 
  end
  end
  if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
      if num_of_files>1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'J',(second_space+10),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'J');
      fprintf(fid, '\n\n');
      for j=1:num_of_files
  fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_QZSS_number(j));
  end
   fprintf(fid, '\n\n');
   fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_QZSS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk, reference_BDS2_GEO_non_clk, reference_BDS3_MEO_non_clk, reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_QZSS_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,QZSS_non_clk);
fclose(fid); 
  end
  end
  
  if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
     if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'I',(second_space+1),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'I');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPI_non_clk_ratio);
fclose(fid); 
     end
  end
     if isempty(GPS)==1 && isempty(GLONASS)==1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
     if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'I',(second_space+10),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'I');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_IRNSS_number(j));
  end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_IRNSS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
   fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_IRNSS_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,IRNSS_non_clk);
fclose(fid); 
     end
     end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
  if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s\n',first_space,'  G',4,'R',4,'E',(second_space+1),'   G',4,'R',4,'E');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', FileName, reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference, FileName2, reference_average_GPS_number,reference_average_GLONASS_number,reference_average_GALILEO_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference, FileName2,   nPG_non_clk_ratio,nPR_non_clk_ratio,nPE_non_clk_ratio);
    fclose(fid); 
  end
  end
   if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)==1
  if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s\n',first_space+4,'  G',4,'R',4,'E',(second_space+9),'   G',4,'R',4,'E');
    fprintf(fid, '\n\n');
      for j=1:num_of_files
          fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_GALILEO_number(j));
      end
   fprintf(fid, '\n\n');
   fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', Average, reference_GPS_number,reference_GLONASS_number,reference_GALILEO_number, Average, GPS_number,GLONASS_number,GALILEO_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPE_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GLONASS_non_clk,reference_GALILEO_non_clk, Average, GPS_non_clk,GLONASS_non_clk,GALILEO_non_clk);
fclose(fid); 
  end
   end
  
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',(second_space+5),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GPS_number_reference,reference_average_GLONASS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GPS_number,reference_average_GLONASS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPG_non_clk_ratio,nPR_non_clk_ratio);
fclose(fid); 
      end
  end
if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
      if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',(second_space+12),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GPS_number(j),reference_average_GLONASS_number(j));
  end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f  %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GPS_number,reference_GLONASS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GPS_number,GLONASS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPG_non_clk_ratio(j),nPR_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GPS_non_clk,reference_GLONASS_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,GPS_non_clk,GLONASS_non_clk);
fclose(fid); 
      end
end

  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s\n',first_space,'  G',4,'R',4,'J',(second_space+1),'   G',4,'R',4,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', FileName, reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_QZSS_number_reference, FileName2, reference_average_GPS_number,reference_average_GLONASS_number,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2,   nPG_non_clk_ratio,nPR_non_clk_ratio,nPJ_non_clk_ratio);
    fclose(fid); 
      end
  end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
      if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s\n',first_space+4,'  G',4,'R',4,'J',(second_space+9),'   G',4,'R',4,'J');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_QZSS_number(j));
  end
   fprintf(fid, '\n\n');
   fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', Average, reference_GPS_number,reference_GLONASS_number,reference_QZSS_number, Average, GPS_number,GLONASS_number,QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GLONASS_non_clk,reference_QZSS_non_clk, Average, GPS_non_clk,GLONASS_non_clk,QZSS_non_clk);
fclose(fid); 
      end
  end

  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s\n',first_space,'  G',4,'R',4,'I',(second_space+1),'   G',4,'R',4,'I');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', FileName, reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_GPS_number,reference_average_GLONASS_number,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2,   nPG_non_clk_ratio,nPR_non_clk_ratio,nPI_non_clk_ratio);
    fclose(fid); 
      end
  end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)==1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
      if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s\n',first_space+4,'  G',4,'R',4,'I',(second_space+9),'   G',4,'R',4,'I');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_IRNSS_number(j));
  end
   fprintf(fid, '\n\n');
   fprintf(fid,'%s  %.1f  %.1f  %.1f  %s  %.1f  %.1f  %.1f\n', Average, reference_GPS_number,reference_GLONASS_number,reference_IRNSS_number, Average, GPS_number,GLONASS_number,IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GLONASS_non_clk,reference_IRNSS_non_clk, Average, GPS_non_clk,GLONASS_non_clk,IRNSS_non_clk);
fclose(fid); 
      end
  end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E',(second_space+5),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GPS_number,reference_average_GLONASS_number,reference_average_GALILEO_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPG_non_clk_ratio,nPR_non_clk_ratio,nPE_non_clk_ratio);
fclose(fid); 
      end
  end
  
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)==1 && isempty(IRNSS)==1
      if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E',(second_space+12),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_GALILEO_number(j));
  end
     fprintf(fid, '\n\n');
     fprintf(fid,'%s  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GPS_number,reference_GLONASS_number,reference_GALILEO_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GPS_number,GLONASS_number,GALILEO_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPE_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk, reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GPS_non_clk,reference_GLONASS_non_clk,reference_GALILEO_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,GPS_non_clk,GLONASS_non_clk,GALILEO_non_clk);
    fclose(fid); 
      end
  end
  
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s\n',first_space,'  G',4,'R',4,'E',4,'J',(second_space+1),'   G',4,'R',4,'E',4,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %s  %.1f  %.1f  %.1f  %.1f\n', FileName, reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference,reference_average_QZSS_number_reference, FileName2, reference_average_GPS_number,reference_average_GLONASS_number,reference_average_GALILEO_number,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2,   nPG_non_clk_ratio,nPR_non_clk_ratio,nPE_non_clk_ratio,nPJ_non_clk_ratio);
    fclose(fid); 
      end
  end
  
   if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
      if num_of_files>1
   fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s\n',first_space+4,'  G',4,'R',4,'E',7,'J',(second_space+9),'   G',4,'R',4,'E',4,'J');
    fprintf(fid, '\n\n');
          for j=1:num_of_files
              fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %s  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j),reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_GALILEO_number(j),reference_average_QZSS_number(j));
          end
           fprintf(fid, '\n\n');
           fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %s  %.1f  %.1f  %.1f  %.1f\n', Average, reference_GPS_number,reference_GLONASS_number,reference_GALILEO_number,reference_QZSS_number, Average, GPS_number,GLONASS_number,GALILEO_number,QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j},nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPE_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GLONASS_non_clk,reference_GALILEO_non_clk,reference_QZSS_non_clk, Average, GPS_non_clk,GLONASS_non_clk,GALILEO_non_clk,QZSS_non_clk);
  fclose(fid); 
      end
   end
  
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
      if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s\n',first_space,'  G',4,'R',4,'E',4,'I',(second_space+1),'   G',4,'R',4,'E',4,'I');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %s  %.1f  %.1f  %.1f  %.1f', FileName, reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_GPS_number,reference_average_GLONASS_number,reference_average_GALILEO_number,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f  %.1f\n', FileName, nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2,   nPG_non_clk_ratio,nPR_non_clk_ratio,nPE_non_clk_ratio,nPI_non_clk_ratio);
    fclose(fid); 
      end
  end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)==1 && isempty(QZSS)==1 && isempty(IRNSS)~=1
      if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s\n',first_space+4,'  G',4,'R',4,'E',4,'I',(second_space+9),'   G',4,'R',4,'E',4,'I');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %s  %.1f  %.1f  %.1f  %.1f', FileName{:,j}, reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_GALILEO_number(j),reference_average_IRNSS_number(j));
  end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %s  %.1f  %.1f  %.1f  %.1f', Average, reference_GPS_number,reference_GLONASS_number,reference_GALILEO_number,reference_IRNSS_number, Average, GPS_number,GLONASS_number,GALILEO_number,IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPE_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %s   %.1f  %.1f  %.1f  %.1f\n', Average, reference_GPS_non_clk,reference_GLONASS_non_clk,reference_GALILEO_non_clk,reference_IRNSS_non_clk, Average, GPS_non_clk,GLONASS_non_clk,GALILEO_non_clk,IRNSS_non_clk);
fclose(fid); 
      end
  end
  
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
         if num_of_files==1
      fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E',5,'J',(second_space+5),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E',5,'J');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference,reference_average_QZSS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GPS_number,reference_average_GLONASS_number,reference_average_GALILEO_number,reference_average_QZSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference,nPJ_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPG_non_clk_ratio,nPR_non_clk_ratio,nPE_non_clk_ratio,nPJ_non_clk_ratio);
fclose(fid); 
         end
  end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)~=1 && isempty(IRNSS)==1
         if num_of_files>1
  fprintf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E',5,'J',(second_space+12),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',5,'R',5,'E',5,'J');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j),reference_average_QZSS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_GALILEO_number(j),reference_average_QZSS_number(j));
  end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number, reference_BDS2_GEO_number, reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GPS_number,reference_GLONASS_number,reference_GALILEO_number,reference_QZSS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GPS_number,GLONASS_number,GALILEO_number,QZSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPE_non_clk_ratio(j),nPJ_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s       %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk, reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GPS_non_clk,reference_GLONASS_non_clk,reference_GALILEO_non_clk,reference_QZSS_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,GPS_non_clk,GLONASS_non_clk,GALILEO_non_clk, QZSS_non_clk);
fclose(fid); 
         end
  end
  
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)~=1 && isempty(IRNSS)~=1
      if num_of_files==1
       fprintf(fid,'%*s %*s %*s  %*s %*s %*s %*s %*s %*s %*s %*s',(first_space+2),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',4,'R',4,'E',4,'J',4,'I',(second_space+5),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',4,'R',4,'E',4,'J',4,'I');
    fprintf(fid, '\n\n');
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, reference_average_BDS2_number_sum_MEO_reference, reference_average_BDS2_number_sum_IGSO_reference,reference_average_BDS2_number_sum_GEO_reference,reference_average_BDS3_number_sum_MEO_reference,reference_average_BDS3_number_sum_IGSO_reference,reference_average_BDS3_number_sum_GEO_reference,reference_average_GPS_number_reference,reference_average_GLONASS_number_reference,reference_average_GALILEO_number_reference,reference_average_QZSS_number_reference,reference_average_IRNSS_number_reference, FileName2, reference_average_BDS2_number_sum_MEO, reference_average_BDS2_number_sum_IGSO,reference_average_BDS2_number_sum_GEO,reference_average_BDS3_number_sum_MEO,reference_average_BDS3_number_sum_IGSO,reference_average_BDS3_number_sum_GEO,reference_average_GPS_number,reference_average_GLONASS_number,reference_average_GALILEO_number,reference_average_QZSS_number,reference_average_IRNSS_number);
    fprintf(fid, '\n\n');
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s        %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName, nPC2_MEO_non_clk_ratio_reference, nPC2_IGSO_non_clk_ratio_reference,nPC2_GEO_non_clk_ratio_reference,nPC3_MEO_non_clk_ratio_reference,nPC3_IGSO_non_clk_ratio_reference,nPC3_GEO_non_clk_ratio_reference,nPG_non_clk_ratio_reference,nPR_non_clk_ratio_reference,nPE_non_clk_ratio_reference,nPJ_non_clk_ratio_reference,nPI_non_clk_ratio_reference, FileName2, nPC2_MEO_non_clk_ratio, nPC2_IGSO_non_clk_ratio,nPC2_GEO_non_clk_ratio,nPC3_MEO_non_clk_ratio,nPC3_IGSO_non_clk_ratio,nPC3_GEO_non_clk_ratio,nPG_non_clk_ratio,nPR_non_clk_ratio,nPE_non_clk_ratio,nPJ_non_clk_ratio,nPI_non_clk_ratio);
fclose(fid); 
  end
  end
  if isempty(GPS)~=1 && isempty(GLONASS)~=1 && isempty(GALILEO)~=1 && isempty(BEIDOU)~=1 && isempty(QZSS)~=1 && isempty(IRNSS)~=1
      if num_of_files>1
  fprintf(fid,'%*s %*s %*s  %*s %*s %*s %*s %*s %*s %*s %*s',(first_space+6),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',4,'R',4,'E',4,'J',4,'I',(second_space+12),'C2_M',2,'C2_I',2, 'C2_G',2,'C3_M',2,'C3_I',2,'C3_G',2,'G',4,'R',4,'E',4,'J',4,'I');
    fprintf(fid, '\n\n');
  for j=1:num_of_files
      fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, reference_average_BDS2_number_sum_MEO_reference(j), reference_average_BDS2_number_sum_IGSO_reference(j),reference_average_BDS2_number_sum_GEO_reference(j),reference_average_BDS3_number_sum_MEO_reference(j),reference_average_BDS3_number_sum_IGSO_reference(j),reference_average_BDS3_number_sum_GEO_reference(j),reference_average_GPS_number_reference(j),reference_average_GLONASS_number_reference(j),reference_average_GALILEO_number_reference(j),reference_average_QZSS_number_reference(j),reference_average_IRNSS_number_reference(j), FileName2{:,j}, reference_average_BDS2_number_sum_MEO(j), reference_average_BDS2_number_sum_IGSO(j),reference_average_BDS2_number_sum_GEO(j),reference_average_BDS3_number_sum_MEO(j),reference_average_BDS3_number_sum_IGSO(j),reference_average_BDS3_number_sum_GEO(j),reference_average_GPS_number(j),reference_average_GLONASS_number(j),reference_average_GALILEO_number(j),reference_average_QZSS_number(j),reference_average_IRNSS_number(j));
  end
  fprintf(fid, '\n\n');
  fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f %.1f %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s     %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_number, reference_BDS2_IGSO_number,reference_BDS2_GEO_number,reference_BDS3_MEO_number,reference_BDS3_IGSO_number,reference_BDS3_GEO_number,reference_GPS_number,reference_GLONASS_number,reference_GALILEO_number,reference_QZSS_number,reference_IRNSS_number, Average, BDS2_MEO_number, BDS2_IGSO_number,BDS2_GEO_number,BDS3_MEO_number,BDS3_IGSO_number,BDS3_GEO_number,GPS_number,GLONASS_number,GALILEO_number,QZSS_number,IRNSS_number);
fprintf(fid, '\n\n');
fprintf(fid,'%*s\n',(first_space+20),'***** Non_Available_clock(%) *****');
fprintf(fid, '\n\n');
for j=1:num_of_files
    fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s        %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', FileName{:,j}, nPC2_MEO_non_clk_ratio_reference(j), nPC2_IGSO_non_clk_ratio_reference(j),nPC2_GEO_non_clk_ratio_reference(j),nPC3_MEO_non_clk_ratio_reference(j),nPC3_IGSO_non_clk_ratio_reference(j),nPC3_GEO_non_clk_ratio_reference(j),nPG_non_clk_ratio_reference(j),nPR_non_clk_ratio_reference(j),nPE_non_clk_ratio_reference(j),nPJ_non_clk_ratio_reference(j),nPI_non_clk_ratio_reference(j), FileName2{:,j}, nPC2_MEO_non_clk_ratio(j), nPC2_IGSO_non_clk_ratio(j),nPC2_GEO_non_clk_ratio(j),nPC3_MEO_non_clk_ratio(j),nPC3_IGSO_non_clk_ratio(j),nPC3_GEO_non_clk_ratio(j),nPG_non_clk_ratio(j),nPR_non_clk_ratio(j),nPE_non_clk_ratio(j),nPJ_non_clk_ratio(j),nPI_non_clk_ratio(j));
end
fprintf(fid, '\n\n');
fprintf(fid,'%s  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %s        %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f  %.1f\n', Average, reference_BDS2_MEO_non_clk, reference_BDS2_IGSO_non_clk,reference_BDS2_GEO_non_clk,reference_BDS3_MEO_non_clk,reference_BDS3_IGSO_non_clk,reference_BDS3_GEO_non_clk,reference_GPS_non_clk,reference_GLONASS_non_clk,reference_GALILEO_non_clk,reference_QZSS_non_clk,reference_IRNSS_non_clk, Average, BDS2_MEO_non_clk, BDS2_IGSO_non_clk,BDS2_GEO_non_clk,BDS3_MEO_non_clk,BDS3_IGSO_non_clk,BDS3_GEO_non_clk,GPS_non_clk,GLONASS_non_clk,GALILEO_non_clk,QZSS_non_clk,IRNSS_non_clk);
  fclose(fid); 
  end
  end
%======================  data availability finished =======================    

%======================  orbit & clock comparison starts=================== 

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
global FileName2 rb2

% if isempty(FileName2)==1
%     errordlg('Input reference and target products', 'Error!', 'modal')
% return
% end

rb2=findobj(gcbf, 'Tag', 'radiobutton3');
set(rb2, 'Value',0);

set(handles.edit1,'Visible','on')
set(handles.edit12,'Visible','on')
set(handles.edit13,'Visible','on')
set(handles.edit14,'Visible','on')
set(handles.edit17,'Visible','on')
set(handles.edit20,'Visible','on')
set(handles.edit21,'Visible','on')


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
rb1=findobj(gcbf, 'Tag', 'radiobutton2');
set(rb1, 'Value',0);

set(handles.edit1,'Visible','off')
set(handles.edit12,'Visible','off')
set(handles.edit13,'Visible','off')
set(handles.edit14,'Visible','off')
% set(handles.edit15,'Visible','off')
% set(handles.edit16,'Visible','off')
set(handles.edit17,'Visible','off')
% set(handles.edit18,'Visible','off')
% set(handles.edit19,'Visible','off')
set(handles.edit20,'Visible','off')
set(handles.edit21,'Visible','off')

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
%set(handles.edit1,'Visible','off')

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



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.      %run button !!!
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global C FileName full_file_name num_of_files C2 FileName2 full_file_name2 num_of_files_2 extension2 rb4
global num_of_files GPS GLONASS GALILEO BEIDOU QZSS IRNSS extension
global rb2 rb3 rb6 rb7 rb8 rb9 rb10
%if isempty(rb7)==0 || isempty(rb8)==0
% Extract the reference satellites PRN
G_ref = get(handles.edit1,'String');
R_ref = get(handles.edit12,'String');
E_ref = get(handles.edit13,'String');
C2_ref = get(handles.edit14,'String');
C3_ref = get(handles.edit17,'String');
QZSS_ref = get(handles.edit20,'String');
G_ref_prefix=append('G',G_ref);
G_ref_double=str2double(get(handles.edit1, 'String')); % if NaN == string...
R_ref_double=str2double(get(handles.edit12, 'String')); % if NaN == string...
E_ref_double=str2double(get(handles.edit13, 'String')); % if NaN == string...
C2_ref_double=str2double(get(handles.edit14, 'String')); % if NaN == string...
C3_ref_double=str2double(get(handles.edit17, 'String')); % if NaN == string...
QZSS_ref_double=str2double(get(handles.edit20, 'String')); % if NaN == string...
R_ref_prefix=append('R',R_ref);
E_ref_prefix=append('E',E_ref);
C2_ref_prefix=append('C2_',C2_ref);
C3_ref_prefix=append('C3_',C3_ref);
QZSS_ref_prefix=append('J',QZSS_ref);

if isempty(GPS)==0
if isempty(rb7)==0 || isempty(rb8)==0
if isnan(G_ref_double)
     errordlg('Input numeric value (01-32) for GPS clock', 'Error!', 'modal')
return
end

if G_ref_double > 32
     errordlg('Input numeric value (01-32) for GPS clock', 'Error!', 'modal')
     return
end

end
end

if isempty(GLONASS)==0
if isempty(rb7)==0 || isempty(rb8)==0
if isnan(R_ref_double)
     errordlg('Input numeric value (01-26) for GLONASS clock', 'Error!', 'modal')
return
end

if R_ref_double > 26
     errordlg('Input numeric value (01-26) for GLONASS clock', 'Error!', 'modal')
     return
end

end
end

% BDS2_ref = get(handles.edit14,'String');
% BDS3_ref = get(handles.edit17,'String');
% QZSS_ref = get(handles.edit20,'String');
% IRNSS_ref = get(handles.edit21,'String');

if length(G_ref)==1
    G_ref=sprintf('%02s',G_ref);
end
if length(R_ref)==1
    R_ref=sprintf('%02s',R_ref);
end
if length(E_ref)==1    
    E_ref=sprintf('%02s',E_ref);
end
if length(C2_ref)==1    
    C2_ref=sprintf('%02s',C2_ref);
end
if length(C3_ref)==1    
    C3_ref=sprintf('%02s',C3_ref);  
end
if length(QZSS_ref)==1
    QZSS_ref=sprintf('%02s',QZSS_ref);   
end
% if length(IRNSS_ref)==1
%     IRNSS_ref=sprintf('%02s',IRNSS_ref);    
% end

if isempty(rb7)==0 || isempty(rb8)==0
if length(G_ref)>2 || length(R_ref)>2 || length(E_ref)>2 || length(C2_ref)>2 || length(C3_ref)>2 || length(QZSS_ref)>2
errordlg('PRN of the reference satellites should consists of two digits (for example: 05, 31, etc.)', 'Error!', 'modal')
return
end
end
