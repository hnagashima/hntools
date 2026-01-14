function cmenu(varargin)
% CMENU  Add a custom menu to MATLAB figure windows
%
% 【目的】
%   研究でよく使う処理（図の保存・スケーリング・依存関係チェックなど）を
%   Figure のメニューバーに自動で追加するための関数。
%   EzyFit などの外部ツールも統合して、解析用 Figure の操作を便利にする。
%
% 【使い方】
%   cmenu              % カレント Figure に Custom メニューを追加
%   cmenu on           % 同上（明示的に on）
%   cmenu off          % カレント Figure から Custom メニューを削除
%   cmenu default      % 全ての Figure 作成時に自動で cmenu を追加（古い方式）
%   cmenu enable       % 上と同じ（alias）
%   cmenu disable      % 自動追加をやめるf=gcf
%   cmenu(src,event)   % Figure 作成時コールバックから呼ばれる形式
%
% 【互換性】
%   R2014b - R2025 で動作するようにバージョン分岐を入れている。
%   - R2018 未満  : uimenu は 'Label' プロパティを使用
%   - R2018 以降 : uimenu は 'Text' プロパティを使用
%   - R2023 未満 : set(0,'defaultFigureCreateFcn',@cmenu) を使用
%   - R2023 以降 : groot (root graphics object) にリスナーを仕込む
%   - R2025 以降 : MenuBar プロパティが 'on' / 'off' で管理される
%
% 【設計方針】
%   - まず既存の Custom/EzyFit メニューを削除してから新規作成
%   - 個別の機能はサブルーチンや別ファイル (save2pdf_menu, FigureScale, label.addLabelMenu, efmenu) に分離
%   - 呼び出し元プログラムの依存関係を簡単に確認できるように "Calling Programs" メニューを用意
%   - defaultFigureCreateFcn を壊さないように一時保存＆復元
%

%% ---- Input Parse ----
switch nargin
    case 0
        % cmenu を引数なしで呼ぶと現在の Figure に Custom メニューを追加
        src = gcf; event = []; option = 'on';
    case 1
        opt = varargin{1};
        switch lower(opt)
            case {'default','enable'}
                % 以降の Figure 作成時に自動的に cmenu を適用
                if versionYear < 2023
                    % 古い方式: root の defaultFigureCreateFcn を上書き
                    set(0,'defaultFigureCreateFcn',@cmenu);
                else
                    % 新しい方式: groot にリスナーを追加
                    addlistener(groot,'ObjectChildAdded', ...
                        @(src,event) cmenu('on',event.Child));
                end
                disp('Default menu has set to cmenu');
                return;
            case 'disable'
                % 自動追加を解除
                if versionYear < 2023
                    set(0,'defaultFigureCreateFcn',[]);
                else
                    delete(findall(groot,'Type','listener')); % 全リスナー削除（注意）
                end
                disp('Cmenu removed from default');
                return;
            otherwise
                % cmenu('on') / cmenu('off') の場合
                src = gcf; event = []; option = opt;
        end
    case 2
        % Figure の CreateFcn から呼ばれるときの形式
        src = varargin{1}; event = varargin{2}; option = 'on';
    otherwise
        src = varargin{1}; event = varargin{2}; option = 'on';
end

if ~ismember(option,{'on','off'})
    error('Option must be ''on'' or ''off''.');
end

fig = src;
if ~isgraphics(fig,'figure'), return; end

%% ---- MenuBar 判定 ----
if versionYear < 2025
    % 古い環境では 'MenuBar' が 'figure'
    if ~strcmp(fig.MenuBar,'figure'), return; end
else
    % 新しい環境では 'on' / 'off'
    if ~strcmp(fig.MenuBar,'on'), return; end
end

%% ---- Clear Old Menus ----
% すでに存在する Custom/EzyFit メニューを削除してから再作成
delete(findobj(fig,'Label','Custom')); % R2018以前
delete(findobj(fig,'Label','EzyFit'));
delete(findobj(fig,'Text','Custom'));  % R2018以降
delete(findobj(fig,'Text','EzyFit'));

if strcmp(option,'off'), return; end

%% ---- Create Main Menu ----
if versionYear < 2018
    mh = uimenu(fig,'Label','Custom');
else
    mh = uimenu(fig,'Text','Custom');
end
mh.HandleVisibility = 'on'; % ユーザーに消されにくくする設定

%% ---- Submenus ----

% --- Save2PDF 機能 ---
%  Figure を PDF に保存するメニューを追加
save2pdf_menu(src,event,mh);

% --- Figure Scale 機能 ---
%  あらかじめ定義したスケール（拡大率など）を Figure に適用
eh3 = uimenu(mh,'Text','FigureScale');
lists = FigureScale;
for k = 1:size(lists,1)
    if versionYear < 2018
        eh = uimenu(eh3,'Label',lists{k,1});
    else
        eh = uimenu(eh3,'Text',lists{k,1});
    end
    eh.Callback = @(src,evt) FigureScale(mh.Parent,src.Text);
end

% --- Label 機能 ---
%  グラフに注釈を追加するラベル機能（外部 label.m が必要）
label.addLabelMenu(src,event,mh);

% --- Dependency Checker ---
%  呼び出し履歴から依存ファイルをリスト化し、クリップボードやファイルに保存
st = flipud(dbstack('-completenames'));
eh5 = uimenu(mh,'Text','Calling Programs');
for k = 1:numel(st)
    [~,fname] = fileparts(st(k).file);
    if ~strcmp(fname,'cmenu')
        uimenu(eh5,'Text',fname, ...
            'MenuSelectedFcn',@(a,b) dependfigure_cmenu(st(k).file,[]));
    end
end

% --- Ezyfit メニュー ---
%  EzyFit ツールボックスの機能を追加
memo = get(0,'defaultFigureCreateFcn');
efmenu;
set(0,'defaultFigureCreateFcn',memo); % 元に戻す

end % cmenu main


%% ---- Utility: version year ----
function y = versionYear
% MATLAB リリース文字列 (例: '2025a') から西暦を取得
V = version('-release'); 
y = str2double(V(1:4));
end