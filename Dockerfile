FROM python:3.9

# Instalar Git y dependencias básicas
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos al contenedor
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Inicializar DVC y Git en tiempo de construcción
RUN git init && dvc init && mkdir -p models

# Comando por defecto: ejecutar script de entrenamiento
CMD ["python", "main.py"]
