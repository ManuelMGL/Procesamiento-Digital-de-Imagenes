# Aumento de Datos para el Forest Fire Dataset en MATLAB

Considerando como conjunto de prueba las imágenes foresFireDataset(ObjectDetection).zip
del repositorio https://data.mendeley.com/datasets/fcsjwd9gr6/1

Este repositorio contiene la implementación en **MATLAB** de técnicas de **aumento de datos (data augmentation)**
aplicadas a imágenes del conjunto **Forest Fire Dataset (Object Detection)**.

El objetivo del proyecto es implementar y analizar distintas técnicas de
aumento de datos, mostrando tanto las **ecuaciones o fundamentos matemáticos** como los **resultados
visuales** obtenidos al aplicarlas.

---

## Dataset utilizado

El conjunto de prueba utilizado corresponde al dataset:

**Forest Fire Dataset (Object Detection)**  
Disponible en Mendeley Data:  
https://data.mendeley.com/datasets/fcsjwd9gr6/1  

⚠️ **Nota:**  
El dataset completo **no se incluye en este repositorio** debido a su tamaño.
El usuario debe descargarlo manualmente desde el enlace anterior.

---

## Lenguaje y herramientas

- **Lenguaje:** MATLAB  
- **Tipo de imágenes:** Imágenes RGB convertidas a escala de grises  

---

## Funcionalidades implementadas

### Técnicas de aumento de datos (sobre imágenes en escala de grises)

Las siguientes técnicas fueron implementadas:

- **Volteado (Flipping)**
  - Horizontal
  - Vertical

- **Rotación**
  - Aplicando interpolación bilineal para estimar los valores de intensidad

- **Traslación**
  - Desplazamiento horizontal y vertical de la imagen

- **Escalamiento**
  - Aumento o reducción del tamaño de la imagen
  - Uso de interpolación bilineal

- **Borrado aleatorio (Random Erase)**
  - Eliminación de una región rectangular aleatoria

- **Mezclado de regiones (CutMix)**
  - Inserción aleatoria de una región de una imagen en otra

---

## Estructura del repositorio

```text
forest-fire-data-augmentation-matlab/
│
├── README.md
├── src/
│   ├── aumento_datos.m
│   ├── flipping.m
│   ├── rotacionBilineal.m
│   ├── traslation.m
│   ├── escalaBilineal.m
│   ├── randomErase.m
│   └── cutMix.m
│
├── examples/
│   ├── original/
│   └── augmented/
│
└── presentation/
    └── Proyecto.pdf
