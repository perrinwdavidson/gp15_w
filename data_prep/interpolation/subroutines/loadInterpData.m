%% load data
%   gp15 coordinates ::
load([output_basepath 'readData/gp15/gp15Coords.mat'], 'gp15Coords');

%  velocity data ::
load([output_basepath 'readData/ecco/eccoWo.mat'], 'eccoWo');

%   station data:
load([output_basepath 'readData/stations/gp15Stations.mat'], 'gp15Stations', 'NUMSTAT');

%%  end subroutine