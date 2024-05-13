var _type_event = ds_map_find_value(async_load, "type");

if (is_main_process) {
	switch(_type_event){
		case network_type_connect: {
			var _socket = ds_map_find_value(async_load, "socket")
			
			//loop through the thread list until we find one which doesnt have a set socket yet.
			var _i=0; repeat(array_length(threads_arr)) {
				var _thread = threads_arr[_i];
				if (_thread.__.network_data.thread_socket == undefined) {
					_thread.__.network_data.thread_socket = _socket;
					_thread.__.connection_state = ConnectionState.Connected;
					_thread.__.thread_state = (_thread.__.thread_state == ThreadState.Init) ? ThreadState.Running : _thread.__.thread_state;
					break;
				}
				
			_i+=1;}//end repeat loop
			
			
			//the new process will end up stealing focus, so let's grab it back
			window_focus();
			//double check to ensure focus
			time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, window_focus));
			
		break;}
		case network_type_disconnect: {
			var _socket = ds_map_find_value(async_load, "socket")
			
			//loop through the thread list until we find the socket
			var _i=0; repeat(array_length(threads_arr)) {
				var _thread = threads_arr[_i];
				if (_thread.__.network_data.thread_socket == _socket) {
					_thread.__.network_data.thread_socket = undefined;
					_thread.__.connection_state = ConnectionState.Disconnected;
					
					//kill the task if it's lingering or held up.
					ProcIdKill(_thread.__.network_data.thread_process);
					
					//dequeue any pending tasks
					//move the queue into pending
					struct_foreach(_thread.__.task_board.pending_tasks, method(_thread.__.task_board.queued_tasks, function(_key, _val) {
						self[$ _key] = _val
					}));
					
					//reset the queue
					_thread.__.task_board.pending_tasks = {};
					 
					//relaunch the process
					// duplicate current process by executing its own command line.
					EnvironmentSetVariable("MultiProcessingInstanceID", string(real(EnvironmentGetVariable("MultiProcessingInstanceID")) + 1));
					// define child process id for later use when the main process dies so we can kill all children.
					var _proc_id = ExecProcessFromArgVAsync(GetArgVFromProcid(ProcIdFromSelf()));
					_thread.__.network_data.thread_process = _proc_id;
						
					
					break;
				}
			_i+=1;}//end repeat loop
			
		break;}
		case network_type_data: {
			var _buffer = ds_map_find_value(async_load, "buffer");
			var _socket = ds_map_find_value(async_load, "id");
			
			var _task_results = __decode_struct(_buffer);
			
			if (_task_results == undefined) { exit; } //incase the full packet has not finished downloading
			
			var _should_break = false;
			
			//loop through the thread list until we find the socket
			var _i=0; repeat(array_length(threads_arr)) {
				var _thread = threads_arr[_i];
				
				//skip the incorrect socket threads
				if (_thread.__.network_data.thread_socket != _socket) {
					_i+=1;
					continue;
				}
				
				var _pending_tasks = _thread.__.task_board.pending_tasks;
				var _hash = variable_get_hash(_task_results.index);
				
				var _task = struct_get_from_hash(_pending_tasks, _hash);
				
				struct_remove(_pending_tasks, _task_results.index);
				struct_set_from_hash(_thread.__.task_board.recieved_tasks, _hash, _task);
				
				var _local_data = struct_get_from_hash(_thread.__.task_board.local_data, _hash) ?? {};
				_local_data.response = _task_results;
				struct_set_from_hash(_thread.__.task_board.local_data, _hash, _local_data);
				
				break;
			}//end repeat loop
			
			buffer_delete(_buffer)
							
		break;}
	}
}
else {
	switch(_type_event){
		case network_type_connect: {
			socket = ds_map_find_value(async_load, "socket");
		break;}
		case network_type_disconnect: {
			var _socket = ds_map_find_value(async_load, "socket")
			var _succeeded = ds_map_find_value(async_load, "succeeded")
			if (_succeeded == 0){
				game_end()
			}
		break;}
		case network_type_non_blocking_connect: {
			
		break;}
		case network_type_data: {
			var _buffer = ds_map_find_value(async_load, "buffer");
			var _socket = ds_map_find_value(async_load, "id");
			
			var _task_struct = __decode_struct(_buffer);
			
			
			//Sometimes a buffer is loaded in chunks, but for the rest of those times this check is specifically for when data is lost through the TCP protocal, Gamemaker has a nasty habit of writing over memory which subprocesses are currently using, leading to getting an invalid buffer
			if (_task_struct == undefined) { exit; };
			
			struct_foreach(_task_struct, function(_index, _task) {
				//run task
				var _returned_struct = __run_task(_task)
				
				//return result
				__send_struct(socket, _returned_struct);
			})
			
			buffer_delete(_buffer)
			
		break;}
	}
	
}