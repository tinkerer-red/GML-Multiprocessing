/// @desc
log(json_encode(async_load, true))

switch (async_load[? "type"]) {
	case network_type_connect : {
		if (async_load[? "status"] >= 0) {
			connected = true;
		}
	break;}
	case network_type_disconnect : {
		if (async_load[? "status"] >= 0) {
			connected = false;
			game_end();
		}
	break;}
	case network_type_data : {
		if (async_load[? "status"] >= 0) {
			
		}
	break;}
	case network_type_non_blocking_connect : {
		connected = network_connect_async(socket, "127.0.0.1", Control_Panel_Port);
	break;}
}
