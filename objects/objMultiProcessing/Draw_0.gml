/// @desc
draw_circle(0,0,32, true)

draw_text(300, 300, 
         $"global.MultiProcessingMainProcessID = {global.MultiProcessingMainProcessID}"
        +$"\nglobal.MultiProcessingProcessID = {global.MultiProcessingProcessID}"
        +$"\nis_main_process = {is_main_process}"
        //+$"\nProcIdExists(int64(global.MultiProcessingMainProcessID)) = {ProcIdExists(int64(global.MultiProcessingMainProcessID))}"
        //+$"\nEnvironmentGetVariable(\"MultiProcessingGameEnd\") = {EnvironmentGetVariable("MultiProcessingGameEnd")}"
        //+$"\nProcIdFromSelf() = {ProcIdFromSelf()}"
        //+$"\ntime_to_live = {time_to_live}"
)


