//only allow one to exist
if (instance_number(object_index) > 1) { instance_destroy(); exit; }

is_main_process = int64(bool(EnvironmentGetVariableExists("MultiProcessingInstanceID")) ? EnvironmentGetVariable("MultiProcessingInstanceID") : string(0)) == 0;
threads_arr = [];

server = undefined; //this is really only remembered on the main process so we can shut down the server on game close.
socket = undefined; //this variable is really only used for workers because they only need to know what socket to reply to. The main process will refer to threads through...  threads_arr[i].__.network_data.thread_socket

process_id = undefined; //just incase we want to know what process we are.

if (is_main_process) {
	server = network_create_server(MultiProcessing_Socket, MultiProcessing_Port, get_core_count()-1);
}
else {
	window_set_caption("subprocess");
	window_hide();
	
	socket = network_create_socket(MultiProcessing_Socket)
	network_connect_async(socket, "127.0.0.1", MultiProcessing_Port) //this defaults to a PULL connection
	
	//occasionally check to see if the main process is still alive
	time_source_start(time_source_create(time_source_game, 1, time_source_units_seconds, function(){
		if (!ProcIdExists(int64(global.MultiProcessingMainProcessID))) {
			game_end();
		}
	}, [], -1));
}

time_to_live = game_get_speed(gamespeed_fps)*60;
__stay_alive = function(){
	objMultiProcessing.time_to_live = game_get_speed(gamespeed_fps)*60;
}
//alarm_set(0, game_get_speed(gamespeed_fps));

if (!is_main_process) {
	alarm_set(1, game_get_speed(gamespeed_fps)*0.25);
}

show_debug_overlay(true)