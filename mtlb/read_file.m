clc; close all; clear

N_users = 1;
N_iterations = 1e4;
N_history = 75;

users_vect = rand(N_users,1);
xy_pos_mtx = rand(N_users,2);

history_pos_mtx_out = nan(N_history,N_users,2);

h_plt = plot( randn(N_history,N_users), randn(N_history,N_users) ,'.-' );
axis equal
xlim([0,1]);
ylim([0,1]);


tic
while(1)
    fid = fopen( 'C:\Users\hpp\Desktop\luminous\nightlamp\position.txt','rt' );
    A = fscanf( fid, '%f,%f,%f,%f' );
    fclose(fid);
    
    if ( size(A,1)==4 )
        history_pos_mtx_out = snake( history_pos_mtx_out , A([2,3])  );
        
        for m=1:N_users
            set(h_plt(m) ,'XData',history_pos_mtx_out(:,m,1) , 'YData', history_pos_mtx_out(:,m,2) );
        end
    end
    
    
    drawnow
end
N_iterations/toc