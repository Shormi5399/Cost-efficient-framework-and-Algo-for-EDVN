% Generate a set of virtual network requests and write to file

iterations = 1000;
filename = 'small_dist_02_03_05.txt';

% VN Requests
VN_frequency_min = 1;
VN_frequency_max = 3;
VN_time_min = 1;
VN_time_max = 3;
VN_priority_min = 1;
VN_priority_max = 3;

% Average lifespan of VN requests (mu)
average_lifespan = 10;

% Average number of VN arrivals (lambda)
average_arrivals = 3;

fileID = fopen(filename,'w');
fprintf(fileID,'Priority | Area | Timeslot | Duration | Frequency | Time | ID | Operator\n');

request_id = 1;

for time_window = 1:iterations
% Number of new requests
        Number_of_VN_arrivals = poissrnd(average_arrivals);

        % Create a number of new VN requests
        if Number_of_VN_arrivals > 0

            % VN_requests have area, duration, and priority level
            

            for vn_requests = 1:Number_of_VN_arrivals
                
                New_VN_requests = zeros(1, 7);
                
                num = randi([1, 100], 1, 1);
                
                if(num < 20)
                New_VN_requests(1, 1) = 1;
                elseif(num<50)
                New_VN_requests(1, 1) = 2;
                else
                New_VN_requests(1, 1) = 3;
                end
                
%                 New_VN_requests(1, 1) = randi([VN_priority_min, VN_priority_max], 1, 1);          
                New_VN_requests(1, 5) = randi([VN_frequency_min, VN_frequency_max], 1, 1);
                New_VN_requests(1, 6) = randi([VN_time_min, VN_time_max], 1, 1);
                New_VN_requests(1, 2) = New_VN_requests(1, 5)*New_VN_requests(1, 6);
                New_VN_requests(1, 3) = time_window;
                New_VN_requests(1, 4) = round(exprnd(average_lifespan));
                New_VN_requests(1, 7) = request_id;
                New_VN_requests(1, 8) = get_operator();

                if New_VN_requests(1, 4) == 0
                    New_VN_requests(1, 4) = 1;
                end
                 fprintf(fileID,'%d   %2d   %3d   %2d   %d   %d   %d   %d\n',New_VN_requests);
                 
                 request_id = request_id +1;
            end
           
        end
end
fclose(fileID);
        
