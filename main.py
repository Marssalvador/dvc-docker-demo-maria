#!/usr/bin/env python3
"""
ML + DVC + Docker Demo
Script principal para entrenar un modelo de Machine Learning con scikit-learn,
guardarlo con joblib y versionarlo con DVC.
"""

import os
import joblib
import subprocess
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import numpy as np

def setup_dvc():
    """Configura DVC si no está inicializado"""
    try:
        if not os.path.exists('.dvc'):
            print("🔧 Inicializando DVC...")
            subprocess.run(['dvc', 'init', '--no-scm'], check=True, capture_output=True)
            print("✓ DVC inicializado correctamente")
        else:
            print("✓ DVC ya está configurado")
    except subprocess.CalledProcessError as e:
        print(f"⚠️  Advertencia: Error al configurar DVC: {e}")
    except FileNotFoundError:
        print("⚠️  Advertencia: DVC no está instalado o no está en PATH")

def create_model_directory():
    """Crea el directorio models si no existe"""
    os.makedirs("models", exist_ok=True)
    print("✓ Directorio models creado/verificado")

def train_model():
    """Entrena el modelo de Machine Learning"""
    print("🚀 Iniciando entrenamiento del modelo...")
    
    # Cargar datos
    print("📊 Cargando dataset Iris...")
    X, y = load_iris(return_X_y=True)
    
    # División de datos
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, 
        test_size=0.2, 
        random_state=42,
        stratify=y
    )
    
    print(f"📈 Datos de entrenamiento: {X_train.shape[0]} muestras")
    print(f"📈 Datos de prueba: {X_test.shape[0]} muestras")
    
    # Crear y entrenar modelo
    print("🤖 Entrenando modelo RandomForest...")
    model = RandomForestClassifier(
        n_estimators=100, 
        max_depth=3, 
        random_state=42,
        n_jobs=-1
    )
    
    model.fit(X_train, y_train)
    
    # Evaluar modelo
    print("📊 Evaluando modelo...")
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    
    print(f"🎯 Precisión del modelo: {accuracy:.4f}")
    print("\n📋 Reporte de clasificación:")
    print(classification_report(y_test, y_pred, target_names=load_iris().target_names))
    
    # Información adicional del modelo
    feature_importance = model.feature_importances_
    feature_names = load_iris().feature_names
    
    print("\n🔍 Importancia de características:")
    for name, importance in zip(feature_names, feature_importance):
        print(f"  {name}: {importance:.4f}")
    
    return model, accuracy

def save_model(model, accuracy):
    """Guarda el modelo y configura DVC tracking"""
    model_path = "models/model.pkl"
    
    print(f"💾 Guardando modelo en {model_path}...")
    joblib.dump(model, model_path)
    
    # Verificar que el modelo se guardó correctamente
    if os.path.exists(model_path):
        file_size = os.path.getsize(model_path)
        print(f"✓ Modelo guardado exitosamente ({file_size} bytes)")
    else:
        raise FileNotFoundError(f"Error: No se pudo guardar el modelo en {model_path}")
    
    # Configurar DVC tracking
    try:
        print("🔄 Configurando DVC tracking...")
        # Verificar si ya está trackeado
        dvc_file = f"{model_path}.dvc"
        if not os.path.exists(dvc_file):
            result = subprocess.run(
                ['dvc', 'add', model_path], 
                check=True, 
                capture_output=True, 
                text=True
            )
            print(f"✓ Modelo añadido a DVC tracking: {dvc_file}")
        else:
            print(f"✓ Modelo ya está bajo DVC tracking: {dvc_file}")
            
    except subprocess.CalledProcessError as e:
        print(f"⚠️  Advertencia: Error al configurar DVC tracking: {e}")
        print("   El modelo se guardó correctamente, pero sin versionado DVC")
    except FileNotFoundError:
        print("⚠️  Advertencia: DVC no disponible para tracking")
        print("   El modelo se guardó correctamente, pero sin versionado DVC")
    
    # Guardar metadatos del modelo
    metadata_path = "models/model_metadata.txt"
    with open(metadata_path, 'w') as f:
        f.write(f"Modelo: RandomForestClassifier\n")
        f.write(f"Precisión: {accuracy:.4f}\n")
        f.write(f"Dataset: Iris\n")
        f.write(f"Fecha: {subprocess.run(['date'], capture_output=True, text=True).stdout.strip()}\n")
        f.write(f"Características: {len(load_iris().feature_names)}\n")
        f.write(f"Clases: {len(load_iris().target_names)}\n")
    
    print(f"📄 Metadatos guardados en {metadata_path}")

def test_model_loading():
    """Prueba que el modelo se puede cargar correctamente"""
    model_path = "models/model.pkl"
    
    try:
        print("🧪 Probando carga del modelo...")
        loaded_model = joblib.load(model_path)
        
        # Hacer una predicción de prueba
        X, _ = load_iris(return_X_y=True)
        test_sample = X[0:1]  # Primera muestra
        prediction = loaded_model.predict(test_sample)
        prediction_proba = loaded_model.predict_proba(test_sample)
        
        print(f"✓ Modelo cargado exitosamente")
        print(f"🔮 Predicción de prueba: clase {prediction[0]}")
        print(f"🔮 Probabilidades: {prediction_proba[0]}")
        
    except Exception as e:
        print(f"❌ Error al cargar el modelo: {e}")
        raise

def main():
    """Función principal"""
    print("="*60)
    print("🚀 ML + DVC + Docker Demo")
    print("="*60)
    
    try:
        # Configuración inicial
        setup_dvc()
        create_model_directory()
        
        # Entrenamiento
        model, accuracy = train_model()
        
        # Guardado y versionado
        save_model(model, accuracy)
        
        # Verificación
        test_model_loading()
        
        print("\n" + "="*60)
        print("🎉 ¡Proceso completado exitosamente!")
        print("="*60)
        print(f"📁 Modelo guardado en: models/model.pkl")
        print(f"🎯 Precisión final: {accuracy:.4f}")
        print("💡 Usa 'make show-model' para ver información del modelo")
        
    except Exception as e:
        print(f"\n❌ Error durante la ejecución: {e}")
        print("🔧 Revisa los logs para más detalles")
        raise

if __name__ == "__main__":
    main()
