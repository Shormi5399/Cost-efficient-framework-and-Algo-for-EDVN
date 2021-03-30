M = 10;
N = 5;

%[priority PRB_freq*PRB_time timeslot duration PRB_freq PRB_time id operator]
first_requests = [1 1 1 5 1 1 1 1; 1 1 1 2 1 1 2 1; 1 6 1 9 2 3 3 2; 1 6 1 10 3 2 4 2 ];
second_requests = [2 10 1 8 2 5 5 1; 2 4 1 5 1 4 6 1; 2 3 1 6 1 3 7 2];
third_requests = [3 12 1 7 4 3 8 1; 3 4 1 6 2 2 9 2; 3 1 1 5 1 1 10 1];

% first_requests = [1 1 1 5 1 1 1 1; 1 1 1 2 1 1 2 1; 1 6 1 9 2 3 3 2; 1 6 1 10 3 2 4 2; 3 12 1 7 4 3 8 1; 3 4 1 6 2 2 9 2; 3 6 1 5 3 2 10 1]; 

satisfied_requests = [];
tic
[optimal_substrate, satisfied_requests] = optimal_embedding(first_requests, satisfied_requests, M, N);
[optimal_substrate, satisfied_requests] = optimal_embedding(third_requests, satisfied_requests, M, N);
[optimal_substrate, satisfied_requests] = optimal_embedding(second_requests, satisfied_requests, M, N);
toc


