%%  save
%   mat ::
save([output_basepath 'model/gp15W.mat'], 'gp15W'); 

%   excel ::
writetable(gp15W, [output_basepath 'model/gp15W.xlsx']); 