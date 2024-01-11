/// @desc Init Internals
socket_type = network_socket_tcp;

callbacks = ds_map_create();
socket = undefined;
connected = 0;
cp_update_pending = true;

//step = __step_server;
//async = __receive_async_server;
//alarm0 = __alarm_server;
alarm_set(0, game_get_speed(gamespeed_fps)*6)


server = network_create_server(socket_type, Control_Panel_Port, 1)
