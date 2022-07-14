function open_two_windows() {
	if (parameter_count() == 3) {
	    ExecuteShell(parameter_string(0) + " " +
	        parameter_string(1) + " " +
	        parameter_string(2) + " " +
			parameter_string(3) + " "+
			parameter_string(4) + " -secondary" + " -tertiary", false, false)
	    // <primary instance>
	    window_set_caption("P1")
	
		window_set_position(200, 260);
	}

	if (parameter_count() > 3) {
	    // <secondary instance>
	    window_set_caption("P2")
	
		window_set_position(900, 260);
	}
	if (parameter_count() > 3) {
	    // <third instance>
	    window_set_caption("P2")
	
		window_set_position(900, 260);
	}


}
