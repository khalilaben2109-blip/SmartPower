@echo off
echo ========================================
echo   DEMARRAGE AVEC COMPTES EXISTANTS
echo ========================================
echo.

echo 1. Demarrage du Backend Spring Boot...
start "Backend Spring Boot" cmd /k "cd /d C:\Users\pc\Desktop\Projet Stage 2.0\THE NEW BACKEND\THE NEW BACKEND && mvn spring-boot:run"

echo 2. Attente du demarrage du backend...
timeout /t 20 /nobreak > nul

echo 3. Test des comptes existants...
curl -X GET http://localhost:8081/api/existing/test-login

echo.
echo 4. Demarrage du Frontend React...
start "Frontend React" cmd /k "cd /d C:\Users\pc\Desktop\Projet Stage 2.0\New FrontEnd\project && pnpm dev"

echo.
echo ========================================
echo   APPLICATIONS DEMARREES !
echo ========================================
echo.
echo Backend:  http://localhost:8081
echo Frontend: http://localhost:5173
echo.
echo Compte existant dans la base de donnees:
echo - admin@gmail.com / admin
echo.
echo IMPORTANT: Si l'authentification ne fonctionne pas,
echo executez le script SQL update-password.sql dans pgAdmin
echo.
echo Test de connexion:
echo curl -X POST http://localhost:8081/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"admin@gmail.com\",\"password\":\"admin\"}"
echo.
pause
