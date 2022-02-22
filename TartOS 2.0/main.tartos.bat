@echo off
set ver=1.0                                                                               
:biosyn
cls
SET /P BIOSYN="Do you want to open BIOS? (Y,N): "
IF %BIOSYN%==Y goto bios
IF %BIOSYN%==N goto waitscr
:bios
::Use BIOS engine from WinDOS 4.5
cls
title Tart BIOS
echo ████████████████████████████████████
echo █Date: %date%█Time: %time%█
echo ████████████████████████████████████
echo ███████████ Tart BIOS  █████████████
echo ████████████████████████████████████
echo ████User██Personalize█Info█ Exit  ██
echo ████████████████████████████████████
echo ████Copyright 2022, TartSoft.(c)████
echo ████████████████████████████████████
set/p input="Input a number: "     
IF %input%==1 goto user_stt
IF %input%==2 goto personalize_stt
IF %input%==3 goto sysinf
IF %input%==4 goto waitscr
IF "%input%"=="" goto bios
:user_stt
cls
title User Setting - Tart BIOS
echo ████████████████████████████████████
echo ███████████ User Setting ███████████
echo ████████████████████████████████████
echo ███Protection█Core█Installed App████
echo ████████████████████████████████████
CHOICE /C PC /N /CS /M "P for Password reset, C for Sytem Info"
IF %ERRORLEVEL%==1 goto protection
IF %ERRORLEVEL%==2 goto info_s
:protection 
echo ████████████████████████████████████
echo █████████████Pass Reset█████████████
echo ████████████████████████████████████
echo ███This will reset your password████
echo ████████████████████████████████████
CHOICE /C YN /N /CS /M "Yes or No?"
IF %ERRORLEVEL%==1 del upwd.txt && goto signup
IF %ERRORLEVEL%==2 goto bios
:personalize_stt
cls
title Personalize - Tart BIOS
echo ████████████████████████████████████
echo ███████████Personalize██████████████
echo ████████████████████████████████████
echo ██Choose a color for the background█
echo ████████████████████████████████████
echo █Color attributes are specified by █
echo █TWO hex digits.                   █
echo █the first corresponds to the back-█
echo █ground; the second the foreground.█  
echo █Each digit can be any of the      █
echo █following values:                 █
echo ████████████████████████████████████
echo █  0 = Black       8 = Gray        █
echo █  1 = Blue        9 = Light Blue  █
echo █  2 = Green       A = Light Green █
echo █  3 = Aqua        B = Light Aqua  █
echo █  4 = Red         C = Light Red   █
echo █  5 = Purple      D = Light Purple█
echo █  6 = Yellow      E = Light Yellow█
echo █  7 = White       F = Bright White█
echo ████████████████████████████████████
set /p bkground=">"
::Check If user input empty by Aacini on DOSTips and Stack Overflow
IF "%bkground%" equ "" goto personalize_stt
goto bios
:sysinf
cls
title System Info - Tart BIOS
echo ████████████████████████████████████
echo ████████████System Info█████████████
echo ████████████████████████████████████
echo ██Version: %ver                  ██
echo ████████████████████████████████████
echo ██Status: Normal                  ██
echo ████████████████████████████████████
echo ██Boot Type: Fast                 ██
echo ████████████████████████████████████
echo ██Structure: TartCore             ██
echo ████████████████████████████████████
pause
goto bios
:waitscr
cls 
color %bkground%
title Booting Up...
echo.
echo      _____          _   _____ _____  
echo     ^|_   _^|        ^| ^| ^|  _  /  ___^| 
echo       ^| ^| __ _ _ __^| ^|_^| ^| ^| \ `--.  
echo       ^| ^|/ _` ^| '__^| __^| ^| ^| ^|`--. \ 
echo       ^| ^| (_^| ^| ^|  ^| ^|_\ \_/ /\__/ / 
echo       \_/\__,_^|_^|   \__^|\___/\____/  
echo ____________________________________________
echo                 TartOS %ver%
echo.
echo          Press any key to continue...                              
echo ____________________________________________
pause >NUL
echo.
echo            Checking Activation...
IF EXIST "actvmark.txt" goto passcheck
IF NOT EXIST "actvmark.txt" goto activationask 
timeout 3 >NUL
:passcheck
echo.
echo            Check Password file...
IF EXIST "upwd.txt" goto password
IF NOT EXIST "upwd.txt" goto signup
:activationask
cls
CHOICE /C 12 /N /M "1 to review the activation key, 2 to activate now"
IF %ERRORLEVEL%==1 call start actvk.tartos.vbs
IF %ERRORLEVEL%==2 goto activate
:activate
cls
set /p actvkey="Type your activation key here: "
IF %actvkey%==276-521-103 echo > actvmark.txt & exit 
IF NOT %actvkey%==276-521-103 msg * Your activate key is not correct & goto activationask
IF "%actvkey%"=="" goto activate
:password
cls
color %bkground%
title Password
::Credit to paxdiablo on Stack Overflow for pass input mask
set "psCommand=powershell -Command "$pword = read-host 'Enter Your Password Here' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p
::Credit to teddy place on Stack Overflow for his password read-compare
::Side Note: I know it would be a very bad idea to save the passowrd on a text file
    SET /p txt=<upwd.txt
    IF "%password%" == "%txt%" (
    ECHO "Password matched!" && goto mainscr
) ELSE (
    ECHO "Your password did not matched!"
    goto password
) 
:signup
cls
color %bkground%
title Signup
@echo off
::Credit to paxdiablo on Stack Overflow for his password input mask
set "psCommand=powershell -Command "$pword = read-host 'Enter Your Setup Password Here' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p
echo > upwd.txt
echo %password% >> upwd.txt
exit
:mainscr
cls
color %bkground%
title Main
call start guibox.appschoose.hta
pause > NUL