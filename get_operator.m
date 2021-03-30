function [ operator ] = get_operator()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
   r = randi(1000, 1);
   
   if(r <= 400)
       operator = 1;
   elseif(r<=800)
       operator = 2;
   elseif(r<=1000)
       operator = 3;
   end
   

end

