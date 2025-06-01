# ML + DVC + Docker Demo

Este repositorio muestra cómo entrenar un modelo de ML, guardar el resultado con `joblib`, y versionarlo usando **DVC**. El entorno completo está contenido en Docker para máxima portabilidad.

## Requisitos

- Docker
- Git
- (opcional) DVC instalado localmente para `dvc push/pull`

## Cómo usar

### 1. Construir la imagen Docker
```bash
docker build -t ml-dvc-demo .
