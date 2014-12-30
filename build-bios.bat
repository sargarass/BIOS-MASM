@echo off

if .%1.==.. goto build_all

:build_this
echo.
echo Build %1.BIN files

if exist %1.bin del %1.bin
if exist src/%1.asm (
	echo Compile %1.asm with Intel syntax
	echo.
	
	for /D %%d in ("c:\program files*") do (
		for /D %%f in ("%%d\microsoft visual studio*") do (
			if exist "%%f\Common7\Tools\vsvars32.bat" (
				call "%%f\Common7\Tools\vsvars32.bat"
			)
		)
	)

	if exist %1.obj del %1.obj

        ml /Zm /nologo /omf /c /Fl src/%1.asm
	echo.

	if exist %1.obj (

		rem wlink SYS dos com file %1.obj name %1.bin
		echo .\chk\link /tiny %1.obj, %1.tmp, %1.map, , nul.def
                .\chk\link /tiny /nologo %1.obj, %1.tmp, %1.map, , nul.def
		echo.

		del %1.obj
		if exist %1.tmp (
			if %1==bios (
				copy /b .\chk\zero.bin+%1.tmp %1.bin >nul
				del %1.tmp
			)
		)
	)
)

if exist %1.bin (
	echo success: %1.bin was translated and linked

rem	if %1==badchksum .\chk\chks badchksum.bin
	if %1==badsign .\chk\chks badsign.bin
	if %1==tools .\chk\chks tools.bin
	if %1==check .\chk\chks check.bin
) else (
	echo ERROR: %1.bin was not builded!
)
goto done

:build_all
call :build_this bios
rem call build-bios tools
rem call build-bios badchksum
rem call build-bios badsign
rem call build-bios check

:done
echo.
exit
