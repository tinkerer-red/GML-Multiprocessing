/// @desc
thread_count = 7;

if (int64(bool(EnvironmentGetVariableExists("MultiProcessingInstanceID")) ? EnvironmentGetVariable("MultiProcessingInstanceID") : string(0)) == 0) {
	threads = [];
	repeat (thread_count) {
		array_push(threads, new ProcessThread());
	}
}
else {
	thread = undefined;
}
global.test = 0;


function factorial(_x) {
	var _t = _x-1;
	var _v = _x;
	repeat (_x-2) {
		_t--;
		_v *= _t;
	}
	return _v;
}

