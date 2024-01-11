//If the init script is required to be called or if the init script will automatically be called on game launch.
#macro Control_Panel_Require_Init_Script true

//the port the control panel will use
#macro Control_Panel_Port 63479

//If either program is closed then both will be closed. Otherwise only the control panel will be closed if the main process is closed.
#macro Control_Panel_Codependent true

//Used to spawn the control panel as the IDE's focused process for debugging
#macro Control_Panel_Spawn_Main_Process_First true
