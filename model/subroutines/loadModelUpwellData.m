%%  load data
%   upwelling ::
load([output_basepath 'interpData/gp15W'], 'gp15W'); 

%   station data ::
load([output_basepath 'readData/stations/gp15Stations.mat'], 'gp15Stations', 'NUMSTAT');

%%  end subroutine