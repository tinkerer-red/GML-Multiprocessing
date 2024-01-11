//to do
//auto close processes after a few seconds of no connection
//on game close, close all processes

#macro _FST_IS_IDE (string_pos("Runner.exe", string(parameter_string(0))) != 0)

enum GATEWAY_EVENTS {
	REFRESH,
	PING,
	//add yours here
	SIZE,
}
function __fst_create_event_functions(){
	var _arr = [];
	_arr[GATEWAY_EVENTS.REFRESH] = function() {
		__fst_ping()
		return true;
	}
	
	_arr[GATEWAY_EVENTS.PING] = function(_time) {
		var _old_tz = date_get_timezone();
		date_set_timezone(timezone_utc);
		__FST.latency = (date_current_datetime()*1000000 - _time);
		date_set_timezone(_old_tz);
		
		alarm[0] = game_get_speed(gamespeed_fps)*10;
		return true;
	}
	
	
	
	return _arr;
}


function FastServerTestingInit(_start_server, _client_count){
	#macro __FST global.FastServerTesting
	__FST = {};
	__FST.owner = self.id;
	__FST.handler_name = (_start_server) ? "Server" : "Client A";
	__FST.latency = 999;
	__FST.INDEX = 0;
	
	//config
	__FST.socket_type = network_socket_tcp;
	
	__FST.event_functions = __fst_create_event_functions();
	
	if (__fst_is_main_process()){
		if (_start_server) {
			//init the server and start the clients
			__fst_log("Initializing server.")
			__fst_define_server(_client_count);
			
			__fst_log("Creating "+string(_client_count)+" clients.")
			var _i = 0; repeat(_client_count){
				__fst_create_client();
			_i+=1;}
		}
		else{
			//if we're the main process and we're logging as client
			__fst_log("Initializing client.")
			__fst_define_client();
			
			__fst_log("Creating server.")
			__fst_create_server(_client_count);
			
			__fst_log("Initializing "+string(_client_count)+" clients.")
			var _i = 0; repeat(_client_count-1){
				__fst_create_client();
			_i+=1;}
		}
	}
	else{
		//if we're a side process
		if (_start_server) {
			//if the main process is the server init our selves as the clients
			__fst_define_client();
		}
		else{
			//if the main process is a client, init the first process as the server, and the rest as a client
			__fst_define_server(_client_count);
		}
	}
	
}


#region process handling
function __fst_define_server(_client_count) {
	__FST.CALLBACKS = ds_map_create();
	__FST.PROCESSES = [];
	__FST.NUMBER_OF_CLIENTS = _client_count;
	__FST.client_sockets = ds_list_create();
	__FST.PROCESSES_INDEX = 0;
	__FST.connected_clients = 0;
	__FST.clients_connected = false;
	__FST.clients_destroyed = false;
	__FST.request_queue = [];
	__FST.pending_request_queue = [];
	
	
	__FST.step = __fst_step_server;
	__FST.async = __fst_receive_async_server;
	__FST.alarm0 = __fst_alarm_server;
	alarm_set(0, 1)
	
	__FST.server = network_create_server(__FST.socket_type, 25565, 64)
	
	window_set_caption("Server")
}

function __fst_define_client() {
	__FST.tasks = ds_priority_create();
	__FST.process_index = (code_is_compiled()) ? real(string_digits(parameter_string(1))) : real(string_digits(parameter_string(3)));
	__FST.clients_connected = false;
	
	__FST.step = __fst_step_client
	__FST.async = __fst_receive_async_client
	__FST.alarm0 = __fst_alarm_client
	alarm_set(0, game_get_speed(gamespeed_fps)*10)
	
	
	//connect to the host
	__FST.client = network_create_socket(__FST.socket_type)
	__FST.connected = network_connect(__FST.client, "police-deny.at.playit.gg", 54421) //this defaults to a PULL connection
	__FST.clients_connected = __FST.connected;
	
	
	window_set_caption("Client "+string(__FST.process_index)+" : Connected: "+string(__FST.connected))
}

function __fst_create_server(_client_count) {
	if (!_FST_IS_IDE){
		var _path = parameter_string(0);
		var _args = "-process_server -clients"+string(_client_count);
	}else{
		var _path = runner_get_path();
		var _args = " -game "+runner_get_game_path()+" -process_server -clients"+string(_client_count);
	}
	
	var _proccess_id = execute_shell_simple(_path, _args);
	//show_debug_message("_proccess_id = "+string(_proccess_id))
	
	//returns the process ID
	return _proccess_id;
}

function __fst_create_client() {
	if (!_FST_IS_IDE){
		var _path = parameter_string(0);
		var _args = "-process_index"+string(__FST.PROCESSES_INDEX);
	}else{
		var _path = runner_get_path();
		var _args = " -game "+runner_get_game_path()+" -process_index"+string(__FST.PROCESSES_INDEX);
	}
	
	var _proccess_id = execute_shell_simple(_path, _args);
	show_debug_message("_proccess_id = "+string(_proccess_id))
	
	//returns the process ID
	return _proccess_id;
}
#endregion

#region main process
#region constructors
function __fst_make_request_callback(_callback, _errback, _context) {
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

function __fst_make_request(_event_id, _args, _index) {
	var _struct = {
		event_id: _event_id,
		args: _args,
		index: _index
	};
	return _struct;
}
#endregion

function __fst_send_request(_request) {
	//do stuff...
	
	var _socket = __FST.client_sockets[| __FST.PROCESSES_INDEX];
	__fst_send_struct(_socket, _request)
	
	__FST.PROCESSES_INDEX++;
	if (__FST.PROCESSES_INDEX >= ds_list_size(__FST.client_sockets)) { __FST.PROCESSES_INDEX -= ds_list_size(__FST.client_sockets); } ;
}

function __fst_receive_async_server(_async_load) {
	var _type_event = ds_map_find_value(_async_load, "type");
	switch(_type_event){
		#region network_type_connect
		case network_type_connect:
			__FST.connected_clients++
			
			if (__FST.connected_clients >= __FST.NUMBER_OF_CLIENTS){
				__FST.clients_connected = true;
			}
			
			var _socket = ds_map_find_value(_async_load, "socket")
			ds_list_add(__FST.client_sockets, _socket)
			
			show_debug_message("client number \""+string(__FST.connected_clients)+"\" connected with socket: "+string(_socket))
		break;
		#endregion
		
		#region network_type_disconnect
		case network_type_disconnect:
			var _socket = ds_map_find_value(_async_load, "socket")
			ds_list_delete(__FST.client_sockets, ds_list_find_index(__FST.client_sockets, _socket));
			//if we didnt kill the clients, then spawn a new one.
			if (!__FST.clients_destroyed){
				__fst_create_client()
			}
		break;
		#endregion
		
		#region network_type_data
		case network_type_data:
			var _buffer = ds_map_find_value(_async_load, "buffer")
			var _socket = ds_map_find_value(_async_load, "id")
			
			var _returned_struct = __fst_decode_struct(_buffer);
			var _return_tasks = _returned_struct.arr;
			
			if (is_array(_return_tasks)){
				var _size = array_length(_return_tasks)
				
				var _i = 0;
				repeat(_size){
					var _task = _return_tasks[_i];
				
					//check the data and load the callbacks for the handled data
					var _index = _task.index;
					var _result = _task.result; //if an error occurced and it timed out, -1 is the return
				
					var _struct = __FST.CALLBACKS[? string(_index)]
				
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
					ds_map_delete(__FST.CALLBACKS, string(_index))
				
					_i++
				}
			}
			
		break;
		#endregion
	}
}

function __fst_step_server() {
	var _size = array_length(__FST.request_queue);
	if (_size != 0){
		var _clients = ds_list_size(__FST.client_sockets);
		if (_clients == 0) { return; }
		
		var _task_per_client = ceil(_size/_clients);
		
		var _bulk_request = [];
		var _all_popped = false;
	
		for (var _i = 0; _i < _clients; _i++){
			for (var _j = 0; _j < _task_per_client; _j++){
				var _request = array_pop(__FST.request_queue)
				array_push(_bulk_request, _request)
				if (array_length(__FST.request_queue) == 0) {
					var _all_popped = true;
					break;
				}
			}
			
			if (array_length(_bulk_request) != 0){
				//send the request out
				__fst_send_request({bulk_request: _bulk_request})
				var _bulk_request = [];
			}
			
			if (_all_popped) {break;}
		}
	}
}

function __fst_alarm_server(){
	__fst_processes_refresh_all()
	owner.alarm[0] = 1
}
#endregion

#region client process
function __fst_receive_async_client(_async_load) {
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
			_bulk_request = _bulk_request.bulk_request;
			for(var _i = 0; _i < array_length(_bulk_request); _i++){
				var _task = _bulk_request[_i]
				
				//queue up the task
				ds_priority_add(__FST.tasks, _task, _task.index)
			
				//instantly run the task
				//__fst_run_task(_task);
			}
		break;
		#endregion
	}
}

function __fst_return_results(_results) {
	//send all results back to the server
	__fst_send_struct(__FST.client, _results)
}

function __fst_step_client() {
	//init the returned data
	var _struct = {
		arr: []
	}
	
	
	//deque and clean info
	var _size = ds_priority_size(__FST.tasks)
	repeat(_size){
		var _task = ds_priority_delete_min(__FST.tasks);
		
		var _returned_data = __fst_run_task(_task);
		
		array_push(_struct.arr, _returned_data);
		
		//this is where we should early out if the process has too much on it's work load.
	}
	
	if (_size){
		__fst_return_results(_struct)
	}
}

function __fst_run_task(_struct) {
	if (!is_undefined(_struct))
	&& (is_struct(_struct))
	&& (variable_struct_exists(_struct, "event_id"))
	&& (_struct.event_id >= 0)
	&& (_struct.event_id < GATEWAY_EVENTS.SIZE) {
		var _func = __FST.event_functions[_struct.event_id];
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
				show_error("client process \""+__FST.process_index+"\" can not run function: \""+script_get_name(_func)+"\" with more then 16 arguments. \n arguments:"+string(_args), true)
			break;
		}
		
		var _returned_struct = {};
		_returned_struct.index = _index;
		_returned_struct.result = _result;
		
		return _returned_struct
	}
}

function __fst_alarm_client(){
	game_end();
}
#endregion

#region data management
function __fst_send_struct(_socket, _struct){
	var _buff = __fst_encode_struct(_struct);
	network_send_packet(_socket, _buff, buffer_tell(_buff));
	buffer_delete(_buff)
}

function __fst_encode_struct(_struct) {
	//we are only doing it this way so in the future we can overwrite the encoding process with our own
	var _buff = buffer_create(1, buffer_grow, 1);
	var _json = json_stringify(_struct);
	
	buffer_seek(_buff, buffer_seek_start, 0)
	buffer_write(_buff, buffer_string, _json);
	return _buff;
}

function __fst_decode_struct(_buff){
	buffer_seek(_buff, buffer_seek_start, 0)
	var _json = buffer_read(_buff, buffer_string)
	buffer_delete(_buff)
	
	return json_parse(_json);
}
#endregion

#region useful function
function __fst_is_main_process(){
	var _p_num = parameter_count();
	var _is_main_process = true;
	for (var _i = 0; _i < _p_num; _i++){
		if (string_pos("-process_index", parameter_string(_i)) == 1){
			_is_main_process = false;
		}
	}
	return _is_main_process;
}

function __fst_processes_refresh_all(){
	if (!__FST.clients_destroyed){
		for (var _i = 0; _i < ds_list_size(__FST.client_sockets); _i++){
			__fst_refresh_ping();
		}
	}
}

function __fst_log(_string) {
	show_debug_message("["+__FST.handler_name+"] "+string(_string))
}

function __fst_ping() {
	var _request = __fst_make_request(GATEWAY_EVENTS.PING, [current_time], __FST.INDEX);
	var _request_callback = __fst_make_request_callback(function(_time){__FST.latency = current_time - _time}, function(){__fst_log("Lost connection to server.")}, id);
	
	//cache the callback info
	__FST.CALLBACKS[? string(__FST.INDEX)] = _request_callback;
	
	__FST.INDEX++
	
	//enqueue the request so we can send multiple requests through a single packet
	array_push(__FST.request_queue, _request);
}

function __fst_refresh_ping() {
	var _request = __fst_make_request(GATEWAY_EVENTS.REFRESH, [], __FST.INDEX);
	var _request_callback = __fst_make_request_callback(function(){}, function(){__fst_log("Lost connection to client.")}, owner);
	
	//cache the callback info
	__FST.CALLBACKS[? string(__FST.INDEX)] = _request_callback;
	
	__FST.INDEX++
	
	//enqueue the request so we can send multiple requests through a single packet
	array_push(__FST.request_queue, _request);
}
#endregion



