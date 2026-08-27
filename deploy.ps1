$ErrorActionPreference = "Stop"

Write-Host "Construyendo la aplicacion de Flutter para Web..."
flutter build web

Write-Host "Reestructurando archivos para Firebase Hosting..."
# Usar Move-Item con -Force para sobreescribir app.html si ya existe
Move-Item -Path "build\web\index.html" -Destination "build\web\app.html" -Force

# Mover la landing page y sus assets a la raiz de build/web
Copy-Item -Path "build\web\landing\*" -Destination "build\web\" -Recurse -Force

Write-Host "Desplegando a Firebase Hosting..."
firebase deploy --only hosting

Write-Host "Deploy completado con exito!"
