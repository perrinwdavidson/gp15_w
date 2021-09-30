%% readData - read data from gp15 and ecco
%--------------------------------------------------------------------------
%% setup environment
setupDataPrep;

%% read data
readGp15;
readEcco;

%% print out 
disp('Done reading data.')

%% end routine