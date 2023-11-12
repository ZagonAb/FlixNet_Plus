# Tema Flixnet_Pus para pegasus-frontend.
 - Un tema inspirado en los televisores inteligentes y las aplicaciones de transmisión de video.

Author: Mátyás Mustoha - modified by Gonzalo Abbate
- (Gracias a [matyas_mustoha](https://github.com/mmatyas) Por la ayuda con el uso de api.memory en el código, no lo hubiera logrado sin su ayuda.! Genio..!

- Bifurcado de [Flixnet](https://github.com/mmatyas/pegasus-theme-flixnet)



- Sigo actualizando partes del codigo por lo que puede variar este repositorio. No olvide hacer una copia de su tema instalado.
- Tambien puede ver las versiones remplazadas [Aqui](https://www.mediafire.com/folder/wycdtzwa6hdoh/FlixNet_Plus_Versiones)

# Algunos cambios
- Se ha agregado video por captura del juego.
- Se ha agregado captura al final del video para evitar bucle de reproducción.
- Se ha agrandado Details y corrido más a la izquierda.
- Se utiliza un aspecto ratio de 10 / 16
- Se utiliza boxFront por captura.
- Se utiliza wheel por texto.
- Se ha estirado la captura al final del video para mejor presentación.
- Se ha agregado la barra de progreso utilizando "playTime" como información adicional en DetailsInfoBar.
- Se agregó "Juegos disponibles: " utilizando "game.count" para ver la cantidad de juegos en cada colección.
- Se utiliza 'api.memory' para recuperar automáticamente el último juego lanzado al cerrar el juego, evitando así regresar al inicio del tema. (Pero si cierra Pegasus Frontend el tema volverá a la normalidad.) Esto último puede evitarlo fácilmente comentando las líneas 223 y 224 en el archivo 'theme.qml'
- Se ha agregado la opcion de poner/quitar juegos como favorito con el botón (X) del mando.
- Se ha agregado el uso de "SortFilterProxyModel" para que al marcar/desmarcar un juego como favorito este automáticamente al principio de la colección.
- Y algunos detalles más insignificantes... (Esto es siempre)
# Pequeños detalles
- Todos los cambios se han probado en resolución de 1366x768 Windows - GNU/Linux <del>"Android"</del> 

<del> Intento portarlo a distintas resoluciones de monitor (resuelto).</del>
- No soy programador por lo que utilizo chatgpt para aprender del código original [Flixnet](https://github.com/mmatyas/pegasus-theme-flixnet) y obviamente [qt](https://doc.qt.io/qt-6/gettingstarted.html).

- Requiere elementos del juego para lucir el tema:  "Screenshots,boxFront,Videos y Wheel"  que los puedes obtener de 
[Skraper](https://www.skraper.net/) y crear los metadatos con [Bellerophon](https://github.com/valsou/bellerophon)

<del> Disculpe si no funciona correctamente en la resolución de su monitor(resuelto).</del>


# Demostración





https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/db4b96cf-f8b4-4ca0-98b8-e1991be12f17


![1](https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/c8d4c98a-2133-466b-addc-3515f206ed1f)

![2](https://github.com/ZagonAb/FlixNet_Plus/assets/132770507/28dcf333-d654-487b-a3d2-155ec7b4f277)


## Instalación

[Descarga](https://github.com/ZagonAb/FlixNet_Plus/archive/refs/heads/main.zip) y extrae el tema a tu [directorio de temas](http://pegasus-frontend.org/docs/user-guide/installing-themes). Luego puede seleccionarlo en el menú de configuración de Pegasus.


# Licencia
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Licencia Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
