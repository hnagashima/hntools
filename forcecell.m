function B = forcecell(A)
% convert input to cell array
% if A is not cell. (i.e. strings)
if iscell(A) == 0
    B = {A};
else
    B = A;
end