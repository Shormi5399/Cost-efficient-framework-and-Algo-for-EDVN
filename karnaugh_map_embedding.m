function [ karnaugh_substrate, success ] = karnaugh_map_embedding( request, karnaugh_substrate  )
%   karnaugh_map_embedding: do karnaugh map embedding
%   INPUT request: virtual network request (priority area timeslot application freq time operator)
%   INPUT karnaugh_substrate
%   OUTPUT karnaugh_substrate
%   OUTPUT success
    
     % Find Karnaugh Regions
        minSize=[request(1, 5), request(1, 6)];
        success = false;

        % Compare Karnaugh map algorithms
        K = FindKarnaughRegions(karnaugh_substrate, minSize);

        if(~isempty(K))
            K = sortrows(K, 5);
            K_Corners = [K(1, 1) K(1, 2); K(1, 1) (K(1, 2)+K(1, 4));
                       (K(1, 1)+K(1, 3)) K(1, 2); (K(1, 1)+K(1, 3)) (K(1, 2)+K(1, 4));];

            % Test the four possible corners as embedding locations 
            possible_locations(1, :) = [K_Corners(1,1) , (K_Corners(1,1) + request(1,5) - 1) , K_Corners(1, 2) , (K_Corners(1, 2) + request(1, 6)-1)];
            possible_locations(2, :) = [K_Corners(2,1) , (K_Corners(2,1) + request(1,5) - 1) , (K_Corners(2, 2) - request(1, 6)+1) , K_Corners(2, 2)];
            possible_locations(3, :) = [(K_Corners(3,1) - request(1,5) + 1) , K_Corners(3,1) , K_Corners(3, 2) , (K_Corners(3, 2) + request(1, 6)-1)];
            possible_locations(4, :) = [(K_Corners(4,1) - request(1,5) + 1) , K_Corners(4,1) , (K_Corners(4, 2) - request(1, 6)+1) , K_Corners(4, 2)];

            embedding_cost = [];

            % Find the EDI for each corner
            for i = 1:4
                test_embedding = karnaugh_substrate;
                test_embedding(possible_locations(i, 1):possible_locations(i, 2), possible_locations(i, 3):possible_locations(i, 4)) = 1;
                embedding_cost(i, 1) = EDI(test_embedding);
                embedding_cost(i, 2) = i;
            end

            % Place the virtual network at the corner with the lowest EDI
            embedding_cost = sortrows(embedding_cost);
            chosen_corner = embedding_cost(1, 2);  
            karnaugh_substrate(possible_locations(chosen_corner, 1):possible_locations(chosen_corner, 2), possible_locations(chosen_corner, 3):possible_locations(chosen_corner, 4)) = request(1,7);
            

            success = true;
        end 
end

