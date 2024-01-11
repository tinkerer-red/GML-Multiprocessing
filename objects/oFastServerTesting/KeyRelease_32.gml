timer_started = true;

test = function(_result) {
	_result.time = (current_time-_result.time)
	//show_debug_message(_result);
	remote_execute(factorial, [__FST.INDEX, current_time], icle)
}

icle = function(_result) {
	_result.time = (current_time-_result.time)
	//show_debug_message(_result);
	remote_execute(factorial, [__FST.INDEX, current_time], test)
}


function factorial(_x, _time) {
	var _t = _x-1;
	var _v = _x;
	repeat (_x-2){
		_t--;
		_v *= _t;
	}
	return {input: _x, result: _v, time: _time};
}

repeat(__FST.NUMBER_OF_PROCESSES*10000){
	remote_execute(factorial, [__FST.INDEX, current_time], icle)
	var _dt = current_time - __FST.last_frame_time;
	if (_dt >= __FST.ideal_frame_time*10){break;}
}



