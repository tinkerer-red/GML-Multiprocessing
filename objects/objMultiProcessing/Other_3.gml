if (is_main_process) {
	
	//kill children on close of the game
	var _i=0; repeat(array_length(threads_arr)) {
		var _thread = threads_arr[_i];
		var _proc = _thread.__.network_data.thread_process;
		ProcIdKill(_proc);
	_i+=1;}//end repeat loop
	
}