__FST.step();

if (timer_started) {
	var _lag = (delta_time * game_get_speed(gamespeed_fps) * 0.000001);
	timer += 1*_lag;
	if (timer >= timer_max){
		game_end();
	}
}
