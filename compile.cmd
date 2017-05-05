@Echo Off
Set CurrentDir=%~dp0
Set CurrentDir=%CurrentDir:~0,-1%

pushd %CurrentDir%
mkdir "%CurrentDir%\bin" >NUL
Color 0E

cls
Echo ** Cleric Script Auto-Compiler  **
Echo version 1.0
Echo by Neanne - May 2017
Echo.
Set Script=%CurrentDir%\Cleric-bot.ahk
Set OutFile=%CurrentDir%\Bin\Auto-Cleric.exe
Set Icon=%CurrentDir%\Cleric-bot.ico

"C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%Script%" /icon "%Icon%" /out "%OutFile%"
Echo.
Echo Compile Done. Output file is : %OutFile%
Echo.
popd

Color 07
Echo Press Any key to continue.
pause >nul