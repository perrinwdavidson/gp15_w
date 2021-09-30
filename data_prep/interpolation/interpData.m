%%  interpolateData - interpolating gp15 data
%--------------------------------------------------------------------------
%%  set-up environment 
setupDataPrep;

%%  configure
configureInterp;

%%  load data
loadInterpData;

%%  interpolate velocities
interpAdvecVelo;

%%  print end
disp('Done interpolating data.')

%%  end program