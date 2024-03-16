# Tema Flixnet_Pus para pegasus-frontend.
 - Un tema inspirado en los televisores inteligentes y las aplicaciones de transmisión de video.

Author: Mátyás Mustoha - modified by Gonzalo Abbate
- Bifurcado de [Flixnet](https://github.com/mmatyas/pegasus-theme-flixnet)



- Sigo actualizando partes del codigo por lo que puede variar este repositorio. No olvide hacer una copia de su tema instalado.
- Tambien puede ver las versiones remplazadas [Aqui](https://www.mediafire.com/folder/wycdtzwa6hdoh/FlixNet_Plus_Versiones)

# Cambios Recientes en el Tema

## Interfaz de Usuario

- **Video por Captura del Juego:** Ahora se incluye un video por captura del juego para mejorar la experiencia visual.
- **Captura al Final del Video:** Se agregó una captura al final del video para evitar bucles de reproducción.
- **Ampliación y Alineación de Detalles:** Se ha agrandado y alineado a la izquierda la sección de Detalles para una presentación más equilibrada.
- **Relación de Aspecto 10:16:** El tema utiliza ahora una relación de aspecto de 10:16 en los boxfront para mejorar la visualización.
- **Utilizando boxFront:** Se ha cambiado la fuente de captura a boxFront para una presentación más uniforme.
- **Uso de wheel por Texto:** Se ha cambiado texto por wheel del juego, proporcionando una mejor experiencia visual.

## Funcionalidades y Mejoras

- **Estiramiento de Captura al Final del Video:** Se ha extendido la captura al final del video para una presentación más estética.
- **Barra de Progreso con playTime:** Se agregó una barra de progreso utilizando "playTime" para proporcionar información adicional en DetailsInfoBar.
- **Conteo de Juegos Disponibles:** Se muestra la cantidad de juegos disponibles en cada colección con "Juegos disponibles: game.count".
- **Recuperación Automática del Último Juego Lanzado:** Recuperación Automática del Último Juego Lanzado: Se ha implementado una función que utiliza 'api.memory' para recordar automáticamente el último juego lanzado al cerrar el juego. Esto evita reiniciar el tema FLixNet_Plus en Pegasus Frontend y volver al inicio del tema, permitiendo que, al cerrar un juego previamente lanzado, el tema vuelva a abrirse con ese juego específico como punto de partida. Esta mejora ofrece una transición más fluida y rápida entre sesiones de juego, facilitando la continuidad de la experiencia del usuario. Cuando se cierra Pegasus Frontend, el código del tema FLixNet_Plus realiza automáticamente una limpieza de la memoria asociada al último juego lanzado. Este proceso garantiza que al volver a abrir Pegasus en el tema, la experiencia comience desde el inicio del tema en lugar de retomar desde el último juego lanzado. Para desactivar esta funcionalidad y permitir que el tema inicie desde el último juego, simplemente comente las líneas 248 y 249 del archivo 'theme.qml' añadiendo "//".

- **Agregar/Quitar Juegos Favoritos con Botón (X):** Se ha añadido la opción de marcar/quitar juegos como favoritos utilizando el botón (X) del mando.
- **Orden Automático de Favoritos:** Se utiliza 'SortFilterProxyModel' para que los juegos marcados como favoritos aparezcan automáticamente al principio de la colección.

## Mejoras Visuales

- **Efecto Scanlines en Video y Captura:** Se ha implementado el efecto scanlines para mejorar la estética visual.
- **Etiqueta Automática "Seguir Jugando":** Se ha introducido una nueva característica automática: "Segui jugando". Esta etiqueta se mostrará dinámicamente para juegos lanzados en los últimos 7 días, indicando que han sido jugados recientemente. Para los demás juegos, la etiqueta se ocultará automáticamente. Esta funcionalidad mejora la visualización y destaca los juegos más recientemente jugados.

## Detalles Adicionales

- **Mejoras Insignificantes:** Se han realizado ajustes y mejoras adicionales para una experiencia más refinada.

Ten en cuenta que estos cambios mejorarán tanto la apariencia visual como la funcionalidad del tema, ofreciendo a los usuarios una experiencia más completa y atractiva.
# Pequeños detalles

- Todos los cambios se han probado en resolución de 1366x768 Windows - GNU/Linux
- No soy programador por lo que utilizo chatgpt para aprender del código original [Flixnet](https://github.com/mmatyas/pegasus-theme-flixnet) y obviamente [qt](https://doc.qt.io/qt-6/gettingstarted.html).

- Usarlo siempre en pantalla completa para una mejor experiencia.
- Requiere elementos del juego para lucir el tema:  "Screenshots,boxFront,Videos y Wheel"  que los puedes obtener de 
[Skraper](https://www.skraper.net/) y crear los metadatos con [Bellerophon](https://github.com/valsou/bellerophon)


# Demostración


https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/db4b96cf-f8b4-4ca0-98b8-e1991be12f17




![1](https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/38202155-9d74-4a7e-8f8a-dd2a206119cf)


![2](https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/b04b4bab-0224-4414-80e6-1ead2d9e4966)


![3](https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/29e3f49c-077e-4572-9a11-1c2e0b7f644a)


![4](https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/5e6195f6-f2f2-42b2-9277-a2601ae4bac7)




## Instalación

[Descarga](https://github.com/ZagonAb/FlixNet_Plus/archive/refs/heads/main.zip) y extrae el tema a tu [directorio de temas](http://pegasus-frontend.org/docs/user-guide/installing-themes). Luego puede seleccionarlo en el menú de configuración de Pegasus.


# Licencia
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Licencia Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
