#macro CP_Version "1.0.0"

#macro CP_Is_IDE (string_pos("Runner.exe", string(parameter_string(0))) != 0)

//enum for async message use
#macro CP global.__ControlPanelEnum
CP = {
	"Button" : "Button",
	"Checkbox" : "Checkbox",
	"Dropdown" : "Dropdown",
	"Folder" : "Folder",
}


//environment variable
global.__ControlPanelInstanceID = int64(bool(EnvironmentGetVariableExists("ControlPanelInstanceID")) ? EnvironmentGetVariable("ControlPanelInstanceID") : string(0));
global.__ControlPanelChildProcessID = 0;
EnvironmentSetVariable("ControlPanelInstanceID", string(global.__ControlPanelInstanceID + 1));

//create the corosponding object
#macro Control_Panel global.__ControlPanel
if (!Control_Panel_Require_Init_Script) {
	time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, ControlPanelInit));
};

//The init function
function ControlPanelInit() {
	show_debug_message("[Red's Control Panel] : Thank you for using Red's Control Panel!")
	show_debug_message("[Red's Control Panel] : Version : "+CP_Version)
	
	if (Control_Panel_Spawn_Main_Process_First) {
		var _primary_obj = objControlPanelServer;
		var _secondary_obj = objControlPanelWorker;
	}
	else {
		var _primary_obj = objControlPanelWorker;
		var _secondary_obj = objControlPanelServer;
	}
	
	if (__cp_is_main_process()) {
		Control_Panel = instance_create_depth(0, 0, -16000, _primary_obj);
		
		// previous run file cleanup
		var dname = game_save_id + "/proc/";
		if directory_exists(dname) {
				directory_destroy(dname);
			}
		directory_create(dname);
		SpawnControlPanel();
	}
	else {
		Control_Panel = instance_create_depth(0, 0, -16000, _secondary_obj);
	}
	
}

//for use if you want to bind it to a button instead of instantly spawning it
function SpawnControlPanel() {
	// duplicate current process by executing its own command line
	global.__ControlPanelChildProcessID = ExecProcessFromArgVAsync(GetArgVFromProcid(ProcIdFromSelf())); // define child process id for later use
	
}

#region Control Panel Constructors
//control panel constructors, use these on the server's end to update the control panel it's self on the worker's end

function cp_button(_name, _callback) constructor {
	type = CP.Button;
	name = _name;
	callback = _callback;
}

function cp_checkbox(_name, _callback, _default_checked = false) constructor {
	type = CP.Checkbox;
	name = _name;
	callback = _callback;
	data = {
		value : _default_checked
	}
}

function cp_dropdown(_name, _callback, _arr, _default_index = -1) constructor {
	type = CP.Dropdown;
	name = _name;
	data = {
		index : _default_index,
		elements : _arr,
	}
}

function cp_folder(_name, _default_open = false) constructor {
	type = CP.Folder;
	name = _name;
	data = {};
	static add = function(_component) {
		data[$ _component.name] = _component;
		
		//queues up changes to the control panel to be synced out the the secondary process
		__queue_cp_update();
		
		return self;
	}
}

#endregion

#region Internal
	
	function __cp_is_main_process() {
		return (global.__ControlPanelInstanceID == 0);
	}
	
	function __cp_is_controller_process() {
		return (instance_exists(objControlPanelWorker));
	}
	
	function __queue_cp_update() {
		objControlPanelServer.cp_update_pending = true;
	}
	
	function __send_cp_update() {
		__cp_send_struct(objControlPanelServer.socket, objControlPanelServer.control_panel);
	}
	
	function __import_cp_update(_struct) {
		//handle the importing of the struct
	}
	
	#region Packet management
		
		function __cp_send_struct(_socket, _struct){
			var _buff = __cp_encode_struct(_struct);
			network_send_packet(_socket, _buff, buffer_tell(_buff));
			buffer_delete(_buff)
		}
		
		function __cp_encode_struct(_struct) {
			var _buff = buffer_create(1, buffer_grow, 1);
			var _json = json_stringify(_struct);
			
			buffer_seek(_buff, buffer_seek_start, 0)
			buffer_write(_buff, buffer_string, _json);
			return _buff;
		}
		
		function __cp_decode_struct(_buff){
			buffer_seek(_buff, buffer_seek_start, 0)
			var _json = buffer_read(_buff, buffer_string)
			buffer_delete(_buff)
			
			return json_parse(_json);
		}
		
	#endregion
	
#endregion