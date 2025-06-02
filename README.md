# ML + DVC + Docker Demo

Este repositorio muestra cómo entrenar un modelo de Machine Learning usando scikit-learn, guardar el resultado con `joblib`, y versionarlo usando **DVC** (Data Version Control). El entorno completo está contenido en Docker para máxima portabilidad y reproducibilidad.

## Descripción del Proyecto

El proyecto incluye:

- Entrenamiento de un modelo RandomForest con el dataset Iris
- Versionado del modelo usando DVC
- Contenedorización completa con Docker
- Automatización con Makefile

## Requisitos

- Docker (versión 20.10 o superior)
- Git
- Make (opcional, para usar el Makefile)

## Estructura del Proyecto

```
dvc-docker-demo-maria/
├── Dockerfile              # Configuración del contenedor
├── main.py                 # Script principal de entrenamiento
├── requirements.txt        # Dependencias de Python
├── Makefile               # Comandos automatizados
├── README.md              # Este archivo
└── models/                # Directorio para modelos entrenados
```

## Instalación y Uso

### Opción 1: Script de inicio rápido (Windows)

Para usuarios de Windows PowerShell:

```powershell
.\quick-start.ps1
```

### Opción 2: Usando Makefile (Linux/Mac/Windows con Make)

1. **Clonar el repositorio:**

```bash
git clone <url-del-repositorio>
cd dvc-docker-demo-maria
```

2. **Construir y ejecutar:**

```bash
make build    # Construye la imagen Docker
make run      # Ejecuta el entrenamiento
make shell    # Accede al contenedor para exploración
```

3. **Ver resultados:**

```bash
make show-model    # Muestra información del modelo generado
```

### Opción 3: Comandos Docker manuales (Universal)

1. **Construir la imagen Docker:**

```bash
docker build -t ml-dvc-demo .
```

2. **Ejecutar el entrenamiento:**

```bash
docker run --rm -v ${PWD}/models:/app/models ml-dvc-demo
```

3. **Acceder al contenedor para exploración:**

```bash
docker run -it --rm -v ${PWD}/models:/app/models ml-dvc-demo bash
```

## Funcionamiento del Sistema

1. **Entrenamiento:** El script `main.py` carga el dataset Iris, entrena un modelo RandomForest y lo guarda en `models/model.pkl`

2. **Versionado DVC:** El modelo se rastrea automáticamente con DVC para control de versiones

3. **Contenedorización:** Todo el proceso se ejecuta dentro de un contenedor Docker aislado

## Archivos Generados

Después de ejecutar el proyecto, encontrarás:

- `models/model.pkl`: Modelo entrenado serializado con joblib
- `models/model.pkl.dvc`: Archivo de metadatos DVC para versionado
- `.dvc/`: Directorio de configuración DVC

## Comandos Útiles

### Con Makefile

```bash
make help         # Muestra ayuda de comandos disponibles
make build        # Construye la imagen Docker
make run          # Ejecuta el entrenamiento
make shell        # Accede al contenedor interactivamente
make clean        # Limpia contenedores e imágenes
make show-model   # Muestra información del modelo
```

### Comandos Docker directos

```bash
# Ver logs del contenedor
docker run --rm ml-dvc-demo

# Montar volumen para persistir modelos
docker run --rm -v ${PWD}/models:/app/models ml-dvc-demo

# Acceder al contenedor
docker run -it --rm ml-dvc-demo bash
```

## Verificación

Para verificar que todo funciona correctamente:

1. Ejecuta `make run` o el comando Docker equivalente
2. Verifica que se creó `models/model.pkl`
3. El output debe mostrar "Modelo guardado en models/model.pkl"
4. El modelo debe tener una precisión > 90% en el dataset de prueba

## Troubleshooting

**Problema:** Error de permisos al escribir en `models/`

**Solución:** Asegúrate de que el directorio `models/` tenga permisos de escritura

**Problema:** Docker build falla

**Solución:** Verifica que Docker esté ejecutándose y que tengas conexión a internet

**Problema:** Modelo no se guarda

**Solución:** Verifica que el directorio `models/` existe y es accesible

## Contribución

Este proyecto es una demostración educativa. Para contribuir:

1. Fork el repositorio
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Crea un Pull Request

## Licencia

Este proyecto es de uso educativo y demostrativo.
```

2. **Ejecutar el entrenamiento:**
```bash
docker run --rm -v ${PWD}/models:/app/models ml-dvc-demo
```

3. **Acceder al contenedor para exploración:**
```bash
docker run -it --rm -v ${PWD}/models:/app/models ml-dvc-demo bash
```

## Funcionamiento del Sistema

1. **Entrenamiento:** El script `main.py` carga el dataset Iris, entrena un modelo RandomForest y lo guarda en `models/model.pkl`

2. **Versionado DVC:** El modelo se rastrea automáticamente con DVC para control de versiones

3. **Contenedorización:** Todo el proceso se ejecuta dentro de un contenedor Docker aislado

## Archivos Generados

Después de ejecutar el proyecto, encontrarás:

- `models/model.pkl`: Modelo entrenado serializado con joblib
- `models/model.pkl.dvc`: Archivo de metadatos DVC para versionado
- `.dvc/`: Directorio de configuración DVC

## Comandos Útiles

### Con Makefile:
```bash
make help         # Muestra ayuda de comandos disponibles
make build        # Construye la imagen Docker
make run          # Ejecuta el entrenamiento
make shell        # Accede al contenedor interactivamente
make clean        # Limpia contenedores e imágenes
make show-model   # Muestra información del modelo
```

### Comandos Docker directos:
```bash
# Ver logs del contenedor
docker run --rm ml-dvc-demo

# Montar volumen para persistir modelos
docker run --rm -v ${PWD}/models:/app/models ml-dvc-demo

# Acceder al contenedor
docker run -it --rm ml-dvc-demo bash
```

## Verificación

Para verificar que todo funciona correctamente:

1. Ejecuta `make run` o el comando Docker equivalente
2. Verifica que se creó `models/model.pkl`
3. El output debe mostrar "Modelo guardado en models/model.pkl"
4. El modelo debe tener una precisión > 90% en el dataset de prueba

## Troubleshooting

**Problema:** Error de permisos al escribir en `models/`
**Solución:** Asegúrate de que el directorio `models/` tenga permisos de escritura

**Problema:** Docker build falla
**Solución:** Verifica que Docker esté ejecutándose y que tengas conexión a internet

**Problema:** Modelo no se guarda
**Solución:** Verifica que el directorio `models/` existe y es accesible

## Contribución

Este proyecto es una demostración educativa. Para contribuir:

1. Fork el repositorio
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Crea un Pull Request

## Licencia

Este proyecto es de uso educativo y demostrativo.
