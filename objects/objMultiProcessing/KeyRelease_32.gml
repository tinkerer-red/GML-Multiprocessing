//just prevents a crash while testing
if (!__mp_is_main_process()) {
	exit;
}

test = function(_result) {
	_result.time = (get_timer()-_result.time)/1000
	draw_txt = string(_result)
	if (_result.input mod 1000 == 0) {
		if (_result.input == 100_000) {
			show_message_async("🎉🎉🎉 Test Successful! 🎉🎉🎉")
		}
		show_debug_message(_result)
	}
	remote_execute(factorial, [__MP.task_index, get_timer()], icle)
}

icle = function(_result) {
	_result.time = (get_timer()-_result.time)/1000
	draw_txt = string(_result)
	if (_result.input mod 1000 == 0) {
		if (_result.input == 100_000) {
			show_message_async("🎉🎉🎉 Test Successful! 🎉🎉🎉")
		}
		show_debug_message(_result)
	}
	remote_execute(factorial, [__MP.task_index, get_timer()], test)
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

var start_time = get_timer();
var runTime = 16_000_000;

var _i=1_000_000;repeat(__MP.processer_count*10) {
	//log(["factorial(_i, get_timer())", factorial(_i, get_timer())])
	remote_execute(factorial, [__MP.task_index, get_timer()], icle)
	
	//if (get_timer() - start_time > runTime) {break;};
_i+=1}
