if (__MP.workers_connected) {
	draw_circle_color(x, y, 32, c_green, c_green, false)
}else{
	draw_circle_color(x, y, 32, c_red, c_red, false)
}

if (!__mp_is_main_process()) { exit; };

var _cb_json = "" //(USE_STRUCTS) ? string(struct_get_names(__MP.CALLBACKS)) : json_encode(__MP.CALLBACKS, true);
var _sr_json = "" //string(ds_map_keys_to_array(__MP.SENT_REQUESTS));
draw_text(0,32,
		"Last Returned Result" + draw_txt + "\n" +
		"Child Process IDs" + string(global.__MultiProcessingChildProcessID) + "\n" + 
		
		"Current Task Index : " + string(__MP.task_index) + "\n" + 
		"Current Callbacks : " + _cb_json + "\n" + 
		"Cached Callbacks Count : " + string(ds_map_size(__MP.request_callbacks)) + "\n" + 
		
		"Current Requests Index : " + string(__MP.request_index) + "\n" +
		"Current Pending Requests : " + _sr_json + "\n" +
		"Pending Request Count : " + string(ds_map_size(__MP.pending_requests)) + "\n" +
"\n")