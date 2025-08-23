@echo off
echo ========================================
echo   LANCEMENT DU PROJET SMARTPOWER
echo ========================================
echo.

echo 1. Test de connexion backend...
curl -X GET http://localhost:8081/api/test/ping
echo.

echo 2. Test d'authentification...
curl -X POST http://localhost:8081/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"admin@gmail.com\",\"password\":\"admin\"}"
echo.

echo 3. Demarrage du frontend...
start "Frontend React" cmd /k "cd /d C:\Users\pc\Desktop\Projet Stage 2.0\New FrontEnd\project && pnpm dev"

echo 4. Ouverture du navigateur...
start http://localhost:5173

echo.
echo ========================================
echo   PROJET LANCE AVEC SUCCES!
echo ========================================
echo.
echo Frontend: http://localhost:5173
echo Backend:  http://localhost:8081
echo.
echo Identifiants: admin@gmail.com / admin
echo.
pause
