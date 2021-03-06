@echo off
:: Copyright (c) 2011 Google Inc. All rights reserved.
::
:: Redistribution and use in source and binary forms, with or without
:: modification, are permitted provided that the following conditions are
:: met:
::
::    * Redistributions of source code must retain the above copyright
:: notice, this list of conditions and the following disclaimer.
::    * Redistributions in binary form must reproduce the above
:: copyright notice, this list of conditions and the following disclaimer
:: in the documentation and/or other materials provided with the
:: distribution.
::    * Neither the name of Google Inc. nor the names of its
:: contributors may be used to endorse or promote products derived from
:: this software without specific prior written permission.
::
:: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
:: "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
:: LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
:: A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
:: OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
:: SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
:: LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
:: DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
:: THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
:: (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
:: OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


setlocal

:: build our shim
cl /nologo /Ox /Zi /W4 /WX /D_CRT_SECURE_NO_WARNINGS /EHsc supalink.cpp /link /out:supalink.exe
if errorlevel 1 goto dead

:: == which link.exe
for %%i in (link.exe) do @set REALLINK=%%~$PATH:i

set SAVETO=%REALLINK%.supalink_orig.exe

if exist "%SAVETO%" goto alreadyexists
:continueafterexists

echo.
echo Going to save original link.exe from:
echo.
echo   %REALLINK%
echo.
echo as:
echo.
echo   %SAVETO%
echo.
echo (as well as the associated .config file) and replace link.exe with supalink.exe.
echo.
echo OK? (Ctrl-C to cancel)
pause

copy /y "%REALLINK%" "%SAVETO%"
copy /y "%REALLINK%.config" "%SAVETO%.config"
copy /y supalink.exe "%REALLINK%"
echo Done. You should be able to enable "Use Library Dependency Inputs" on large projects now.

goto done

:dead
echo Maybe run vsvars32.bat first?
goto done

:alreadyexists
echo.
echo Backup location "%SAVETO%" already exists.
echo.
echo Restoring that to original link.exe first, OK?
pause
move /y "%SAVETO%" "%REALLINK%"
goto continueafterexists

:done
