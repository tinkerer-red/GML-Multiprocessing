//to do
//auto close processes after a few seconds of no connection
//on game close, close all processes

#macro IS_IDE (string_pos("Runner.exe", string(parameter_string(0))) != 0)


enum SOCKET_TYPE {
	REQ,
	REP,
	PUSH,
	PULL,
	DEALER,
	ROUTER,
}

function MultiProcessingInit(){
	#macro __MP global.MultiProcessing
	__MP = {};
	
	//config
	__MP.socket_type = network_socket_tcp;
	
	if (is_main_process()){
		//define this process as the server
		__mp_define_server();
		show_debug_message("server has started for multi processing")
	}else{
		//hide the new process
		//application_surface_draw_enable(false);
		//draw_enable_drawevent(false)
		
		//define this process as a worker
		__mp_define_worker();
	}
}

function remote_execute(_func, _args = [], _context = self, _callback = function(_result){}, _errback = function(_result){}){
	var _request = __make_request(_func, _args, __MP.INDEX);
	var _request_callback = __make_request_callback(_callback, _errback, _context);
	
	//cache the callback info
	__MP.CALLBACKS[? string(__MP.INDEX)] = _request_callback;
	
	__MP.INDEX++
	
	//enqueue the request so we can send multiple requests through a single packet
	array_push(__MP.request_queue, _request);
	
	//update indexes
	//__MP.INDEX++;
	
}

#region process handling
function __mp_define_server() {
	__MP.CALLBACKS = ds_map_create();
	__MP.INDEX = 0;
	__MP.PROCESSES = [];
	__MP.worker_sockets = ds_list_create();
	__MP.PROCESSES_INDEX = 0;
	__MP.connected_workers = 0;
	__MP.workers_connected = false;
	__MP.workers_destroyed = false;
	__MP.request_queue = []
	__MP.pending_request_queue = []
	
	
	__MP.step = __step_server;
	__MP.async = __receive_async_server;
	__MP.alarm0 = __alarm_server;
	alarm_set(0, game_get_speed(gamespeed_fps)*5)
	
	//Config------------------------------------------------------------------------------------------\\
	//                                                                                                ||
	__MP.MAX_CPU_PERCENT = 100; //how much of each thread is allowed to be used.
	__MP.NUMBER_OF_PROCESSES = 7; //How many threads to use, this needs to be replaced with a good way to count the number of threads
	//                                                                                                ||
	//------------------------------------------------------------------------------------------------//
	
	__MP.server = network_create_server(__MP.socket_type, 67623, 64)
	
	// parameter_string(0)="C:\Users\Katarina\AppData\Roaming\GameMaker-Studio\Runner.exe"
	var RunnerPath = parameter_string(0);
	
	//if this is the main process
	repeat (__MP.NUMBER_OF_PROCESSES){
		show_debug_message("about to create workers")
		__mp_create_worker();
	}
	
	__MP.last_frame_time = current_time;
	__MP.frame_time = 100/game_get_speed(gamespeed_fps)
	__MP.ideal_frame_time = __MP.frame_time * (1 + __MP.MAX_CPU_PERCENT/100)
}

function __mp_define_worker() {
	__MP.tasks = ds_priority_create();
	__MP.process_index = (code_is_compiled()) ? real(parameter_string(2)) : real(parameter_string(4));
	__MP.workers_connected = false;
	
	__MP.step = __step_worker
	__MP.async = __receive_async_worker
	__MP.alarm0 = __alarm_worker
	alarm_set(0, game_get_speed(gamespeed_fps)*60)
	
	//switch to an always inactive room
	__MP.ROOM = room_add();
	room_goto(__MP.ROOM);
		
		
	//kill all other instances which aren't the multiprocess
	var _oi = object_index;
	with (all){
		if (object_index != _oi){ instance_destroy() }
	}
	
	
	//connect to the host
	__MP.client = network_create_socket(__MP.socket_type)
	__MP.connected = network_connect(__MP.client, "127.0.0.1", 67623) //this defaults to a PULL connection
	__MP.workers_connected = __MP.connected;
}

function __mp_create_worker() {
	if (!IS_IDE){
		var _path = parameter_string(0);
		var _args = "-process_index"+string(__MP.PROCESSES_INDEX);
	}else{
		var _path = _runner_get_path();
		var _args = " -game "+_runner_get_game_path()+" -process_index"+string(__MP.PROCESSES_INDEX);
	}
	
	var _proccess_id = execute_shell_simple(_path, _args);
	//show_debug_message("_proccess_id = "+string(_proccess_id))
	
	//returns the process ID
	return _proccess_id;
}
#endregion

#region main process
#region constructors
function __make_request_callback(_callback, _errback, _context) {
	var _struct = {}
	_struct.context = _context; //the id of the object which originally called
	
	//the function which is run when the information is returned
	if (typeof(_callback) == "method"){
		_struct.callback = asset_get_index(script_get_name(_callback))
	}else{
		_struct.callback = _callback;
	}
	
	if (typeof(_errback) == "method"){
		_struct.err_back = asset_get_index(script_get_name(_errback))
	}else{
		_struct.err_back = _errback;
	}
	
	return _struct;
}

function __make_request(_func, _args, _index) {
	var _struct = {};
	
	//convert a method into an asset index
	if (typeof(_func) == "method"){
		_struct.func = asset_get_index(script_get_name(_func))
	}else{
		_struct.func = _func;
	}
	
	_struct.args = (is_array(_args)) ? _args : [_args]; //the arguments for the function above
	_struct.index = _index; //the index used for the request, used to run the correct callback
	
	return _struct;
}
#endregion

function __send_request(_request) {
	//do stuff...
	
	var _socket = __MP.worker_sockets[| __MP.PROCESSES_INDEX];
	__send_struct(_socket, _request)
	
	__MP.PROCESSES_INDEX++;
	if (__MP.PROCESSES_INDEX >= ds_list_size(__MP.worker_sockets)) { __MP.PROCESSES_INDEX -= ds_list_size(__MP.worker_sockets); } ;
}

function __receive_async_server(_async_load) {
	var _type_event = ds_map_find_value(_async_load, "type");
	switch(_type_event){
		#region network_type_connect
		case network_type_connect:
			__MP.connected_workers++
			
			if (__MP.connected_workers >= __MP.NUMBER_OF_PROCESSES){
				__MP.workers_connected = true;
			}
			
			var _socket = ds_map_find_value(_async_load, "socket")
			ds_list_add(__MP.worker_sockets, _socket)
			
			show_debug_message("Worker number \""+string(__MP.connected_workers)+"\" connected with socket: "+string(_socket))
		break;
		#endregion
		
		#region network_type_disconnect
		case network_type_disconnect:
			var _socket = ds_map_find_value(_async_load, "socket")
			ds_list_delete(__MP.worker_sockets, ds_list_find_index(__MP.worker_sockets, _socket));
			//if we didnt kill the workers, then spawn a new one.
			if (!__MP.workers_destroyed){
				__mp_create_worker()
			}
		break;
		#endregion
		
		#region network_type_data
		case network_type_data:
			var _buffer = ds_map_find_value(_async_load, "buffer")
			var _socket = ds_map_find_value(_async_load, "id")
			
			var _returned_struct = __decode_struct(_buffer);
			var _return_tasks = _returned_struct.arr;
			
			if (is_array(_return_tasks)){
				var _size = array_length(_return_tasks)
				
				var _i = 0;
				repeat(_size){
					var _task = _return_tasks[_i];
				
					//check the data and load the callbacks for the handled data
					var _index = _task.index;
					var _result = _task.result; //if an error occurced and it timed out, -1 is the return
				
					var _struct = __MP.CALLBACKS[? string(_index)]
				
					if (_result == -1){
						if instance_exists(_struct.context){
							var _inst = _struct.context;
							var _func = _struct.errback;
							with (_inst) {_func(_result);}
						}else{
							_struct.errback(_result);
						}
					}
					else{
						if instance_exists(_struct.context){
							var _inst = _struct.context;
							var _func = _struct.callback
							with (_inst) {_func(_result);}
						}else{
							_struct.callback(_result);
						}
					}
					ds_map_delete(__MP.CALLBACKS, string(_index))
				
					_i++
				}
			}
			
		break;
		#endregion
	}
}

function __step_server() {
	var _size = array_length(__MP.request_queue);
	if (_size != 0){
		var _workers = ds_list_size(__MP.worker_sockets);
		var _task_per_worker = ceil(_size/_workers);
		
		var _bulk_request = [];
		var _all_popped = false;
	
		for (var _i = 0; _i < _workers; _i++){
			for (var _j = 0; _j < _task_per_worker; _j++){
				var _request = array_pop(__MP.request_queue)
				array_push(_bulk_request, _request)
				if (array_length(__MP.request_queue) == 0) {
					var _all_popped = true;
					break;
				}
			}
			
			if (array_length(_bulk_request) != 0){
				//send the request out
				__send_request(_bulk_request)
				var _bulk_request = [];
			}
			
			//early out so we can make use of the rest of the time between frames to build and send the requests out
			var _dt = current_time - __MP.last_frame_time;
			if (_dt >= __MP.ideal_frame_time){break;}
			if (_all_popped) {break;}
			
		}
	}
	
	__MP.last_frame_time = current_time;
}

function __alarm_server(){
	alarm_set(0, game_get_speed(gamespeed_fps)*5)
	processes_refresh_all()
}
#endregion

#region worker process
function __receive_async_worker(_async_load) {
	var _type_event = ds_map_find_value(_async_load, "type");
	
	switch(_type_event){
		#region network_type_connect
		case network_type_connect:
			var _socket = ds_map_find_value(_async_load, "socket")
		break;
		#endregion
		
		#region network_type_disconnect
		case network_type_disconnect:
		case network_type_non_blocking_connect:
			var _socket = ds_map_find_value(_async_load, "socket")
			var _succeeded = ds_map_find_value(_async_load, "succeeded")
			if (_succeeded == 0){
				game_end()
			}
		break;
		#endregion
		
		#region network_type_data
		case network_type_data:
			var _buffer = ds_map_find_value(_async_load, "buffer");
			var _socket = ds_map_find_value(_async_load, "id");
			
			var _bulk_request = __decode_struct(_buffer);
			for(var _i = 0; _i < array_length(_bulk_request); _i++){
				var _task = _bulk_request[_i]
				
				//queue up the task
				ds_priority_add(__MP.tasks, _task, _task.index)
			
				//instantly run the task
				//__run_task(_task);
			}
		break;
		#endregion
	}
}

function __return_results(_results) {
	//send all results back to the server
	__send_struct(__MP.client, _results)
}

function __step_worker() {
	//init the returned data
	var _struct = {
		arr: []
	}
	
	
	//deque and clean info
	var _size = ds_priority_size(__MP.tasks)
	repeat(_size){
		var _task = ds_priority_delete_min(__MP.tasks);
		
		var _returned_data = __run_task(_task);
		
		array_push(_struct.arr, _returned_data);
		
		//this is where we should easy out if the process has too much on it's work load.
	}
	
	if (_size){
		__return_results(_struct)
	}
}

function __run_task(_struct) {
	if (!is_undefined(_struct))
	&& (is_struct(_struct)){
		var _func = _struct.func;
		var _args = _struct.args;
		var _index = _struct.index;
		
		//run the function with the correct number of arguments
		switch (array_length(_args)) {
			case 0:  var _result = _func() break;
			case 1:  var _result = _func(_args[0]) break;
			case 2:  var _result = _func(_args[0], _args[1]) break;
			case 3:  var _result = _func(_args[0], _args[1], _args[2]) break;
			case 4:  var _result = _func(_args[0], _args[1], _args[2], _args[3]) break;
			case 5:  var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4]) break;
			case 6:  var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5]) break;
			case 7:  var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6]) break;
			case 8:  var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7]) break;
			case 9:  var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]) break;
			case 10: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9]) break;
			case 11: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10]) break;
			case 12: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11]) break;
			case 13: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12]) break;
			case 14: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13]) break;
			case 15: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14]) break;
			case 16: var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15]) break;
			default:
				show_error("Worker process \""+__MP.process_index+"\" can not run function: \""+script_get_name(_func)+"\" with more then 16 arguments. \n arguments:"+string(_args), true)
			break;
		}
		
		var _returned_struct = {};
		_returned_struct.index = _index;
		_returned_struct.result = _result;
		
		return _returned_struct
	}
}

function __alarm_worker(){
	game_end();
}
#endregion

#region data management
function __send_struct(_socket, _struct){
	var _buff = __encode_struct(_struct);
	network_send_packet(_socket, _buff, buffer_tell(_buff));
	buffer_delete(_buff)
}

function __encode_struct(_struct) {
	//we are only doing it this way so in the future we can overwrite the encoding process with our own
	var _buff = buffer_create(1, buffer_grow, 1);
	var _json = json_stringify(_struct);
	
	buffer_seek(_buff, buffer_seek_start, 0)
	buffer_write(_buff, buffer_string, _json);
	return _buff;
}

function __decode_struct(_buff){
	buffer_seek(_buff, buffer_seek_start, 0)
	var _json = buffer_read(_buff, buffer_string)
	buffer_delete(_buff)
	
	return json_parse(_json);
}
#endregion

#region useful function
function is_main_process(){
	var _p_num = parameter_count();
	var _is_main_process = true;
	for (var _i = 0; _i < _p_num; _i++){
		if (string_pos("-process_index", parameter_string(_i)) == 1){
			_is_main_process = false;
		}
	}
	return _is_main_process;
}

function processes_end_all(){
	if (!__MP.workers_destroyed){
		for (var _i = 0; _i < ds_list_size(__MP.worker_sockets); _i++){
			remote_execute(game_end);
		}
		__MP.workers_destroyed = true;
	}
}

function processes_start_all(){
	if (__MP.workers_destroyed){
		for (var _i = 0; _i < __MP.NUMBER_OF_PROCESSES; _i++){
			__mp_create_worker()
		}
		__MP.workers_destroyed = false;
	}
}

function processes_refresh_all(){
	if (!__MP.workers_destroyed){
		for (var _i = 0; _i < ds_list_size(__MP.worker_sockets); _i++){
			remote_execute(alarm_set, [0, game_get_speed(gamespeed_fps)*60]);
		}
		__MP.workers_destroyed = true;
	}
}
#endregion


