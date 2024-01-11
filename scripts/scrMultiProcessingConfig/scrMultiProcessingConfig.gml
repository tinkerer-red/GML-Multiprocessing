//If the init script is required to be called or if the init script will automatically be called on game launch.
#macro MultiProcessing_Require_Init_Script true
//the port multiprocessing will use
#macro MultiProcessing_Port 63479
//the socket type to use
#macro MultiProcessing_Socket network_socket_tcp

//How much of each thread is allowed to be used.
//#macro MultiProcessing_Max_CPU_Percent 100

//How many threads to use, this needs to be replaced with a good way to count the number of threads
#macro MultiProcessing_Percent_Of_Cores 0.25 //{Float: 0-1} //The percent of available cores to make use of. the ideal max should roughly be 0.25 to leave the OS breathing room
#macro MultiProcessing_Number_Of_Processes_Min 1 //{Real}
#macro MultiProcessing_Number_Of_Processes_Max 7 //{Real}
#macro MultiProcessing_Unlock_Number_Of_Processes false //{Bool} This simply allows you to run more processes then you have cores, not suggested as it causes OS to lag till bluescreen

//{float: 0-1} How much of the frame to take up, 0.625 is usually a perfect number to keep your frames
// NOTE : if you're using a tick manager like IOTA set this value to 1;
#macro MultiProcessing_Percent_Of_Frame 0.025 //{Float 0-1} 

//{Real} If a negative value, this uncaps the amount of tasks able to be processed, MultiProcessing_Percent_Of_Frame will still be applicable despite this
// NOTE : if you produce more tasks then this hard limit you will eventually run out of memory
#macro MultiProcessing_Tasks_Per_Frame -1

//The speed at which your game will run
// NOTE : if you're using a tick manager like IOTA set this value to a value under tick rate speed.
#macro MultiProcessing_Frame_Speed 60

//If the main process will continue to run even if a subprocess dies should we create a new process in it's place?
#macro MultiProcessing_Respawn true

// Used to spawn the multiprocessing as the IDE's focused process for debugging
// True: The game process will be the first process launched and the IDE's console will have focus on that.
// False: A subprocess will be the first process launched and the IDE's console will have focus on that.
#macro MultiProcessing_Spawn_Main_Process_First true

#macro MultiProcessing_TTL 30 //{Real} The "Time To Live" in seconds a subprocesses have to respond, or get a signal from the main process.

#region Debugging
#macro GC_SAFE true //{Bool} if this is turned off there is no assurance that a task will ever complete
#macro USE_STRUCTS true //{Bool} Used for testing the speeds of structs over maps and vyseversa
#endregion