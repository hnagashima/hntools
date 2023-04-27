function createFigureOutsideIDE(varargin)
% figureがMATLAB のIDEとできるだけ重ならない位置に出るようにします。
%   createFigureOutsideIDE(src,event)
%

% src = varargin{1};
% event = varargin{2};

% MATLABのデスクトップオブジェクトを取得
desktop = com.mathworks.mde.desk.MLDesktop.getInstance;

% MATLABのIDEウィンドウのJavaフレームオブジェクトを取得
mainFrame = desktop.getMainFrame;

% Javaフレームオブジェクトのスクリーン上の位置を取得
ide_position = mainFrame.getLocationOnScreen;


% MATLABのスクリーンの位置とサイズを取得
root = groot;
monitors = root.MonitorPositions;

% 新しいfigureウィンドウを作成
hFig = gcf;

% 新しいfigureウィンドウの位置とサイズを設定
fig_position = get(hFig,'Position');
fig_position([1,2]) = [ide_position.getX+mainFrame.getWidth+10, ide_position.getY+10];
set(hFig, 'Position', fig_position);



% 上記のコードでは、com.mathworks.mde.desk.MLDesktop.getInstanceを使用してMATLABのデスクトップオブジェクトを取得し、
% desktop.getMainFrameを使用してMATLABのIDEウィンドウのJavaフレームオブジェクトを取得します。
% mainFrame.getLocationOnScreenを使用して、Javaフレームオブジェクトのスクリーン上の位置を取得し、groot.MonitorPositionsを使用してMATLABのスクリーンの位置とサイズを取得します。
% 次に、figureコマンドを使用して新しいfigureウィンドウを作成します。
% そして、setコマンドを使用して、新しいfigureウィンドウの位置とサイズを手動で設定し、MATLABのIDEウィンドウに重ならないように調整します。
% 最後に、必要に応じて、新しいfigureウィンドウの背景色などの設定を行います。
% このコードを実行することで、MATLABのIDEウィンドウに重ならないように、新しいfigureウィンドウを作成することができます。