/// @description Insert description here
// You can write your code in this editor


canvas_resized = function() {
	//cache previous values
	var _prev_width = canvas_width;
	var _prev_height = canvas_height;
	
	//store the new variables
	var _w = window_get_width();
	var _h = window_get_height();
	if (_w == 0) || (_h == 0) {
		//early out if the window was minimized
		return false;
	}
	
	//store current values
	canvas_width = _w;
	canvas_height = _h;
	
	//if the app was resized
	return (canvas_width != _prev_width) || (canvas_height != _prev_height);
}