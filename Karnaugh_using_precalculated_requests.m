% Karnaugh-map Embedding

%% Define Parameters
show_plot = false;
show_steps = false;

% Iterations
iterations = 500;
filename = 'vnr.txt';
linenumber = 1;

% Substrate resources  
DF = 20;
DT = 20;
Karnaugh_Substrate = zeros(DF,DT);
Embedding_Time = zeros(DF,DT);

% Maximum wating time
waiting_time_1 = 3;
waiting_time_2 = 3;
waiting_time_3 = 3;

% Performance metrics
rejected_vns = 0;
total_vns =0;


%% Initialize main loop

VN_Requests = [];
Reject_rate = [];
occupied_area = [];

fileID = fopen(filename);
text = textscan(fileID, '%s', 6, 'delimiter', '|');
Requests = textscan(fileID, '%d %d %d %d %d %d', 'CollectOutput', 1);
fclose(fileID);

number_of_Requests = size(Requests{1}, 1);

Start = tic;
for time_window = 1:iterations
    %% Read in virtual network requests

    linestart = linenumber;
    while((Requests{1}(linenumber, 3) == time_window)&&(linenumber~=number_of_Requests))
        linenumber = linenumber +1;
    end
    
    VN_Requests = [VN_Requests;Requests{1}(linestart:linenumber-1, :)];
     % Set up the queue 
    VN_Requests(:,2) = -VN_Requests(:,2);
    
    VN_Requests = sortrows(VN_Requests);
    VN_Requests(:,2) = -VN_Requests(:,2);
    
    total_vns = size(VN_Requests, 1);
    
    %% Update time remaining for embedded networks
    
    for i = 1:DF
        for j =1:DT
            if(Embedding_Time(i, j) <2)
                Embedding_Time(i, j) = 0;
                Karnaugh_Substrate(i, j) = 0;
            else
                Embedding_Time(i, j) = Embedding_Time(i, j) - 1;
            end
        end
    end
    
    %% Embedding algorithm
    indeces = 0;
    
    if(time_window > 1)
        % Show the current embedding
        if(show_steps)
            
           % Scale the colormap to be logarithmic
            cmap = summer(80);
            cmap = flipud(cmap);

            newX = logspace(0, log10(80), 80);
            logMap = interp1(1:80, cmap, newX);

            cmap = [1 1 1; flipud(logMap)];

            figure(1); title('Step through');
            imagesc(kron(Embedding_Time, ones(100/DF, 100/DT)));
            caxis([0 80]);
            colormap(cmap);
            colorbar('SouthOutside');
            pause;
        end
    end
    
    for VN_Requests_index = 1:size(VN_Requests, 1)
        
        
        % Find Karnaugh Regions
        minSize=[VN_Requests(VN_Requests_index, 5), VN_Requests(VN_Requests_index, 6)];
        
        
        % Compare Karnaugh map algorithms
        K = FindKarnaughRegions(Karnaugh_Substrate, minSize);
        
        if(~isempty(K))
            K = sortrows(K, 5);
            K_Corners = [K(1, 1) K(1, 2); K(1, 1) (K(1, 2)+K(1, 4));
                       (K(1, 1)+K(1, 3)) K(1, 2); (K(1, 1)+K(1, 3)) (K(1, 2)+K(1, 4));];
             
            % Test the four possible corners as embedding locations 
            Embedding_Locations(1, :) = [K_Corners(1,1) , (K_Corners(1,1) + VN_Requests(VN_Requests_index,5) - 1) , K_Corners(1, 2) , (K_Corners(1, 2) + VN_Requests(VN_Requests_index, 6)-1)];
            Embedding_Locations(2, :) = [K_Corners(2,1) , (K_Corners(2,1) + VN_Requests(VN_Requests_index,5) - 1) , (K_Corners(2, 2) - VN_Requests(VN_Requests_index, 6)+1) , K_Corners(2, 2)];
            Embedding_Locations(3, :) = [(K_Corners(3,1) - VN_Requests(VN_Requests_index,5) + 1) , K_Corners(3,1) , K_Corners(3, 2) , (K_Corners(1, 2) + VN_Requests(VN_Requests_index, 6)-1)];
            Embedding_Locations(4, :) = [(K_Corners(4,1) - VN_Requests(VN_Requests_index,5) + 1) , K_Corners(4,1) , (K_Corners(4, 2) - VN_Requests(VN_Requests_index, 6)+1) , K_Corners(4, 2)];
            
            Embedding_Density_Cost = [];
            
            % Find the EDI for each corner
            for i = 1:4
                Test_Embedding = Karnaugh_Substrate;
                Test_Embedding(Embedding_Locations(i, 1):Embedding_Locations(i, 2), Embedding_Locations(i, 3):Embedding_Locations(i, 4)) = 1;
                Embedding_Density_Cost(i, 1) = EDI(Test_Embedding);
                Embedding_Density_Cost(i, 2) = i;
            end
            
            % Place the virtual network at the corner with the lowest EDI
            
            Embedding_Density_Cost = sort(Embedding_Density_Cost, 1);
            Chosen_Corner = Embedding_Density_Cost(1, 2);  
            Karnaugh_Substrate(Embedding_Locations(Chosen_Corner, 1):Embedding_Locations(Chosen_Corner, 2), Embedding_Locations(Chosen_Corner, 3):Embedding_Locations(Chosen_Corner, 4)) = 1;     
            
            % Update the embedding time (time left for VN to be embedded)
            Embedding_Time(Embedding_Locations(Chosen_Corner, 1):Embedding_Locations(Chosen_Corner, 2), Embedding_Locations(Chosen_Corner, 3):Embedding_Locations(Chosen_Corner, 4)) = VN_Requests(VN_Requests_index,4);
            
            % Add embedded request to list of requests to remove
            indeces = [indeces, VN_Requests_index];
            
            % Show the embedding for each request
           if(show_steps)
        
                % Scale the colormap to be logarithmic
                cmap = summer(80);
                cmap = flipud(cmap);

                newX = logspace(0, log10(80), 80);
                logMap = interp1(1:80, cmap, newX);

                cmap = [1 1 1; flipud(logMap)];

                figure(1); title('Step through'); 
                imagesc(kron(Embedding_Time, ones(100/DF, 100/DT)));
                caxis([0 80]);
                colormap(cmap);
                colorbar('SouthOutside');
                pause;
           end
        end 
    end
    
    %% Plot Substrate
    
    if(show_plot)
        
        % Scale the colormap to be logarithmic
        max_time = max(Embedding_Time(:));
        cmap = summer(80);
        cmap = flipud(cmap);

        newX = logspace(0, log10(80), 80);
        logMap = interp1(1:80, cmap, newX);

        cmap = [1 1 1; flipud(logMap)];

        % Normalize the time values
        E= round(Embedding_Time .*80/max_time);
        figure(1); title('Embedding Time'); 
        imagesc(kron(E, ones(100/DF, 100/DT)));
        colormap(cmap);
        colorbar('SouthOutside');
        pause;
    end
    
    %% Remove VN requests that are too old
    
    int = size(VN_Requests, 1);
    for index = 1:int
        if ((VN_Requests(index, 1) == 1) &&( time_window - VN_Requests(index, 3)) == waiting_time_1)
            indeces = [indeces, index];
            rejected_vns = rejected_vns + 1;
        elseif ((VN_Requests(index, 1) == 2) &&( time_window - VN_Requests(index, 3)) == waiting_time_2)
            indeces = [indeces, index];
            rejected_vns = rejected_vns + 1;
        elseif ((VN_Requests(index, 1) == 3) &&( time_window - VN_Requests(index, 3)) == waiting_time_3)
            indeces = [indeces, index];
            rejected_vns = rejected_vns + 1;
        end
    end
    
    VN_Requests=VN_Requests(setdiff(1:end, indeces), :);
    Reject_rate = [Reject_rate (rejected_vns/total_vns)];
    rejected_vns = 0;
    
    occupied = 0;
    for i = 1:DF
        for j = 1:DT
            if(Karnaugh_Substrate(i, j) == 1)
               occupied = occupied +1;
            end
        end
    end
             
    occupied_area(time_window) = occupied/(DF*DT);
    
    % End main loop
    
end
toc(Start)

%% Performance

figure(1); title('Performance'); 

subplot(2,2,1); % plot the resource utility
title('Resource Usage');
xlabel('Time');
ylabel('Resource usage');
title('Resource Usage')
axis([0 500 0 1]);
plot(smooth(occupied_area, 3));
subplot(2,2,2); % plot the reject rate
title('Reject rate');
xlabel('Time');
ylabel('Reject rate');
plot(smooth(Reject_rate, 51));
xlabel('Time');
ylabel('Reject rate');
Average_Resource_usage = sum(occupied_area)/iterations
Average_Reject_rate = sum(Reject_rate)/iterations



    