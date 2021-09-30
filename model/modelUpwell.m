%%  modelUpwell - estimating upwelling across the pmt
%--------------------------------------------------------------------------
%%  set-up environment 
setupModelUpwell;

%%  load data
loadModelUpwellData;

%%  objectively map upwelling
objMapVelo;

%%  save
saveVelo; 

%%  print end
disp('Done modeling upwelling data.')

%%  end program