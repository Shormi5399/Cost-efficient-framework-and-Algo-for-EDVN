function [K] = FindKarnaughRegions( M, minSize )
%FindKarnaughRegions Find rectangular areas in a Boolean Matrix
%   input:  M       - 2D Boolean matrix 
%           minSize - [height width] - minimum width and height on regions of 
%                     interest (used to restrict final choise)
%   output: K       - Vector of rectangular Karnaugh areas
%                   - The Vector is of the form:
%                     (row_index, column_index, row_length, column_length, area)
%                   

[nR, nC] = size(M);
minHeight = minSize(1);
minWidth = minSize(2);

K = [];
C_H = zeros(nR, nC);
C_V = zeros(nR, nC);

for r = 1:nR                    % For each element in the Matrix
    for c = 1:nC
        if (M(r, c) == 0)
%             &&((C_V(r, c)~=1)&&(C_H(r, c)~=1))       % if the cell is empty
            
            c_border = c;
            r_border = r;
                                % Find the horizontal border
            while((c_border < nC) && (M(r, c_border+1) == 0)) 
                c_border = c_border + 1;
            end
                                % Find the vertical border
            while((r_border < nR)&&(M(r_border+1, c) == 0))
                r_border = r_border + 1;
            end
            
            if((c_border - c >= minWidth-1)&&(r_border - r >= minHeight-1))
                
                                    % Starting from the largest possible hole
                for r_index = r_border:-1:r+minHeight-1
                    for c_index = c_border:-1:c+minWidth-1

                                    % Check if it is a viable Karnaugh region
                        contained =0;
                        if (M(r:r_index, c:c_index)== 0)
%                                 Check that it is not contained in another
%                                 region in the list
                            if (~isempty(K))
                                for K_index = 1:size(K,1)
                                    if((K(K_index, 1)<=r)&&(K(K_index, 2)<=c)&&((K(K_index, 1)+K(K_index, 3))>=r_index)&& ((K(K_index, 2) +K(K_index, 4)) >=c_index))
                                        contained =1;
                                    end
                                end
                            end
%                                 If not contained, add to the list
                            if(contained ==0)
                                K = [K; [r, c, (r_index - r), (c_index - c),(r_index - r +1)*(c_index - c +1)]];
                            end
                            
                        end              
                    end
                end
                
%                 C_V(r:r_border, c) = 1;
%                 C_H(r, c:c_border) = 1;
            end
        end
    end
end










