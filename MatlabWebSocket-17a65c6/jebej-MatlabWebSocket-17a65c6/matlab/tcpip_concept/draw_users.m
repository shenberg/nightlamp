function draw_users( h_fig , variables_from_server )
global history_pos_mtx

% a = clock;
% if ( mod(a(6),1/30) < 0.1 )
    history_pos_mtx = snake( history_pos_mtx , variables_from_server([2,3]).' );
    
    h_plot = get(1,'Children');
    curr_user_line = get( h_plot , 'Children' );
    
    x_orig = history_pos_mtx(:,1);
    y_orig = history_pos_mtx(:,2);
    N_orig = length(x_orig);
    
%     x_intrp = interp1( 1:N_orig , x_orig ,linspace(1,N_orig,20) );
%     y_intrp = spline(x_orig,y_orig,x_intrp);
    
    set(curr_user_line ,'XData', x_orig , 'YData', y_orig );
    
    drawnow
% end