@echo off
echo ========================================
echo   DEMARRAGE DE L'APPLICATION SMARTPOWER
echo ========================================
echo.

echo 1. Demarrage du Backend Spring Boot...
start "Backend Spring Boot" cmd /k "cd /d C:\Users\pc\Desktop\Projet Stage 2.0\THE NEW BACKEND\THE NEW BACKEND && mvn spring-boot:run"

echo 2. Attente du demarrage du backend...
timeout /t 15 /nobreak > nul

echo 3. Demarrage du Frontend React...
start "Frontend React" cmd /k "cd /d C:\Users\pc\Desktop\Projet Stage 2.0\New FrontEnd\project && pnpm dev"

echo.
echo ========================================
echo   APPLICATIONS DEMARREES !
echo ========================================
echo.
echo Backend:  http://localhost:8081
echo Frontend: http://localhost:5173
echo.
echo Comptes de test:
echo - admin@example.com / password
echo - client@example.com / password
echo - technical@example.com / password
echo.
pause
