function [ O_substrate, embedded_O_requests, buffered_requests] = optimal_allocation(optimal_requests, DF, DT, traffic_types)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        O_substrate = zeros(DF,DT);
        embedded_O_requests = [];
        buffered_requests = [];
        satisfied_requests = [];
        
         if(size(optimal_requests) ~= 0)
            optimal_requests(:,2) = -optimal_requests(:,2);
            optimal_requests = sortrows(optimal_requests);
            optimal_requests(:,2) = -optimal_requests(:,2);
      
            previous_requests = [];
            current_requests = [];
            
            indeces = 0;
            for i=0:traffic_types
                
                
                for j=1:size(optimal_requests)
                    if(optimal_requests(j, 1) == i)
                        current_requests = [current_requests; optimal_requests(j, :)];
                    end
                
                end  
                
                if(size(current_requests) ~= 0)
                   [O_substrate, satisfied_requests, indeces] = optimal_embedding(current_requests, previous_requests , DF, DT);
                    
                end
                
                current_requests = current_requests(setdiff(1:size(current_requests, 1), indeces), :);
                previous_requests = satisfied_requests;
                
            end
            
            embedded_O_requests = satisfied_requests;
            
            buffered_requests = current_requests;
                         
         end
         

end

