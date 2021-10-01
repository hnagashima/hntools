function [g,MagP] = g09Spin(filename)
% Import magnetic parameters from Log file of single point
% calculation  of gaussian 09 with nmr option.
% %
% - filename: File path of LOG file.
% - g : g-tensor
% - MagP : Magnetic parameters for each atom. Structure.
%   - MagP.Atom : Atom Names. '1H','14N',etc...
%   - MagP.Aiso : Isotropic hyperfine coupling (MHz)
%   - MagP.Adip : Dipoler hyperfine coupling tensor (MHz)
%
% #########Example%#########
% % 
% filename = 'AQDSRADICAL_SP.LOG';
% [g,MagP] = g09Spin('AQDSRADICAL_SP.LOG');
% Sys = struct; % Initialize Sys structure
% for k = 1:numel(MagP)
%     Nucs = MagP(k).Atom;
%     if strcmp(Nucs, '1H') % Only includes proton in the spectra.
%         A = MagP(k).Adip + MagP(k).Aiso * eye(3);
%         Sys = nucspinadd(Sys, Nucs, A);
%     end
% end
% 
% 
% Sys.g = g;
% Sys.lw = 0.01;
% Exp.Harmonic = 1;
% Exp.mwFreq = 9.5;
% Exp.Range = [337 340];
% 
% pepper(Sys,Exp) % Run pepper.




% C : data cell.
C = readcell(filename); % Read to cell. Each cell contains 1 word.
[LI1] = containind(C,'Isotropic Fermi Contact Couplings');
[LI2] = containind(C, 'Center         ----  Spin Dipole Couplings  ----');
[LIg] = containind(C, 'g tensor [g = g_e + g_RMC + g_DC + g_OZ/SOC]:');
nAtoms = length((LI1+2) : (LI2-2)); % Number of atoms
MagP(nAtoms) = struct; % Final magnetic parameter

% Imports Fermi constant.
FermiConst = C((LI1+2) : (LI2-2),1);
for k = 1:numel(FermiConst)
    data0 = textscan(FermiConst{k},'%d %s %f %f %f %f');
    
    % Import atom name for easyspin
    tmp = erase(data0{2},{')','('});
    [startI, endI] = regexp(tmp{1}, '\d*');
    Number = tmp{1}(startI:endI);
    AtomChar = tmp{1}(1:(startI-1));
    MagP(k).Atom = [Number AtomChar];
    
    
    
    MagP(k).Aiso = data0{3};
end


% Imports Dipole coupling Tensor (3x3 matrix)
SpinDipoleCouplings1 = C ( (LI2+2) + (1:nAtoms),1 ) ;
SpinDipoleCouplings2 = C ( (LI2 + 2 + nAtoms + 3) + (1:nAtoms), 1);
for k = 1:numel(SpinDipoleCouplings1)
    data1 = textscan(SpinDipoleCouplings1{k},'%d %s %f %f %f'); % 3XX, 3YY, 3ZZ
    data2 = textscan(SpinDipoleCouplings2{k},'%d %s %f %f %f'); % XY XZ YZ
    Adip_au = [data1{3} data2{3} data2{4};
               data2{3} data1{4} data2{5};
               data2{4} data2{5} data1{5}];
    MagP(k).Adip = au2Mhz(Adip_au);
end




% Imports g-value
tmp =  C ( (LIg+(1:3)),1 );
tmp = erase(tmp, {'X','Y','Z','='});
tmp = strrep(tmp,'D','e');
for k = 1:numel(tmp)
    tmp2(k,:) = textscan(tmp{k},'%f %f %f');
end
g = cell2mat(tmp2);



end

% Ordering by atoms. 1H. Prefer 14N and 1H, then put C, and others.

%%







% #########################################################################
% Sub functions

function [LI,CI, ind] = containind(cellArray, pattern)
% This function searches a pattern in cell array and return the index which is
% contataining the pattern
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