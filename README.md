# Tema Flixnet+ para pegasus-frontend.
 - Un tema inspirado en los televisores inteligentes y las aplicaciones de transmisión de video.
 - Author: Mátyás Mustoha - modified by Gonzalo Abbate
 - Bifurcado de [Flixnet](https://github.com/mmatyas/pegasus-theme-flixnet)

- Sigo actualizando partes del codigo por lo que puede variar este repositorio. No olvide hacer una copia de su tema instalado.
- Tambien puede ver las versiones remplazadas [Aqui](https://www.mediafire.com/folder/wycdtzwa6hdoh/FlixNet_Plus_Versiones)

# Cambios Recientes en el Tema

 **Barra de Progreso de Tiempo de Juego y Fases**
- **La barra de progreso muestra visualmente el tiempo de juego acumulado, ayudando a los jugadores a ver su avance de manera clara y dinámica. A medida que el jugador acumula más tiempo en el juego, la barra cambia de color y se adapta a las diferentes fases de progreso.**

**Visualización de la Fase**

¿Cómo funciona la barra de progreso?

**Fase 0: 1-30 minutos**
- Durante los primeros 30 minutos de juego, la barra es de color verde. La barra se va llenando a medida que el jugador acumula más minutos, proporcionando una representación visual clara del tiempo jugado en esta fase inicial.

![0](https://github.com/ZagonAb/FlixNet_Plus/blob/769b518a464ae627ab722a5acdad6e330f5fae6d/.meta/screenshots/phase0.png)

**Fase 1: 30-60 minutos**
- Cuando el tiempo de juego supera los 30 minutos pero no llega a 1 hora, la barra se vuelve azul. Esta fase indica que el jugador está superando la etapa inicial y avanzando en el juego.

![1](https://github.com/ZagonAb/FlixNet_Plus/blob/769b518a464ae627ab722a5acdad6e330f5fae6d/.meta/screenshots/phase1.png)

**Fase 2: Más de 1 hora**
- A partir de 1 hora de juego, el color de la barra cambia según el tiempo acumulado:
- De 1 a 20 horas: La barra es amarilla.
- Más de 20 horas: La barra se vuelve roja, indicando que el jugador ha alcanzado un nivel de juego avanzado y ha invertido muchas horas en el juego.

![2](https://github.com/ZagonAb/FlixNet_Plus/blob/769b518a464ae627ab722a5acdad6e330f5fae6d/.meta/screenshots/phase2.png)

- Si el tiempo de juego es inferior a 1 minuto, la barra no será visible. Esto garantiza que solo se muestren las barras cuando el tiempo de juego es significativo y aporta información útil al jugador.

**Objetivo de la Barra**
- La barra y las fases proporcionan una forma visualmente atractiva de seguir el progreso del jugador. A medida que el jugador avanza, no solo puede ver el tiempo jugado, sino también el cambio de color que refleja su progreso en el juego. Esto hace que la experiencia sea más interactiva y motivadora.

## Interfaz de Usuario

- **Video por Captura del Juego:** Ahora se incluye un video por captura del juego para mejorar la experiencia visual.
- **Captura al Final del Video:** Se agregó una captura al final del video para evitar bucles de reproducción.
- **Relación de Aspecto 10:16:** El tema utiliza ahora una relación de aspecto de 10:16 en los boxfront para mejorar la visualización.
- **Utilizando boxFront:** Se ha cambiado la fuente de captura a boxFront para una presentación más uniforme.
- **Uso de wheel por Texto:** Se ha cambiado texto por wheel del juego, proporcionando una mejor experiencia visual.

## Funcionalidades y Mejoras

- Se han agregado 4 nuevas colecciones: "Todos los juegos", "Mi lista", "Seguir jugando" y "Juegos recomendados", como una mejora para mantener el orden y la organización en la interfaz.
- La colección "Mi Lista" y la colección "Seguir Jugando" estarán automáticamente ocultas si no contienen juegos en esas respectivas colecciones, lo que garantiza una interfaz limpia y sin elementos innecesarios. Además, la colección "Seguir Jugando" únicamente contendrá juegos que hayan sido lanzados por más de 1 minuto en los últimos 7 días. Esta característica permite que la colección varíe según la actividad de juego del usuario, evitando acumular una cantidad infinita de juegos lanzados por error o aquellos que han sido jugados hace mucho tiempo. De esta manera, se mantiene la colección fresca y actualizada con los últimos juegos jugados, promoviendo una experiencia de usuario más organizada y centrada en los juegos recientes.
- ~~**Barra de Progreso con playTime:** Se agregó una barra de progreso utilizando "playTime" para proporcionar información adicional en DetailsInfoBar.~~
- **Conteo de Juegos Disponibles:** Se muestra la cantidad de juegos disponibles en cada colección con "Juegos disponibles: game.count".
- Se ha implementado una barra lateral izquierda que facilita el acceso al índice de cada colección nueva:
La opción "Home" nos permite volver al índice 0 de la interfaz, proporcionando una navegación intuitiva y rápida.
La opción "Buscar" nos permite buscar entre nuestra amplia lista de colecciones, ahorrándonos tiempo en la interfaz al encontrar rápidamente lo que necesitamos.
La opción "Plus" nos desplaza a la colección "Mi lista" contendrá todos los juegos que hemos marcado como favoritos, agrupándolos en una sola colección para una fácil accesibilidad.
La opción "Trending" nos lleva a la colección "Juegos Recomendados", que presenta una selección de 15 juegos aleatorios que podrían ajustarse a nuestros gustos, proporcionando sugerencias emocionantes y variadas.

- **Agregar/Quitar Juegos Favoritos con Botón (X):** Se ha añadido la opción de marcar/quitar juegos como favoritos utilizando el botón (X) del mando.

## Mejoras Visuales

- **Efecto Scanlines mediante .png en Video y Captura:** Se ha implementado el efecto scanlines para mejorar la estética visual.
- **Etiqueta Automática "Seguir Jugando":** Se ha introducido una nueva característica automática: "Segui jugando". Esta etiqueta se mostrará dinámicamente para juegos lanzados en los últimos 7 días, indicando que han sido jugados recientemente. Para los demás juegos, la etiqueta se ocultará automáticamente. Esta funcionalidad mejora la visualización y destaca los juegos más recientemente jugados.

## Detalles Adicionales

- **Mejoras Insignificantes:** Se han realizado ajustes y mejoras adicionales para una experiencia más refinada.

Ten en cuenta que estos cambios mejorarán tanto la apariencia visual como la funcionalidad del tema, ofreciendo a los usuarios una experiencia más completa y atractiva.
# Pequeños detalles

- Todos los cambios se han probado en resolución de 1366x768 Windows - GNU/Linux

- Usarlo siempre en pantalla completa para una mejor experiencia.
- Requiere elementos del juego para lucir el tema:  "Screenshots,boxFront,Videos y Wheel"  que los puedes obtener de 
[Skraper](https://www.skraper.net/) y crear los metadatos con [Bellerophon](https://github.com/valsou/bellerophon)

# Demostración

https://github.com/user-attachments/assets/256ea16e-2557-48ff-8dff-77541c1538ef

![1](https://github.com/user-attachments/assets/cc4083fa-2c94-4d77-a494-79febfcf32b1)
![2](https://github.com/user-attachments/assets/d214ce54-8c3f-4441-83f0-c0502df1e7f4)
![3](https://github.com/user-attachments/assets/11459dba-8e27-4c60-a7af-7e5e92082f2b)
![4](https://github.com/user-attachments/assets/c6f0a4f1-7bae-4977-8c8c-cca67d182a8c)

## Instalación

[Descarga](https://github.com/ZagonAb/FlixNet_Plus/archive/refs/heads/main.zip) y extrae el tema a tu [directorio de temas](http://pegasus-frontend.org/docs/user-guide/installing-themes). Luego puede seleccionarlo en el menú de configuración de Pegasus.


# Licencia
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Licencia Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
