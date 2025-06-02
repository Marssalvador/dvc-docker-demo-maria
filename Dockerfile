# ML + DVC + Docker Demo
# Dockerfile para crear un entorno reproducible de Machine Learning

# Usar imagen base oficial de Python
FROM python:3.9-slim

# Metadatos de la imagen
LABEL maintainer="ML Demo Team"
LABEL description="Demo de ML con DVC y Docker para entrenamiento de modelos"
LABEL version="1.0"

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV DVC_NO_ANALYTICS=true

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        build-essential \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root para mayor seguridad
RUN useradd --create-home --shell /bin/bash mluser && \
    mkdir -p /app && \
    chown -R mluser:mluser /app

# Cambiar a usuario no-root
USER mluser

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias primero (para cache de Docker)
COPY --chown=mluser:mluser requirements.txt .

# Instalar dependencias de Python
RUN pip install --user --no-cache-dir --upgrade pip && \
    pip install --user --no-cache-dir -r requirements.txt

# Asegurar que los binarios de pip estén en PATH
ENV PATH="/home/mluser/.local/bin:${PATH}"

# Copiar código fuente
COPY --chown=mluser:mluser . .

# Crear directorios necesarios
RUN mkdir -p models && \
    chmod +x main.py

# Configurar Git (necesario para DVC)
RUN git config --global user.email "demo@example.com" && \
    git config --global user.name "ML Demo" && \
    git config --global init.defaultBranch main

# Inicializar repositorio Git y DVC
RUN git init && \
    dvc init --no-scm && \
    git add .dvc && \
    git commit -m "Initialize DVC"

# Exponer puerto (si fuera necesario para una API futura)
EXPOSE 8000

# Verificaciones de salud
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sklearn, joblib, dvc; print('Dependencies OK')" || exit 1

# Comando por defecto
CMD ["python", "main.py"]
