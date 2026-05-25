@echo off
echo ========================================
echo CEK IP ADDRESS PC
echo ========================================
echo.
ipconfig | findstr /i "IPv4"
echo.
echo ========================================
echo Gunakan IP address diatas untuk update
echo file: Quiz_App\lib\inti\layanan\layanan_api.dart
echo ========================================
pause
