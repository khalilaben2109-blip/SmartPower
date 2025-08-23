@echo off
echo ========================================
echo   DEMARRAGE FINAL FONCTIONNEL
echo ========================================
echo.

echo 1. Test de connexion backend...
curl -X GET http://localhost:8081/api/test/ping

echo.
echo 2. Test des comptes existants...
curl -X GET http://localhost:8081/api/existing/test-login

echo.
echo 3. Test d'authentification...
curl -X POST http://localhost:8081/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"admin@gmail.com\",\"password\":\"admin\"}"

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
echo executez le script SQL fix-admin-user.sql dans pgAdmin
echo.
pause
