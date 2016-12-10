function history_pos_mtx_out = snake( history_pos_mtx_in , curr_pos_mtx )

N = size(history_pos_mtx_in,1);
history_pos_mtx_out = zeros( size(history_pos_mtx_in) );

for k=1:(N-1)
    history_pos_mtx_out(k,:,:) = history_pos_mtx_in(k+1,:,:);
end

history_pos_mtx_out(N,:,:) = curr_pos_mtx;
