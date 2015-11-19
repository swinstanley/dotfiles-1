@echo off
GOTO :MAIN

:eval
SET _evalresultvar=%1
if "%2"=="" (
  echo "ERROR: 2 arguments required for eval %_evalresultvar% <command>"
  goto :EOF
  )
shift
setlocal enabledelayedexpansion
set _cmdline=
:loop
echo %%1 is %1 cmdline is %_cmdline%
if not "%~1"=="" (
  set _cmdline=!_cmdline! %~1
  shift 
  goto :loop
  )

echo "executing %_cmdline%"
for /F "usebackq delims=" %%i in (`%_cmdline%`) do IF NOT "%%i"=="" ( SET _evalresult=!_evalresult! %%i)
echo "GOT %_evalresult%"
endlocal
goto :EOF
:getargc
    set getargc_v0=%1
    set /a "%getargc_v0% = 0"

:getargc_l0
    if not x%2x==xx (
        shift
        set /a "%getargc_v0% = %getargc_v0% + 1"
        goto :getargc_l0
    )
    set getargc_v0=
goto :eof
:menu
setlocal

FOR /L %%C in (1,1,9) DO IF NOT "%1" == "" (
   ECHO %%C - %1
   SHIFT /1 
   )
endlocal

goto :EOF
SET DEFAULTPYTHONDIR="C:\tools\python"
for /d %%p in ('c:\tools\python*') do IF EXIST %%p\python.exe (

  )

:MAIN
setlocal enableextensions enabledelayedexpansion
CALL :getargc argc Apples Frogs Peas
echo "Checked argument count it was=%argc%"
CALL :eval pver python -V
echo "Python version=%pver%"
endlocal
