//only allow one to exist
if (instance_number(object_index) > 1) { instance_destroy(); exit; }
game_set_speed(60, gamespeed_fps);
//init multi processing
MultiProcessingInit()

show_debug_overlay(true)

draw_txt = "";