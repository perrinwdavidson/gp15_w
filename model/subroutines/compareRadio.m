%%  configure
close all

%%  load data
load('/Users/perrindavidson/Research/whoi/current/gp15/outputs/interpolateData/gp15_w.mat', 'gp15_w');

%   rename ::
gp15W_234 = gp15_w; 
gp15W_230 = gp15W; 

%%  get equatorial stationd data ::
%   get indices ::
idx230 = find(gp15W_230.Station == 27 | gp15W_230.Station == 29 | gp15W_230.Station == 31); 
idx234 = find(gp15W_234.stationNo == 27 | gp15W_234.stationNo == 29 | gp15W_234.stationNo == 31); 

%   get 230 data ::
wEq.stats230 = gp15W_230.Station(idx230); 
wEq.depth230 = gp15W_230.Depth(idx230); 
wEq.w230 = gp15W_230.w(idx230); 
wEq.wError230 = gp15W_230.wError(idx230); 

%   get 234 data ::
wEq.stats234 = gp15W_234.stationNo(idx234); 
wEq.depth234 = gp15W_234.depth(idx234); 
wEq.w234 = gp15W_234.velo(idx234); 
wEq.wError234 = gp15W_234.veloError(idx234); 

%%  plot
%   define stations ::
plotStats = [27, 29, 31]; 

%   define constants ::
SEC2DAY = 60 ^ 2 * 24; 

%   loop through each station and plot ::
%%% start tiledlayout ::
t = tiledlayout(1, length(plotStats)); 

%%% loop and plot ::
for iStat = plotStats
    
    %   get station data ::
    %%% 230 ::
    stat230z = wEq.depth230(wEq.stats230 == iStat); 
    stat230w = wEq.w230(wEq.stats230 == iStat); 
    stat230werr = wEq.wError230(wEq.stats230 == iStat); 
    
    %%% 234 ::
    stat234z = wEq.depth234(wEq.stats234 == iStat); 
    stat234w = wEq.w234(wEq.stats234 == iStat); 
    stat234werr = wEq.wError234(wEq.stats234 == iStat); 
    
    %   plot ::
    nexttile(); 
    hold on

    %%% 230 ::
    plot(stat230w .* SEC2DAY, stat230z, '-ok', ...
         'markerEdgeColor', 'k', ...
         'markerFaceColor', 'k', ...
         'lineWidth', 1, ...
         'markerSize', 5);
    scatter(stat230werr .* SEC2DAY, stat230z, 'o', ...
            'lineWidth', 1, ...
            'markerEdgeColor', 'k', ...
            'markerFaceColor', 'white');

    %%% 234 ::
    plot(stat234w, stat234z, '-or', ...
         'markerEdgeColor', 'r', ...
         'markerFaceColor', 'r', ...
         'lineWidth', 1, ...
         'markerSize', 5);
    scatter(stat234werr, stat234z, 'o', ...
            'lineWidth', 1, ...
            'markerEdgeColor', 'r', ...
            'markerFaceColor', 'white');
        
    hold off

    box on

    ylim([0  200])

    set(gca, 'yDir', 'reverse', 'tickLabelInterpreter', ...
        'latex', 'fontSize', 16, 'fontWeight', 'bold', ...
        'lineWidth', 1);
    
end

%   give labels ::
xlabel(t, '\textbf{Upwelling Velocity  (m d$^{-1}$)}', ...
       'interpreter', 'latex', 'fontSize', 20); 
ylabel(t, '\textbf{Depth (m)}', 'interpreter', 'latex', ...
       'fontSize', 20); 

%   make figure look good ::
set(gcf, 'units', 'inches', 'position', [2, 2, 15, 10], ...
    'paperUnits', 'inches', 'paperSize', [15, 10]);

exportgraphics(gcf, ...
               [output_basepath 'modelUpwell/wPlots/wComp.png'], ...
               'resolution', 300); 

%%  end subroutine