function safePrint(filename,formattype)
%% help documentation
% safePrint checks to see if a file with the same name already exists before printing. 
% If the file already exists, the user will be prompted to override the current file if they wish.
% If the user does not wish to override the current file the user must enter 'no' and the funtion will not print
%
% Inputs 
% filename = name of figure 
% formattype = the format you wish to print the file as
% safePrint(filename,formattype) prints the figure as formattype file
% safePrint(filename.formatttype) prints the figure as formattype file
% safePrint(filename) prints the figure as a PDF file
%
% Example Inputs
% figure; surf(peaks);
% safePrint('peaks','-deps'); 
%   this prints the figure as an eps file
%
% figure; surf(peaks);
% safePrint('peaks.jpeg');
%   this prints the figure as a jpeg file
%
% figure; surf(peaks);
% safePrint('peaks');
%   this prints the figure as a PDF file

%% Get file parts
[path,name,ext] = fileparts(filename);

%% Add format type if not specified
if nargin < 2
   if strcmpi(ext, '')
      formattype = '-dpdf';
   else
      formattype = ext;
   end
end

%% Change from '.' format to '-d'   
if contains(formattype, '.')
   removeDotExt = extractAfter(formattype, '.');
   printExt = ['-d' removeDotExt];
elseif ~contains(formattype, '-d') 
   printExt = ['-d' formattype];
else
   printExt = formattype;
end

%% Change tif to tiff and jpeg to jpg for proper print format
if strcmpi(formattype, '.tif') || strcmpi(formattype, '-tif') || strcmpi(formattype, '-dtif') || strcmpi(formattype, 'tif')
   printExt = '-dtiff';
elseif strcmpi(formattype, '.jpeg') || strcmpi(formattype, '-jpeg') || strcmpi(formattype, '-djpeg') || strcmpi(formattype, 'jpeg')
   printExt = '-djpg';
end

%% Add path if there is not one already
if strcmpi(path, '')
   path = pwd;
end

%% Check to see if the file already exists and print
printFile = fullfile(path,strcat(name,'.',extractAfter(printExt,'-d')));
if exist(printFile,'file')
    userResp = input('This filename already exists. Do you want to override it?\n','s');
    if strcmpi(userResp,'no')
       warning('User did not want to override the current file. Nothing was saved');
       return;
    end
end
print(printFile,printExt);