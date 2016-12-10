clc; close all; clear

N_users = 1; % number of users connected
N_history = 75; % length of line for each user

% users_vect = rand(N_users,1);
history_pos_mtx_out = nan(N_history,N_users,2);% creating a matrix containing all users xy lines

%>>> Creating a plot. inside loop we will change only the handle h_plt
figure(1);
h_plt = plot( randn(N_history,N_users), randn(N_history,N_users) ,'.-' );
get(1)
axis equal
xlim([0,1]);
ylim([0,1]);

% >>> Preparing to start loop loop
n = nightClient('ws://localhost:3001');
%>>> Endless loop
while(1)
    history_pos_mtx_out = snake( history_pos_mtx_out , A([2,3])  );
    
    for m=1:N_users
        set(h_plt(m) ,'XData',history_pos_mtx_out(:,m,1) , 'YData', history_pos_mtx_out(:,m,2) );
        drawnow
    end
end




