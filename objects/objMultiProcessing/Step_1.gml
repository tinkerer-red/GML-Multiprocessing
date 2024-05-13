/// @desc


if (is_main_process) {
	var _i=0; repeat(array_length(threads_arr)) {
		var _thread = threads_arr[_i];
		
		//skip unready Threads
		if (_thread.__.thread_state == ThreadState.Init)
		|| (_thread.__.thread_state == ThreadState.Paused) {
			_i+=1;
			continue;
		}
		
		//loop through the queue
		
		var __closure = {};
		__closure.task_board = _thread.__.task_board;
		struct_foreach(_thread.__.task_board.recieved_tasks, method(__closure, function(_index, _task) {
			
			var _local_data = struct_get_from_hash(task_board.local_data, variable_get_hash(_index));
			var _response = _local_data.response;
			
			if (_response.success) {
				//execute the callback.
				_local_data.callback(_response.result);
			}
			else {
				//execute the errorback.
				_local_data.errorback(_response.error);
			}
			
			//remove the key from recieved and task_board
			struct_remove(task_board.tasks, _index);
			struct_remove(task_board.recieved_tasks, _index);
			struct_remove(task_board.local_data, _index);
			
		}));
		
		
	_i+=1;}//end repeat loop
}