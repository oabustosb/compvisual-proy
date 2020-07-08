# Computación Visual - Proyecto

### Realizado por:
Oscar Alberto Bustos B. - oabustosb@unal.edu.co


## Introducción

### Problemática
Dentro del procesamiento de imágenes, un reto importante es la manipulación de imágenes bidimensionales de gran tamaño, conocidas como _megaimágenes_ o _megatexturas_. Estas imágenes de gran formato pueden alcanzar incluso varios gigabytes de tamaño en ciertos casos, y son continuamente generadas en diversos campos científicos, como la medicina, la astronomía y la física de partículas. El almacenamiento y procesamiento de las imágenes de gran formato son problemas actuales y muy desafiantes en el campo de la Computación Visual.

### Trabajo previo
A partir de la información consultada en diversas fuentes, se determinó que la manipulación efectiva de una _megaimagen_ requiere de dos elementos básicos: la capacidad de __navegar eficientemente__ por ella, de forma tal que se pueda identificar la posición de detalles relevantes dentro de la imagen completa, y la capacidad de __procesar rápidamente__ toda la megaimagen, incluso a nivel de pixeles individuales, para extraer propiedades relevantes de éstos o aplicar filtros cuando sean requeridos. En otras palabras, extraer información útil de una _megaimagen_ requiere __posicionar__ y __procesar__ las zonas de interés para usuarios específicos.



## Objetivo

El principal objetivo del proyecto es encontrar formas eficientes de cumplir con estos dos requerimientos de ubicación y procesado de las zonas de interés dentro de una _megaimagen_. Aunque definir una 'zona de interés' depende de los objetivos propios del usuario que manipule la megaimagen, poder encontrar estas zonas, cualesquiera que sean, requiere de un manejo intensivo de recursos de hardware, y por lo tanto de una estructura de código altamente eficiente. Ante un hardware de mediana capacidad, la eficiencia del código se convierte en una característica fundamental para el desempeño de la solución propuesta.



## Diseño de la Solución

El concepto fundamental dentro de la solución propuesta es el _mipmap_. Dada una imagen, un mipmap de dicha imagen es una versión reducida de la imagen principal, por lo general en una proporción que es potencia de dos. Es decir, un mipmap de nivel 1 es la imagen reducida a la mitad, un mipmap de nivel 2 es la imagen reducida a la cuarta parte, un mipmap de nivel 3 es la imagen reducida a la octava parte, y así sucesivamente; los sucesivos mipmaps conforman una _pirámide de mipmaps_. Los mipmaps se usan intensivamente en el renderizado de texuras en videojuegos, ya que a medida que un objeto varía su profundidad, se puede escoger entre un mipmap y otro para aumentar o reducir el nivel de detalle. Además, la generación de mipmaps es un proceso altamente eficiente y que no ocupa demasiado espacio, pues toda la pirámide de mipmaps sólo ocupa un 33% adicional en espacio de memoria respecto a la imagen original. Y, ya que las megaimágenes se comportan como texturas dentro de Processing, es posible generar los mipmaps con pocas líneas de código. 

![Mipmapping](https://upload.wikimedia.org/wikipedia/commons/5/5c/MipMap_Example_STS101.jpg)

__¿Cómo facilitan los mipmaps la ubicación y el procesamiento?__ El mipmap de nivel __n__ contiene cuatro veces menos texels que el mipmap de nivel __n - 1__, así que si se usan mipmaps en lugar de las texturas originales, el procesamiento puede reducirse considerablemente. Además, aunque la ubicación dentro de una imagen esté referenciada respecto a la textura original, la zona que se referencia puede ser dibujada como parte de un mipmap para así reducir la carga sobre el hardware. 



## Implementación

La implementación de la solución propuesta se llevó a cabo en dos fases.
* __Aplicación de Shaders:__ Los shaders, como intermediarios entre el software de alto nivel y el hardware, aceleran el procesamiento de las imágenes gracias a la capacidad de paralelización. Además, permiten la generación automática de los mipmaps de una textura dada, a través de la función GLSL `textureLod`, que permite acceder a un mipmap específico a través de un número llamado `lod` (level-of-detail). Este sketch utiliza esta variable para cambiar dinámicamente el mipmap que se utiliza para realizar un procesamiento complejo (en este caso, la conversión de la imagen a ASCII tal como se definió en el taller de Procesamiento de Imágenes). El código se encuentra en la carpeta `Project 1`.
* __Navegación por una imagen grande:__ Dadas las limitaciones del software de Processing (que al estar basado en Java está sometido a las características de JVM), cada sketch tiene un límite de memoria disponible, por lo que hay un límite al tamaño de las imágenes que el IDE puede manejar. Este sketch utiliza imágenes relativamente grandes (4096x4096 o 5000x5000) y permite hacer zoom y navegar por ella, utilizando atajos de teclado (las teclas `+` y `-` para aumentar y reducir el zoom, y las teclas `2`, `4`, `6` y `8` para los movimientos abajo, izquierda, derecha y arriba). El código se encuentra en la carpeta `Project 2`.



## Conclusiones (resultados, trabajo futuro)

* A pesar de las limitaciones de hardware y software presentes al realizar el proyecto, Processing es una herramienta muy poderosa para la manipulación de imágenes. La conjunción del sketch con los shaders, que permiten acelerar el procesamiento al paralelizarlo, hace que el rendimiento de los sketch del proyecto sea bastante bueno, comparándolo con escenarios en los que no se usan. Por ejemplo, al comparar el primer sketch del proyecto (conversión ASCII) con los sketch del taller que hacen lo mismo, se aprecia una evidente mejora en el rendimiento y en la rapidez del rendering.
* El uso de la función de GLSL `textureLod` permite controlar la pirámide de mipmaps con gran facilidad por parte del usuario. Aunque normalmente el uso de los mipmaps es controlado de forma interna por GLSL, esta función hace que codificar los shaders para los diferentes mipmaps de las texturas sea muy sencillo. GLSL tiene múltiples opciones para generar y manipular mipmaps, pero creo que esta función lo hace de una forma muy fácil de comprender.
* Existe bastante información sobre los mipmaps y cómo se usan mediante GLSL, pero hay poca información sobre cómo integrar su uso con las megaimágenes, además de que hay pocas de ellas disponibles de forma pública. Esta falta de información redujo el avance del proyecto, por lo que, como trabajo a futuro, propongo continuar investigando sobre ambos temas, encontrar más escenarios de conexión entre ellos y buscar maneras más eficientes de utilizar las diferentes herramientas de Processing para poder manejar imágenes de resoluciones aún mayores.


