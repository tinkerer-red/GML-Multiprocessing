/// @desc Init

//hide the new process
//application_surface_draw_enable(false);
//draw_enable_drawevent(false)
socket_type = network_socket_tcp;

//step = __step_worker
//async = __receive_async_worker
//alarm0 = __alarm_worker
//alarm_set(0, game_get_speed(gamespeed_fps)*20)

//switch to an always inactive room
cp_room = room_add();
room_set_width(cp_room, 128)
room_set_height(cp_room, 256)
room_goto(cp_room);

//move the window
//window_set_position(1, 31);
window_set_size(360, 720);


//kill all other instances which aren't the control panel
var _oi = object_index;
with (all) {
	if (object_index != _oi){ instance_destroy() }
}

//connect to the host
socket = network_create_socket(socket_type)
connect_id = network_connect_async(socket, "127.0.0.1", Control_Panel_Port) //this defaults to a PULL connection
connected = false;


//display handlers
canvas_width  = window_get_width();
canvas_height = window_get_height();
