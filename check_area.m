function [ combinations ] = check_area(indices, previous_combinations, requests, F, T )
%CHECK_AREA Summary of this function goes her

    checked_all = false;
    combinations = previous_combinations;
    area = 0;
    prev_area = 0;
    
    if(size(previous_combinations, 1))
        for i =1:size(previous_combinations, 2)
            if(previous_combinations(1, i))
                prev_area = prev_area + requests(i, 2);
            end
        end
    end
           
    for i =1:size(indices, 2)
        if(indices(i))
            area = area + requests(indices(i), 2);
        end
    end

    area = prev_area + area;
    real_ind = find(indices);

    if(area < F*T)
        if(size(previous_combinations, 1))
            new_combination = previous_combinations;
        else
            new_combination = zeros(1, size(requests, 1));
        end
        
        for i=1:size(real_ind, 2)
            new_combination(1, real_ind(i)) = 1;
        end
        
        combinations = [previous_combinations; new_combination ];
    end
    
    if(size(real_ind, 2) > 1)
        new_indices = nchoosek(real_ind, size(real_ind, 2)-1);
        
        for i = 1:size(new_indices, 1)
            
            check_indices = zeros(1, size(requests, 1));
            for j=1:size(new_indices, 2)
                check_indices(1, new_indices(i, j)) =new_indices(i, j);                
            end
            combinations = [combinations; check_area(check_indices, previous_combinations, requests, F, T )];
            combinations = unique(combinations, 'rows');
        end
    end  
end

