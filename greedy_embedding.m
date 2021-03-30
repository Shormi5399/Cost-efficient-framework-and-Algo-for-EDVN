function [ successful, greedy_substrate, combinations] = greedy_embedding( G_requests, num_priorities, previous_combinations,  F, T)
%GREEDY_EMBEDDING Summary of this function goes here
%   Detailed explanation goes here

    % Sort requests by priority
       
    greedy_substrate = zeros(F, T);
    all =0;
    
%          G_requests(:,2) = -G_requests(:,2);
%          G_requests = sortrows(G_requests);
%          G_requests(:,2) = -G_requests(:,2);

        indeces = 0;

        combinations = [];
%         guarenteed = false;
%         previous_accepted = [];
        j = 1;
        last = j;
        first = j;
        
        if(size(previous_combinations, 1) ~=0)
            all = 1;
            while((j <= size(G_requests, 1))&(G_requests(j, 1) == 0))
                    j = j +1;
            end

            last = j;
            first = j;
        end

        for i = all:num_priorities 
            % find all requests with this priority level
                        
            while((last <= size(G_requests, 1))&(G_requests(last, 1) == i))
                last = last +1;
            end
            
            % from small to large
            % find possible combo's recursively
            if(last>1)
%                 current_combinations = find_combinations2(first:last-1, previous_combinations, G_requests, F, T);
                  combinations = check_area([zeros(1, first-1) first:last-1 zeros(1, size(G_requests, 1)-last+1)], previous_combinations, G_requests, F, T);
            end
            % exclude the combinations that don't include higher priority
%             current_combinations = check_combinations(previous_accepted, current_combinations);
            % find the set of largest
            [greedy_substrate, successful, combinations ] = greedy_allocation(combinations, G_requests, F, T);
        
%             [combinations ]= find_largest2(combinations, G_requests, F, T);

%             dimensions indices
            previous_combinations = combinations;
%             previous_accepted = indices;
            first = last;
        end

        % do the embedding
        
%         current_combinations(1, :)
end

% Priority Area Timeslot Duration Frequency Time ID Operator
