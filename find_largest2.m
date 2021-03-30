function [combinations ] = find_largest2( current_combinations, G_requests, F, T )
% dimensions total
%FIND_LARGEST Summary of this function goes here
%   Detailed explanation goes here
    smallest_F= F;
    smallest_T = T;
    largest_area = 0;
    combinations = [];
%     total = [];
    
    % find largest area
    
    for i=1:size(current_combinations, 1)
         area = 0;
        for j=1:size(G_requests, 1)
            if(current_combinations(i, j) ~=0)
                area = area +G_requests(j, 2); 
            end
        end
        
        if(area >= largest_area)
            largest_area = area;
        end
    end
    
    % select combinations with largest area
    for i=1:size(current_combinations, 1)
        area = 0;
        indices=[];
        for j=1:size(G_requests, 1)
           if(current_combinations(i, j) ~=0)
               area = area +G_requests(j, 2);
               indices = [indices j];
           end
        end
        if(area ==largest_area)
           combinations = [combinations; current_combinations(i, :)];
%            total = [total; indices];
        end
    end
    
    % sort by smallest total dimensions
%     index = ones(size(combinations, 1),1);
%     dimensions = ones(size(combinations, 1), 2);
    
%     for i=1:size(combinations)
%          F_sum = G_requests(1, 5);
%          T_sum= G_requests(1, 6);
%          FF_small = [G_requests(1, 5)];
%          FT_small = [G_requests(1, 6)];
%         for j=2:size(G_requests, 1)
%             if(combinations(i, j) ==1)
%                 F_sum1 = F_sum-FF_small(1);
%                 if (G_requests(j, 5) > FF_small(1)) FF_small(1) = G_requests(j, 5); end;
%                 if(G_requests(j, 6) + FT_small(1) < T_sum)
%                     FT_small(1)=FT_small(1) + G_requests(j, 6);
%                     F_sum = F_sum1 + FF_small(1);
%                 else
%                     F_sum=F_sum + G_requests(j, 5);  
%                 end
%                 if(G_requests(j, 6)>T_sum)
%                     T_sum = G_requests(j, 6);
%                 elseif(G_requests(j, 6)<T_sum)
%                     FF_small = [FF_small; G_requests(j, 5)];
%                     FT_small = [FT_small; G_requests(j, 6)];                    
%                 end
%                 [FT_small idx] = sort(FT_small);
%                 FF_small = FF_small(idx, :);
%                 
%             elseif(combinations(i, j) ==2)  
%                 if(G_requests(j, 5)>F_sum)
%                     F_sum = G_requests(j, 5);
%                 end
%                 T_sum= T_sum + G_requests(j, 6);
%             end 
%         end
% %         dimensions(i, 1) = F_sum;
% %         dimensions(i, 2) = T_sum;
%         index(i, 1) = F_sum*T_sum;
%     end
%     
%     [index, idx] = sort(index);
%     combinations = combinations(idx, :);
%     dimensions = dimensions(idx, :);
    
end

