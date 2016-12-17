clear all; close all; clc

N_users = 1; % number of users connected
N_history = 10; % length of line for each user

% users_vect = rand(N_users,1);
global history_pos_mtx
history_pos_mtx = nan(N_history,N_users,2);% creating a matrix containing all users xy lines

h_data_transfer.history_pos_mtx = history_pos_mtx;

%>>> Creating a plot. inside loop we will change only the handle h_plt
figure(1);
h_plt = plot( randn(N_history,N_users), randn(N_history,N_users) ,'.-','MarkerSize',10 );

set(gcf,'Position',get(0,'ScreenSize'));
set(gcf,'Position', round([1,1,1920/2,1080/2]) );

set(gcf,'GraphicsSmoothing','off','Renderer','Painters');
set(gca,'YDir','reverse' ,'Position',[0,0,1,1]);
axis equal
xlim([0,1]);
ylim([0,1]);

t = tcpclient('192.168.1.18',5000)
% set(t,'timeout',1);

while(1)
    a = read(t,150,'uint8');
    indices = strfind(a,'01549744012');
%     char(a)
%     char( a( indices(1):indices(2) ) )
    A = sscanf( char(a( indices(1):indices(2) )) , '%d,%f,%f,%d');   
    
    draw_users( 1 , A );
end

