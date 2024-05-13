/// @Keep children alive
if (is_main_process) {
	var _i=0; repeat(array_length(threads_arr)) {
		var _thread = threads_arr[_i];
		
		_thread.Push(__stay_alive, [], function(){}, function(){})
		
	_i+=1;}//end repeat loop
}
else {
	if (time_to_live <= 0) {
		game_end();
	}
}

//reset alarm
alarm_set(0, game_get_speed(gamespeed_fps));