%%  read gp15 data
%   coordinates ::
fileName = [input_basepath 'gp15/gp15_coordinates.xlsx'];
gp15Coords = readtable(fileName, 'variableNamingRule', 'preserve');

%%  make stations arrays
%   make array ::
stations = unique(gp15Coords.Station, 'rows');

%   number of stations ::
NUMSTAT = size(stations, 1);

%%  save 
%   coords ::
save([output_basepath 'readData/gp15/gp15Coords.mat'], 'gp15Coords');

%   stations ::
%%% give new variables ::
gp15Stations = stations;
clear stations

%%% save ::
save([output_basepath 'readData/stations/gp15Stations.mat'], 'gp15Stations', 'NUMSTAT');

%% end subroutine