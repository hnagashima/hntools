function cmenu(varargin)
% Add custom menu to the figure menubar.
% cmenu         % adds cmenu to the figure.
% cmenu on      % adds cmenu to the figure.
% cmenu off     % removes cmenu
% cmenu default % set cmenu as a default figure create function.
% cmenu enable  % set cmenu as a default figure create function.
% cmenu disable % remove cmenu from a default figure create function.
% cmenu(src, event)  % called from Figure create function. 
%       Same as cmenu on
% 
% 
% cmenu off removes custom menu from the current figure.
% cmenu on adds custom menu to the figure.
% 
% cmenu requires ezyfit.
% 
% 
% Run following script at startup.m to setup cmenu as a default.
%   cmenu default
%  set(0, 'defaultFigureCreateFcn',@(src, event) cmenu('on',src,event));
% This function is called when figure is created.
% 

% Parse inputs
switch nargin 
    case 0
        src = gcf;
        event = [];
        option = 'on';
    case 1
        if strcmp(varargin{1},'default')
            set(0, 'defaultFigureCreateFcn',@cmenu);
            disp('Default menu has set to be cmenu');
            return;
        end
        if strcmp(varargin{1},'enable')
            set(0, 'defaultFigureCreateFcn',@cmenu);
            disp('Default menu has set to be cmenu');
            return;
        end
        if strcmp(varargin{1}, 'disable')
            set(0, 'defaultFigureCreateFcn',[]);
            disp('Cmenu has removed from the default figure menu.');
            return;
        end
        src = gcf;
        event = [];
        option = varargin{1};
    case 2
        src = varargin{1};
        event = varargin{2};
        option = 'on';
    otherwise
        % It can be called when the cmenu is called as a default figure
        % create function with other programs. third input will be another
        % functions.
        src = varargin{1};
        event = varargin{2};
        option = 'on';

end

% option must be on or off.

if ~ismember(option,{'on','off'}) 
        error('Option is ''on'' , ''off'' , ''default'' or ''disable'' ');
end


fig = src;% F = figure; gcf
% Check if figure is numberless ( = appdesigner or some GUI apps)
if isempty(fig.Number)
    return;
end
if strcmp(fig.MenuBar,'figure') == 0
    return;
end



%% menu処理
% Set figure positions.
createFigureOutsideIDE(varargin{:});
% clear menu at first.
delete(findobj(fig,'Label','Custom')); % clear old menu object.
delete(findobj(fig,'Label','EzyFit')); % clear menu object.

switch option
    case 'off'
        return;
    case 'on'

end



mh = uimenu(fig,LabelName ,'Custom');
mh.HandleVisibility = 'on'; % undeletable object.
%---
% add save2pdf menu
v = version('-release'); % get Matlab version
save2pdf_menu(src, event, mh); % old version may need ghost script and save2pdf
% if str2double(v(1:4)) < 2020
% 
% else %  export graphics is available at matlab2020a and later.    
%     exportgraphics_menu(src, event, mh);% add exportgraphics_menu
% end


%---
% add Figure Scale menu
eh3 = uimenu(mh,LabelName,'FigureScale');
lists = FigureScale;
c_eh3{1,size(lists,1)} = [];
for k = 1:size(lists,1)
    c_eh3{k} = uimenu(eh3,LabelName,lists{k,1});
    c_eh3{k}.Callback = @setFigureScale;
end
    function setFigureScale(src,~)
        FigureScale(mh.Parent,src.Text);
    end

%---
% add label menu
label.addLabelMenu(src,event, mh);

% add Figure size fix menu.
%eh4 = uimenu(mh, LabelName, 'Command for fix Figure Size');


%---
% add program report and dependency checker
st = dbstack('-completenames'); % List of calling programs
st = flipud(st);
eh5 = uimenu(mh, LabelName, 'Calling Programs');
eh5_files = cell(1, numel(st) + 1);
for k = 1:numel(st)  
    [~,f_name] = fileparts(st(k).file); % only the file name , not path
    if strcmp(f_name , 'cmenu') == 0 % cmenu will not be listed.
        eh5_files{k} = uimenu(eh5, LabelName,  f_name );
        eh5_files{k}.MenuSelectedFcn=@(~,~) dependfigure_cmenu(st(k).file,eh5_files{k});
        
    end
end


%---
% add Ezyfit Function
memo_dFigCreateFcn = get(0,'defaultFigureCreateFcn'); % remember default figure create fcn.
efmenu;
set(0,'defaultFigureCreateFcn',memo_dFigCreateFcn);% Restore default figure create fcn.

% remove this function from current Figure.
fig.CreateFcn = [];

%---


% 例
% eh0 = uimenu(mh,'text','test');
% fun0 = @(src,event,varargin) disp('test');
% eh0.MenuSelectedFcn = fun0;

% src event is reserved inputs.
% You need to specify as a 1st and 2nd inputs, 
% even though you don't need src and event.

% PDF export functions
% eh1 = uimenu(mh,'text','Export to PDF');
% fun = @(src,event,varargin) save2pdf(mh.Parent);
% eh1.MenuSelectedFcn = fun;
% 
% eh2 = uimenu(mh, 'text', 'Export to transparent PDF');
% fun = @(src,event, varargin) save2pdf_transparent(mh.Parent);
% eh2.MenuSelectedFcn = fun;
end



function pname = LabelName
% Return 'text' or 'label' depending on MATLAB version
V = version('-release');
if str2double(V(1:4)) < 2018        
    pname = 'label';
else
    pname = 'text';
end

end

%% Figure Size Fix.




%% Dependency list
function dependfigure_cmenu(filenamecell, eh4_files)
% This function tries to set dependency of the figures
% The files and products will be copied to the clipboard.
%
%dependfigure_cmenu(filenamecell, eh4_files)
% filename cell : プログラムの名前, セル配列か文字列
% eh4_files     : メニューのハンドル。実行結果をそこに生成するようなプログラムを想定した

disp('Generating the dependencies...');

filenamecell = forcecell(filenamecell);

% check dependencies.
[fList,pList] = matlab.codetools.requiredFilesAndProducts(filenamecell{1});
fList = reshape(fList,[],1);
pList = reshape(pList,[],1);

productList = {pList.Name};
productList = reshape(productList,[],1);

% #copy to clipboard (Version 1, Full file lists.)
% clipboard('copy', strjoin([fList; productList], newline));
% disp('Dependency Lists were copied to your clipboard');

% #TidyUp
dnames = cell(numel(fList),3); % dependency file names.
% separate to directory
for k = 1:numel(fList)
   [dnames{k,1} , fn,ext] = fileparts(fList{k});
   dnames{k,2} = [sprintf('\t'), fn,ext];
end
[~, ia] = unique(dnames(:,1),'stable'); % Remove unique folders
for k = 1:numel(ia)
    dnames{ia(k),3} = dnames{ia(k),1};
end
%Re-sorting
tx = reshape(dnames(:,[3 2]).',[],1);
tx(cellfun(@isempty,tx)) = [];

% Copy to clipboard (version 2, partial file lists)
clipboard('copy', strjoin([tx; productList], newline));

% Save to the file.
%fp = fopen(['dependenciesfilenamecell{1});
[filedir, file, ~] = fileparts(filenamecell{1});
ext = '_dependence.txt'; k = 1; sw = 0;
while sw == 0
    fn2 = fullfile(filedir, [file ext]);
    if exist(fn2, 'file') % when the file exists.
        % File exists.
        ext = ['_dependence' num2str(k) '.txt'];
        k = k + 1;
    else
        % You can use this file.
        sw = 1;
    end
end
fp = fopen(fn2,'w');
if fp == -1
    error('Error in creating file');
else
    % Write the string to the file.
   fprintf(fp, '%s', strjoin([tx; productList], newline));
   fclose(fp);
   disp('Dependency Lists were succesfully saved at :');
   disp(fn2);
end

end