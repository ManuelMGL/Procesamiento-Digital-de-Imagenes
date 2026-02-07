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


## Ejemplos

Para la validación de las técnicas implementadas se utilizaron **cinco imágenes diferentes** del *Forest Fire Dataset*.  
Las imágenes originales empleadas son las siguientes:

- **I1:** `1_JPG.rf.82be351019b363a690c1f9394144c4d9.jpg`
- **I2:** `30_png.rf.6cbeb530234c3ab68177111a4b97f767.jpg`
- **I3:** `98_png.rf.72cc9d6f4481c6d509a464692b7da029.jpg`
- **I4:** `173_JPG.rf.3d77dde3b3a5641f2b17638b3c40b8e3.jpg`
- **I5:** `264_png.rf.43a917f94cc73493b26b63d01e015184.jpg`

---

### Parámetros utilizados

Para cada imagen se aplicaron distintos parámetros en las operaciones de aumento de datos.  
Cada elemento de los siguientes arreglos corresponde al índice de la imagen \(I_i\).

#### Volteado

El arreglo `volteados` indica el tipo de volteado aplicado a cada imagen, donde el primer valor corresponde al volteado horizontal y el segundo al volteado vertical.  
Un valor de `1` indica que el volteado se aplica, mientras que `0` indica que no se aplica.

```matlab
volteados = {[0, 1], [1, 0], [1, 1], [0, 1], [1, 1]};
```

#### Rotación

Para la operación de rotación se aplicaron ángulos distintos a cada imagen,
medidos en grados.  
La rotación se realizó alrededor del centro de la imagen y se utilizó
**interpolación bilineal** para estimar los valores de intensidad en la imagen
resultante, evitando efectos de aliasing.

Cada elemento del arreglo `angulos` corresponde al ángulo de rotación aplicado
a la imagen \(I\).

```matlab
angulos = {30, 45, 60, 80, 90};
```

#### Traslación

La traslación consiste en desplazar la imagen original una determinada cantidad
de píxeles en las direcciones horizontal y vertical.  
Cada elemento del arreglo `traslaciones` define el vector de traslación
\([Tx, Ty]\), expresado en píxeles, aplicado a la imagen correspondiente
\(I\).

Esta transformación permite simular desplazamientos o variaciones
en la posición del objeto dentro de la imagen.

```matlab
traslaciones = {[200, 300], [400, 500], [300, 400], [100, 100], [50, 400]};
```

#### Escalamiento

El escalamiento consiste en modificar el tamaño de la imagen original mediante
factores de escala aplicados de forma independiente en los ejes horizontal y
vertical.  
Cada elemento del arreglo `escalados` define los factores de escala
\([Sx, Sy]\) utilizados para la imagen correspondiente \(I\).

Para esta transformación se empleó **interpolación bilineal**, con el objetivo
de preservar la continuidad espacial de la imagen y reducir la aparición de
artefactos visuales en la imagen resultante.

```matlab
escalados = {[2, 3], [4, 5], [3, 4], [10, 10], [5, 4]};
```

---
Los valores para las funciones randomErase() y cutMix() fueron calculados de manera aleatoria.

---
## Estructura del repositorio

```text
Procesamiento-Digital-de-Imagenes/
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
    └── Proyecto-Fase I.pdf




