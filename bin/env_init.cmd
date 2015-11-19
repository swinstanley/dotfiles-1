@echo off
SET _DEBUG=0
GOTO :MAIN 
:CLEAR
    SET PATH=
    SET LIB=
    SET INCLUDE=
    FOR /F "usebackq tokens=1 delims==" %%V in (`SET ENV_`) DO SET "%%V="
GOTO :EOF
:CORE 
    SET "PATH=e:\home\swinstanley\bin\"

:WINDOWS

    SET "PATH=%PATH%;%WINDIR%;%WINDIR%\System32"
    GOTO :EOF
:PYTHON 
    IF "%PYTHON%"=="" SET "PYTHON=C:\tools\python\python.exe"
    IF NOT EXIST "%PYTHON%" ( "ECHO Unable to find %PYTHON%" & exit 5)
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
        SET VSVARS_FLAGS=x86
    )
    IF "%VCARCH%"=="64" (
        SET VSVARS_FLAGS=amd64 
    )

    IF "%VSVARS_FLAGS%"==""  (
        ECHO "Error in :VS_PYTHON unable to discover compiler version"
        GOTO :EOF
    )
    SET _BASEDIR=
    REM ECHO SETTING VC++ Directories for VC Version %VCVER%
    @IF "%VCVER%"=="1500" ( 
    SET "_BASEDIR=C:\Program Files (x86)\Common Files\Microsoft\Visual C++ for Python\9.0\" 

    @IF "%VCVER%"=="1600" ( 
    SET "_BASEDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0\" )

    @IF "%VCVER%"=="1900" ( 
    SET "_BASEDIR=C:\Program Files (x86)\Microsoft Visual Studio 14.0\" )

    IF "%_BASEDIR%"=="" (
        ECHO Unable to find visual studio base directory
        GOTO :EOF )

    IF EXIST "%_BASEDIR%\VC\bin\%VCARCH%" ( 
        SET "PATH=%PATH%;%_BASEDIR%\VC\bin\%VCARCH%" 
        ) ELSE (
        SET "PATH=%PATH%;%_BASEDIR%\VC\bin"
        )
    
    IF EXIST "%_BASEDIR%\VC\lib\%VCARCH%" ( 
        SET "LIB=%PATH%;%_BASEDIR%\VC\lib\%VCARCH%;%_BASEDIR%\VC\atlmfc\lib\%VCARCH%" 
        ) ELSE (
            SET "LIB=%PATH%;%_BASEDIR%\VC\lib;%_BASEDIR%\VC\atlmfc\lib"
        )

        SET "INCLUDE=%PATH%;%_BASEDIR%\VC\include;%_BASEDIR%\VC\atlmfc\include" 

        FOR /F "tokens=2 delims==" %%V in (`SET ENV_INCLUDE`) DO SET "INCLUDE=!INCLUDE!;%%V"
        FOR /F "usebackq tokens=2 delims==" %%V in (`SET ENV_LIB`) DO SET "LIB=!LIB!;%%V"

GOTO :EOF

:MAIN
IF "%1"=="" ( 
    SET TARGETS=CLEAR CORE WINDOWS PYTHON VIM GIT CHOCOLATEY MSYS NODEJS VS_PYTHON
) ELSE SET TARGETS=%*

FOR %%T in (%TARGETS%) DO ECHO :%%T &  CALL :%%T



