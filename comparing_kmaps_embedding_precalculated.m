% Karnaugh-map Embedding

%% Define Parameters

clear all;

% Iterations
iterations = 1000;
filename = 'vnr.txt';
linenumber = 1;

% Substrate resources
number_of_VMOs = 3;
DF = 12;
DT = 12;

% Maximum wating time
waiting_time_1 = 1;
waiting_time_2 = 2;
waiting_time_3 = 3;

%Include optimal
include_optimal = false;

% Performance metrics
rejected_vns = 0;
total_requests_1 = zeros(iterations, number_of_VMOs);
total_requests_2 = zeros(iterations, number_of_VMOs);
total_requests_3 = zeros(iterations, number_of_VMOs);
occupied_area = zeros(iterations, 3);
every_x_point = 5;
alpha = 0.5;
beta = 0.3;
gamma = 0.2;
limit = 1;
num_priorities = 3;

%% Initialize main loop

K_rejected_1 = zeros(iterations, number_of_VMOs);
K_rejected_2 = zeros(iterations, number_of_VMOs);
K_rejected_3 = zeros(iterations, number_of_VMOs);
KE_rejected_1 = zeros(iterations, number_of_VMOs);
KE_rejected_2 = zeros(iterations, number_of_VMOs);
KE_rejected_3 = zeros(iterations, number_of_VMOs);
S_O_rejected_1 = zeros(iterations, number_of_VMOs);
S_O_rejected_2 = zeros(iterations, number_of_VMOs);
S_O_rejected_3 = zeros(iterations, number_of_VMOs);
D_rejected_1 = zeros(iterations, number_of_VMOs);
D_rejected_2 = zeros(iterations, number_of_VMOs);
D_rejected_3 = zeros(iterations, number_of_VMOs);
D_O_rejected_1 = zeros(iterations, number_of_VMOs);
D_O_rejected_2 = zeros(iterations, number_of_VMOs);
D_O_rejected_3 = zeros(iterations, number_of_VMOs);
DE_rejected_1 = zeros(iterations, number_of_VMOs);
DE_rejected_2 = zeros(iterations, number_of_VMOs);
DE_rejected_3 = zeros(iterations, number_of_VMOs);
K_revenue = zeros(iterations+100, 1);
KE_revenue = zeros(iterations+100, 1);
S_O_revenue = zeros(iterations+100, 1);
D_revenue = zeros(iterations+100, 1);
DE_revenue = zeros(iterations+100, 1);
D_O_revenue = zeros(iterations+100, 1);

K_substrate = zeros(DF,DT);
KE_substrate = zeros(DF,DT);
S_O_substrate = zeros(DF,DT);

K_requests = [];
KE_requests = [];
S_O_requests = [];
D_requests = [];
DE_requests = [];
D_O_requests = [];
existing_K_networks = [];
existing_KE_networks = [];
existing_S_O_networks = [];
existing_D_networks = [];
existing_DE_networks = [];
existing_D_O_networks = [];
K_occupied_area = zeros(iterations, 1);
KE_occupied_area = zeros(iterations, 1);
S_O_occupied_area = zeros(iterations, 1);
D_occupied_area = zeros(iterations, 1);
DE_occupied_area = zeros(iterations, 1);
D_O_occupied_area = zeros(iterations, 1);

G_rejected_1 = zeros(iterations, number_of_VMOs);
G_rejected_2 = zeros(iterations, number_of_VMOs);
G_rejected_3 = zeros(iterations, number_of_VMOs);
G_revenue = zeros(iterations+100, 1);
G_requests = [];
G_existing_networks = [];
G_occupied_area = zeros(iterations, 1);
G_previous_combinations = [];
previous_permutation = [];


fileID = fopen(filename);
text = textscan(fileID, '%s', 8, 'delimiter', '|');
Requests = textscan(fileID, '%d %d %d %d %d %d %d %d', 'CollectOutput', 1);
% Priority Area Timeslot Duration Frequency Time ID Operator
% Requests = csvread(filename);
fclose(fileID);

number_of_Requests = size(Requests{1}, 1);
% number_of_Requests = size(Requests(:, 1));

Start = tic;

progressbar(0);

for timeslot = 1:iterations
    %% Read in virtual network requests

    linestart = linenumber;
    while((Requests{1}(linenumber, 3) == timeslot)&&(linenumber~=number_of_Requests))
        linenumber = linenumber +1;
    end
    new_requests = double([Requests{1}(linestart:linenumber-1, :)]);

%     linestart = linenumber;
%     while((Requests(linenumber, 3) == timeslot)&&(linenumber~=number_of_Requests(1, 1)))
%         linenumber = linenumber +1;
%     end    
%     new_requests = [Requests(linestart:linenumber-1, :)];

    
    if(timeslot <=iterations)
        for i=1:size(new_requests)
            operator = new_requests(i, 8);
            if(new_requests(i, 1)==1)
                total_requests_1(timeslot, operator) = total_requests_1(timeslot, operator) + new_requests(i, 2)*new_requests(i, 4);
            elseif(new_requests(i, 1)==2)
                total_requests_2(timeslot, operator) = total_requests_2(timeslot, operator) + new_requests(i, 2)*new_requests(i, 4);
            elseif(new_requests(i, 1)==3)
                total_requests_3(timeslot, operator) = total_requests_3(timeslot, operator) + new_requests(i, 2)*new_requests(i, 4);
            end
            

        end
    end
    
    
    
    %% K-maps Embedding algorithm
    
    indices = 0;
    
    for k = 1:size(existing_K_networks, 1)
        if(existing_K_networks(k, 4) == 1)
            indices = [indices, k];
        else
            existing_K_networks(k, 4) = existing_K_networks(k, 4) - 1;
        end
    end
                
    existing_K_networks = existing_K_networks(setdiff(1:size(existing_K_networks, 1), indices), :);
            
    for i = 1:DF
            for j =1:DT
                update = true;
                for k = 1:size(existing_K_networks, 1)
                    if(existing_K_networks(k, 7) == K_substrate(i, j))
                        update = false;
                    end    
                end
                if(update == true)
                    K_substrate(i, j) = 0;
                end
            end
    end
    
     % Sort Requests by priority and area
    K_requests = [K_requests; new_requests];

    if(size(K_requests) ~= 0)
        K_requests(:,2) = -K_requests(:,2);
        K_requests = sortrows(K_requests);
        K_requests(:,2) = -K_requests(:,2);

        indices = 0;

        for i = 1:size(K_requests, 1)

            [K_substrate, success] = karnaugh_map_embedding(K_requests(i, :), K_substrate);

            if(success)

                % Update the current applications
                existing_K_networks = [existing_K_networks; K_requests(i, :)];
                
                if(K_requests(i, 1) == 1)
                    K_revenue(timeslot:timeslot + K_requests(i, 4)) = K_revenue(timeslot:timeslot + K_requests(i, 4)) + alpha*K_requests(i, 2);
                elseif(K_requests(i, 1) == 2)
                    K_revenue(timeslot:timeslot + K_requests(i, 4)) = K_revenue(timeslot:timeslot + K_requests(i, 4)) + beta*(K_requests(i, 2));
                elseif(K_requests(i, 1) == 3)
                    K_revenue(timeslot:timeslot + K_requests(i, 4)) = K_revenue(timeslot:timeslot + K_requests(i, 4)) + gamma*(K_requests(i, 2));
                end
                % Add embedded request to list of requests to remove
                indices = [indices, i];

            end

        end
        
        
        K_requests = K_requests(setdiff(1:size(K_requests, 1), indices), :);

         if(size(K_requests) ~= 0)
            indices = 0;
            
            for i = 1:size(K_requests, 1);
                if ((K_requests(i, 1) == 1) &&( timeslot - K_requests(i, 3)) == waiting_time_1)
                    indices = [indices, i];
                    K_rejected_1(timeslot - waiting_time_1, K_requests(i, 8)) = K_rejected_1(timeslot - waiting_time_1, K_requests(i, 8)) + K_requests(i, 2)*K_requests(i, 4);
                elseif ((K_requests(i, 1) == 2) &&( timeslot - K_requests(i, 3)) == waiting_time_2)
                    indices = [indices, i];
                    K_rejected_2(timeslot - waiting_time_2, K_requests(i, 8)) = K_rejected_2(timeslot - waiting_time_2, K_requests(i, 8)) + K_requests(i, 2)*K_requests(i, 4);
                elseif ((K_requests(i, 1) == 3) &&( timeslot - K_requests(i, 3)) == waiting_time_3)
                    indices = [indices, i];
                    K_rejected_3(timeslot - waiting_time_3, K_requests(i, 8)) = K_rejected_3(timeslot - waiting_time_3, K_requests(i, 8)) + K_requests(i, 2)*K_requests(i, 4);
                end
            end
        else
            K_requests = [];
        end

        K_requests = K_requests(setdiff(1:size(K_requests, 1), indices), :);
    end
    
    occupied = 0;
    for i = 1:DF
        for j = 1:DT
            if(K_substrate(i, j) ~=0)
               occupied = occupied +1;
            end
        end
    end
             
    K_occupied_area(timeslot, 1) = occupied/(DF*DT);
    
    %% Karnaugh with improved EDI
    
    indices = 0;
    
    for k = 1:size(existing_KE_networks, 1)
        if(existing_KE_networks(k, 4) == 1)
            indices = [indices, k];
        else
            existing_KE_networks(k, 4) = existing_KE_networks(k, 4) - 1;
        end
    end
                
    existing_KE_networks = existing_KE_networks(setdiff(1:size(existing_KE_networks, 1), indices), :);
            
    for i = 1:DF
            for j =1:DT
                update = true;
                for k = 1:size(existing_KE_networks, 1)
                    if(existing_KE_networks(k, 7) == KE_substrate(i, j))
                        update = false;
                    end    
                end
                if(update == true)
                    KE_substrate(i, j) = 0;
                end
            end
    end
    
     % Sort Requests by priority and area
    KE_requests = [KE_requests; new_requests];

    if(size(KE_requests) ~= 0)
        KE_requests(:,2) = -KE_requests(:,2);
        KE_requests = sortrows(KE_requests);
        KE_requests(:,2) = -KE_requests(:,2);

        indices = 0;

        for i = 1:size(KE_requests, 1)

            [KE_substrate, success] = karnaugh_map_EDI_embedding(KE_requests(i, :), KE_substrate);

            if(success)

                % Update the current applications
                existing_KE_networks = [existing_KE_networks; KE_requests(i, :)];
                
                if(KE_requests(i, 1) == 1)
                    KE_revenue(timeslot:timeslot + KE_requests(i, 4)) = KE_revenue(timeslot:timeslot + KE_requests(i, 4)) + alpha*KE_requests(i, 2);
                elseif(KE_requests(i, 1) == 2)
                    KE_revenue(timeslot:timeslot + KE_requests(i, 4)) = KE_revenue(timeslot:timeslot + KE_requests(i, 4)) + beta*(KE_requests(i, 2));
                elseif(KE_requests(i, 1) == 3)
                    KE_revenue(timeslot:timeslot + KE_requests(i, 4)) = KE_revenue(timeslot:timeslot + KE_requests(i, 4)) + gamma*(KE_requests(i, 2));
                end
                % Add embedded request to list of requests to remove
                indices = [indices, i];

            end

        end
        
        
        KE_requests = KE_requests(setdiff(1:size(KE_requests, 1), indices), :);

         if(size(KE_requests) ~= 0)
            indices = 0;
            
            for i = 1:size(KE_requests, 1);
                if ((KE_requests(i, 1) == 1) &&( timeslot - KE_requests(i, 3)) == waiting_time_1)
                    indices = [indices, i];
                    KE_rejected_1(timeslot - waiting_time_1, KE_requests(i, 8)) = KE_rejected_1(timeslot - waiting_time_1, KE_requests(i, 8)) + KE_requests(i, 2)*KE_requests(i, 4);
                elseif ((KE_requests(i, 1) == 2) &&( timeslot - KE_requests(i, 3)) == waiting_time_2)
                    indices = [indices, i];
                    KE_rejected_2(timeslot - waiting_time_2, KE_requests(i, 8)) = KE_rejected_2(timeslot - waiting_time_2, KE_requests(i, 8)) + KE_requests(i, 2)*KE_requests(i, 4);
                elseif ((KE_requests(i, 1) == 3) &&( timeslot - KE_requests(i, 3)) == waiting_time_3)
                    indices = [indices, i];
                    KE_rejected_3(timeslot - waiting_time_3, KE_requests(i, 8)) = KE_rejected_3(timeslot - waiting_time_3, KE_requests(i, 8)) + KE_requests(i, 2)*KE_requests(i, 4);
                end
            end
        else
            KE_requests = [];
        end

        KE_requests = KE_requests(setdiff(1:size(KE_requests, 1), indices), :);
    end
    
    occupied = 0;
    for i = 1:DF
        for j = 1:DT
            if(KE_substrate(i, j) ~=0)
               occupied = occupied +1;
            end
        end
    end
             
    KE_occupied_area(timeslot, 1) = occupied/(DF*DT);
    
    
      %% Static Optimal Embedding
    if(include_optimal == true)
        
       indices = 0;
    
        for k = 1:size(existing_S_O_networks, 1)
            if(existing_S_O_networks(k, 4) == 1)
                indices = [indices, k];
            else
                existing_S_O_networks(k, 4) = existing_S_O_networks(k, 4) - 1;
            end
        end

        existing_S_O_networks = existing_S_O_networks(setdiff(1:size(existing_S_O_networks, 1), indices), :);

        for i = 1:DF
            for j =1:DT
                update = true;
                for k = 1:size(existing_S_O_networks, 1)
                    if(existing_S_O_networks(k, 7) == S_O_substrate(i, j))
                        update = false;
                    end    
                end
                if(update == true)
                    S_O_substrate(i, j) = 0;
                end
            end
    end
        
        S_O_requests = [existing_S_O_networks; S_O_requests; new_requests];
        
        [S_O_substrate, existing_S_O_networks, S_O_requests] = static_optimal_allocation(existing_S_O_networks, S_O_substrate, S_O_requests, DF, DT, 3);
        
        for i=1:size(existing_S_O_networks)
            if(existing_S_O_networks(i, 1) == 1)
                S_O_revenue(timeslot:timeslot + existing_S_O_networks(i, 4)) = S_O_revenue(timeslot:timeslot + existing_S_O_networks(i, 4)) + alpha*existing_S_O_networks(i, 2);
            elseif(existing_S_O_networks(i, 1) == 2)
                S_O_revenue(timeslot:timeslot + existing_S_O_networks(i, 4)) = S_O_revenue(timeslot:timeslot + existing_S_O_networks(i, 4)) + beta*(existing_S_O_networks(i, 2));
            elseif(existing_S_O_networks(i, 1) == 3)
                S_O_revenue(timeslot:timeslot + existing_S_O_networks(i, 4)) = S_O_revenue(timeslot:timeslot + existing_S_O_networks(i, 4)) + gamma*(existing_S_O_networks(i, 2));
            end
        end
        
        for k = 1:size(existing_S_O_networks, 1)
            existing_S_O_networks(k, 1) = 0;
        end
       
        if(size(S_O_requests) ~= 0)
            indices = 0;
            
            for i = 1:size(S_O_requests, 1);
                if ((S_O_requests(i, 1) == 1) &&( timeslot - S_O_requests(i, 3)) == waiting_time_1)
                    indices = [indices, i];
                    S_O_rejected_1(timeslot - waiting_time_1, S_O_requests(i, 8)) = S_O_rejected_1(timeslot - waiting_time_1, S_O_requests(i, 8)) + S_O_requests(i, 2)*S_O_requests(i, 4);
                elseif ((S_O_requests(i, 1) == 2) &&( timeslot - S_O_requests(i, 3)) == waiting_time_2)
                    indices = [indices, i];
                    S_O_rejected_2(timeslot - waiting_time_2, S_O_requests(i, 8)) = S_O_rejected_2(timeslot - waiting_time_2, S_O_requests(i, 8)) + S_O_requests(i, 2)*S_O_requests(i, 4);
                elseif ((S_O_requests(i, 1) == 3) &&( timeslot - S_O_requests(i, 3)) == waiting_time_3)
                    indices = [indices, i];
                    S_O_rejected_3(timeslot - waiting_time_3, S_O_requests(i, 8)) = S_O_rejected_3(timeslot - waiting_time_3, S_O_requests(i, 8)) + S_O_requests(i, 2)*S_O_requests(i, 4);
                end
            end

            S_O_requests = S_O_requests(setdiff(1:size(S_O_requests, 1), indices), :);
        else
            S_O_requests = [];
        end
                    
        occupied = 0;
        for i = 1:DF
            for j = 1:DT
                if(S_O_substrate(i, j) ~=0)
                    occupied = occupied +1;
                end
            end
        end

        S_O_occupied_area(timeslot, 1) = occupied/(DF*DT);
    end
    
    %% Dyanmic Optimal Embedding
     if(include_optimal == true)
        
        indices = 0;

        for k = 1:size(existing_D_O_networks, 1)
            if(existing_D_O_networks(k, 4) == 1)
                indices = [indices, k];
            else
                existing_D_O_networks(k, 4) = existing_D_O_networks(k, 4) - 1;
            end
        end

        existing_D_O_networks = existing_D_O_networks(setdiff(1:size(existing_D_O_networks, 1), indices), :);
        
        D_O_requests = [existing_D_O_networks; D_O_requests; new_requests];
        
        
        [D_O_substrate, embedded_D_O_requests, D_O_requests] = optimal_allocation( D_O_requests, DF, DT, 3);

        
        existing_D_O_networks = embedded_D_O_requests;

        for i=1:size(existing_D_O_networks)
            if(existing_D_O_networks(i, 1) == 1)
                D_O_revenue(timeslot:timeslot + existing_D_O_networks(i, 4)) = D_O_revenue(timeslot:timeslot + existing_D_O_networks(i, 4)) + alpha*existing_D_O_networks(i, 2);
            elseif(existing_D_O_networks(i, 1) == 2)
                D_O_revenue(timeslot:timeslot + existing_D_O_networks(i, 4)) = D_O_revenue(timeslot:timeslot + existing_D_O_networks(i, 4)) + beta*(existing_D_O_networks(i, 2));
            elseif(existing_D_O_networks(i, 1) == 3)
                D_O_revenue(timeslot:timeslot + existing_D_O_networks(i, 4)) = D_O_revenue(timeslot:timeslot + existing_D_O_networks(i, 4)) + gamma*(existing_D_O_networks(i, 2));
            end
        end
        
        for k = 1:size(existing_D_O_networks, 1)
            existing_D_O_networks(k, 1) = 0;
        end
       
        if(size(D_O_requests) ~= 0)
            indices = 0;
            
            for i = 1:size(D_O_requests, 1);
                if ((D_O_requests(i, 1) == 1) &&( timeslot - D_O_requests(i, 3)) == waiting_time_1)
                    indices = [indices, i];
                    D_O_rejected_1(timeslot - waiting_time_1, D_O_requests(i, 8)) = D_O_rejected_1(timeslot - waiting_time_1, D_O_requests(i, 8)) + D_O_requests(i, 2)*D_O_requests(i, 4);
                elseif ((D_O_requests(i, 1) == 2) &&( timeslot - D_O_requests(i, 3)) == waiting_time_2)
                    indices = [indices, i];
                    D_O_rejected_2(timeslot - waiting_time_2, D_O_requests(i, 8)) = D_O_rejected_2(timeslot - waiting_time_2, D_O_requests(i, 8)) + D_O_requests(i, 2)*D_O_requests(i, 4);
                elseif ((D_O_requests(i, 1) == 3) &&( timeslot - D_O_requests(i, 3)) == waiting_time_3)
                    indices = [indices, i];
                    D_O_rejected_3(timeslot - waiting_time_3, D_O_requests(i, 8)) = D_O_rejected_3(timeslot - waiting_time_3, D_O_requests(i, 8)) + D_O_requests(i, 2)*D_O_requests(i, 4);
                end
            end

            D_O_requests = D_O_requests(setdiff(1:size(D_O_requests, 1), indices), :);
        else
            D_O_requests = [];
        end
            
        occupied = 0;
        for i = 1:DF
            for j = 1:DT
                if(D_O_substrate(i, j) ~=0)
                    occupied = occupied +1;
                end
            end
        end
             
        D_O_occupied_area(timeslot, 1) = occupied/(DF*DT);
        
     end

        %% Dynamic K-maps
        
        indices = 0;
        
        for k = 1:size(existing_D_networks, 1)
            if(existing_D_networks(k, 4) == 1)
                indices = [indices, k];
            else
                existing_D_networks(k, 4) = existing_D_networks(k, 4) - 1;
            end
        end

        existing_D_networks = existing_D_networks(setdiff(1:size(existing_D_networks, 1), indices), :);
        
        D_requests = [existing_D_networks; D_requests; new_requests];
        
        existing_D_networks = [];
        
        D_substrate = zeros(DF,DT);
        
        if(size(D_requests) ~= 0)
            D_requests(:,2) = -D_requests(:,2);
            D_requests = sortrows(D_requests);
            D_requests(:,2) = -D_requests(:,2);

            indices = 0;

            for i = 1:size(D_requests)

                [D_substrate, success] = dynamic_karnaugh_map_embedding(D_requests(i, :), D_substrate);
                if(success)
                    % Add embedded request to list of requests to remove
                    indices = [indices, i];
                    if(D_requests(i, 1) == 1)
                        D_revenue(timeslot:timeslot + D_requests(i, 4)) = D_revenue(timeslot:timeslot + D_requests(i, 4)) + alpha*D_requests(i, 2);
                    elseif(D_requests(i, 1) == 2)
                        D_revenue(timeslot:timeslot + D_requests(i, 4)) = D_revenue(timeslot:timeslot + D_requests(i, 4)) + beta*(D_requests(i, 2));
                    elseif(D_requests(i, 1) == 3)
                        D_revenue(timeslot:timeslot + D_requests(i, 4)) = D_revenue(timeslot:timeslot + D_requests(i, 4)) + gamma*(D_requests(i, 2));
                    end
                    
                    existing_D_networks = [existing_D_networks; D_requests(i, :)]; 
                end
            end

            for k = 1:size(existing_D_networks, 1)
                existing_D_networks(k, 1) = 0;
            end
            
            D_requests = D_requests(setdiff(1:size(D_requests, 1), indices), :);

            if(size(D_requests) ~= 0)
                indices = 0;

                for i = 1:size(D_requests, 1);
                    if ((D_requests(i, 1) == 1) &&( timeslot - D_requests(i, 3)) == waiting_time_1)
                        indices = [indices, i];
                        D_rejected_1(timeslot - waiting_time_1, D_requests(i, 8)) = D_rejected_1(timeslot - waiting_time_1, D_requests(i, 8)) + D_requests(i, 2)*D_requests(i, 4);
                    elseif ((D_requests(i, 1) == 2) &&( timeslot - D_requests(i, 3)) == waiting_time_2)
                        indices = [indices, i];
                        D_rejected_2(timeslot - waiting_time_2, D_requests(i, 8)) = D_rejected_2(timeslot - waiting_time_2, D_requests(i, 8)) + D_requests(i, 2)*D_requests(i, 4);
                    elseif ((D_requests(i, 1) == 3) &&( timeslot - D_requests(i, 3)) == waiting_time_3)
                        indices = [indices, i];
                        D_rejected_3(timeslot - waiting_time_3, D_requests(i, 8)) = D_rejected_3(timeslot - waiting_time_3, D_requests(i, 8)) + D_requests(i, 2)*D_requests(i, 4);
                    end
                end

                D_requests = D_requests(setdiff(1:size(D_requests, 1), indices), :);
            else
                D_requests = [];
            end
        end
        
        occupied = 0;
        for i = 1:DF
            for j = 1:DT
               if(D_substrate(i, j) ~=0)
                  occupied = occupied +1;
               end
            end
        end
             
        D_occupied_area(timeslot, 1) = occupied/(DF*DT);
        
        %% Dynamic with improved EDI
        
        indices = 0;
        
        for k = 1:size(existing_DE_networks, 1)
            if(existing_DE_networks(k, 4) == 1)
                indices = [indices, k];
            else
                existing_DE_networks(k, 4) = existing_DE_networks(k, 4) - 1;
            end
        end

        existing_DE_networks = existing_DE_networks(setdiff(1:size(existing_DE_networks, 1), indices), :);
        
        DE_requests = [existing_DE_networks; DE_requests; new_requests];
        
        existing_DE_networks = [];
        
        DE_substrate = zeros(DF,DT);
        
        if(size(DE_requests) ~= 0)
            DE_requests(:,2) = -DE_requests(:,2);
            DE_requests = sortrows(DE_requests);
            DE_requests(:,2) = -DE_requests(:,2);

            indices = 0;

            for i = 1:size(DE_requests)

                [DE_substrate, success] = dynamic_karnaugh_map_EDI_embedding(DE_requests(i, :), DE_substrate);
                if(success)
                    % Add embedded request to list of requests to remove
                    indices = [indices, i];
                    if(DE_requests(i, 1) == 1)
                        DE_revenue(timeslot:timeslot + DE_requests(i, 4)) = DE_revenue(timeslot:timeslot + DE_requests(i, 4)) + alpha*DE_requests(i, 2);
                    elseif(DE_requests(i, 1) == 2)
                        DE_revenue(timeslot:timeslot + DE_requests(i, 4)) = DE_revenue(timeslot:timeslot + DE_requests(i, 4)) + beta*(DE_requests(i, 2));
                    elseif(DE_requests(i, 1) == 3)
                        DE_revenue(timeslot:timeslot + DE_requests(i, 4)) = DE_revenue(timeslot:timeslot + DE_requests(i, 4)) + gamma*(DE_requests(i, 2));
                    end
                    
                    existing_DE_networks = [existing_DE_networks; DE_requests(i, :)]; 
                end
            end

            for k = 1:size(existing_DE_networks, 1)
                existing_DE_networks(k, 1) = 0;
            end
            
            DE_requests = DE_requests(setdiff(1:size(DE_requests, 1), indices), :);

            if(size(DE_requests) ~= 0)
                indices = 0;

                for i = 1:size(DE_requests, 1);
                    if ((DE_requests(i, 1) == 1) &&( timeslot - DE_requests(i, 3)) == waiting_time_1)
                        indices = [indices, i];
                        DE_rejected_1(timeslot - waiting_time_1, DE_requests(i, 8)) = DE_rejected_1(timeslot - waiting_time_1, DE_requests(i, 8)) + DE_requests(i, 2)*DE_requests(i, 4);
                    elseif ((DE_requests(i, 1) == 2) &&( timeslot - DE_requests(i, 3)) == waiting_time_2)
                        indices = [indices, i];
                        DE_rejected_2(timeslot - waiting_time_2, DE_requests(i, 8)) = DE_rejected_2(timeslot - waiting_time_2, DE_requests(i, 8)) + DE_requests(i, 2)*DE_requests(i, 4);
                    elseif ((DE_requests(i, 1) == 3) &&( timeslot - DE_requests(i, 3)) == waiting_time_3)
                        indices = [indices, i];
                        DE_rejected_3(timeslot - waiting_time_3, DE_requests(i, 8)) = DE_rejected_3(timeslot - waiting_time_3, DE_requests(i, 8)) + DE_requests(i, 2)*DE_requests(i, 4);
                    end
                end

                DE_requests = DE_requests(setdiff(1:size(DE_requests, 1), indices), :);
            else
                DE_requests = [];
            end
        end
        
        occupied = 0;
        for i = 1:DF
            for j = 1:DT
               if(DE_substrate(i, j) ~=0)
                  occupied = occupied +1;
               end
            end
        end
             
        DE_occupied_area(timeslot, 1) = occupied/(DF*DT);
    
         %% Dynamic Greedy

        indices = 0;
        
        for k = 1:size(G_existing_networks, 1)
            if(G_existing_networks(k, 4) == 1)
                indices = [indices, k];
            else
                G_existing_networks(k, 4) = G_existing_networks(k, 4) - 1;
            end
        end

        G_existing_networks = G_existing_networks(setdiff(1:size(G_existing_networks, 1), indices), :);
        
%         if(sum(indices))
            G_previous_combinations = unique(G_previous_combinations(:, setdiff(1:size(G_previous_combinations, 2), indices)), 'rows');
            G_previous_combinations = [G_previous_combinations, zeros(size(G_previous_combinations, 1), size(G_requests, 1)), zeros(size(G_previous_combinations, 1), size(new_requests, 1))];
            
            p_indices = [];
            
            for j =1:size(indices, 2)
                for l=1:size(previous_permutation, 2)
                    if(previous_permutation(1, l) == indices(1, j))
                        p_indices = [p_indices, l];
                    end
                end
            end
            
            previous_permutation = previous_permutation(:, setdiff(1:size(previous_permutation, 2), p_indices));
            
%         else
%             G_previous_combinations = [];
%         end
        
        G_requests = [G_existing_networks; G_requests; new_requests];
        
        G_existing_networks = [];
        
        G_substrate = zeros(DF,DT);
        
        if(size(G_requests) ~= 0)
            
            G_requests(:,2) = -G_requests(:,2);
            [G_requests idx] = sortrows(G_requests);
            G_requests(:,2) = -G_requests(:,2);
    
%             if(sum(indices))
                G_previous_combinations = G_previous_combinations(:, idx);
%             end
            
%             limit = 50;
% 
%             if(size(G_previous_combinations, 1) > limit)
%                 size(G_previous_combinations, 1)
% %                 size(G_previous_combinations, 2)
%                 G_previous_combinations = G_previous_combinations(1:limit, :);
%             end
            
            indices = 0;

            G_requests;
            G_previous_combinations;
            
            [succesful_requests, G_substrate, G_previous_combinations] = greedy_embedding(G_requests, num_priorities, G_previous_combinations, DF, DT);

            G_substrate;
%             D_substrate
            %sucessful_requests
            for i = 1:size(succesful_requests)
%                     Add embedded request to list of requests to remove

                j = succesful_requests(i);
                indices = [indices, j];
                
                if(G_requests(j, 1) ~=0)

                    if(G_requests(j, 1) == 1)
                        G_revenue(timeslot:timeslot + G_requests(j, 4)) = G_revenue(timeslot:timeslot + G_requests(j, 4)) + alpha*G_requests(j, 2);
                    elseif(G_requests(j, 1) == 2)
                        G_revenue(timeslot:timeslot + G_requests(j, 4)) = G_revenue(timeslot:timeslot + G_requests(j, 4)) + beta*(G_requests(j, 2));
                    elseif(G_requests(j, 1) == 3)
                        G_revenue(timeslot:timeslot + G_requests(j, 4)) = G_revenue(timeslot:timeslot + G_requests(j, 4)) + gamma*(G_requests(j, 2));
                    end
                end

                G_existing_networks = [G_existing_networks; G_requests(j, :)]; 
            end
           

            for k = 1:size(G_existing_networks, 1)
                G_existing_networks(k, 1) = 0;
            end
            
            G_requests = G_requests(setdiff(1:size(G_requests, 1), indices), :);

            if(size(G_requests) ~= 0)
                indices = 0;

                for i = 1:size(G_requests, 1);
                    if ((G_requests(i, 1) == 1) &&( timeslot - G_requests(i, 3)) == waiting_time_1)
                        indices = [indices, i];
                        G_rejected_1(timeslot - waiting_time_1, G_requests(i, 8)) = G_rejected_1(timeslot - waiting_time_1, G_requests(i, 8)) + G_requests(i, 2)*G_requests(i, 4);
                    elseif ((G_requests(i, 1) == 2) &&( timeslot - G_requests(i, 3)) == waiting_time_2)
                        indices = [indices, i];
                        G_rejected_2(timeslot - waiting_time_2, G_requests(i, 8)) = G_rejected_2(timeslot - waiting_time_2, G_requests(i, 8)) + G_requests(i, 2)*G_requests(i, 4);                   
                    elseif ((G_requests(i, 1) == 3) &&( timeslot - G_requests(i, 3)) == waiting_time_3)
                        indices = [indices, i];
                        G_rejected_3(timeslot - waiting_time_3, G_requests(i, 8)) = G_rejected_3(timeslot - waiting_time_3, G_requests(i, 8)) + G_requests(i, 2)*G_requests(i, 4);                    
                    end
                end

                G_requests = G_requests(setdiff(1:size(G_requests, 1), indices), :);
            else
                G_requests = [];
            end
        end
        
        occupied = 0;
        for i = 1:DF
            for j = 1:DT
               if(G_substrate(i, j) ~=0)
                  occupied = occupied +1;
               end
            end
        end
             
        G_occupied_area(timeslot, 1) = occupied/(DF*DT);
    
 %%
   

%     K_substrate 
%     KE_substrate
%     S_O_substrate
%     D_substrate
%     DE_substrate
%     D_O_substrate
%     K_requests
%     S_O_requests
%     D_requests
%     D_O_requests

   progressbar(timeslot/iterations);
    
    % End main loop
   
   f = 'temp.mat';
   save(f);
   clear;
   load temp.mat;
   delete(f);
   
   
end
toc(Start)

%% Performance
% 
% reject_rate_timeslot = zeros(iterations, 6);
% 
% 
% for i=1:iterations
%         
%     Average_reject_rate(i, 1) = sum(sum(K_rejected_1(1:i, :)));
%     Average_reject_rate(i, 2) = sum(sum(KE_rejected_1(1:i, :)));
%     Average_reject_rate(i, 3) = sum(sum(S_O_rejected_1(1:i, :)));
%     Average_reject_rate(i, 4) = sum(sum(D_rejected_1(1:i, :)));
%     Average_reject_rate(i, 5) = sum(sum(DE_rejected_1(1:i, :)));
%     Average_reject_rate(i, 6) = sum(sum(D_O_rejected_1(1:i, :)));
%     Average_reject_rate(i, 7)= sum(sum(K_rejected_2(1:i, :)));
%     Average_reject_rate(i, 8) = sum(sum(KE_rejected_2(1:i, :)));
%     Average_reject_rate(i, 9) = sum(sum(S_O_rejected_2(1:i, :)));
%     Average_reject_rate(i, 10) = sum(sum(D_rejected_2(1:i, :)));
%     Average_reject_rate(i, 11) = sum(sum(DE_rejected_2(1:i, :)));
%     Average_reject_rate(i, 12) = sum(sum(D_O_rejected_2(1:i, :)));
%     Average_reject_rate(i, 13) = sum(sum(K_rejected_3(1:i, :)));
%     Average_reject_rate(i, 14) = sum(sum(KE_rejected_3(1:i, :)));
%     Average_reject_rate(i, 15) = sum(sum(S_O_rejected_3(1:i, :)));
%     Average_reject_rate(i, 16) = sum(sum(D_rejected_3(1:i, :)));
%     Average_reject_rate(i, 17) = sum(sum(DE_rejected_3(1:i, :)));
%     Average_reject_rate(i, 18) = sum(sum(D_O_rejected_3(1:i, :)));
%     Average_reject_rate_all(i, 1) = Average_reject_rate(i, 1) + Average_reject_rate(i, 7) + Average_reject_rate(i, 13);
%     Average_reject_rate_all(i, 2) = Average_reject_rate(i, 2) + Average_reject_rate(i, 8) + Average_reject_rate(i, 14);
%     Average_reject_rate_all(i, 3) = Average_reject_rate(i, 3) + Average_reject_rate(i, 9) + Average_reject_rate(i, 15);
%     Average_reject_rate_all(i, 4) = Average_reject_rate(i, 4) + Average_reject_rate(i, 10) + Average_reject_rate(i, 16);
%     Average_reject_rate_all(i, 5) = Average_reject_rate(i, 5) + Average_reject_rate(i, 11) + Average_reject_rate(i, 17);
%     Average_reject_rate_all(i, 6) = Average_reject_rate(i, 6) + Average_reject_rate(i, 12) + Average_reject_rate(i, 18);
%     
%     reject_rate_timeslot(i, 1) = sum(K_rejected_1(i, :)) + sum(K_rejected_2(i, :)) + sum(K_rejected_3(i, :));
%     reject_rate_timeslot(i, 2) = sum(KE_rejected_1(i, :)) + sum(KE_rejected_2(i, :)) + sum(KE_rejected_3(i, :));
%     reject_rate_timeslot(i, 3) = sum(S_O_rejected_1(i, :)) + sum(S_O_rejected_2(i, :)) + sum(S_O_rejected_3(i, :));
%     reject_rate_timeslot(i, 4) = sum(D_rejected_1(i, :)) + sum(D_rejected_2(i, :)) + sum(D_rejected_3(i, :));
%     reject_rate_timeslot(i, 5) = sum(DE_rejected_1(i, :)) + sum(DE_rejected_2(i, :)) + sum(DE_rejected_3(i, :));
%     reject_rate_timeslot(i, 6) = sum(D_O_rejected_1(i, :)) + sum(D_O_rejected_2(i, :)) + sum(D_O_rejected_3(i, :));
% %         Average_reject_rate(i, 1) = sum(K_rejected_1(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 2) = sum(D_rejected_1(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 3) = sum(O_rejected_1(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 4) = sum(K_rejected_2(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 5) = sum(D_rejected_2(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 6) = sum(O_rejected_2(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 7) = sum(K_rejected_3(i, :)/total_requests(i, :));       
% %         Average_reject_rate(i, 8) = sum(D_rejected_3(i, :)/total_requests(i, :));
% %         Average_reject_rate(i, 9) = sum(O_rejected_3(i, :)/total_requests(i, :));
% 
% end
% 
% for i=1:iterations
% 
%         occupied_area(i, 1) = K_occupied_area(i);
%         occupied_area(i, 2) = KE_occupied_area(i);
%         occupied_area(i, 3) = S_O_occupied_area(i);
%         occupied_area(i, 4) = D_occupied_area(i);
%         occupied_area(i, 5) = DE_occupied_area(i);
%         occupied_area(i, 6) = D_O_occupied_area(i);
%         
%         revenue(i, 1) = sum(K_revenue(1:i));
%         revenue(i, 2) = sum(KE_revenue(1:i));
%         revenue(i, 3) = sum(S_O_revenue(1:i));
%         revenue(i, 4) = sum(D_revenue(1:i));
%         revenue(i, 5) = sum(DE_revenue(1:i));
%         revenue(i, 6) = sum(D_O_revenue(1:i));
% end
% 
% figure(1); title('Reject Rate 1'); 
% 
% %     subplot(5, 1, 5);
%     plot(1:every_x_point:iterations, Average_reject_rate(1:every_x_point:end, 1:6));
%     hleg = legend('K-maps-1', 'K-maps EDI-1', 'Static Optimal-1', 'Dynamic-1', 'Dynamic EDI-1',  'Dynamic Optimal-1','Location','NorthWest');
%     xlabel('Time(s)');
%     ylabel('Reject Rate 1');
%     
% figure(2); title('Reject Rate 2'); 
% 
%     plot(1:every_x_point:iterations, Average_reject_rate(1:every_x_point:end, 7:12));
%     hleg = legend('K-maps-2', 'K-maps EDI-2', 'Static Optimal-2', 'Dynamic-2', 'Dynamic EDI-2', 'Dynamic Optimal-2','Location','NorthWest');
%     xlabel('Time(s)');
%     ylabel('Reject Rate 2');
%     
% figure(3); title('Reject Rate 3'); 
%     plot(1:every_x_point:iterations, Average_reject_rate(1:every_x_point:end, 13:18));
%     xlabel('Time(s)');
%     ylabel('Reject Rate 3');
%     hleg = legend('K-maps-3', 'K-maps EDI-3','Static Optimal-3', 'Dynamic-3', 'Dynamic EDI-3', 'Dynamic Optimal-3','Location','NorthWest');
%     
% figure(4); title('Reject Rate'); 
%     plot(1:every_x_point:iterations, Average_reject_rate_all(1:every_x_point:end, :));
%     xlabel('Time(s)');
%     ylabel('Reject Rate');
%     hleg = legend('K-maps', 'K-maps EDI', 'Static Optimal','Dynamic', 'Dynamic EDI', 'Dynamic Optimal','Location','NorthWest');
%        
% reject_rate_timeslot(1,:) = smooth(reject_rate_timeslot(1, :), 200);
% reject_rate_timeslot(2,:) = smooth(reject_rate_timeslot(2, :), 200);  
% reject_rate_timeslot(3,:) = smooth(reject_rate_timeslot(3, :), 200);  
% reject_rate_timeslot(4,:) = smooth(reject_rate_timeslot(4, :), 200);  
% reject_rate_timeslot(5,:) = smooth(reject_rate_timeslot(5, :), 200);  
% reject_rate_timeslot(6,:) = smooth(reject_rate_timeslot(6, :), 200);  
% 
%     
% figure(7); title('Reject Rate'); 
%     plot(1:every_x_point:iterations, reject_rate_timeslot(1:every_x_point:end, :));
%     xlabel('Time(s)');
%     ylabel('Reject Rate');
%     hleg = legend('K-maps', 'K-maps EDI', 'Static Optimal','Dynamic', 'Dynamic EDI', 'Dynamic Optimal','Location','NorthWest');    
% 
% figure(5); title('Revenue'); 
% 
% %     subplot(5, 1, 5);
%     plot(1:every_x_point:iterations, revenue(1:every_x_point:end, :));
%     xlabel('Time(s)');
%     ylabel('Revenue');
%     hleg = legend('K-maps','K-maps EDI', 'Static Optimal','Dynamic', 'Dynamic EDI', 'Dynamic Optimal', 'Location','NorthWest');
%     
% figure(6); title('Occupied Area'); 
% 
% %     subplot(5, 1, 5);
%     plot(1:every_x_point:iterations, occupied_area(1:every_x_point:end, :));
%     xlabel('Time(s)');
%     ylabel('Occupied Area');
%     hleg = legend('K-maps', 'K-maps EDI', 'Static Optimal', 'Dynamic', 'Dynamic EDI', 'Dynamic Optimal', 'Location','SouthEast');
% 
% %     Average_K_reject_rate_1 = sum(K_rejected_1)/(sum(total_requests(:, :)))  
% %     Average_D_reject_rate_1 = sum(D_rejected_1)/(sum(total_requests(:, :))) 
% %     Average_O_reject_rate_1 = sum(O_rejected_1)/(sum(total_requests(:, :)))
% %     Average_K_reject_rate_2 = sum(K_rejected_2)/(sum(total_requests(:, :)))
% %     Average_D_reject_rate_2 = sum(D_rejected_2)/(sum(total_requests(:, :)))
% %     Average_O_reject_rate_2 = sum(O_rejected_2)/(sum(total_requests(:, :)))
% %     Average_K_reject_rate_3 = sum(K_rejected_3)/(sum(total_requests(:, :)))
% %     Average_D_reject_rate_3 = sum(D_rejected_3)/(sum(total_requests(:, :)))
% %     Average_O_reject_rate_3 = sum(O_rejected_3)/(sum(total_requests(:, :)))
%     Average_K_reject_rate = (sum(K_rejected_1)+sum(K_rejected_2)+sum(K_rejected_3))/(sum(total_requests(:, :)))
%     Average_KE_reject_rate = (sum(KE_rejected_1)+sum(KE_rejected_2)+sum(KE_rejected_3))/(sum(total_requests(:, :)))
%     Average_S_O_reject_rate = (sum(S_O_rejected_1)+sum(S_O_rejected_2)+sum(S_O_rejected_3))/(sum(total_requests(:, :)))
%     Average_D_reject_rate = (sum(D_rejected_1)+sum(D_rejected_2)+sum(D_rejected_3))/(sum(total_requests(:, :)))
%     Average_DE_reject_rate = (sum(DE_rejected_1)+sum(DE_rejected_2)+sum(DE_rejected_3))/(sum(total_requests(:, :)))
%     Average_D_O_reject_rate = (sum(D_O_rejected_1)+sum(D_O_rejected_2)+sum(D_O_rejected_3))/(sum(total_requests(:, :)))
% 
% 
% 
% % subplot(2,2,1); % plot the resource utility
% % title('Resource Usage');
% % xlabel('Time');
% % ylabel('Resource usage');
% % title('Resource Usage')
% % axis([0 500 0 1]);
% % plot(smooth(K_occupied_area, 3));
% % subplot(2,2,2); % plot the reject rate
% % title('Reject rate');
% % xlabel('Time');
% % ylabel('Reject rate');
% % plot(smooth(K_reject_rate, 51));
% % xlabel('Time');
% % ylabel('Reject rate');
% % Average_Resource_usage = sum(K_occupied_area)/iterations
% % Average_Reject_rate = sum(K_reject_rate)/iterations
% 
% 
% 
%     