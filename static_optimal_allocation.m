function [ substrate, embedded_O_requests, buffered_requests] = static_optimal_allocation(existing_networks, O_substrate, optimal_requests, DF, DT, traffic_types)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        substrate = zeros(DF,DT);
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
                   [substrate, satisfied_requests, indeces] = static_optimal_embedding(existing_networks, O_substrate, current_requests, previous_requests , DF, DT);   
                end  
                

                current_requests = current_requests(setdiff(1:size(current_requests, 1), indeces), :);
                previous_requests = satisfied_requests;
                
            end
            
            buffered_requests = current_requests;
            embedded_O_requests = satisfied_requests;
            
            
                         
         end
         

end

