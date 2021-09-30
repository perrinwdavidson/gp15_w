%%  setup environment
cd /Users/perrindavidson/Research/whoi/current/gp15_w/code/gp15_w/model/
clear 
close all
warning('off')

%%  set in and out paths
input_basepath = '/Users/perrindavidson/Research/whoi/current/gp15_w/inputs/';
output_basepath = '/Users/perrindavidson/Research/whoi/current/gp15_w/outputs/';

%%  add in toolboxes
addpath /Users/perrindavidson/Documents/MATLAB/toolboxes/interpolation/kriging/kriging1d/
addpath /Users/perrindavidson/Documents/MATLAB/toolboxes/interpolation/objectivemap
addpath /Users/perrindavidson/Documents/MATLAB/toolboxes/interpolation/objectivemap/subroutines/

%%  end subroutine