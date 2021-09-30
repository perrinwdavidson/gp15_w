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

%%  compare 234 and 230 upwelling timescales
compareRadio; 

%%  print end
disp('Done modeling upwelling data.')

%%  end program