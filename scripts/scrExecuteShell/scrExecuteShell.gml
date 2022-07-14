function log(_str){
	show_debug_message(_str)
}

function _runner_get_path(){
	var _map = os_get_info();
	var _is64bit = _map[? "is64bit"];
	ds_map_destroy(_map);
	switch (os_type){
		case os_windows:
			var _os_path = "\\windows";
			if (_is64bit) { _os_path += "\\x64"}
			_os_path += "\\Runner.exe"
		break;
		/* currently unsupported
		case os_macosx:
			var _os_path = "\mac";
			var _extension = ".exe"
		break;
		case os_linux:
			var _os_path = "\linux";
			var _extension = ".exe"
		break;
		*/
	}
	
	return environment_get_variable("ProgramData")+"\\GameMakerStudio2\\Cache\\runtimes\\runtime-"+string(GM_runtime_version)+_os_path;
}

function _runner_get_game_path(){
	var _AppData = environment_get_variable("APPDATA") // "C:\Users\{USER}\AppData\Roaming"
	_AppData = string_replace(_AppData, "Roaming", "Local\\GameMakerStudio2\\GMS2TEMP\\");
	var _folder = string_replace(working_directory, "Y:\\", ""); // "Multi_Processing_45F40BE9_VM\"
	var _game_name = string_replace(game_project_name, "_", " ") // converts "Multi_Processing" into "Multi Processing"
	return "\""+_AppData+_folder+_game_name+".win\""
}

function ExecuteShell(_fname, _wait, _hidden = undefined) {
	/* 
		ExecuteShell(fname, wait, hidden);
		fname: file, program, or command to execute.
		wait: wait for file to close before resume?
		hidden: hide all files opened from command?
		"hidden" is both optional and Windows-only.
		"hidden" only works on files, not programs.
		"hidden" can hide batch files' cmd windows.
	*/
	
	switch(os_type){
		case os_windows:
			var ExecuteShell_result = (is_undefined(_hidden)) ? ExecuteShellWin(_fname, _wait) : ExecuteShellWinExt(_fname, _wait, _hidden);
			keyboard_clear(keyboard_lastkey);
			mouse_clear(mouse_lastbutton);
			return ExecuteShell_result;
		break;
		case os_macosx:
			var ExecuteShell_result = ExecuteShellMac(_fname, _wait);
			keyboard_clear(keyboard_lastkey);
			mouse_clear(mouse_lastbutton);
			return ExecuteShell_result;
		break;
		case os_linux:
			var ExecuteShell_result = ExecuteShellLinux(_fname, _wait);
			external_free("ExecuteShell.so");
			keyboard_clear(keyboard_lastkey);
			mouse_clear(mouse_lastbutton);
			return ExecuteShell_result;
		break;
	}

}
