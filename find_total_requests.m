
% Iterations
iterations = 1000;
filename = 'small_dist_02_03_05.txt';
linenumber = 1;
waiting_time_3 = 3;

% Substrate resources
number_of_VMOs = 3;

total_requests_1= zeros(iterations, number_of_VMOs);
total_requests_2= zeros(iterations, number_of_VMOs);
total_requests_3= zeros(iterations, number_of_VMOs);

fileID = fopen(filename);
% text = textscan(fileID, '%s', 8, 'delimiter', '|');
% Requests = textscan(fileID, '%d %d %d %d %d %d %d %d', 'CollectOutput', 1);
Requests = csvread(filename);
% Priority Area Timeslot Duration Frequency Time ID Operator
fclose(fileID);

number_of_Requests = size(Requests(:, 1));


for timeslot = 1:iterations
    

    linestart = linenumber;
    while((Requests(linenumber, 3) == timeslot)&&(linenumber~=number_of_Requests(1, 1)))
        linenumber = linenumber +1;
    end
    
    new_requests = [Requests(linestart:linenumber-1, :)];
    
    if(timeslot <=iterations)
        for i=1:size(new_requests)
            operator = new_requests(i, 8);
            if(new_requests(i, 1)==1)
                total_requests_1(timeslot, operator) = total_requests_1(timeslot, operator) + new_requests(i, 2)*new_requests(i, 4);
            elseif(new_requests(i, 1)==2)
                total_requests_2(timeslot, operator) = total_requests_2(timeslot, operator) + new_requests(i, 2)*new_requests(i, 4);
            elseif(new_requests(i, 1)==3)
                total_requests_3(timeslot, operator) = total_requests_3(timeslot, operator) + new_requests(i, 2)*new_requests(i, 4);
            end
        end
    end
end

% sum(total_requests_1(:, :))
sum(sum(total_requests_1) +sum(total_requests_2) + sum(total_requests_3))