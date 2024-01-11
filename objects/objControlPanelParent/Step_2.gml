// if game instance has child
fname = game_save_id + "/proc/" + string(ProcIdFromSelf()) + ".tmp";
if (file_exists(fname)) {
	var fd = file_text_open_read(fname);
	if (fd != -1) {
		var str = file_text_read_string(fd);
		file_text_readln(fd);
		file_text_close(fd);
		if (str == "CHILD_PROCESS_DIED") {
				game_end();
		}
	}
	else {
		show_error("ERROR: Failed to open file for reading!\n\nERROR DETAILS: Too many file descriptors opened by the current process or insufficient priviledges to access file!", true);
	}
}

// global.__ControlPanelChildProcessID == 0 if not successfully executed and CompletionStatusFromExecutedProcess() == true if child is dead
if (global.__ControlPanelChildProcessID != 0 && !CompletionStatusFromExecutedProcess(global.__ControlPanelChildProcessID)) {
	// die if child is dead
var fname = game_save_id + "/proc/" + string(global.__ControlPanelChildProcessID) + ".tmp";
	if (file_exists(fname)) {
		var fd = file_text_open_read(fname);
		if (fd != -1) {
			var str = file_text_read_string(fd);
			file_text_readln(fd);
			file_text_close(fd);
			if (str == "CHILD_PROCESS_DIED") {
					game_end();
			}
		}
		else {
			show_error("ERROR: Failed to open file for reading!\n\nERROR DETAILS: Too many file descriptors opened by the current process or insufficient priviledges to access file!", true);
		}
	}
}
