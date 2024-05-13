/// @desc
if (threads != undefined) {
	var _i=0; repeat(100_000) {
		var _thread = threads[_i%thread_count];
		_thread.Push(factorial,
				[_i],
				function(_result) {
					global.test += 1
				},
				function(_err){
					show_debug_message(_err);
				}
		)
	_i+=1;}//end repeat loop
	
}
