%%  save
%   mat ::
save([output_basepath 'modelUpwell/gp15W.mat'], 'gp15W'); 

%   excel ::
writetable(gp15W, [output_basepath 'modelUpwell/gp15W.xlsx']); 