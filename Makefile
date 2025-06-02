# Makefile para ML + DVC + Docker Demo
# Este archivo automatiza las tareas comunes del proyecto

# Variables de configuración
IMAGE_NAME = ml-dvc-demo
CONTAINER_NAME = ml-dvc-demo-container
MODELS_DIR = models

# Color para output
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Comando por defecto
.DEFAULT_GOAL := help

##@ Comandos principales

.PHONY: help
help: ## Muestra esta ayuda
	@echo "$(BLUE)ML + DVC + Docker Demo - Comandos disponibles:$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build
build: ## Construye la imagen Docker
	@echo "$(BLUE)Construyendo imagen Docker...$(NC)"
	@if [ ! -d "$(MODELS_DIR)" ]; then mkdir -p $(MODELS_DIR); fi
	docker build -t $(IMAGE_NAME) .
	@echo "$(GREEN)✓ Imagen construida exitosamente$(NC)"

.PHONY: run
run: build ## Ejecuta el entrenamiento del modelo
	@echo "$(BLUE)Iniciando entrenamiento del modelo...$(NC)"
	@if [ ! -d "$(MODELS_DIR)" ]; then mkdir -p $(MODELS_DIR); fi
	docker run --rm \
		--name $(CONTAINER_NAME) \
		-v $$(pwd)/$(MODELS_DIR):/app/$(MODELS_DIR) \
		$(IMAGE_NAME)
	@echo "$(GREEN)✓ Entrenamiento completado$(NC)"
	@echo "$(YELLOW)📁 Revisa el directorio $(MODELS_DIR)/ para ver el modelo generado$(NC)"

.PHONY: shell
shell: build ## Accede al contenedor de forma interactiva
	@echo "$(BLUE)Accediendo al contenedor...$(NC)"
	@if [ ! -d "$(MODELS_DIR)" ]; then mkdir -p $(MODELS_DIR); fi
	docker run -it --rm \
		--name $(CONTAINER_NAME)-shell \
		-v $$(pwd)/$(MODELS_DIR):/app/$(MODELS_DIR) \
		$(IMAGE_NAME) bash

.PHONY: dev
dev: build ## Ejecuta el contenedor en modo desarrollo
	@echo "$(BLUE)Iniciando contenedor en modo desarrollo...$(NC)"
	@if [ ! -d "$(MODELS_DIR)" ]; then mkdir -p $(MODELS_DIR); fi
	docker run -it --rm \
		--name $(CONTAINER_NAME)-dev \
		-v $$(pwd):/app \
		$(IMAGE_NAME) bash

##@ Información y verificación

.PHONY: show-model
show-model: ## Muestra información del modelo entrenado
	@echo "$(BLUE)Información del modelo:$(NC)"
	@if [ -f "$(MODELS_DIR)/model.pkl" ]; then \
		echo "$(GREEN)✓ Modelo encontrado: $(MODELS_DIR)/model.pkl$(NC)"; \
		ls -lh $(MODELS_DIR)/model.pkl; \
		echo "$(YELLOW)Tamaño: $$(du -h $(MODELS_DIR)/model.pkl | cut -f1)$(NC)"; \
	else \
		echo "$(RED)✗ Modelo no encontrado. Ejecuta 'make run' primero$(NC)"; \
	fi

.PHONY: test
test: ## Ejecuta pruebas básicas del sistema
	@echo "$(BLUE)Ejecutando pruebas básicas...$(NC)"
	@echo "$(YELLOW)1. Verificando Docker...$(NC)"
	@docker --version > /dev/null && echo "$(GREEN)✓ Docker disponible$(NC)" || echo "$(RED)✗ Docker no disponible$(NC)"
	@echo "$(YELLOW)2. Verificando imagen...$(NC)"
	@docker images | grep -q $(IMAGE_NAME) && echo "$(GREEN)✓ Imagen $(IMAGE_NAME) existe$(NC)" || echo "$(RED)✗ Imagen no encontrada. Ejecuta 'make build'$(NC)"
	@echo "$(YELLOW)3. Verificando directorio models...$(NC)"
	@[ -d "$(MODELS_DIR)" ] && echo "$(GREEN)✓ Directorio $(MODELS_DIR) existe$(NC)" || echo "$(RED)✗ Directorio $(MODELS_DIR) no existe$(NC)"

.PHONY: test-model
test-model: ## Ejecuta pruebas completas del modelo
	@echo "$(BLUE)Ejecutando pruebas del modelo...$(NC)"
	@if [ ! -d "$(MODELS_DIR)" ]; then mkdir -p $(MODELS_DIR); fi
	docker run --rm \
		--name $(CONTAINER_NAME)-test \
		-v $$(pwd)/$(MODELS_DIR):/app/$(MODELS_DIR) \
		$(IMAGE_NAME) python test_project.py

.PHONY: status
status: ## Muestra el estado del proyecto
	@echo "$(BLUE)Estado del proyecto:$(NC)"
	@echo "$(YELLOW)📂 Estructura de archivos:$(NC)"
	@ls -la
	@echo ""
	@echo "$(YELLOW)🐳 Imágenes Docker:$(NC)"
	@docker images | grep $(IMAGE_NAME) || echo "$(RED)No hay imágenes construidas$(NC)"
	@echo ""
	@echo "$(YELLOW)📁 Contenido de models/:$(NC)"
	@ls -la $(MODELS_DIR)/ 2>/dev/null || echo "$(RED)Directorio vacío o no existe$(NC)"

##@ Limpieza y mantenimiento

.PHONY: clean
clean: ## Limpia contenedores e imágenes
	@echo "$(BLUE)Limpiando recursos Docker...$(NC)"
	@echo "$(YELLOW)Deteniendo contenedores...$(NC)"
	@docker ps -q --filter "name=$(CONTAINER_NAME)" | xargs -r docker stop
	@echo "$(YELLOW)Eliminando contenedores...$(NC)"
	@docker ps -a -q --filter "name=$(CONTAINER_NAME)" | xargs -r docker rm
	@echo "$(YELLOW)Eliminando imagen...$(NC)"
	@docker images -q $(IMAGE_NAME) | xargs -r docker rmi
	@echo "$(GREEN)✓ Limpieza completada$(NC)"

.PHONY: clean-models
clean-models: ## Elimina los modelos generados
	@echo "$(BLUE)Limpiando modelos...$(NC)"
	@if [ -d "$(MODELS_DIR)" ]; then \
		rm -rf $(MODELS_DIR)/*; \
		echo "$(GREEN)✓ Modelos eliminados$(NC)"; \
	else \
		echo "$(YELLOW)No hay modelos para limpiar$(NC)"; \
	fi

.PHONY: reset
reset: clean clean-models ## Resetea completamente el proyecto
	@echo "$(BLUE)Reseteando proyecto...$(NC)"
	@echo "$(GREEN)✓ Proyecto reseteado completamente$(NC)"

##@ Desarrollo y debugging

.PHONY: logs
logs: ## Muestra los logs del último contenedor ejecutado
	@echo "$(BLUE)Mostrando logs...$(NC)"
	@docker logs $(CONTAINER_NAME) 2>/dev/null || echo "$(RED)No hay contenedor activo$(NC)"

.PHONY: inspect
inspect: ## Inspecciona la imagen Docker
	@echo "$(BLUE)Inspeccionando imagen $(IMAGE_NAME)...$(NC)"
	@docker inspect $(IMAGE_NAME) 2>/dev/null || echo "$(RED)Imagen no encontrada. Ejecuta 'make build'$(NC)"

.PHONY: size
size: ## Muestra el tamaño de la imagen Docker
	@echo "$(BLUE)Tamaño de la imagen:$(NC)"
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" || echo "$(RED)Imagen no encontrada$(NC)"

##@ Comandos de integración

.PHONY: ci
ci: build test run test-model show-model ## Ejecuta pipeline completo de CI
	@echo "$(GREEN)✓ Pipeline de CI completado exitosamente$(NC)"

.PHONY: quick-start
quick-start: build run show-model ## Inicio rápido: construye, ejecuta y muestra resultado
	@echo "$(GREEN)✓ Inicio rápido completado$(NC)"
	@echo "$(YELLOW)💡 Usa 'make shell' para explorar el contenedor$(NC)"
	@echo "$(YELLOW)💡 Usa 'make help' para ver todos los comandos$(NC)"

# Reglas especiales
.PHONY: all
all: quick-start ## Alias para quick-start

# Prevenir borrado de archivos intermedios
.PRECIOUS: $(MODELS_DIR)/model.pkl
