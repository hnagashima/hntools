function B = forcecell(A)
% convert input to cell array
% if A is not cell. (i.e. strings)
% B = forcecell(A);
% A: input (any variables)
% B: cell array including the input A.

if iscell(A) == 0
    B = {A};
else
    B = A;
end