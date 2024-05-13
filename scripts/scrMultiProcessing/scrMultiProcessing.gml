#region header
	
	#macro MP_Version "1.1.0"
	show_debug_message("[Red's MultiProcessing] : Thank you for using Red's MultiProcessing!");
	show_debug_message("[Red's MultiProcessing] : Version : "+MP_Version);
	
#endregion

function ProcessThread() constructor {
	if !instance_exists(objMultiProcessing) {
		instance_create_depth(0,0,-16000,objMultiProcessing);
	}
	if (!objMultiProcessing.is_main_process) {
		show_error("Trying to create a new thread inside of a thread, this is not officially supported!", true);
	}
	
	
	//Pauses the ProcessThread execution.
	static Pause = function() {
		__pause()
		
		return self;
	}
	
	//Resumes the ProcessThread execution.
	static Resume = function() {
		__resume()
		
		return self;
	}
	
	//Inserts a function/method or struct to a set position within the ProcessThread.
	static Insert = function(_index, _func, _arg, _callback, _errorback) {
		Push(_func, _arg, _callback, _errorback);
		return self;
	}
	
	//Pushes one or multiple functions/methods or structs, adding at the end of the queue.
	static Push = function(_func, _arg, _callback, _errorback) {
		var _task = new __task(_func, _arg, _callback, _errorback);
		var _hash = variable_get_hash(_task.index);
		
		struct_set_from_hash(__.task_board.tasks, _hash, _task);
		struct_set_from_hash(__.task_board.queued_tasks, _hash, _task);
		
		//set local data
		var _local_data = {}
		_local_data.callback  = _callback;
		_local_data.errorback = _errorback
		struct_set_from_hash(__.task_board.local_data, _hash, _local_data);
		
		return self;
	}
	
	//Clears the ProcessThread queue.
	static Clear = function() {
		__.queue = [];
		return self;
	}
	
	//Frees the ProcessThread queue.
	static Destroy = function() {
		array_insert(new __task(game_end));
		return self;
	}
	
	//Gets the length of the ProcessThread queue.
	static GetQueueLength = function() {
		return array_length(__.queue);
	}
	
	//Flushes all functions (aka executes all functions/methods) within the queue, regardless of the settings of .SetMaxTime() and .SetMaxExecutions(), and regardless if it's paused or not.
	static Flush = function() {
		struct_foreach(__.task_board.tasks, function(_index, _key) {
			
			var _local_data = struct_get_from_hash(__.task_board.local_data, variable_get_hash(_index));
			
			var _result = __run_task(_key);
			
			if (_result.success) {
				//execute the callback.
				_local_data.callback(_result.result);
			}
			else {
				//execute the errorback.
				_local_data.errorback(_result.error);
			}
		});
		
		__.task_board.tasks = {}
		__.task_board.pending_tasks = {}
		__.task_board.queued_tasks = {}
		__.task_board.recieved_tasks = {}
		__.task_board.local_data = {}
		
		return self;
	}
	
	#region Private
		
		static __pause = function() {
			__.thread_state = ThreadState.Paused;
			return self;
		}
		
		//Resumes the ProcessThread execution.
		static __resume = function() {
			__.thread_state = ThreadState.Running;
			return self;
		}
		
		static __task = function(_func, _arg) constructor {
			static TaskIndex = 0;
			index = string(TaskIndex++);
			func = (typeof(_func) == "method") ? asset_get_index(script_get_name(_func)) : _func
			args = (is_array(_arg)) ? _arg : [_arg]; //the arguments for the function above
		}
		
	#endregion
	
	enum ThreadState {
		Init,
		Paused,
		Running
	}
	enum ConnectionState {
		Disconnected,
		Connected
	}
	
	__ = {};
	__.thread_state = ThreadState.Init;
	__.connection_state = ConnectionState.Disconnected;
	
	__.task_board = {}; //a hash tables of all tasks by their index
	__.task_board.tasks = {};
	__.task_board.queued_tasks   = {};
	__.task_board.pending_tasks  = {};
	__.task_board.recieved_tasks = {};
	
	__.task_board.local_data = {};
	//__.task_board.local_data[$ "0"].callback  = {};
	//__.task_board.local_data[$ "0"].errorback = {};
	//__.task_board.local_data[$ "0"].responses  = {};
	
	
	__.network_data = new __ThreadNetworkData();
	__.network_data.thread_controller = self;
	
	//init the process
	if (objMultiProcessing.is_main_process) {
		if (array_get_index(objMultiProcessing.threads_arr, self) == -1) {
			array_push(objMultiProcessing.threads_arr, self);
			
			// duplicate current process by executing its own command line.
			EnvironmentSetVariable("MultiProcessingInstanceID", string(real(EnvironmentGetVariable("MultiProcessingInstanceID")) + 1));
			// define child process id for later use when the main process dies so we can kill all children.
			var _proc_id = ExecProcessFromArgVAsync(GetArgVFromProcid(ProcIdFromSelf()));
			__.network_data.thread_process = _proc_id;
		}
	}
	
}

#region jsDoc
/// @func    remote_execute()
/// @desc    Execute a function with supplied arguments on a separate process, when a response is returned this will pass the function's return into the callback as an argument.
///
///          .
///
///          Note: This will trigger the async networking event, although this message will be processed by the multiprocessing handler
/// @param   {Function} func : The function to execute.
/// @param   {Array} arg : The arguments for the function.
/// @param   {Function} callback : The function or method to be executed when a responce has been recieved, this will pass the function's return into the callback as an argument.
#endregion
function remote_execute(_func, _args = undefined, _callback = undefined, _errorback = undefined) {
	static empty_arr = []; //prevent the need to create new arrays every time
	static empty_func = function(_result){}; //prevent the need to create new methods every time
	static thread = new ProcessThread();
	
	//is the first is null/undefined use the second
	_args ??= empty_arr;
	_callback ??= empty_func;
	_callback ??= empty_func;
	
	thread.Push(_func, _args, _callback, _errorback);
}

//used to help devs know how many threads we can safely spawn, which would be (core count - 1)
function get_core_count() {
	return cpu_numcpus();
}

#region Object Init
	
	//create the corosponding object
	time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, function(){
		if !instance_exists(objMultiProcessing) {
			instance_create_depth(0,0,-16000,objMultiProcessing);
		}
	}));
	
#endregion

#region Environment Variables
	
	//instance id : used to keep track of what instance number the process is
	global.MultiProcessingProcessID = int64(bool(EnvironmentGetVariableExists("MultiProcessingInstanceID")) ? EnvironmentGetVariable("MultiProcessingInstanceID") : string(0));
	if (!EnvironmentGetVariableExists("MultiProcessingInstanceID")){
		EnvironmentSetVariable("MultiProcessingInstanceID", string(global.MultiProcessingProcessID));
	}
	if (!EnvironmentGetVariableExists("MultiProcessingGameEnd")){
		EnvironmentSetVariable("MultiProcessingGameEnd", "0");
	}
	if (!EnvironmentGetVariableExists("MultiProcessingMainProcessID")) {
		if (EnvironmentGetVariableExists("MultiProcessingInstanceID")) {
			EnvironmentSetVariable("MultiProcessingMainProcessID", string(ProcIdFromSelf()));
		}
	}
	global.MultiProcessingMainProcessID = EnvironmentGetVariable("MultiProcessingMainProcessID")
	
#endregion

#region Blank Room Init
	
	//create a quiet room
	if (global.MultiProcessingMainProcessID != ProcIdFromSelf()) {
		time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, function(){
			room_goto(room_add());
		}));
	}
#endregion

#region private

function __ThreadNetworkData() constructor {
	thread_controller = undefined;
	thread_process    = undefined;
	thread_socket     = undefined;
}

#region Data Management
	
	function __send_struct(_socket, _struct) {
		var _buff = __encode_struct(_struct);
		network_send_packet(_socket, _buff, buffer_tell(_buff));
		buffer_delete(_buff);
	}
	function __encode_struct(_struct) {
		var _buff = buffer_create(1, buffer_grow, 1);
		var _json = json_stringify(_struct);
						
		buffer_seek(_buff, buffer_seek_start, 0);
		buffer_write(_buff, buffer_string, _json);
						
		return _buff;
	}
	function __decode_struct(_buff){
		buffer_seek(_buff, buffer_seek_start, 0);
		var _json = buffer_read(_buff, buffer_string);
						
		try {
			var _r = json_parse(_json);
		}
		catch(error) {
			var _r = undefined;
		}
						
		return _r;
	}
	
#endregion

function __run_task(_task) {
	if (!is_undefined(_task))
	&& (is_struct(_task)) {
		try {
			var _func = _task.func;
			var _args = _task.args;
			var _index = _task.index;
						
			var _length = array_length(_args);
						
			//An alternitive to the waterfall of doom as proposed by YellowAfterlife
			// NOTE : I know this is really unnecessary optimization as most functions only require a few arguments. But I found it interesting at the time.
			// This is not really needed for 2.3 but is needed for when i port this back to gm8 and gms1.4
			if (_length > 16) {
				show_error("Worker process can not run function: \""+script_get_name(_func)+"\" with more then 16 arguments. \narguments: "+string(_args), true)
			}
						
			if (_length < 8) {
				if (_length < 4) {
					if (_length < 2) {
						if (_length == 1) {
							var _result = _func(_args[0])
						}
						else{
							var _result = _func()
						}
					}
					else {
						if (_length == 3) {
							var _result = _func(_args[0], _args[1], _args[2])
						}
						else{
							var _result = _func(_args[0], _args[1])
						}
					}
				}
				else {
					if (_length < 6) {
						if (_length == 5) {
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4])
						}
						else{
							var _result = _func(_args[0], _args[1], _args[2], _args[3])
						}
					}
					else {
						if (_length == 7) {
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6])
						}
						else{
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5])
						}
					}
				}
			}
			else {
				if (_length < 12) {
					if (_length < 10) {
						if (_length == 9) {
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8])
						}
						else{
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7])
						}
					}
					else {
						if (_length == 11) {
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10])
						}
						else{
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9])
						}
					}
				}
				else {
					if (_length < 14) {
						if (_length == 13) {
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12])
						}
						else{
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11])
						}
					}
					else {
						if (_length < 15) {
							var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14])
						}
						else{
							if (_length == 16) {
								var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15])
							}
							else {
								var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13])
							}
						}
					}
				}
			}
						
			var _returned_struct = {};
			_returned_struct.index = _index;
			_returned_struct.result = _result;
			_returned_struct.success = true;
		}
		catch(_err) {
			var _returned_struct = {index: _task.index, result: undefined, success: false, error: _err}
		}
		
	}
	else {
		var _returned_struct = {index: _task.index, result: undefined, success: false, error: "Worker process can not process supplied struct! \nstruct: "+string(_task)}
	}
	
	return _returned_struct
}

#endregion