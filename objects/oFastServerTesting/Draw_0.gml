if (__FST.clients_connected){
	draw_circle_color(x, y, 32, c_green, c_green, false)
}else{
	draw_circle_color(x, y, 32, c_red, c_red, false)
}

draw_text(200,200, string(__FST.latency))
