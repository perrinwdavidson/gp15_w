%%  make query array
%   define constants ::
c = 299792458; 
km2m = 1000; 

%   make time array ::
%%% get bounds ::
tStart = min(gp15Coords.Date) - days(dTimeAve); 
tEnd   = max(gp15Coords.Date); 

%%% round to hours/mins 12:00 (noon) ::
tStart.Hour   = 12; 
tStart.Minute = 0; 
tStart.Second = 0;
tEnd.Hour     = 12; 
tEnd.Minute   = 0; 
tEnd.Second   = 0;

%%% make array ::
tQ      = tStart : 1 : tEnd; 
NUMTIME = length(tQ); 

%%% turn into meter units (c * t) ::
tQSec = c .* posixtime(tQ);

%   make spatial coordinate array ::
%%% get data ::
coords = gp15Coords(:, [4, 3, 5]); 
NUMSAMP = size(coords, 1); 

%%% make longitude [0, 360] ::
coords.Longitude(coords.Longitude < 0) = coords.Longitude(coords.Longitude < 0) + 360; 

%%% turn degrees into meters ::
coords.Longitude = deg2km(coords.Longitude) .* km2m; 
coords.Latitude = deg2km(coords.Latitude) .* km2m; 
coords = table2array(coords); 

%   make total query array ::
%%% get total array ::
for iTime = 1 : 1 : NUMTIME 
    
    %   get time ::
    t = tQSec(iTime); 
    
    %   put into array ::
    if iTime == 1
        
        x = [coords, repmat(t, NUMSAMP, 1)]; 
        
    else
        
        x = cat(1, x, [coords, repmat(t, NUMSAMP, 1)]); 
        
    end
    
end 

%%% make vectors ::
lonq = x(:, 1); 
latq = x(:, 2); 
dpthq = x(:, 3); 
timeq = x(:, 4); 

%%  make sample array
%   coordinates ::
[lon, lat, dpth, time] = ndgrid(deg2km(double(eccoWo.longitude)) .* km2m, ...
                                deg2km(double(eccoWo.latitude)) .* km2m, ...
                                double(eccoWo.depth), ...
                                c .* posixtime(eccoWo.time)); 

%   ordinates ::
w = fillmissing(eccoWo.wo, 'nearest');
                            
%%  interpolate
%   interpolate values ::
wInt = interpn(lon, lat, dpth, time, w, lonq, latq, dpthq, timeq, 'linear'); 

%   make array ::
gp15WInt = [x, wInt]; 

%%  time average
%   preallocate ::
wAve = NaN(NUMSAMP, 1);

%   loop ::
for iSamp = 1 : 1 : NUMSAMP
    
    %   get coords ::
    lonStat = coords(iSamp, 1); 
    latStat = coords(iSamp, 2); 
    depthStat = coords(iSamp, 3); 

    %   find time bounds ::
    %%% get ::
    tAveStart = gp15Coords.Date(iSamp) - days(dTimeAve); 
    tAveEnd = gp15Coords.Date(iSamp); 

    %%% round to hours/mins 12:00 (noon) ::
    tAveStart.Hour   = 12; 
    tAveStart.Minute = 0; 
    tAveStart.Second = 0;
    tAveEnd.Hour     = 12; 
    tAveEnd.Minute   = 0; 
    tAveEnd.Second   = 0;
    
    %%% convert to posix ::
    tAveStart = c * posixtime(tAveStart); 
    tAveEnd   = c * posixtime(tAveEnd); 
    
    %   find w at station ::
    wStat = gp15WInt(gp15WInt(:, 4) >= tAveStart ...
                     & gp15WInt(:, 4) <= tAveEnd ...
                     & gp15WInt(:, 1) == lonStat ... 
                     & gp15WInt(:, 2) == latStat ...
                     & gp15WInt(:, 3) == depthStat, 5); 
                 
    %   average ::
    wAve(iSamp) = mean(wStat, 'omitnan'); 

end

%   put into final table ::
gp15W = gp15Coords; 
gp15W.w = wAve; 

%%  save
save([output_basepath 'interpData/gp15W'], 'gp15W'); 

%%  end subroutine