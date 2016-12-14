function draw_users( h_fig , variables_from_server )
global history_pos_mtx

a = clock;
if ( mod(a(6),1/30) < 0.1 )
    history_pos_mtx = snake( history_pos_mtx , variables_from_server([2,3]).' );
    
    h_plot = get(1,'Children');
    curr_user_line = get( h_plot , 'Children' );
    
    set(curr_user_line ,'XData',history_pos_mtx(:,1) , 'YData', history_pos_mtx(:,2) );
    drawnow
end