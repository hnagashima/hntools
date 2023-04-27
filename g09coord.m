function [P] = g09coord(filename)
% Import coordinates and parameters
% from single point calculation of gaussian 09.
% %
% - filename: File path of LOG file.
% - P : Parameters. Structure.
%   - P.X : Coordinates (X)
%   - P.Y : Coordinates (Y)
%   - P.Z : Coordinates (Z)
%   - P.R : Coordinates [X,Y,Z]
%   - P.SpinDensity : SpinDensities
%   - P.Atom : Atomic names.
%
% #########Example%#########
%




% C : data cell.
C = readcell(filename); % Read to cell. Each cell contains 1 word.

% Some files results cell including date-time data, not a text,
% This problem cause an error at strfind in the containind function.
non_char_ind = cellfun(@ischar, C);
for k = 1:numel(non_char_ind)
    if ~non_char_ind(k)
        C{k} = '';
    end
end

[LI1] = containind(C, 'Symbolic Z-matrix:');
[LI2_1] = containind(C, 'Standard basis:');
[LI2_2] = containind(C, 'Input orientation:');
temp = [LI2_1 ; LI2_2]; 
LI2 = min(temp);
% Imports Coordinates.
coord = C((LI1+2) : (LI2-1),1);
P(1:numel(coord)) = struct(...
    'X',0,'Y',0,'Z',0,'R',[0 0 0],'SpinDensity',0,'Atom','');
for k = 1:numel(coord)
    data0 = textscan(coord{k},'%s %f %f %f');
    P(k).X = data0{2}; P(k).Y = data0{3}; P(k).Z = data0{4};
    P(k).R = [data0{2}, data0{3}, data0{4}];
    P(k).Atom = data0{1};
end

[LI1] = containind(C, 'Mulliken charges and spin densities:');
[LI2] = containind(C, 'Sum of Mulliken charges =');

% Imports Spin density.
dens = C((LI1(end)+2) : (LI2(end)-1),1);
for k = 1:numel(dens)
    data1 = textscan(dens{k},'%d %s %f %f');
    P(k).SpinDensity = data1{4};
end







end

% Ordering by atoms. 1H. Prefer 14N and 1H, then put C, and others.

%%







% #########################################################################
% Sub functions

function [LI,CI, ind] = containind(cellArray, pattern)
% This function searches a pattern in cell array and return the index which
% is contataining the pattern
% LI : Line index 
% CI : Column index
% ind : index
I1 = cellfun(@(cells) strfind(cells, pattern), cellArray,'UniformOutput', false);
I2 = cellfun(@isempty, I1,'UniformOutput',true);
ind = find(I2 == 0); % Line of Isotropic Fermi Constant Couplings.
[LI, CI ] = ind2sub(size(cellArray),ind); % Line number and column number
end


function MHz = au2Mhz(au)
% This function converts a.u.(dipole coupling) to MHz.  
MHz = au * -72.356223664730678;
end