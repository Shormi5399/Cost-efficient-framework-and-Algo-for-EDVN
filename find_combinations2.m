function [possible_combinations] = find_combinations2( available_list, existing_combinations, requests, limit_F, limit_T)
% guarenteed,
%CHECK_COMBOS Summary of this function goes here
%   Detailed explanation goes here
    possible_combinations= existing_combinations;

    if(size(available_list, 2) ==1)&(size(existing_combinations, 1) ==0)
            possible_combinations = zeros(2, size(requests, 1));
            possible_combinations(1, available_list) = 1;
            possible_combinations(2, available_list) = 2;      
        return;
    end

  combinations= existing_combinations;
  
   for i=1:size(available_list, 2)
        
       new_list = setdiff(available_list, available_list(i));
       
        if((requests(available_list(i),5)<=limit_F)&&(requests(available_list(i),6)<=limit_T))
            
            if(size(available_list, 2) ~=1)
                combinations = find_combinations2(new_list, existing_combinations, requests, limit_F, limit_T);
                combinations = unique(combinations, 'rows');
            
                possible_combinations = [possible_combinations ;combinations];
            end
                   
            for j=1:size(combinations, 1)
              
              F_size = 0;
              T_size = 0;
              T_size = 0;
              T_size = 0;
              small = [];
               
              for k=1:size(combinations, 2)  
                  if(combinations(j,k) == 1)
                      
                      if(F_size + requests(k, 5) <=limit_F)
                           F_size = F_size + requests(k, 5);
                           small = [small; requests(k, 5), requests(k, 6)];
                           if(requests(k, 6)>T_size)
                               T_size = requests(k, 6);
                           end
                      else
                          if(size(small, 1))
                            small = sortrows(small, 2);
                          end
                          found =false;
                           for l =1:size(small, 1)       
                               if(requests(k, 5) == small(l, 1))&(small(l, 2) + requests(k, 6) <=limit_T)
                                   found = true;
                                   small(l, 2) = small(l, 2)+requests(k, 6);
                                   if(small(l, 2) > T_size)
                                       T_size = small(l, 2);
                                   end
                                   break
                               end           
                           end
                           if(found ~= true)
                               for l =1:size(small, 1)                 
                                   if(requests(k, 5) < small(l, 1))&(small(l, 2) + requests(k, 6) <=limit_T)
                                       small = [small; small(l, 1) - requests(k, 5), small(l, 2)];
                                       small(l, 2) = small(l, 2)+requests(k, 6);
                                       small(l, 1) = requests(k, 5);     
                                       if(small(l, 2) > T_size)
                                           T_size = small(l, 2);
                                       end
                                       break;
                                   end           
                               end  
                           end
                      end
                      
                
                  elseif(combinations(j, k)==2)
                      if(T_size + requests(k, 6) <=limit_T)
                           T_size = T_size + requests(k, 6);
                           small = [small; requests(k, 5), requests(k, 6)];
                           if(requests(k, 5)>F_size)
                               F_size = requests(k, 5);
                           end
                      else
                          if(size(small, 1))
                            small = sortrows(small, 1);
                          end
                          found = false;
                           for l =1:size(small, 1)       
                               if(requests(k, 6) == small(l, 2))&(small(l, 1) + requests(k, 5) <=limit_F)      
                                   found = true;
                                   small(l, 1) = small(l, 1)+requests(k, 5);
                                   if(small(l, 1) > F_size)
                                       F_size = small(l, 1);
                                   end
                                   break
                               end           
                           end
                           if(found~=false)
                               for l =1:size(small, 1)                 
                                   if(requests(k, 6) < small(l, 2))&(small(l, 1) + requests(k, 5) <=limit_F)      
                                       small = [small; small(l, 1), small(l, 2)- requests(k, 6)];
                                       small(l, 1) = small(l, 2)+requests(k, 5); 
                                       small(l, 2) = requests(k, 6);
                                       if(small(l, 1) > F_size)
                                           F_size = small(l, 1);
                                       end
                                       break;
                                   end           
                               end 
                           end
                      end
                      
                  end
              end              
                      
              if(requests(available_list(i),5) + F_size<=limit_F)&(requests(available_list(i),6)<=limit_T)
                   
                  indeces = combinations(j, :);
                  indeces(1, available_list(i)) = 1;
                  possible_combinations = [possible_combinations; indeces];
              else
                   for l =1:size(small, 1)       
                       if(requests(k, 6) <= small(l, 2))&(requests(available_list(i),6)<=limit_T)          
                           indeces = combinations(j, :);
                           indeces(1, available_list(i)) = 1;
                           possible_combinations = [possible_combinations; indeces];
                           if(small(l, 2) > T_size)
                              T_size = small(l, 2);
                           end
                           break;
                       end           
                   end
              end
              
              if(requests(available_list(i),5)<=limit_F)&(requests(available_list(i),6)+T_size<=limit_T)
                  
                  indeces = combinations(j, :);
                  indeces(1, available_list(i)) = 2;
                  possible_combinations = [possible_combinations; indeces];
              else
                   for l =1:size(small, 1)       
                       if(requests(k, 5) <= small(l, 1))&(requests(available_list(i),6)+T_size<=limit_T)
                           indeces = combinations(j, :);
                           indeces(1, available_list(i)) = 2;
                           possible_combinations = [possible_combinations; indeces];
                           if(small(l, 1) > F_size)
                              F_size = small(l, 1);
                           end
                           break;
                       end           
                   end
              end

            end
            possible_combinations = unique(possible_combinations, 'rows');
        end
   end           
             % available_list(setdiff(1:size(available_list, 1), i), :);
         
   %additional_requests = available_list(setdiff(1:size(available_list, 1), current_combination), :);

end

% PriorityArea Timeslot Duration Frequency Time ID Operator
