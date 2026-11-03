if "%TARGET_PLATFORM%" == "win-arm64" (
    set CUDA_ARCH=arm64
) else (
    set CUDA_ARCH=x64
)

if not exist %PREFIX% mkdir %PREFIX%
mkdir %LIBRARY_LIB%\%CUDA_ARCH%
mkdir %LIBRARY_INC%\targets
mkdir %LIBRARY_INC%\targets\%CUDA_ARCH%

xcopy /E /I /Y lib\cmake "%LIBRARY_LIB%\%CUDA_ARCH%\cmake"
xcopy /E /I /Y include\* "%LIBRARY_INC%\targets\%CUDA_ARCH%"
