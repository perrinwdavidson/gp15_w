function gp15W = objmapvelo(gp15W, gp15Stations, NUMSTAT, plotting, output_basepath)

    %   set max depth ::
    maxDepth = 400; 
    
    %   set constants ::
    SEC2DAY = 60 * 60 * 24; 

    %   loop through all stations ::
    for iStat = 1 : 1 : NUMSTAT

        %   specify equitorial station ::
        statNo = gp15Stations(iStat);

        %   get data ::
        X = gp15W.Depth(gp15W.Station == statNo); 
        V = gp15W.w(gp15W.Station == statNo);

        %   set query grid ::
        Xq = X; 

        %   specify depth ::
        X = X(X <= maxDepth);
        V = V(X <= maxDepth);
        Xq = Xq(X <= maxDepth);

        %   get length of data ::
        n = length(X); 

        %   set max length scale ::
        lenScaleBound = 10;

        %%  objectively map data
        [Vhat, VhatVar, ~] = objectiveMapping(X, V, Xq, lenScaleBound);

        %%  make noise
        noise = V - Vhat; 

        %%  make final arrays
        %   get indices of where data is ::
        statIdx = find(gp15W.Station == statNo & gp15W.Depth <= maxDepth); 

        %   put data in ::
        gp15W.w(statIdx) = Vhat; 
        gp15W.wError(statIdx) = noise;
        %gp15_w.veloError(statIdx) = sqrt((noise .^ 2) + (VhatVar .^ 2)); 
        
        %   plotting arrays ::
        if strcmp(plotting, 'yes')

            figure; 

            hold on

            plot(V .* SEC2DAY, X, '-ok', ...
                 'markerEdgeColor', 'k', ...
                 'markerFaceColor', 'k', ...
                 'lineWidth', 1, ...
                 'markerSize', 5);
            plot(Vhat .* SEC2DAY, X, '--', 'color', 'k', 'lineWidth', 1);
            scatter(noise .* SEC2DAY, X, 'o', ...
                    'lineWidth', 1, ...
                    'markerEdgeColor', 'k', ...
                    'markerFaceColor', 'white');
             
            hold off

            box on

            xlabel('\textbf{Upwelling Velocity  (m d$^{-1}$)}', ...
                   'interpreter', 'latex', 'fontSize', 20); 
            ylabel('\textbf{Depth (m)}', 'interpreter', 'latex', ...
                   'fontSize', 20); 

            ylim([0  200])

            set(gca, 'yDir', 'reverse', 'tickLabelInterpreter', ...
                'latex', 'fontSize', 16, 'fontWeight', 'bold', ...
                'lineWidth', 1);

            set(gcf, 'units', 'inches', 'position', [2, 2, 5, 10], ...
                'paperUnits', 'inches', 'paperSize', [5, 10]);

            exportgraphics(gcf, ...
                           [output_basepath 'model/wPlots/w' num2str(statNo) '.png'], ...
                           'resolution', 300); 

        end

    end
    
end