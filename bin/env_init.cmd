@echo off
SET _DEBUG=0
SET _THIS_FILE=%~f0
GOTO :MAIN 
:CLEAR
    SET PATH=
    SET LIB=
    SET INCLUDE=
    FOR /F "usebackq tokens=1 delims==" %%V in (`SET ENV_ 2^>nul` ) DO SET "%%V="
GOTO :EOF
:CORE 
    SET "PATH=e:\home\swinstanley\bin\"

:WINDOWS

    SET "PATH=%PATH%;%WINDIR%;%WINDIR%\System32"
    GOTO :EOF

:PYTHON27
    SET "PYTHON=c:\tools\python2\python.exe"
    GOTO :PYTHON
:PY34
:PYTHON34_64
    SET "PYTHON=C:\tools\python34_64\python.exe"
    GOTO :PYTHON

:PY34_32
:PYTHON34_32
    SET "PYTHON=C:\tools\PYTHON34_32Bit\python.exe"
    GOTO :PYTHON
:PY35
SET PYTHON=c:\tools\python\python.exe

:PYTHON 
    IF "%PYTHON%"=="" SET "PYTHON=C:\tools\python\python.exe"
    IF NOT EXIST "%PYTHON%" ( "ECHO Unable to find %PYTHON%" & GOTO :EOF)
    IF "%_DEBUG%"=="" ("ECHO %PYTHON% being used to seed path")

    FOR /F %%I in ("%PYTHON%") DO SET "_PYDIR=%%~dpI"
    SET "PATH=%PATH%;%_PYDIR%;%_PYDIR%Scripts\" 
    SET "ENV_LIBPYTHON=%_PYDIR%Libs"
    SET "ENV_INCLUDEPYTHON=%_PYDIR%Include"
    SET _PYDIR=
GOTO :EOF

:VIM
    SET "PATH=%PATH%;e:\home\swinstanley\Documents\vim\vim74\"

GOTO :EOF
:CMDER
    @set PATH=%PATH%;%CMDER_ROOT%\vendor\conemu-maximus5\Conemu
GOTO :EOF
:GIT
    SET "PATH=%PATH%;C:\Program Files\Git\cmd\"
GOTO :EOF

:CHOCOLATEY
    SET "PATH=%PATH%;C:\ProgramData\Chocolatey\bin\"
GOTO :EOF

:MSYS
    SET "PATH=%PATH%;C:\MSYS64\usr\bin\;C:\MSYS64\mingw64\bin\"
GOTO :EOF

:NODEJS
    SET "PATH=%PATH%;C:\Program Files\NodeJS\;%APPDATA%\npm\"
GOTO :EOF

REM -------------------------------------------------------------------------------- 
REM SET VC VERSION TO MATCH PYTHON FUNCTIONALITY
REM -------------------------------------------------------------------------------- 
:VS_PYTHON
    for /f "tokens=3,4 delims=()., " %%I in ('%PYTHON% -c "import platform;print(platform.python_compiler())"') DO IF NOT "%%J"=="" (
        SET "VCVER=%%I" 
        SET "VCARCH=%%J"   
        )
    
    IF "%VCARCH%"=="32" (
        SET "ARCHDIR="
    )
    IF "%VCARCH%"=="64" (
        SET ARCHDIR=amd64
    )

    SET _BASEDIR=
    @IF "%VCVER%"=="1500" SET "_BASEDIR=C:\Program Files (x86)\Common Files\Microsoft\Visual C++ for Python\9.0"

    @IF "%VCVER%"=="1600" SET "_BASEDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0" 
    

    @IF "%VCVER%"=="1900" SET "_BASEDIR=C:\Program Files (x86)\Microsoft Visual Studio 14.0"

    IF "%_BASEDIR%"=="" (
        ECHO Unable to find visual studio base directory
        GOTO :EOF )

        SET "PATH=%PATH%;%_BASEDIR%\VC\bin\%ARCHDIR%" 
        SET "LIB=%PATH%;%_BASEDIR%\VC\lib\%ARCHDIR%;%_BASEDIR%\VC\atlmfc\lib\%ARCHDIR%" 

        SET "INCLUDE=%PATH%;%_BASEDIR%\VC\include;%_BASEDIR%\VC\atlmfc\include" 
        REM FOR /F "tokens=2 delims==" %%V in (`SET ENV_INCLUDE`) DO SET INCLUDE=!INCLUDE!;%%V
        REM FOR /F "usebackq tokens=2 delims==" %%V in (`SET ENV_LIB`) DO SET LIB=!LIB!;%%V

GOTO :EOF
:HELP
echo COMMANDS ARE
for /F "usebackq tokens=1 delims=:" %%I in (`findstr /R "^:[a-Z].*" "%_THIS_FILE%"`) DO (ECHO %%I)
GOTO :EOF
:MAIN
IF "%*:help=" == "%*" (
    SET TARGETS=HELP
)
IF "%1"=="" ( 
    SET TARGETS=CLEAR CORE WINDOWS PYTHON VIM GIT CHOCOLATEY MSYS NODEJS VS_PYTHON CMDER
) ELSE SET TARGETS=%*

FOR %%T in (%TARGETS%) DO ECHO :%%T &  CALL :%%T
SET _THIS_FILE=
SET TARGETS=


