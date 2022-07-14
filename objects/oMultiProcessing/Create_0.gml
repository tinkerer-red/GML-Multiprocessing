//only allow one to exist
if (instance_number(object_index) > 1) { instance_destroy(); exit; }

//init multi processing
MultiProcessingInit()


show_debug_overlay(true)

timer_started = false;
timer = 0;
timer_max = game_get_speed(gamespeed_fps)*10;

