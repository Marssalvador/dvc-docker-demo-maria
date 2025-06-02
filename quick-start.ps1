# ML + DVC + Docker Demo - Quick Start Script for Windows PowerShell
# Script de inicio rápido para Windows

Write-Host "🚀 ML + DVC + Docker Demo - Inicio Rápido" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Verificar requisitos
Write-Host "`n🔍 Verificando requisitos..." -ForegroundColor Yellow

# Verificar Docker
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker disponible: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker no está instalado o no está en PATH" -ForegroundColor Red
    Write-Host "   Instala Docker Desktop desde: https://docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "Dockerfile")) {
    Write-Host "❌ No se encontró Dockerfile. Asegúrate de estar en el directorio del proyecto." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Directorio correcto confirmado" -ForegroundColor Green

# Crear directorio models si no existe
if (-not (Test-Path "models")) {
    New-Item -ItemType Directory -Name "models" | Out-Null
    Write-Host "✅ Directorio models creado" -ForegroundColor Green
}

# Construir imagen Docker
Write-Host "`n🏗️  Construyendo imagen Docker..." -ForegroundColor Yellow
try {
    docker build -t ml-dvc-demo .
    Write-Host "✅ Imagen construida exitosamente" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al construir la imagen Docker" -ForegroundColor Red
    exit 1
}

# Ejecutar entrenamiento
Write-Host "`n🤖 Ejecutando entrenamiento del modelo..." -ForegroundColor Yellow
try {
    docker run --rm --name ml-dvc-demo-container -v "${PWD}/models:/app/models" ml-dvc-demo
    Write-Host "✅ Entrenamiento completado" -ForegroundColor Green
} catch {
    Write-Host "❌ Error durante el entrenamiento" -ForegroundColor Red
    exit 1
}

# Verificar resultados
Write-Host "`n📊 Verificando resultados..." -ForegroundColor Yellow
if (Test-Path "models/model.pkl") {
    $fileSize = (Get-Item "models/model.pkl").Length
    Write-Host "✅ Modelo generado: models/model.pkl ($fileSize bytes)" -ForegroundColor Green
} else {
    Write-Host "❌ No se encontró el modelo generado" -ForegroundColor Red
    exit 1
}

# Ejecutar pruebas
Write-Host "`n🧪 Ejecutando pruebas..." -ForegroundColor Yellow
try {
    docker run --rm --name ml-dvc-demo-test -v "${PWD}/models:/app/models" ml-dvc-demo python test_project.py
    Write-Host "✅ Pruebas completadas exitosamente" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Advertencia: Algunas pruebas pueden haber fallado" -ForegroundColor Yellow
}

# Resumen final
Write-Host "`n🎉 ¡Proyecto completado exitosamente!" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "📁 Modelo guardado en: models/model.pkl" -ForegroundColor White
Write-Host "🐳 Imagen Docker: ml-dvc-demo" -ForegroundColor White
Write-Host "`n💡 Próximos pasos:" -ForegroundColor Yellow
Write-Host "   • Explora el contenedor: docker run -it --rm ml-dvc-demo bash" -ForegroundColor White
Write-Host "   • Ver ayuda del Makefile: make help (si tienes Make instalado)" -ForegroundColor White
Write-Host "   • Leer documentación: README.md" -ForegroundColor White
Write-Host "   • Estado del proyecto: PROJECT_STATUS.md" -ForegroundColor White
