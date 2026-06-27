@echo off
set PATH=C:\Program Files\Git\bin;C:\Program Files\Git\cmd;C:\Program Files\Git\usr\bin;%PATH%
set GIT_EXECUTABLE=C:\Program Files\Git\bin\git.exe
cd /d "C:\Users\Hirieo\projects\ValleySave\valleysave-app"
call "C:\Users\Hirieo\Downloads\flutter_windows_3.44.0-stable\flutter\bin\flutter.bat" %*
