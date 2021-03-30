function [ substrate, satisfied_requests, indeces ] = optimal_embedding( dynamic_requests, previous_requests, DF, DT )

%OPTIMAL_EMBEDDING Finds the most optimal embedding of the set of requests
%Sk at priority k using Cplex

%   INPUT: dynamic_requests: set of requests with priority k (Sk)
%   INPUT: previous_requests: set of satisfied requests with priorities < k (Pk)
%   INPUT: DF: total number of frequency blocks (M)
%   INPUT: DT: total number of time blocks (N)
%   OUTPUT: substrate: the substrate with the embedded requests in the most
%   optimal locations
%   OUTPUT: satisfied_requests: set of satisfied requests 

satisfied_requests = [];
substrate = zeros(DF, DT);
b_substrate = zeros(DF, DT);
indeces = 0;

S = size(dynamic_requests, 1);
P = size(previous_requests, 1);

if(size(previous_requests, 1) ~= 0)
    total_requests = [previous_requests; dynamic_requests];
else
    total_requests = dynamic_requests;
end

b_offset = DF*DT*(P+S);
s_offset= DF*DT*P;


f = [ones(b_offset, 1); zeros(b_offset, 1)];

%% Less than or equal constraints

% Avoid overlap - Constraint on a
A = zeros(DF*DT, b_offset*2);
for i=1:P+S
    for j=1:DF*DT
        A(j, j+(i-1)*DF*DT) = 1;
    end
end
B = ones(DF*DT, 1);

% % Avoid overlap - Constraint on b
% A2 = zeros(DF*DT, b_offset*2);
% for i=1:P+S
%     for j=1:DF*DT
%         A2(j, b_offset + j+(i-1)*DF*DT) = 1;
%     end
% end
% B2 = ones(DF*DT, 1);
% 
% A=[A; A2];
% B=[B; B2];
% 
% clear A2;
% clear B2;

% At most one b per new requests - constraint on b
A2 = zeros(S, b_offset*2);
for i=1:S
    A2(i,b_offset + s_offset + 1+(i-1)*DF*DT:b_offset + s_offset + + DF*DT+(i-1)*DF*DT) = 1;
end
B2 = ones(S, 1);

A=[A; A2];
B=[B; B2];

clear A2;
clear B2;


% Shape constraint- Constraint on a and b

% no_of_possible_locations = 0;
% 
% for i=1:P+S
%     no_of_possible_locations = no_of_possible_locations + (DF-total_requests(i, 5)+1)*(DT-total_requests(i, 6)+1);
% end
% 
% next_request = 0;
% A2 = zeros(no_of_possible_locations, b_offset*2);
% B2 = zeros(no_of_possible_locations, 1);
% 
% for i=1:P+S
%     
%     x_size = total_requests(i, 5)-1;
%     y_size = total_requests(i, 6)-1;
%     
%     for j=1:DF-x_size
%         for k=1:DT-y_size
%             starting_point = (i-1)*DF*DT+(j-1)*(DT) +k;
%             for x=0:x_size
%                 for y=0:y_size
%                     A2(next_request + (j-1)*(DT-y_size) +k, starting_point+x*DT +y)  = -1;
% %                     A2(next_request + (j-1)*(DT-y_size) +k, b_offset + starting_point +x*DT+y) = (x_size+1)*(y_size+1);
% %                     A2(no_of_possible_locations + next_request + (j-1)*(DT-y_size) +k, starting_point+x*DT +y)  = -1;
% %                     A2(no_of_possible_locations + next_request + (j-1)*(DT-y_size) +k, b_offset + starting_point) = (x_size+1)*(y_size+1);
%                 end
%             end
%             A2(next_request + (j-1)*(DT-y_size) +k, b_offset + starting_point) = (x_size+1)*(y_size+1);
%         end
%     end
%     next_request = next_request + (DF-x_size)*(DT-y_size);
%     
% end
% 
% A=[A; A2];
% B=[B; B2];
% 
% clear A2;
% clear B2;

% Location of b's constraint and shape - contraint on a and b

next_request = 0;
A2 = zeros(DF*DT*(S+P), b_offset*2);
B2 = zeros(DF*DT*(S+P), 1);

for i=1:P+S
    
    x_size = total_requests(i, 5)-1;
    y_size = total_requests(i, 6)-1;
    
    for j=1:DF
        for k=1:DT
            starting_point = (i-1)*DF*DT+(j-1)*(DT) +k;
            bound1 = 0;
            bound2 = 0;
            
            if(j+x_size > DF)
                bound1 = j+x_size-DF;
            end
            if(k+y_size > DT)
                bound2 = k+y_size-DT;
            end
            
            for x=0:x_size-bound1
                for y=0:y_size-bound2
                    A2(next_request + (j-1)*(DT) +k, starting_point+x*DT +y)  = -1;
%                     A2(no_of_possible_locations + next_request + (j-1)*(DT-y_size) +k, starting_point+x*DT +y)  = -1;
%                     A2(no_of_possible_locations + next_request + (j-1)*(DT-y_size) +k, b_offset + starting_point) = (x_size+1)*(y_size+1);
                end
            end
            A2(next_request + (j-1)*(DT) +k, b_offset + starting_point) = (x_size+1)*(y_size+1) - bound1*bound2;
        end
    end
    next_request = next_request + (DF)*(DT);
    
end

A=[A; A2];
B=[B; B2];

clear A2;
clear B2;

%% Equal constraints

% Previous requests must be embedded - Constraint on b
C = zeros(P, b_offset*2);
for i=0:P-1
    C(i+1,b_offset +1+i*DF*DT: b_offset +DF*DT+i*DF*DT) = 1;
end
D = ones(P, 1);

% Only allow a's if we have a b - Constraint on a and b

C2 = zeros((S+P), b_offset*2);

for i=1:P+S
    C2(i, 1+(i-1)*DF*DT : DF*DT+(i-1)*DF*DT)=1;
    C2(i, b_offset + 1 +(i-1)*DF*DT: b_offset + DF*DT + (i-1)*DF*DT)=-total_requests(i, 5)*total_requests(i, 6);
end

D2 = zeros((S+P), 1);

C = [C;C2];
D = [D; D2];

clear C2;
clear D2;

% next_request = 0;
% C2 = zeros(no_of_possible_locations, b_offset*2);
% D2 = zeros(no_of_possible_locations, 1);

% for i=1:P+S
%     
%     x_size = total_requests(i, 5)-1;
%     y_size = total_requests(i, 6)-1;
%     
%     for j=1:DF-x_size
%         for k=1:DT-y_size
%             starting_point = (i-1)*DF*DT+(j-1)*(DT) +k;
%             for x=0:x_size
%                 for y=0:y_size
%                     C2(next_request + (j-1)*(DT-y_size) +k, starting_point+x*DT +y)  = 1;
% %                     C2(next_request + (j-1)*(DT-y_size) +k, b_offset + starting_point +x*DT+y) = -(x_size+1)*(y_size+1);
%                 end
%             end
%             C2(next_request + (j-1)*(DT-y_size) +k, b_offset + starting_point) = -(x_size+1)*(y_size+1);
%         end
%     end
%     next_request = next_request + (DF-x_size)*(DT-y_size);
%     
% end
% 
% C = [C;C2];
% D = [D; D2];
% 
% clear C2;
% clear D2;

[result, utility] = cplexbilp(-f, A, B, C, D);

clear A;
clear B;
clear C;
clear D;

for i=1:P+S
    satisfied = false;
    for j=1:DF
        for k=1:DT
            if(result((i-1)*DF*DT + (j-1)*DT +k, 1) == 1)
%                 substrate(j, k) = count+1;
                substrate(j, k) = total_requests(i, 7);
                satisfied = true;
            end
            if(result((i-1)*DF*DT + (j-1)*DT +k +b_offset, 1) == 1)
                b_substrate(j, k) = total_requests(i, 7);
            end
        end
    end
    if(satisfied == true);
        satisfied_requests = [satisfied_requests; total_requests(i, :)];
        if(i > P)
           indeces = [indeces; (i-P)];
        end
    end
end

% substrate
% b_substrate
% utility

end

