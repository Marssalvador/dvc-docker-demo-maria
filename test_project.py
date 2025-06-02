#!/usr/bin/env python3
"""
Tests para ML + DVC + Docker Demo
Script de pruebas para validar el funcionamiento del proyecto
"""

import os
import sys
import subprocess
import joblib
import numpy as np
from sklearn.datasets import load_iris
from sklearn.metrics import accuracy_score

def test_environment():
    """Prueba que el entorno esté configurado correctamente"""
    print("🧪 Probando entorno...")
    
    # Verificar imports
    try:
        import sklearn
        import dvc
        import joblib
        print(f"✓ scikit-learn: {sklearn.__version__}")
        print(f"✓ DVC: {dvc.__version__}")
        print(f"✓ joblib: {joblib.__version__}")
    except ImportError as e:
        print(f"❌ Error de import: {e}")
        return False
    
    # Verificar directorios
    if not os.path.exists('models'):
        print("❌ Directorio models no existe")
        return False
    
    print("✓ Entorno configurado correctamente")
    return True

def test_model_exists():
    """Prueba que el modelo existe"""
    print("\n🧪 Probando existencia del modelo...")
    
    model_path = "models/model.pkl"
    if not os.path.exists(model_path):
        print(f"❌ Modelo no encontrado en {model_path}")
        return False
    
    file_size = os.path.getsize(model_path)
    print(f"✓ Modelo encontrado ({file_size} bytes)")
    return True

def test_model_functionality():
    """Prueba que el modelo funciona correctamente"""
    print("\n🧪 Probando funcionalidad del modelo...")
    
    try:
        # Cargar modelo
        model = joblib.load("models/model.pkl")
        print("✓ Modelo cargado exitosamente")
        
        # Cargar datos de prueba
        X, y = load_iris(return_X_y=True)
        
        # Hacer predicciones
        predictions = model.predict(X)
        accuracy = accuracy_score(y, predictions)
        
        print(f"✓ Predicciones realizadas")
        print(f"✓ Precisión: {accuracy:.4f}")
        
        # Verificar que la precisión es razonable
        if accuracy < 0.8:
            print(f"⚠️  Advertencia: Precisión baja ({accuracy:.4f})")
            return False
        
        # Probar predicción individual
        sample_prediction = model.predict(X[0:1])
        probabilities = model.predict_proba(X[0:1])
        
        print(f"✓ Predicción de muestra: {sample_prediction[0]}")
        print(f"✓ Probabilidades: {probabilities[0]}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error al probar modelo: {e}")
        return False

def test_dvc_integration():
    """Prueba la integración con DVC"""
    print("\n🧪 Probando integración DVC...")
    
    # Verificar archivos DVC
    dvc_file = "models/model.pkl.dvc"
    if os.path.exists(dvc_file):
        print(f"✓ Archivo DVC encontrado: {dvc_file}")
        return True
    else:
        print(f"⚠️  Archivo DVC no encontrado: {dvc_file}")
        print("   Esto es esperado si DVC no está configurado")
        return True

def test_metadata():
    """Prueba que los metadatos existan"""
    print("\n🧪 Probando metadatos...")
    
    metadata_path = "models/model_metadata.txt"
    if not os.path.exists(metadata_path):
        print(f"⚠️  Metadatos no encontrados: {metadata_path}")
        return True
    
    with open(metadata_path, 'r') as f:
        content = f.read()
        print(f"✓ Metadatos encontrados:")
        for line in content.strip().split('\n'):
            print(f"   {line}")
    
    return True

def run_performance_test():
    """Ejecuta pruebas de rendimiento básicas"""
    print("\n🧪 Probando rendimiento...")
    
    try:
        import time
        
        # Cargar modelo
        start_time = time.time()
        model = joblib.load("models/model.pkl")
        load_time = time.time() - start_time
        
        # Cargar datos
        X, _ = load_iris(return_X_y=True)
        
        # Tiempo de predicción
        start_time = time.time()
        predictions = model.predict(X)
        prediction_time = time.time() - start_time
        
        print(f"✓ Tiempo de carga: {load_time:.4f}s")
        print(f"✓ Tiempo de predicción: {prediction_time:.4f}s")
        print(f"✓ Predicciones por segundo: {len(X)/prediction_time:.0f}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error en pruebas de rendimiento: {e}")
        return False

def main():
    """Función principal de pruebas"""
    print("="*60)
    print("🧪 EJECUTANDO PRUEBAS DEL PROYECTO")
    print("="*60)
    
    tests = [
        ("Entorno", test_environment),
        ("Existencia del modelo", test_model_exists),
        ("Funcionalidad del modelo", test_model_functionality),
        ("Integración DVC", test_dvc_integration),
        ("Metadatos", test_metadata),
        ("Rendimiento", run_performance_test),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        try:
            if test_func():
                passed += 1
            else:
                print(f"❌ Prueba fallida: {test_name}")
        except Exception as e:
            print(f"❌ Error en prueba {test_name}: {e}")
    
    print("\n" + "="*60)
    print(f"📊 RESULTADOS: {passed}/{total} pruebas pasaron")
    print("="*60)
    
    if passed == total:
        print("🎉 ¡Todas las pruebas pasaron exitosamente!")
        sys.exit(0)
    else:
        print("⚠️  Algunas pruebas fallaron")
        sys.exit(1)

if __name__ == "__main__":
    main()
