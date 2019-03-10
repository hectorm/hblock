:: Author:     Héctor Molinero Fernández <hector@molinero.dev>
:: Repository: https://github.com/hectorm/hblock
:: License:    MIT, https://opensource.org/licenses/MIT

:: This script needs administrator privileges.
:: WARNING: consider disabling "DNS Client" service if your machine slows down.

@echo off

set "source=%~dp0hosts"
set "target=%windir%\System32\drivers\etc\hosts"

echo.
echo ==================
echo #     hBlock     #
echo ==================
echo.

if exist "%source%" (
	if exist "%target%" (
		attrib -r -s -h "%target%" > nul
	)

	copy /y "%source%" "%target%" > nul
	attrib +r "%target%" > nul
) else (
	echo Error, source file not found.
)

echo Execution finished.
echo.

pause
