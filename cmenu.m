function cmenu(varargin)
% Add custom menu to the figure menubar.
% cmenu         % adds cmenu to the figure.
% cmenu on      % adds cmenu to the figure.
% cmenu off     % removes cmenu
% cmenu default % set cmenu as a default figure create function.
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
            return;
        end
        src = gcf;
        event = [];
        option = varargin{1};
    case 2
        src = varargin{1};
        event = varargin{2};
        option = 'on';
end

% option must be on or off.

if ~ismember(option,{'on','off'}) 
        error('Option is ''on'' or ''off'' ');
end


fig = src; % F = figure; gcf
% Check if figure is numberless ( = appdesigner or some GUI apps)
if isempty(fig.Number)
    return;
end
if strcmp(fig.MenuBar,'figure') == 0
    return;
end



%% menuèàóù

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

% add save2pdf menu
save2pdf_menu(src, event, mh);

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


% add label menu
label.addLabelMenu(src,event, mh);

% add Ezyfit Function
memo_dFigCreateFcn = get(0,'defaultFigureCreateFcn'); % remember default figure create fcn.
efmenu;
set(0,'defaultFigureCreateFcn',memo_dFigCreateFcn);% Restore default figure create fcn.

% remove this function from current Figure.
fig.CreateFcn = [];



% ó·
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