{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "libxprocess",
  "androidactivityinject": "",
  "androidclassname": "",
  "androidcodeinjection": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidPermissions": [],
  "androidProps": false,
  "androidsourcedir": "",
  "author": "",
  "classname": "",
  "copyToTargets": 194,
  "date": "2021-06-09T05:32:23.3229009-05:00",
  "description": "",
  "exportToGame": true,
  "extensionVersion": "0.0.1",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"libxprocess.dll","constants":[
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_EXEP","hidden":false,"value":"0x1000",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_CWDP","hidden":false,"value":"0x2000",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_PPID","hidden":false,"value":"0x0100",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_CPID","hidden":false,"value":"0x0200",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_ARGV","hidden":false,"value":"0x0010",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_ENVV","hidden":false,"value":"0x0020",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"KINFO_OWID","hidden":false,"value":"0x0001",},
      ],"copyToTargets":194,"filename":"libxprocess.dll","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcessExecute","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"ProcessExecute","help":"ProcessExecute(command)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcessExecuteAsync","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"ProcessExecuteAsync","help":"ProcessExecuteAsync(command)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"CompletionStatusFromExecutedProcess","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"CompletionStatusFromExecutedProcess","help":"CompletionStatusFromExecutedProcess(procIndex)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ExecutedProcessWriteToStandardInput","argCount":0,"args":[
            2,
            1,
          ],"documentation":"","externalName":"ExecutedProcessWriteToStandardInput","help":"ExecutedProcessWriteToStandardInput(procId,input)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ExecutedProcessReadFromStandardOutput","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ExecutedProcessReadFromStandardOutput","help":"ExecutedProcessReadFromStandardOutput(procId)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcIdExists","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ProcIdExists","help":"ProcIdExists(procId)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcIdKill","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ProcIdKill","help":"ProcIdKill(procId)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcListCreate","argCount":0,"args":[],"documentation":"","externalName":"ProcListCreate","help":"ProcListCreate()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcessId","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"ProcessId","help":"ProcessId(procList,i)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcessIdLength","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ProcessIdLength","help":"ProcessIdLength(procList)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"FreeProcInfo","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"FreeProcInfo","help":"FreeProcInfo(procInfo)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"FreeProcList","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"FreeProcList","help":"FreeProcList(procList)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ExecutableImageFilePath","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ExecutableImageFilePath","help":"ExecutableImageFilePath(procInfo)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"CurrentWorkingDirectory","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"CurrentWorkingDirectory","help":"CurrentWorkingDirectory(procInfo)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ParentProcessId","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ParentProcessId","help":"ParentProcessId(procInfo)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ChildProcessId","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"ChildProcessId","help":"ChildProcessId(procInfo,i)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ChildProcessIdLength","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ChildProcessIdLength","help":"ChildProcessIdLength(procInfo)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"CommandLine","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"CommandLine","help":"CommandLine(procInfo,i)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"CommandLineLength","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"CommandLineLength","help":"CommandLineLength(procInfo)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"Environment","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"Environment","help":"Environment(procInfo,i)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"EnvironmentLength","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"EnvironmentLength","help":"EnvironmentLength(procInfo)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"OwnedWindowId","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"OwnedWindowId","help":"OwnedWindowId(procInfo,i)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"OwnedWindowIdLength","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"OwnedWindowIdLength","help":"OwnedWindowIdLength(procInfo)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"WindowIdExists","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"WindowIdExists","help":"WindowIdExists(winId)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"WindowIdKill","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"WindowIdKill","help":"WindowIdKill(winId)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcIdFromSelf","argCount":0,"args":[],"documentation":"","externalName":"ProcIdFromSelf","help":"ProcIdFromSelf()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ParentProcIdFromSelf","argCount":0,"args":[],"documentation":"","externalName":"ParentProcIdFromSelf","help":"ParentProcIdFromSelf()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ExecutableFromSelf","argCount":0,"args":[],"documentation":"","externalName":"ExecutableFromSelf","help":"ExectuableFromSelf()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"DirectoryGetCurrentWorking","argCount":0,"args":[],"documentation":"","externalName":"DirectoryGetCurrentWorking","help":"DirectoryGetCurrentWorking()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"DirectorySetCurrentWorking","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"DirectorySetCurrentWorking","help":"DirectorySetCurrentWorking(dname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"EnvironmentGetVariable","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"EnvironmentGetVariable","help":"EnvironmentGetVariable(name)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"EnvironmentSetVariable","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"EnvironmentSetVariable","help":"EnvironmentSetVariable(name,value)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"EnvironmentUnsetVariable","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"EnvironmentUnsetVariable","help":"EnvironmentUnsetVariable(name)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"FreeExecutedProcessStandardInput","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"FreeExecutedProcessStandardInput","help":"FreeExecutedProcessStandardInput(procIndex)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"FreeExecutedProcessStandardOutput","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"FreeExecutedProcessStandardOutput","help":"FreeExecutedProcessStandardOutput(procIndex)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcInfoFromProcId","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ProcInfoFromProcId","help":"ProcInfoFromProcId(procId)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ExeFromProcId","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"ExeFromProcId","help":"ExeFromProcId(procId)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"CwdFromProcId","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"CwdFromProcId","help":"CwdFromProcId(procId)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"DirectoryGetTemporaryPath","argCount":0,"args":[],"documentation":"","externalName":"DirectoryGetTemporaryPath","help":"DirectoryGetTemporaryPath()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"WindowIdFromNativeWindow","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"WindowIdFromNativeWindow","help":"WindowIdFromNativeWindow(window)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"EnvironmentGetVariableExists","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"EnvironmentGetVariableExists","help":"","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"ProcInfoFromProcIdEx","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"ProcInfoFromProcIdEx","help":"ProcInfoFromProcIdEx(procId,kInfoFlags)","hidden":false,"kind":1,"returnType":2,},
      ],"init":"","kind":1,"order":[
        {"name":"ProcessExecute","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcessExecuteAsync","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"CompletionStatusFromExecutedProcess","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ExecutedProcessWriteToStandardInput","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ExecutedProcessReadFromStandardOutput","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcIdExists","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcIdKill","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcListCreate","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcessId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcessIdLength","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"FreeProcInfo","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"FreeProcList","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ExecutableImageFilePath","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"CurrentWorkingDirectory","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ParentProcessId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ChildProcessId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ChildProcessIdLength","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"CommandLine","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"CommandLineLength","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"Environment","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"EnvironmentLength","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"OwnedWindowId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"OwnedWindowIdLength","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"WindowIdExists","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"WindowIdKill","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcIdFromSelf","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ParentProcIdFromSelf","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ExecutableFromSelf","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"DirectoryGetCurrentWorking","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"DirectorySetCurrentWorking","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"EnvironmentGetVariable","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"EnvironmentGetVariableExists","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"EnvironmentSetVariable","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"EnvironmentUnsetVariable","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"DirectoryGetTemporaryPath","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"FreeExecutedProcessStandardInput","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"FreeExecutedProcessStandardOutput","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcInfoFromProcId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ProcInfoFromProcIdEx","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"ExeFromProcId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"CwdFromProcId","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"WindowIdFromNativeWindow","path":"extensions/libxprocess/libxprocess.yy",},
      ],"origname":"","ProxyFiles":[
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libxprocess.dylib","TargetMask":1,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libxprocess_arm.so","TargetMask":7,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libxprocess_arm64.so","TargetMask":7,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libxprocess.so","TargetMask":7,},
      ],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"libxprocess.zip","constants":[],"copyToTargets":0,"filename":"libxprocess.zip","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"libxprocess.gml","constants":[],"copyToTargets":194,"filename":"libxprocess.gml","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"libxprocess_init","argCount":0,"args":[],"documentation":"","externalName":"libxprocess_init","help":"libxprocess_init()","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"execute_shell","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"execute_shell","help":"execute_shell(prog,arg)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"execute_program","argCount":0,"args":[
            1,
            1,
            2,
          ],"documentation":"","externalName":"execute_program","help":"execute_program(prog,arg,wait)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_enable_stddesc","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_enable_stddesc","help":"file_text_enable_stddesc(enable)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_open_write_stdin","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_open_write_stdin(pid)","help":"file_text_open_write_stdin(pid)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_write_string_stdin","argCount":0,"args":[
            2,
            1,
          ],"documentation":"","externalName":"file_text_write_string_stdin(file,","help":"file_text_write_string_stdin(file,str)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_close_stdin","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_close_stdin(file)","help":"file_text_close_stdin(file)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_open_read_stdout","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_open_read_stdout","help":"file_text_open_read_stdout(pid)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_read_string_stdout","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_read_string_stdout","help":"file_text_read_string_stdout(file)","hidden":false,"kind":2,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_close_stdout","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_close_stdout","help":"file_text_close_stdout(file)","hidden":false,"kind":2,"returnType":2,},
      ],"init":"libxprocess_init","kind":2,"order":[
        {"name":"libxprocess_init","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"execute_shell","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"execute_program","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_enable_stddesc","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_open_write_stdin","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_write_string_stdin","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_close_stdin","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_open_read_stdout","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_read_string_stdout","path":"extensions/libxprocess/libxprocess.yy",},
        {"name":"file_text_close_stdout","path":"extensions/libxprocess/libxprocess.yy",},
      ],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
  ],
  "gradleinject": "",
  "hasConvertedCodeInjection": true,
  "helpfile": "",
  "HTML5CodeInjection": "",
  "html5Props": false,
  "IncludedResources": [],
  "installdir": "",
  "iosCocoaPodDependencies": "",
  "iosCocoaPods": "",
  "ioscodeinjection": "",
  "iosdelegatename": "",
  "iosplistinject": "",
  "iosProps": false,
  "iosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "license": "",
  "maccompilerflags": "",
  "maclinkerflags": "",
  "macsourcedir": "",
  "options": [],
  "optionsFile": "options.json",
  "packageId": "",
  "parent": {
    "name": "xProcess",
    "path": "folders/_Libraries/xProcess.yy",
  },
  "productId": "",
  "sourcedir": "",
  "supportedTargets": -1,
  "tvosclassname": null,
  "tvosCocoaPodDependencies": "",
  "tvosCocoaPods": "",
  "tvoscodeinjection": "",
  "tvosdelegatename": null,
  "tvosmaccompilerflags": "",
  "tvosmaclinkerflags": "",
  "tvosplistinject": "",
  "tvosProps": false,
  "tvosSystemFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
}