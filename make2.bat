@echo off
mkdir build 2>nul
mkdir bin 2>nul
chdir build
REM if not exist "SLPS_006_VANILLA.61" (
    ..\tools\psximager\psxrip "..\Rockman 8 - Metal Heroes (Japan).cue" "..\build" >nul
    copy /Y /B SLPS_006.30 /B SLPS_006_VANILLA.30 /B >nul
REM )

..\tools\armips\armips hack.asm -root ..\src

if exist "..\bin\Rockman8_Practice2.cue" (
	..\tools\psximager\psxinject "..\bin\Rockman8_Practice.cue" SLPS_006.30 SLPS_006.30 >nul
) else (
	..\tools\psximager\psxbuild -c ..cat Rockman8_Practice.bin >nul
	move /y Rockman8_Practice.cue ..\bin\Rockman8_Practice.cue >nul
	move /y Rockman8_Practice.bin ..\bin\Rockman8_Practice.bin >nul
)


chdir ..
