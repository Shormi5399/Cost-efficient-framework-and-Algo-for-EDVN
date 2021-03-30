function [ karnaugh_substrate, success ] = karnaugh_map_EDI_embedding( request, karnaugh_substrate  )
%   karnaugh_map_embedding: do karnaugh map embedding
%   INPUT request: virtual network request (priority area timeslot application freq time operator)
%   INPUT karnaugh_substrate
%   OUTPUT karnaugh_substrate
%   OUTPUT success
    
     % Find Karnaugh Regions
        minSize=[request(1, 5), request(1, 6)];
        success = false;
        possible_locations=[];
        embedding_cost = [];

        % Compare Karnaugh map algorithms
        K = FindKarnaughRegions(karnaugh_substrate, minSize);

        if(~isempty(K))
            K = sortrows(K, 5);
            for j=1:size(K)
                
                K_Corners = [K(j, 1) K(j, 2); K(j, 1) (K(j, 2)+K(j, 4));
                           (K(j, 1)+K(j, 3)) K(j, 2); (K(j, 1)+K(j, 3)) (K(j, 2)+K(j, 4));];

                % Test the four possible corners as embedding locations 
                possible_locations((j-1)*4 + 1, :) = [K_Corners(1,1) , (K_Corners(1,1) + request(1,5) - 1) , K_Corners(1, 2) , (K_Corners(1, 2) + request(1, 6)-1)];
                possible_locations((j-1)*4 + 2, :) = [K_Corners(2,1) , (K_Corners(2,1) + request(1,5) - 1) , (K_Corners(2, 2) - request(1, 6)+1) , K_Corners(2, 2)];
                possible_locations((j-1)*4 + 3, :) = [(K_Corners(3,1) - request(1,5) + 1) , K_Corners(3,1) , K_Corners(3, 2) , (K_Corners(3, 2) + request(1, 6)-1)];
                possible_locations((j-1)*4 + 4, :) = [(K_Corners(4,1) - request(1,5) + 1) , K_Corners(4,1) , (K_Corners(4, 2) - request(1, 6)+1) , K_Corners(4, 2)];

                % Find the EDI for each corner
                for i = 1:4
                    test_embedding = karnaugh_substrate;
                    test_embedding(possible_locations((j-1)*4 + i, 1):possible_locations((j-1)*4 + i, 2), possible_locations((j-1)*4 + i, 3):possible_locations((j-1)*4 + i, 4)) = 1;
                    embedding_cost((j-1)*4 + i, 1) = EDI(test_embedding);
                    embedding_cost((j-1)*4 + i, 2) = (j-1)*4 + i;
                end
            end

            % Place the virtual network at the corner with the lowest EDI
            embedding_cost = sortrows(embedding_cost);
            chosen_corner = embedding_cost(1, 2);  
            karnaugh_substrate(possible_locations(chosen_corner, 1):possible_locations(chosen_corner, 2), possible_locations(chosen_corner, 3):possible_locations(chosen_corner, 4)) = request(1,7);
            

            success = true;
        end 
end

