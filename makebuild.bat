@echo off
chdir build

..\tools\psximager\psxbuild -c ..cat Rockman8_Practice.bin >nul
move /y Rockman8_Practice.cue ..\bin\Rockman8_Practice.cue >nul
move /y Rockman8_Practice.bin ..\bin\Rockman8_Practice.bin >nul



chdir ..
