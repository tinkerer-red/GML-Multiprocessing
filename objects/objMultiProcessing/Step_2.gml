/// @Desc Send Packets


if (is_main_process) {
	var _i=0; repeat(array_length(threads_arr)) {
		var _thread = threads_arr[_i];
		
		//skip unready Threads
		if (_thread.__.connection_state == ConnectionState.Disconnected)
		|| (_thread.__.thread_state == ThreadState.Init)
		|| (_thread.__.thread_state == ThreadState.Paused) {
			_i+=1;
			continue;
		}
		
		var _tasks = _thread.__.task_board.queued_tasks;
		
		if (!struct_names_count(_tasks)) continue;
		
		//send the entire queue
		__send_struct(_thread.__.network_data.thread_socket, _tasks);
		
		//move the queue into pending
		struct_foreach(_thread.__.task_board.queued_tasks, method(_thread.__.task_board.pending_tasks, function(_key, _val) {
			self[$ _key] = _val
		}));
		
		//reset the queue
		_thread.__.task_board.queued_tasks = {};
		
	_i+=1;}//end repeat loop
}
else {
	//incase the main thread is locked up for more then 1 minute kill out.
	time_to_live -= 1;
}