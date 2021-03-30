function [ greedy_substrate indices best_combination] = greedy_allocation(current_combinations, G_requests, F, T)
%GREEDY_ALLOCATION Summary of this function goes here
%   Detailed explanation goes here
    
    indices = [];
    remove_indices = [];
    greedy_substrate = zeros(F, T);
    dimensions = [];
    smallest = F*T;
    largest_area = 0;
    combinations_EDI = [];
    best_EDI = F*T*4;
    best_combination = [];
    
    
    for j=1:size(current_combinations, 1)
        
        area = 0;
        test_substrate = zeros(F, T);
        test_indices = [];
        
        for i=1:size(current_combinations, 2)
            if(current_combinations(j, i) ~= 0)
                [test_substrate success ] = dynamic_karnaugh_map_embedding(G_requests(i, :), test_substrate);
                if(success)
                   area = area +G_requests(i, 2);
                   test_indices = [test_indices; i];
                end
            end
        end
        if(area > largest_area)
           largest_area = area;
           best_combination = current_combinations(j, :);
           greedy_substrate = test_substrate;
           indices = test_indices;
        end
    end
    
    
    
%     for j=1:size(current_combinations, 1)
%         
% %         j=1;
%        
%         current_indices = [];
% %        
%             f_largest = 1;
%             t_largest = 1;
%             test_indices = [];
%             test_substrate = zeros(F, T);
%             area = 0;
%             temp_smallest = F*T;     
%             current_success = true;
%             for i=1:size(current_combinations, 2)
%                 
% 
%                 [f_dim, t_dim, success] = find_dimension(test_substrate, current_combinations(j, i), G_requests(i, 5)-1, G_requests(i, 6)-1, f_largest, t_largest);
%                 if (success)
%                     test_substrate(f_dim:f_dim + G_requests(i, 5)-1, t_dim:t_dim + G_requests(i, 6)-1) = G_requests(i, 7);
%                     test_indices = [test_indices; i];
% 
%                     if(f_dim + G_requests(i, 5)-1 > f_largest)
%                         f_largest = f_dim+G_requests( i, 5)-1;
%                     end
%                     if(t_dim+ G_requests(i, 6)-1 > t_largest)
%                         t_largest = t_dim + G_requests( i, 6)-1;
%                     end  
%                     area = area +G_requests(i, 2);
%                     
%                 else
%                      current_success=false;
%                      break; 
%                 end       
%             end   
%             
%            if(area > largest_area)
%                largest_area = area;
%                if( temp_smallest <= smallest)
%                    smallest = temp_smallest;
%                end
%            end
%       
%             if(EDI(test_substrate)<best_EDI)
%                 greedy_substrate = test_substrate;
%                 best_EDI = EDI(test_substrate);
%             end
%                 
% 
%             if(current_success==true)
%           
%                 combinations_EDI = [combinations_EDI; EDI(test_substrate)];
%             end;
% 
%               
%         dimensions = [dimensions; f_largest*t_largest];
%     end
%     
% %     for j=1:size(current_combinations, 1)  
% %         area = 0;
% %         for i=1:size(current_combinations, 2)
% %              if(current_combinations(j, i) ~=0)
% %                  area = area +G_requests(i, 2);
% %              end
% %         end
% %         if(area<largest_area)
% %             remove_indices = [remove_indices; j];
% %         end
% %     end
%     
% %     current_combinations = setdiff(current_combinations, current_combinations(remove_indices, :), 'rows');
% %     dimensions = setdiff(dimensions, dimensions(remove_indices, :), 'rows');
%     
% %     [dimensions idx] = sort(dimensions, 'descend');
%     [combinations_EDI idx] = sort(combinations_EDI);
%     current_combinations = current_combinations(idx, :);
%          
%     
%     indices2 = [];
%     previous = 0;
% %     if(size(combinations_EDI, 1))
% %         smallest = combinations_EDI(1);
% %     end
% % (combinations_EDI(i) ~= smallest)&
% 
%     for i=1:size(combinations_EDI)
%         if(combinations_EDI(i) == previous)
%             indices2 = [indices2, i];
%         end
%         previous = combinations_EDI(i);
%     end
%     
%     current_combinations = setdiff(current_combinations, current_combinations(indices2, :), 'rows');

end

