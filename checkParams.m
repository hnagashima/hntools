function checkParams(A,B,varargin)
%
% checkParams compare variables in A and B and display which variables do
% not match. It is useful for debugging if there is a correct program and
% an incorrect program.
%
% Usage:
%   checkParams(A, B)
%   checkParams(structA, structB)
%
% Inputs:
%   - A : Filename of .mat which includes the variables. This file can be
%       created by a "save" function by save('A.mat') at the end of program;
%   - B : Filename of .mat which includes the variables of another program.
%   - structA, structB : Structures with fields.
%
% There are no outputs. Results are shown in the command window.
%

% Internal HELP:
%   -varargin : name of the structure for reccuring call.



narginchk(2,4);
% A, B structure case:
if ~ (isstruct(A) && isstruct(B))
    if ~ (ischar(A) && ischar(B))
        error('Inputs are not filenames or structures.');
    else
        % A and B are the filenames of .mat files. They converted to the
        % structure files.
        A = load(A);
        B = load(B);
    end
    
end

% Parent is the name of parent structure.
if nargin == 2
    parent = ''; % Name of the parent.
    indent = '';
else
    parent = [varargin{1}, '.']; % Name of the parent.
    indent = [varargin{2}, '  ']; % add indent
end

% Read fieldname.;
fnA = fieldnames(A); fnB = fieldnames(B);
fn = unique([fnA;fnB]); % Reduce overlapping fieldnames.

% Compare data.
onlyA = zeros(1,numel(fn)); % Store the data.
onlyB = zeros(1,numel(fn)); % Initializing.

for k = 1:numel(fn)
    if isfield(A, fn{k}) && isfield(B,fn{k})
        if ~isequal(A.(fn{k}), B.(fn{k}))
            % Mismatch case.
            if isstruct(A.(fn{k})) && isstruct(B.(fn{k}))
                % Recurrent call.
                disp([indent parent, fn{k}, '---']);
                checkParams(A.(fn{k}),B.(fn{k}),[parent, fn{k}], indent);
            else
                disp([indent parent, fn{k}]);
            end
        end
    else
        % This field is only in A or B.
        if isfield(A, fn{k})
            onlyA(k) = k;
        else
            onlyB(k) = k;
        end
    end
end


% Display if the value is only in A or B.
onlyA(0 == (onlyA)) = []; % Remove empty fields.
onlyB(0 == (onlyB)) = []; % Remove empty fields.
if numel(onlyA) > 0
    disp([indent '--Not included in the 2nd input.--']);
    for k = 1:numel(onlyA)
        I = onlyA(k);
        disp(['  ' indent fn{I}]);
    end
end
if numel(onlyB) > 0
    disp([indent '--Not included in the 1st input.--']);
    for k = 1:numel(onlyB)
        I = onlyB(k);
        disp(['  ' indent fn{I}]);
    end
end
if numel(onlyA)> 0 || numel(onlyB) > 0
    disp([indent '----------------------------------']);
end


end





