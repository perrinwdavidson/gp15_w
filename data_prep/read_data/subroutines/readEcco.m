%%  read ecco upwelling data
%   do you want to download data ::
downloadData = 'yes'; 

%   do you want to save the data ::
saveData = 'yes';

%   define averaging range ::
%%% sample time ::
sampleYear = 2018; 

%%% number of years to average ::
yearAve = 2; 

%%% starting year to average ::
startYear = sampleYear - yearAve; 

%%% set starting and ending quarters for each year ::
qStart = 3; 
qEnd   = 4; 

%   set-up urls ::
%%% base urls ::
baseUrl = 'https://ecco.jpl.nasa.gov/drive/files/NearRealTime/Smoother/dr080i_'; 
inputPath = [input_basepath 'ecco/']; 

%%% quarter urls ::
qUrl = {'/n10day_01_09/Wave_08_08.00001_02160_240.cdf'; ...
        '/n10day_10_18/Wave_08_08.02160_04320_240.cdf'; ...
        '/n10day_19_27/Wave_08_08.04320_06480_240.cdf'; ...
        '/n10day_28_37/Wave_08_08.06480_08880_240.cdf'}; 
        
%   download appropriate data ::
%%% cd into the correct folder ::
cd(inputPath); 

%%% set counter ::
iCount = 1; 

%%% loop through all years ::
for iYear = 0 : 1 : yearAve
    
    %   get quarter arrays ::
    if iYear == 0
        
        qAve = qStart : 1 : 4; 
        
    elseif iYear == yearAve
        
        qAve = 1 : 1 : qEnd; 
        
    else
        
        qAve = 1 : 1 : 4; 
        
    end
    
    %   make directory ::
    mkdir(num2str(startYear + iYear)); 
    
    %   add to path ::
    addpath(num2str(startYear + iYear)); 
    
    %   cd into directory ::
    cd(num2str(startYear + iYear)); 
    
    %   loop through all quarters ::
    for iQ = qAve
        
        if strcmp(downloadData, 'yes')
            
            %%% get url ::
            url  = [baseUrl num2str(startYear + iYear) qUrl{iQ}];

            %%% make command ::
            command = ['wget --user=perrinwdavidson --password=Y95uMfxbXfaGaJxc0K9 -r -nc -np -nH --cut-dirs=6 ' url];

            %%% download ::
            status = system(command); 
        
        end
        
        %   get new data ::
        if iCount == 1
            
            eccoWo.wo        = ncread(qUrl{iQ}(15 : end), 'Wave'); 
            eccoWo.longitude = ncread(qUrl{iQ}(15 : end), 'lon');
            eccoWo.latitude  = ncread(qUrl{iQ}(15 : end), 'lat'); 
            eccoWo.depth     = ncread(qUrl{iQ}(15 : end), 'depth'); 
            eccoWo.time      = ncread(qUrl{iQ}(15 : end), 'time'); 
            
        else
            
            eccoWo.wo   = cat(4, eccoWo.wo, ncread(qUrl{iQ}(15 : end), 'Wave')); 
            eccoWo.time = cat(1, eccoWo.time, ncread(qUrl{iQ}(15 : end), 'time')); 
            
        end
        
        %   loop to next quarter ::
        iCount = iCount + 1; 

    end
    
    %   cd out of directory ::
    cd('..');
    
end

%   quality control data ::
%%% remove blanks ::
eccoWo.wo(eccoWo.wo == -1.000000000000000e+10) = NaN;

%%% convert to datetime array ::
eccoWo.time = eccoWo.time .* (60 ^ 2);
eccoWo.time = datetime(eccoWo.time, 'convertFrom', 'posixtime');

%%% non-responsive fixing of december times ::
eccoWo.time(17 : 1 : 19) = [datetime(2016, 12, 11), ...
                            datetime(2016, 12, 21), ...
                            datetime(2016, 12, 31)];

%   cd into proper directory ::
if strcmp(saveData, 'yes')
    
    cd('/Users/perrindavidson/Research/whoi/current/gp15_w/code/gp15_w/data_prep/');
    
end

%%  save
save('-v7.3', [output_basepath 'readData/ecco/eccoWo'], 'eccoWo');

%% end subroutine