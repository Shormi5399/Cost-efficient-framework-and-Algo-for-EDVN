function [ i, j, success] = find_dimension2( substrate, dimension, f, t, f_largest, t_largest)
%FIND_DIMENSION Summary of this function goes here
%   Detailed explanation goes here
    success = false;
    
%     if(t_largest > size(substrate, 2)-t)
%         t_largest = size(substrate, 2)-t;
%     end
%     
%     if(f_largest > size(substrate, 1)-f)
%         f_largest = size(substrate, 1)-f;
%     end
    
    if(dimension ==1)
        for j = 1:(size(substrate, 2)-t)
            for i = 1: (size(substrate, 1)-f)
                if(substrate(i:i+f, j:j+t) == 0)
                    success = true;
                    return;
                end
            end
        end
%         for i = 1: (size(substrate, 1)-f)
%             for j = t_largest:(size(substrate, 2)-t)
%                 if(substrate(i:i+f, j:j+t) == 0)
%                     success = true;
%                     return;
%                 end
%             end
%         end    
    elseif(dimension == 2)
        for i = 1:(size(substrate, 1)-f)
            for j = 1: (size(substrate, 2)-t) 
                if(substrate(i:i+f, j:j+t) == 0)
                    success = true;
                    return;
                end
            end
        end
%         for j = 1: (size(substrate, 2)-t)
%             for i = f_largest: (size(substrate, 1)-f)
%                 if(substrate(i:i+f, j:j+t) == 0)
%                     success = true;
%                     return;
%                 end
%             end
%          end
    end
end

