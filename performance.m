%% Performance

% % set(0,'defaulttextinterpreter','latex');
% set(0,'DefaultTextFontname', 'Arial');
% set(0,'DefaultAxesFontName', 'Arial');

iterations = 1000;
reject_rate_timeslot = zeros(iterations, 6);
every_x_point = 5;


run2 = true;

for i=1:iterations
        
    Average_reject_rate(i, 1) = sum(sum(K_rejected_1(1:i, :)))/sum(sum(total_requests_1(1:i, :)));
    Average_reject_rate(i, 2) = sum(sum(K_rejected_2(1:i, :)))/sum(sum(total_requests_2(1:i, :)));
    Average_reject_rate(i, 3) = sum(sum(K_rejected_3(1:i, :)))/sum(sum(total_requests_3(1:i, :)));
    Average_reject_rate(i, 4) = sum(sum(G_rejected_1(1:i, :)))/sum(sum(total_requests_1(1:i, :)));
    Average_reject_rate(i, 5) = sum(sum(G_rejected_2(1:i, :)))/sum(sum(total_requests_2(1:i, :)));
    Average_reject_rate(i, 6) = sum(sum(G_rejected_3(1:i, :)))/sum(sum(total_requests_3(1:i, :)));
    Average_reject_rate(i, 7)= sum(sum(S_O_rejected_1(1:i, :)))/sum(sum(total_requests_1(1:i, :)));
    Average_reject_rate(i, 8) = sum(sum(S_O_rejected_2(1:i, :)))/sum(sum(total_requests_2(1:i, :)));
    Average_reject_rate(i, 9) = sum(sum(S_O_rejected_3(1:i, :)))/sum(sum(total_requests_3(1:i, :)));
    Average_reject_rate(i, 10) = sum(sum(D_rejected_1(1:i, :)))/sum(sum(total_requests_1(1:i, :)));
    Average_reject_rate(i, 11) = sum(sum(D_rejected_2(1:i, :)))/sum(sum(total_requests_2(1:i, :)));
    Average_reject_rate(i, 12) = sum(sum(D_rejected_3(1:i, :)))/sum(sum(total_requests_3(1:i, :)));
    Average_reject_rate(i, 13) = sum(sum(DE_rejected_1(1:i, :)))/sum(sum(total_requests_1(1:i, :)));
    Average_reject_rate(i, 14) = sum(sum(DE_rejected_2(1:i, :)))/sum(sum(total_requests_2(1:i, :)));
    Average_reject_rate(i, 15) = sum(sum(DE_rejected_3(1:i, :)))/sum(sum(total_requests_3(1:i, :)));
    Average_reject_rate(i, 16) = sum(sum(D_O_rejected_1(1:i, :)))/sum(sum(total_requests_1(1:i, :)));
    Average_reject_rate(i, 17) = sum(sum(D_O_rejected_2(1:i, :)))/sum(sum(total_requests_2(1:i, :)));
    Average_reject_rate(i, 18) = sum(sum(D_O_rejected_3(1:i, :)))/sum(sum(total_requests_3(1:i, :)));
    Average_reject_rate_all(i, 1) = (sum(sum(K_rejected_1(1:i, :)))+sum(sum(K_rejected_2(1:i, :)))+sum(sum(K_rejected_3(1:i, :))))/(sum(sum(total_requests_1(1:i, :)))+sum(sum(total_requests_2(1:i, :)))+sum(sum(total_requests_3(1:i, :))));
    Average_reject_rate_all(i, 2) = (sum(sum(G_rejected_1(1:i, :)))+sum(sum(G_rejected_2(1:i, :)))+sum(sum(G_rejected_3(1:i, :))))/(sum(sum(total_requests_1(1:i, :)))+sum(sum(total_requests_2(1:i, :)))+sum(sum(total_requests_3(1:i, :))));
    Average_reject_rate_all(i, 3) = (sum(sum(S_O_rejected_1(1:i, :)))+sum(sum(S_O_rejected_2(1:i, :)))+sum(sum(S_O_rejected_3(1:i, :))))/(sum(sum(total_requests_1(1:i, :)))+sum(sum(total_requests_2(1:i, :)))+sum(sum(total_requests_3(1:i, :))));
    Average_reject_rate_all(i, 4) = (sum(sum(D_rejected_1(1:i, :)))+sum(sum(D_rejected_2(1:i, :)))+sum(sum(D_rejected_3(1:i, :))))/(sum(sum(total_requests_1(1:i, :)))+sum(sum(total_requests_2(1:i, :)))+sum(sum(total_requests_3(1:i, :))));
    Average_reject_rate_all(i, 5) = (sum(sum(DE_rejected_1(1:i, :)))+sum(sum(DE_rejected_2(1:i, :)))+sum(sum(DE_rejected_3(1:i, :))))/(sum(sum(total_requests_1(1:i, :)))+sum(sum(total_requests_2(1:i, :)))+sum(sum(total_requests_3(1:i, :))));
    Average_reject_rate_all(i, 6) = (sum(sum(D_O_rejected_1(1:i, :)))+sum(sum(D_O_rejected_2(1:i, :)))+sum(sum(D_O_rejected_3(1:i, :))))/(sum(sum(total_requests_1(1:i, :)))+sum(sum(total_requests_2(1:i, :)))+sum(sum(total_requests_3(1:i, :))));
    
%     reject_rate_timeslot(i, 1) = sum(K_rejected_1(i, :)) + sum(K_rejected_2(i, :)) + sum(K_rejected_3(i, :));
%     reject_rate_timeslot(i, 2) = sum(KE_rejected_1(i, :)) + sum(KE_rejected_2(i, :)) + sum(KE_rejected_3(i, :));
%     reject_rate_timeslot(i, 3) = sum(S_O_rejected_1(i, :)) + sum(S_O_rejected_2(i, :)) + sum(S_O_rejected_3(i, :));
%     reject_rate_timeslot(i, 4) = sum(D_rejected_1(i, :)) + sum(D_rejected_2(i, :)) + sum(D_rejected_3(i, :));
%     reject_rate_timeslot(i, 5) = sum(DE_rejected_1(i, :)) + sum(DE_rejected_2(i, :)) + sum(DE_rejected_3(i, :));
%     reject_rate_timeslot(i, 6) = sum(D_O_rejected_1(i, :)) + sum(D_O_rejected_2(i, :)) + sum(D_O_rejected_3(i, :));
       
%         Average_reject_rate(i, 1) = sum(K_rejected_1(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 2) = sum(D_rejected_1(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 3) = sum(O_rejected_1(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 4) = sum(K_rejected_2(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 5) = sum(D_rejected_2(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 6) = sum(O_rejected_2(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 7) = sum(K_rejected_3(i, :)/total_requests(i, :));       
%         Average_reject_rate(i, 8) = sum(D_rejected_3(i, :)/total_requests(i, :));
%         Average_reject_rate(i, 9) = sum(O_rejected_3(i, :)/total_requests(i, :));

end

for i=1:iterations

        occupied_area(i, 1) = K_occupied_area(i);
        occupied_area(i, 2) = G_occupied_area(i);
        occupied_area(i, 3) = S_O_occupied_area(i);
        occupied_area(i, 4) = D_occupied_area(i);
        occupied_area(i, 5) = DE_occupied_area(i);
        occupied_area(i, 6) = D_O_occupied_area(i);
        
        revenue(i, 1) = sum(K_revenue(1:i))/i;
        revenue(i, 2) = sum(G_revenue(1:i))/i;
        revenue(i, 3) = sum(S_O_revenue(1:i))/i;
        revenue(i, 4) = sum(D_revenue(1:i))/i;
        revenue(i, 5) = sum(DE_revenue(1:i))/i;
        revenue(i, 6) = sum(D_O_revenue(1:i))/i;
end



% if(run2 == false)
%     figure(1); title('Reject Rate 1');
% else
%     figure(7); title('Reject Rate 1'); 
% end
% 
% %     subplot(5, 1, 5);
%     plot(1:every_x_point:iterations, Average_reject_rate(1:every_x_point:end, [1 4 7 10 13 16]));
%     hleg = legend('Static K-maps', 'Static MinEDI', 'Optimal_S',  'Dynamic K-maps', 'Dynamic MinEDI', 'Optimal D',  'Location','SouthEast');
%     xlabel('Timeslots');
%     ylabel('Reject Rate 1');
% 
%  
% if(run2 == false)
%     figure(2); title('Reject Rate 2');
% else
%     figure(8); title('Reject Rate 2'); 
% end 
% 
%     plot(1:every_x_point:iterations, Average_reject_rate(1:every_x_point:end, [2 5 8 11 14 17]));
%     hleg = legend('Static K-maps', 'Static MinEDI', 'Optimal S', 'Dynamic K-maps', 'Dynamic MinEDI', 'Optimal D',  'Location','SouthEast');
%     xlabel('Timeslots');
%     ylabel('Reject Rate 2');
%     
%     
% if(run2 == false)
%     figure(3); title('Reject Rate 3');
% else
%     figure(9); title('Reject Rate 3'); 
% end
%    
%     plot(1:every_x_point:iterations, Average_reject_rate(1:every_x_point:end, [3 6 9 12 15 18]));
%     xlabel('Timeslots');
%     ylabel('Reject Rate 3');
%     hleg = legend('Static K-maps', 'Static MinEDI', 'Optimal S',  'Dynamic K-maps', 'Dynamic MinEDI', 'Optimal D',  'Location','SouthEast');
%  
  
if(run2 == false)
    figure(4); title('Reject Rate');
    hFig = figure(4);
else
    figure(10); title('Reject Rate'); 
    hFig = figure(10);
end
 
    
    p = plot(1:every_x_point:iterations, Average_reject_rate_all(1:every_x_point:end, [1]), '-bs', 1:every_x_point:iterations, Average_reject_rate_all(1:every_x_point:end, [4]), ':ro', 1:every_x_point:iterations, Average_reject_rate_all(1:every_x_point:end, [2]), '--g*');
    
    set(p(1),'linewidth',1);
    set(p(2) ,'linewidth',2);
    set(p(3) ,'linewidth',2);
    
    nummarkers(p, 25, 1);
    
    [legh,objh,outh,outm] = legend(p,'Static Embedding', 'Dynamic Embedding', 'Greedy Embedding ', 'Location', 'SouthEast' );
    set(objh(1),'linewidth',1);
    set(objh(2),'linewidth',1);
    set(objh(3),'linewidth',1);
    set(objh(4),'linewidth',1);
    set(objh(5),'linewidth',2);
    set(objh(6) ,'linewidth',1);
    set(objh(7),'linewidth',1);
    set(objh(8),'linewidth',2);
    set(objh(9) ,'linewidth',1);
    
    set(gca,'fontsize',14);
    set(hFig, 'Position', [0 0 750 600]);
    xlabel('Timeslots', 'FontWeight', 'light' , 'FontSize', 14);
    ylabel('Rejection Rate', 'FontWeight', 'light', 'FontSize', 14);
%     ylim([0 0.12]);
    
   
%          'Optimal S ','Optimal D', 'Static MinEDI', 'Dynamic MinEDI',
 
if(run2 == false)
    figure(5); title('Revenue');
    hFig = figure(5);
else
    figure(11); title('Revenue'); 
    hFig = figure(11);
end

    
    p = plot(1:every_x_point:iterations, revenue(1:every_x_point:end, [1])/(1/3*144), '-bs', 1:every_x_point:iterations, revenue(1:every_x_point:end, [4])/(1/3*144), ':ro', 1:every_x_point:iterations, revenue(1:every_x_point:end, [2])/(1/3*144), '--g*');
    
    set(p(1),'linewidth',1);
    set(p(2) ,'linewidth',2);
    set(p(3) ,'linewidth',2);
    
    nummarkers(p, 25, 1);
    
    [legh,objh,outh,outm] = legend(p,'Static Embedding',  'Dynamic Embedding', 'Greedy Embedding ', 'Location', 'SouthEast' );
    set(objh(1),'linewidth',1);
    set(objh(2),'linewidth',1);
    set(objh(3),'linewidth',1);
    set(objh(4),'linewidth',1);
    set(objh(5),'linewidth',2);
    set(objh(6) ,'linewidth',1);
    set(objh(7),'linewidth',1);
    set(objh(8),'linewidth',2);
    set(objh(9) ,'linewidth',1);
    
    set(gca,'fontsize',14);
    set(hFig, 'Position', [0 0 750 600]);
    xlabel('Timeslots', 'FontWeight', 'light' , 'FontSize', 14);
    ylabel('Revenue', 'FontWeight', 'light', 'FontSize', 14);
    
%     ylim([0 0.8]);
    
 %'Optimal S', 'Optimal D', 'Static MinEDI',  'Dynamic MinEDI',
% if(run2 == false)
%     figure(6); title('Occupied Area');
% else
%     figure(12); title('Occupied Area'); 
% end
%     
% 
% %     subplot(5, 1, 5);
%     plot(1:every_x_point:iterations, occupied_area(1:every_x_point:end, [1 2 4 5]));
%     xlabel('Timeslots');
%     ylabel('Occupied Area');
%     hleg = legend('Static K-maps', 'Static MinEDI', 'Optimal S',  'Dynamic K-maps', 'Dynamic MinEDI', 'Optimal D', 'Location','SouthEast');
    

%     Average_K_reject_rate_1 = sum(K_rejected_1)/(sum(total_requests(:, :)))  
%     Average_D_reject_rate_1 = sum(D_rejected_1)/(sum(total_requests(:, :))) 
%     Average_O_reject_rate_1 = sum(O_rejected_1)/(sum(total_requests(:, :)))
%     Average_K_reject_rate_2 = sum(K_rejected_2)/(sum(total_requests(:, :)))
%     Average_D_reject_rate_2 = sum(D_rejected_2)/(sum(total_requests(:, :)))
%     Average_O_reject_rate_2 = sum(O_rejected_2)/(sum(total_requests(:, :)))
%     Average_K_reject_rate_3 = sum(K_rejected_3)/(sum(total_requests(:, :)))
%     Average_D_reject_rate_3 = sum(D_rejected_3)/(sum(total_requests(:, :)))
%     Average_O_reject_rate_3 = sum(O_rejected_3)/(sum(total_requests(:, :)))

%     Average_K_reject_rate = (sum(sum(K_rejected_1))+sum(sum(K_rejected_2))+sum(sum(K_rejected_3)))/(sum(sum(total_requests_1))+sum(sum(total_requests_2))+sum(sum(total_requests_3)))
%     Average_KE_reject_rate = (sum(sum(KE_rejected_1))+sum(sum(KE_rejected_2))+sum(sum(KE_rejected_3)))/(sum(sum(total_requests_1))+sum(sum(total_requests_2))+sum(sum(total_requests_3)))
%     Average_S_O_reject_rate = (sum(sum(S_O_rejected_1))+sum(sum(S_O_rejected_2))+sum(sum(S_O_rejected_3)))/(sum(sum(total_requests_1))+sum(sum(total_requests_2))+sum(sum(total_requests_3)))
%     Average_D_reject_rate = (sum(sum(D_rejected_1))+sum(sum(D_rejected_2))+sum(sum(D_rejected_3)))/(sum(sum(total_requests_1))+sum(sum(total_requests_2))+sum(sum(total_requests_3)))
%     Average_DE_reject_rate = (sum(sum(DE_rejected_1))+sum(sum(DE_rejected_2))+sum(sum(DE_rejected_3)))/(sum(sum(total_requests_1))+sum(sum(total_requests_2))+sum(sum(total_requests_3)))
%     Average_D_O_reject_rate = (sum(sum(D_O_rejected_1))+sum(sum(D_O_rejected_2))+sum(sum(D_O_rejected_3)))/(sum(sum(total_requests_1))+sum(sum(total_requests_2))+sum(sum(total_requests_3)))



% subplot(2,2,1); % plot the resource utility
% title('Resource Usage');
% xlabel('Time');
% ylabel('Resource usage');
% title('Resource Usage')
% axis([0 500 0 1]);
% plot(smooth(K_occupied_area, 3));
% subplot(2,2,2); % plot the reject rate
% title('Reject rate');
% xlabel('Time');
% ylabel('Reject rate');
% plot(smooth(K_reject_rate, 51));
% xlabel('Time');
% ylabel('Reject rate');
% Average_Resource_usage = sum(K_occupied_area)/iterations
% Average_Reject_rate = sum(K_reject_rate)/iterations



    