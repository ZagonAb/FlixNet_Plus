// Pegasus Frontend - Flixnet theme.
// Copyright (C) 2017  Mátyás Mustoha
// Author: Mátyás Mustoha - modified by Gonzalo Abbate for GNU/LINUX - WINDOWS
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12
import SortFilterProxyModel 0.2

FocusScope {

    focus: true

    // Propiedades para el diseño de los íconos en cuadrícula
    // Propiedades relacionadas con el tamaño y el espaciado de los íconos en la cuadrícula
    readonly property real cellRatio: 10 / 16 // Calcula la relación de aspecto de la celda
    readonly property int cellHeight: vpx(255) // Establece la altura de la celda en 255 píxeles
    readonly property int cellWidth: cellHeight * cellRatio // Calcula el ancho de la celda basado en la relación de aspecto
    readonly property int cellSpacing: vpx(10) // Establece el espaciado entre las celdas en 10 píxeles
    readonly property int cellPaddedWidth: cellWidth + cellSpacing // Calcula el ancho de la celda con el espacio añadido
    // Propiedades para las etiquetas de categoría de las filas
    readonly property int labelFontSize: vpx(18) // Establece el tamaño de fuente de la etiqueta en 18 píxeles
    readonly property int labelHeight: labelFontSize * 2.5 // Calcula la altura de la etiqueta basada en el tamaño de fuente
    // Propiedad para la guía izquierda del diseño
    readonly property int leftGuideline: vpx(100) // Establece una guía izquierda en 100 píxeles desde el borde izquierdo
    ///////////////////////////////////////////////////////////////////////////
    // Propiedad booleana para controlar la visibilidad de la barra de búsqueda
    property bool searchVisible: false
    readonly property int sidebarWidth: 60
    // Lógica de enfoque
    property bool navigatedDown: false
    property bool sidebarFocused: false
    property bool searchFocused: false // Nueva propiedad para controlar el enfoque del texto "Buscar
    //property int selectedIndex: 1 // Índice de la opción seleccionada (1 para "Buscar")
    property int selectedIndex: sidebarFocused ? 1 : -1 // Índice de la opción seleccionada (-1 cuando no está enfocada)
    property int virtualKeyboardIndex: 0
    // Restablecer selectedIndex a -1 cuando el foco de la barra lateral cambia a false
    onSidebarFocusedChanged: {
        if (!sidebarFocused) {
            selectedIndex = -1;
        } else {
            // Si la barra lateral está enfocada, asegúrate de que selectedIndex sea válido
            if (selectedIndex === -1) {
                // Establecer el valor predeterminado de selectedIndex en 1 si no hay opción seleccionada
                selectedIndex = 1;
            }
        }
    }
    //Barra lateral izquierda
    Rectangle {
        id: sidebar
        width: sidebarFocused ? 150 : 60 // Ancho de la barra lateral (60 cuando no está enfocada, 100 cuando está enfocada)
        height: parent.height
        layer.enabled: true
        color: "transparent"
        opacity: sidebarFocused ? 1 : 0.8
        z: sidebarFocused ? 101 : 99
        focus: sidebarFocused

        // Fondo con gradiente lineal
        LinearGradient {
            width: sidebarWidth
            height: sidebar.height
            anchors.left: sidebar.left

            start: Qt.point(0, 0)
            end: Qt.point(width, 0)

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF000000" } // Negro sólido
                GradientStop { position: 0.7; color: "#88000000" } // Negro con menos opacidad
                GradientStop { position: 1.0; color: "#00000000" } // Totalmente transparente
            }
        }
        
        // Animación para agrandar la barra al entrar
        SequentialAnimation {
            id: enterAnimation
            NumberAnimation { target: sidebar; property: "width"; to: 150; duration: 300; easing.type: Easing.OutCubic }
        }

        // Animación para reducir la barra al salir
        SequentialAnimation {
            id: exitAnimation
            NumberAnimation { target: sidebar; property: "width"; to: 60; duration: 300; easing.type: Easing.OutCubic }
        }

        Image {
            source: selectedIndex === 0 ? "assets/home.png" : "assets/home_inactive.png" // Ruta de la imagen de inicio
            width: 24 // Ancho deseado del icono
            height: 20 // Altura deseada del icono
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: parent.height * 0.4 // Espacio desde arriba (20% de la altura)
            }
        }

        Image {
            source: selectedIndex === 1 ? "assets/search.png" : "assets/search_inactive.png" // Ruta de la imagen de búsqueda
            width: 24 // Ancho deseado del icono
            height: 20 // Altura deseada del icono
            anchors.centerIn: parent

        }

        Image {
            source: selectedIndex === 2 ? "assets/plus.png" : "assets/plus_inactive.png" // Ruta de la imagen de categoría
            width: 24 // Ancho deseado del icono
            height: 24 // Altura deseada del icono
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * 0.4 // Espacio desde abajo (20% de la altura)
            }
        }

        Image {
            source: selectedIndex === 3 ? "assets/Trending.png" : "assets/Trending_inactive.png" // Ruta de la imagen de la opción Trending
            width: 24 // Ancho deseado del icono
            height: 20 // Altura deseada del icono
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * 0.32 // Ajusta este valor según tus necesidades
            }
        }


        Keys.onUpPressed: {
            selectedIndex = Math.max(selectedIndex - 1, 0)
        }

        Keys.onDownPressed: {
            selectedIndex = Math.min(selectedIndex + 1, 3) // Ajusta el máximo de acuerdo al número de opciones, en este caso 3 opciones + 1 (Trending)
        }

        // Lógica para enfocar/desenfocar la barra lateral
        Keys.onLeftPressed: {
            selectionMarker.opacity = 0.0;
            sidebarFocused = true;
            searchFocused = true;  // Iluminar el texto "Buscar"
            collectionAxis.focus = false;
        }
        Keys.onRightPressed: {
            if (sidebarFocused) {
                sidebarFocused = false;
                searchFocused = false; // Desiluminar el texto "Buscar"
                selectionMarker.opacity = 1.0;
                collectionAxis.focus = true;
                collectionAxis.currentIndex = Math.min(collectionAxis.currentIndex, collectionAxis.model.count - 1);
            }
        }

        Keys.onPressed: {
            if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                if (selectedIndex === 0) {
                    //Volver al indice 0 de collectionAxis
                    collectionAxis.currentIndex = 0
                } else if (selectedIndex === 1) {
                    // Mostrar la barra de búsqueda al presionar Enter en la opción "Buscar"
                    searchVisible = true;
                    sidebarFocused = false;
                    // Desenfocar el rectángulo selectionMarker
                    selectionMarker.opacity = 0.0;
                    // Mostrar el teclado virtual cuando se abre la barra de búsqueda
                    virtualKeyboardContainer.visible = true;
                    // Establecer el foco en el teclado virtual
                    virtualKeyboardContainer.focus = true;
                } else if (selectedIndex === 2) {
                    // Verificar si hay juegos marcados como favoritos antes de cambiar al índice correspondiente
                    if (favoritesProxyModel.count > 0) {
                        collectionAxis.currentIndex = collectionsListModel.favoritesIndex;
                    }
                } else if (selectedIndex === 3) {
                    // Cambiar al índice correspondiente a la colección de juegos recomendados
                    collectionAxis.currentIndex = 1; // El índice 1 corresponde a la colección de juegos recomendados en collectionsListModel
                }
            }
        }
    }

    //Filtrado de api.allGames
    SortFilterProxyModel {
        id: gamesFiltered
        
        sourceModel: api.allGames
        property string searchTerm: "" // Definición de searchTerm aquí
        
        filters: [
            // Filtrar los resultados para que coincidan con la primera letra introducida por el usuario
            RegExpFilter {
                roleName: "title"; 
                pattern: "^" + gamesFiltered.searchTerm.trim().replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&') + ".+"; // Coincidir con la primera letra introducida por el usuario
                caseSensitivity: Qt.CaseInsensitive; 
                enabled: gamesFiltered.searchTerm !== ""; // Habilitar el filtro solo cuando hay un término de búsqueda
            }
        ]
    }
    
    //Barra de busqueda, teclado virtual y rectangulo de resultados        
    Item {
        width: parent.width / 2 -300// Mitad del ancho de la pantalla
        height: parent.height // Mismo alto que el padre
        z: 100
        // Ajuste de la posición hacia la derecha
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05 // Ajuste de la separación desde el lado izquierdo

        Rectangle {
            width: parent.width // Mismo ancho que el padre
            height: parent.height // Mismo alto que el padre
            color: "transparent" // Color de fondo opcional, puedes cambiarlo según tus preferencias
            visible: searchVisible
            
            // Barra de búsqueda
            Rectangle {
                id: searchBar
                width: parent.width // Mismo ancho que el padre
                height: 50 // Alto deseado
                color: "#1f1f1f"
                radius: 20
                border.width: 2
                //border.color: "#d9d9d9"
                z: 100

                // Contenido de la barra de búsqueda
                Row {
                    anchors {
                        fill: parent
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    Image {
                        id: searchIcon
                        source: "assets/search_inactive.png"
                        width: vpx(16)
                        height: vpx(16)
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: vpx(25)
                        }
                        opacity: searchInput.text.trim().length > 0 ? 0.2 : 1 // Opacidad inicial basada en si hay texto en el campo de búsqueda
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    TextInput {
                        id: searchInput
                        visible: searchVisible // Mostrar solo cuando la barra de búsqueda está visible
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                        FontLoader {
                            id: netflixSansBold
                            source: "font/NetflixSansBold.ttf"
                        }
                        font.family: netflixSansBold.name
                        font.pixelSize: 24 // Tamaño de fuente deseado
                        anchors {
                            fill: parent
                            leftMargin: searchIcon.width + vpx(35) // Espacio adicional para el icono y el margen
                            rightMargin: vpx(10) // Margen derecho para separar el borde derecho del rectángulo
                            verticalCenter: parent.verticalCenter
                        }
                        
                        onTextChanged: {
                            // Lógica de búsqueda
                            gamesFiltered.searchTerm = searchInput.text.trim();
                            searchResults.visible = searchInput.text.trim() !== ""; // Mostrar resultados solo si hay texto en la búsqueda
                        }
                    }

                    Text {
                        id: searchPlaceholder
                        text: "Buscar el juego..."
                        color: "#8c8c8c"//"grey"
                        font.family: netflixSansBold.name
                        font.pixelSize: 24
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: searchIcon.right // Ajuste del anclaje izquierdo para que el texto esté a la derecha del icono
                            leftMargin: vpx(10) // Ajuste del margen izquierdo para agregar espacio entre el icono y el texto
                            right: parent.right // Anclar a la derecha del padre
                            rightMargin: vpx(10) // Margen derecho fijo para mantener el espacio en pantalla completa
                        }
                        visible: searchInput.length === 0 // Mostrar el texto solo cuando el campo de búsqueda está vacío
                        opacity: searchInput.length > 0 ? 0 : 0.7 // Ocultar el texto cuando se está escribiendo en el campo de búsqueda
                        Behavior on opacity { NumberAnimation { duration: 50 } }
                        wrapMode: Text.Wrap // Permitir el ajuste de texto automático
                    }
                }
            }

            //Teclado virtual
            Rectangle {
                id: virtualKeyboardContainer
                width: parent.width // Mismo ancho que el padre
                height: 300 // Alto deseado
                color: "#1f1f1f"
                radius: 7
                border.width: 2
                //border.color: "#d9d9d9"
                anchors {
                  top: searchBar.bottom
                  left: parent.left
                }
                // Establecer el enfoque en el propio teclado virtual
                focus: searchVisible
                z: 100  

                Column {
                  anchors.fill: parent
                  spacing: 5 // Espacio entre columnas

                  // Ajuste de la posición a la derecha
                  Rectangle {
                    width: (parent.width - (6 * 40 + 5 * 5)) / 2 // Espacio en blanco a la izquierda y a la derecha del GridLayout
                    height: 1 // Solo para ajustar el espacio
                    color: "transparent"
                  }

                  GridLayout {
                    id: keyboardGrid
                    columns: 6
                    rows: 6 // 6 filas en lugar de 7
                    anchors.horizontalCenter: parent.horizontalCenter
                    columnSpacing: (parent.width - (6 * 40)) / 7 // Espacio proporcional entre columnas
                    rowSpacing: (parent.height - (6 * 40)) / 7 // Espacio proporcional entre filas
                     
                    // Crear componentes de texto para letras 'a' a 'z' y números '0' a '9'
                    Repeater {
                      model: 26 + 10 // Letras + Números
                      Rectangle {
                        width: 40 // Ancho fijo para todos los botones
                        height: 40 // Alto fijo para todos los botones
                        clip: true // Aplicar clip para recortar el contenido si se desborda
                        color: "transparent" // Color de fondo transparente
                        border.color: virtualKeyboardIndex === index && virtualKeyboardContainer.focus ? "#d9d9d9" : (virtualKeyboardContainer.focus ? "transparent" : "#1f1f1f")
                        border.width: 2 // Ancho del borde
                        radius: 7

                        Item {
                          anchors.fill: parent
                          Text {
                            anchors.centerIn: parent
                            text: index < 26 ? String.fromCharCode(97 + index) : (index < 26 + 10 ? index - 26 : "") // Letras, Números
                            font.pixelSize: 20 // Tamaño de la fuente
                            color: "grey" // Color del texto
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                          }
                        }
                      }
                    }
                  }
                }
                // Manejar eventos de teclado para navegación y selección
                Keys.onPressed: {
                    if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                        if (virtualKeyboardIndex < 26) {
                            searchInput.text += String.fromCharCode(97 + virtualKeyboardIndex); // Agregar letra al campo de búsqueda
                        } else {
                            searchInput.text += virtualKeyboardIndex - 26; // Agregar número al campo de búsqueda
                        }
                    } else if (event.key === Qt.Key_Left && virtualKeyboardIndex === 0) {
                        searchVisible = false; // Ocultar la barra de búsqueda
                        sidebarFocused = true; // Establecer el foco en la barra lateral
                    } else if (event.key === Qt.Key_Left) {
                        if (virtualKeyboardIndex > 0 ){
                            virtualKeyboardIndex--;
                            if (virtualKeyboardIndex === 5 || virtualKeyboardIndex === 11 || virtualKeyboardIndex === 17 || virtualKeyboardIndex === 23 || virtualKeyboardIndex === 29 || virtualKeyboardIndex === 35 || virtualKeyboardIndex === 41) {
                                searchVisible = false; // Ocultar la barra de búsqueda
                                sidebarFocused = true; // Establecer el foco en la barra lateral
                            }
                        }
                    } else if (event.key === Qt.Key_Right) {
                        if (virtualKeyboardIndex < (26 + 12) - 1) {
                            virtualKeyboardIndex++;
                        }
                    } else if (event.key === Qt.Key_Up) {
                        if (virtualKeyboardIndex >= 6) {
                            virtualKeyboardIndex -= 6;
                        }
                    } else if (event.key === Qt.Key_Down) {
                        if (virtualKeyboardIndex < (26 + 10) - 6) {
                            virtualKeyboardIndex += 6;
                        } else if (virtualKeyboardIndex >= 30 && virtualKeyboardIndex <= 35) { // Añadido: Manejar movimiento hacia abajo en la última fila
                            if (buttonKeyContainer.focus = true) {
                                navigatedDown = false;

                            }
                        }
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        // Agregar la lógica para que al presionar Enter se escriba la letra o número seleccionado
                        if (virtualKeyboardIndex < 26) {
                            searchInput.text += String.fromCharCode(65 + virtualKeyboardIndex); // Agregar letra al campo de búsqueda
                        } else {
                            searchInput.text += virtualKeyboardIndex - 26; // Agregar número al campo de búsqueda
                        }
                    }
                }
            }

            //botones con iconos
            Rectangle {
                id: buttonKeyContainer
                width: parent.width // Mismo ancho que el padre
                height: 35 // Alto deseado
                color: "#1f1f1f" // Color de fondo
                radius: 7
                border.width: 2
                visible: searchVisible
                anchors {
                    top: virtualKeyboardContainer.bottom
                    left: parent.left
                }
                // Índice de la selección actual
                property int selectedIndex: 0

                Row {
                    width: parent.width // Ancho igual al del buttonKeyContainer
                    height: parent.height // Alto igual al del buttonKeyContainer
                    spacing: 0 // Sin espaciado entre los iconos

                    // Iconos que estarán siempre visibles
                    Repeater {
                        model: 3 // Número de iconos
                        Image {
                            width: buttonKeyContainer.width / 3 // Ancho igualmente distribuido para cada icono
                            height: parent.height // Alto igual al del buttonKeyContainer
                            source: index === 0 ? "assets/del.png" : (index === 1 ? "assets/espacio.png" : (index === 2 ? "assets/sidebar.png" : ""))
                            fillMode: Image.PreserveAspectFit // Ajustar la imagen al tamaño del botón
                        }
                    }
                }

                // Rectángulo selector para resaltar los iconos al obtener el foco
                Rectangle {
                    id: selectorRectangle
                    width: buttonKeyContainer.width / 3 // Ancho proporcional al del buttonKeyContainer
                    height: 35 // Alto igual al de los botones
                    color: "transparent" // Color del relleno transparente
                    border.color: "white" // Color del borde
                    border.width: 2 // Ancho del borde
                    visible: buttonKeyContainer.focus // Hacer visible el rectángulo selector solo cuando obtenga el foco
                    clip: true
                    radius: 7
                }

                // Manejar eventos de teclado para navegación y selección
                Keys.onPressed: {
                    if (!event.isAutoRepeat) {
                        if (event.key === Qt.Key_Left) {
                            if (buttonKeyContainer.selectedIndex > 0) {
                                buttonKeyContainer.selectedIndex--; // Mover a la izquierda
                                selectorRectangle.x -= buttonKeyContainer.width / 3;
                            }
                        } else if (event.key === Qt.Key_Right) {
                            if (buttonKeyContainer.selectedIndex < 2) {
                                buttonKeyContainer.selectedIndex++; // Mover a la derecha
                                selectorRectangle.x += buttonKeyContainer.width / 3;
                            }
                        } else if (event.key === Qt.Key_Up) {
                            // Mover el foco al teclado virtual
                            virtualKeyboardContainer.focus = true;
                            //buttonKeyContainer.visible = true;
                            buttonKeyContainer.focus = false;
                            navigatedDown = false;
                        } else if (event.key === Qt.Key_Down) {
                            // Si se presiona la tecla de flecha hacia abajo y estamos sobre uno de los botones, hacer lo siguiente:
                            if (buttonKeyContainer.selectedIndex >= 0 && buttonKeyContainer.selectedIndex <= 2) {
                                if (searchResults.visible) {
                                    resultsList.focus = true;
                                    navigatedDown = true;
                                }
                            }
                        } else if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                            if (buttonKeyContainer.selectedIndex === 0) {
                                // Eliminar la última letra del texto en searchInput
                                searchInput.text = searchInput.text.slice(0, -1);
                            } else if (buttonKeyContainer.selectedIndex === 1) {
                                // Agregar un espacio al texto en searchInput
                                searchInput.text += " ";
                            } else if (buttonKeyContainer.selectedIndex === 2) {
                                // Ocultar la búsqueda y enfocar la barra lateral
                                searchVisible = false;
                                sidebarFocused = true;
                            }
                        }
                    }
                }
            }

            // Resultados de búsqueda
            Rectangle {
                id: searchResults
                width: parent.width // Mismo ancho que el padre
                height: parent.height - virtualKeyboardContainer.height -100// Alto deseado
                color: "#1f1f1f" //#171717"
                radius: 7
                border.width: 2
                //border.color: "#d9d9d9"
                anchors {
                    top: buttonKeyContainer.bottom
                    left: parent.left
                }
                visible: false // Comienza oculto

                ListView {
                    id: resultsList
                    width: parent.width // Mismo ancho que el padre
                    height: parent.height // Mismo alto que el padre
                    // Contenido de la lista de resultados...
                    model: gamesFiltered
                    clip: true

                    delegate: Rectangle {
                        width: parent ? parent.width : 0 // Verifica si hay un padre antes de acceder a su anchura
                        height: 30 // Altura deseada de cada elemento de la lista
                        color: ListView.isCurrentItem && navigatedDown ? "red" : "transparent" // Controlar la visibilidad basada en la propiedad navigatedDown
                        border.color: ListView.isCurrentItem && navigatedDown ? "red" : "transparent" // Controlar la visibilidad basada en la propiedad navigatedDown
                        border.width: ListView.isCurrentItem && navigatedDown ? 3 : 0 // Controlar la visibilidad basada en la propiedad navigatedDown
                        radius: 7
                        FontLoader {
                            id: netflixSansBold
                            source: "font/NetflixSansBold.ttf"
                        }
                        Text {
                            anchors.fill: parent
                            text: model.title !== undefined ? model.title : "Title not available"
                            font.family: netflixSansBold.name // Utilizar la fuente personalizada
                            font.pixelSize: 18 // Tamaño de fuente deseado
                            verticalAlignment: Text.AlignVCenter
                            padding: 5 // Espaciado interior deseado
                            color: "white" // Cambiar el color del texto a blanco
                            wrapMode: Text.WordWrap // Ajustar el texto dentro del rectángulo
                            elide: Text.ElideRight // Truncar el texto si es demasiado largo
                        }
                    }

                    // Manejar evento de tecla para mover el foco hacia arriba
                    Keys.onUpPressed: {
                        if (resultsList.currentIndex === 0) {
                            // Cambiar el enfoque a la barra de búsqueda
                            //virtualKeyboardContainer.focus = true;
                            buttonKeyContainer.focus = true
                            // Establecer la propiedad navigatedDown a false
                            navigatedDown = false;
                        } else {
                            // Desplazar hacia arriba si no estamos en el primer elemento
                            resultsList.currentIndex--;
                        }
                    }

                    // Manejar evento de tecla para lanzar el juego seleccionado
                    Keys.onPressed: {
                        if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                            // Obtener el título del juego seleccionado
                            var selectedGame = gamesFiltered.get(resultsList.currentIndex);
                            var selectedTitle = selectedGame.title;

                            // Buscar el juego con el título seleccionado
                            var gamesArray = api.allGames.toVarArray();
                            var gameFound = gamesArray.find(function(game) {
                                return game.title === selectedTitle;
                            });

                            // Verificar si se encontró el juego
                            if (gameFound) {
                                console.log("Se lanzará el juego seleccionado:", gameFound.title);
                                // Lanzar el juego encontrado
                                sidebarFocused = false;
                                searchVisible = false;
                                searchFocused = false; // Desiluminar el texto "Buscar"
                                selectionMarker.opacity = 1.0;
                                collectionAxis.focus = true;
                                gameFound.launch();
                            } else {
                                console.log("No se encontró el juego con el título:", selectedTitle);
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Modelo de colecciones funciona perfectamente
    Item {
        id: root

        property alias favoritesModel: favoritesProxyModel
        property bool favoritesVisible: favoritesProxyModel.count > 0 
        property alias continuePlayingModel: continuePlayingProxyModel
        property bool continuePlayingVisible: continuePlayingProxyModel.count > 0

        ListModel {
            id: collectionsListModel
            property int allIndex: 0
            property int favoritesIndex: -1
            property int continuePlayingIndex: -1
            property bool favoritesAvailable: false // Agregamos la propiedad para indicar si la colección de favoritos está disponible

            Component.onCompleted: {
                // Insertar colección "Todos los juegos"
                var allCollection = { name: "Todos los juegos", shortName: "todoslosjuegos", games: api.allGames };
                collectionsListModel.append(allCollection);

                // Insertar colección "Juegos recomendados"
                var recommendedCollection = { name: "Juegos recomendados", shortName: "recomendados", games: gameListModel };
                collectionsListModel.append(recommendedCollection);

                // Insertar colección "Mi lista" si tiene juegos
                if (favoritesProxyModel.count > 0) {
                    var favoritesCollection = { name: "Mi lista", shortName: "milista", games: favoritesProxyModel };
                    collectionsListModel.append(favoritesCollection);
                    collectionsListModel.favoritesIndex = collectionsListModel.count - 1;
                    collectionsListModel.favoritesAvailable = true; // Establecemos la propiedad en true si hay juegos en la colección de favoritos
                }

                // Insertar colección "Seguir jugando" si tiene juegos
                if (continuePlayingProxyModel.count > 0) {
                    var continuePlayingCollection = { name: "Seguir jugando", shortName: "seguirjugando", games: continuePlayingProxyModel };
                    collectionsListModel.append(continuePlayingCollection);
                    collectionsListModel.continuePlayingIndex = collectionsListModel.count - 1;
                }

                // Insertar colecciones restantes
                for (var i = 0; i < api.collections.count; ++i) {
                    var collection = api.collections.get(i);
                    if (collection.name !== "Mi lista" && collection.name !== "Seguir jugando") {
                        collectionsListModel.append(collection);
                    }
                }
            }
        }

            SortFilterProxyModel {
                id: gamesFiltered2
                sourceModel: api.allGames
                sorters: RoleSorter { roleName: "name"; sortOrder: Qt.AscendingOrder; }
            }

            ListModel {
                id: gameListModel

                function getRandomIndices(count) {
                    var indices = [];
                    for (var i = 0; i < count; ++i) {
                        indices.push(i);
                    }
                    indices.sort(function() { return 0.5 - Math.random() });
                    return indices;
                }

                Component.onCompleted: {
                    var maxGames = 15;
                    var randomIndices = getRandomIndices(gamesFiltered2.count);
                    for (var j = 0; j < maxGames && j < randomIndices.length; ++j) {
                        var gameIndex = randomIndices[j];
                        var game = gamesFiltered2.get(gameIndex);
                        gameListModel.append(game);
                    }
                }
            }

        SortFilterProxyModel {
            id: filteredGames1
            sourceModel: api.allGames
            sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
        }
        
        ListModel {
            id: continuePlayingProxyModel

            Component.onCompleted: {
                var currentDate = new Date()
                var sevenDaysAgo = new Date(currentDate.getTime() - 7 * 24 * 60 * 60 * 1000) // Restar 7 días en milisegundos
                for (var i = 0; i < filteredGames1.count; ++i) {
                    var game = filteredGames1.get(i)
                    var lastPlayedDate = new Date(game.lastPlayed)
                    var playTimeInMinutes = game.playTime / 60
                    if (lastPlayedDate >= sevenDaysAgo && playTimeInMinutes > 1) {
                        continuePlayingProxyModel.append(game)
                    }
                }

                // Si la colección "Seguir jugando" está vacía, se elimina de la lista
                if (count === 0 && collectionsListModel.continuePlayingIndex !== -1) {
                    collectionsListModel.remove(collectionsListModel.continuePlayingIndex, 1);
                    collectionsListModel.continuePlayingIndex = -1;
                }
                // Si hay juegos en "Seguir jugando" y la colección "Seguir jugando" no está en la lista, se agrega
                else if (count > 0 && collectionsListModel.continuePlayingIndex === -1) {
                    var allIndex = collectionsListModel.allIndex;
                    var continuePlayingIndex = -1;
                    // Encontrar el índice donde insertar la colección "Seguir jugando"
                    for (var i = 0; i < collectionsListModel.count; ++i) {
                        if (collectionsListModel.get(i).shortName === "recomendados") {
                            continuePlayingIndex = i + 1; // Insertar después de "Juegos recomendados"
                            break;
                        }
                    }
                    // Insertar la colección "Seguir jugando" en el índice correcto
                    if (continuePlayingIndex !== -1) {
                        var continuePlayingCollection = { name: "Continuar jugando", shortName: "continuarjugando", games: continuePlayingProxyModel };
                        collectionsListModel.insert(continuePlayingIndex, continuePlayingCollection);
                        collectionsListModel.continuePlayingIndex = continuePlayingIndex;
                    }
                }
                // Actualizar la visibilidad de las colecciones
                //updateCollectionsVisibility();
            }
        }

        SortFilterProxyModel {
            id: favoritesProxyModel
            sourceModel: api.allGames
            filters: ValueFilter { roleName: "favorite"; value: true }
            onCountChanged: {
                // Si la colección "Favoritos" está vacía, se elimina de la lista
                if (count === 0 && collectionsListModel.favoritesIndex !== -1) {
                    collectionsListModel.remove(collectionsListModel.favoritesIndex, 1);
                    collectionsListModel.favoritesIndex = -1;
                }
                // Si hay juegos favoritos y la colección "Favoritos" no está en la lista, se agrega
                else if (count > 0 && collectionsListModel.favoritesIndex === -1) {
                    var allIndex = collectionsListModel.allIndex;
                    var favoritesIndex = -1;
                    // Encontrar el índice donde insertar la colección "Mi lista"
                    for (var i = 0; i < collectionsListModel.count; ++i) {
                        if (collectionsListModel.get(i).shortName === "recomendados") {
                            favoritesIndex = i + 1; // Insertar después de "Juegos recomendados"
                            break;
                        }
                    }
                    // Insertar la colección "Mi lista" en el índice correcto
                    if (favoritesIndex !== -1) {
                        var favoritesCollection = { name: "Mi lista", shortName: "milista", games: favoritesProxyModel };
                        collectionsListModel.insert(favoritesIndex, favoritesCollection);
                        collectionsListModel.favoritesIndex = favoritesIndex;
                    }
                }
                // Actualizar la visibilidad de las colecciones
                //updateCollectionsVisibility();
            }
        }
    }

    Video {
        game: collectionAxis.currentItem ? collectionAxis.currentItem.currentGame : null // Asigna el juego actual al componente de video si existe
        anchors {
            top: parent.top // Ancla el componente de video al borde superior del padre
            left: parent.horizontalCenter // Anclando al centro horizontal del padre
            right: parent.right // Ancla el componente de video al borde derecho del padre
            bottom: selectionMarker.top // Ancla el borde inferior del componente de video al borde superior del marcador de selección
            bottomMargin: -5 // Margen negativo de 5 píxeles hacia abajo para superponer el marcador de selección
            leftMargin: -150 // Margen negativo de 150 píxeles hacia la izquierda para mover el componente de video hacia la izquierda
        }
    }

    Details {
        game: collectionAxis.currentItem ? collectionAxis.currentItem.currentGame : null // Asigna el juego actual al componente de detalles si existe
        anchors {
            top: parent.top // Ancla el componente de detalles al borde superior del padre
            left: parent.left; leftMargin: leftGuideline // - 70 // Ancla el borde izquierdo del componente de detalles a la guía izquierda
            bottom: collectionAxis.top; bottomMargin: labelHeight * 0.63 // Ancla el borde inferior del componente de detalles al borde superior del eje de colección con un margen
            right: parent.horizontalCenter // Ancla el borde derecho del componente de detalles al centro horizontal del padre
        }
        opacity: sidebarFocused ? 0.5 : 1.0
    }

    Rectangle {
        id: selectionMarker // Identificador del rectángulo de marcador de selección
        width: cellWidth // Establece el ancho del rectángulo igual al ancho de la celda
        height: cellHeight // Establece la altura del rectángulo igual a la altura de la celda
        z: 100 // Establece la prioridad de apilamiento del rectángulo
        anchors {
            left: parent.left // Ancla el borde izquierdo del rectángulo al borde izquierdo del padre
            leftMargin: leftGuideline // Establece el margen izquierdo del rectángulo según la guía izquierda
            bottom: parent.bottom // Ancla el borde inferior del rectángulo al borde inferior del padre
            bottomMargin: labelHeight - cellHeight + vpx(304.5) // Establece el margen inferior del rectángulo con respecto a la altura de la etiqueta y el espacio adicional
        }
        color: "transparent" // Establece el color del rectángulo como transparente
        border { width: 4; color: "white" } // Establece un borde blanco de 4 píxeles de ancho para el rectángulo
    }

    // Cuadrícula de colecciones
    PathView {
        // Propiedades generales de la cuadrícula de colecciones
        id: collectionAxis // Identificador del PathView
        property real collectionAxisOpacity: searchVisible ? 0.3 : 1.0
        width: parent.width // Establece el ancho del PathView igual al ancho del elemento padre
        height: 1.3 * (labelHeight + cellHeight) + vpx(5) // Establece la altura del PathView como 1.3 veces la suma de la altura de la etiqueta y la altura de la celda, más un valor en píxeles
        anchors.bottom: parent.bottom // Ancla el PathView al borde inferior del elemento padre
        model: collectionsListModel // Establece el modelo de datos para el PathView, probablemente una lista de colecciones de juegos
        delegate: collectionAxisDelegate // Establece el delegado para cada elemento en el PathView

        // Propiedades del recorrido de la cuadrícula
        // Lógica para la navegación y control de la cuadrícula de colecciones
        pathItemCount: 4 // Establece el número de elementos en la ruta
        readonly property int pathLength: (labelHeight + cellHeight) * 4 // Calcula la longitud total de la ruta
        path: Path {
            startX: collectionAxis.width * 0.5 // Establece la posición inicial en X de la ruta en la mitad del ancho del PathView
            startY: (labelHeight + cellHeight) * -0.5 // Establece la posición inicial en Y de la ruta en la mitad negativa de la suma de la altura de la etiqueta y la altura de la celda
            PathLine {
                x: collectionAxis.path.startX // Establece la posición final en X de la ruta
                y: collectionAxis.path.startY + collectionAxis.pathLength // Establece la posición final en Y de la ruta sumando la longitud de la ruta a la posición inicial en Y
            }
        }
        // Lógica para la inicialización de la cuadrícula de colecciones al completar
        snapMode: PathView.SnapOneItem // Establece el modo de ajuste para mostrar un elemento completo a la vez
        highlightRangeMode: PathView.StrictlyEnforceRange // Establece el modo de resaltado para asegurar que solo se resalte un rango de elementos
        movementDirection: PathView.Positive // Establece la dirección de movimiento de la cuadrícula
        clip: true // Habilita el recorte para asegurarse de que los elementos fuera del área visible no se dibujen
        preferredHighlightBegin: 1 / 4 // Establece la posición de inicio preferida para el resaltado
        preferredHighlightEnd: preferredHighlightBegin // Establece la posición final preferida para el resaltado igual a la posición de inicio preferida
        focus: true // Habilita el enfoque en el PathView
        Keys.onUpPressed: decrementCurrentIndex() // Maneja el evento de tecla presionada: decrementa el índice actual al presionar la tecla hacia arriba
        Keys.onDownPressed: incrementCurrentIndex() // Maneja el evento de tecla presionada: incrementa el índice actual al presionar la tecla hacia abajo
        
        Keys.onLeftPressed: {
            if (currentItem.axis.currentIndex === 0) {
                selectionMarker.opacity = 0.0;
                sidebarFocused = true;
                searchFocused = true; // Iluminar el texto "Buscar"
                collectionAxis.focus = false;
            } else {
                 // Si no estás dentro de la barra, permite desplazarte hacia la derecha sobre los juegos de la colección
                if (currentItem.axis.currentIndex > 0) {
                    currentItem.axis.decrementCurrentIndex()
                }
            }
        }

        Keys.onRightPressed: {
            if (sidebarFocused) {
                selectionMarker.opacity = 1.0;
                sidebarFocused = false
                searchFocused = false // Desiluminar el texto "Buscar"
                collectionAxis.focus = true
                collectionAxis.currentIndex = Math.min(collectionAxis.currentIndex, collectionAxis.model.count - 1)
            } else {
                // Si no estás dentro de la barra, permite desplazarte hacia la derecha sobre los juegos de la colección
                if (currentItem.axis.currentIndex < currentItem.axis.model.count - 1) {
                    currentItem.axis.incrementCurrentIndex()
                }
            }
        }

        Keys.onPressed: { // Maneja el evento de tecla presionada
            if (!event.isAutoRepeat) { // Verifica si la tecla no está en modo de repetición automática
                if (api.keys.isDetails(event)) { // Verifica si la tecla presionada es para detalles
                    var game = currentItem.currentGame; // Obtiene el juego actual
                    console.log("Juego actual:", game.title); // Imprime el título del juego actual en la consola
                    game.favorite = !game.favorite; // Cambia el estado de favorito del juego
                    if (game.favorite) {
                        console.log("Juego marcado como favorito:", game.title); // Imprime un mensaje si el juego se marca como favorito
                    } else {
                        console.log("Juego desmarcado como favorito:", game.title); // Imprime un mensaje si el juego se desmarca como favorito
                    }
                } else if (api.keys.isAccept(event)) { // Verifica si la tecla presionada es para aceptar
                    var game = currentItem.currentGame; // Obtiene el juego actual
                    api.memory.set('collection', currentItem.name); // Establece el nombre de la colección en la memoria
                    api.memory.set('game', currentItem.currentGame.title); // Establece el título del juego en la memoria
                    game.launch(); // Lanza el juego
                }
            }
        }
        opacity: collectionAxisOpacity
    }

    // Componente para el delegado de la cuadrícula de colecciones
    // Define cómo se muestra cada fila de la cuadrícula de colecciones
    Component {
        // Propiedades específicas del delegado de la cuadrícula de colecciones
        id: collectionAxisDelegate // Identificador del componente
        Item {
            // Propiedades para el delegado de la cuadrícula de colecciones
            property alias axis: gameAxis // Alias para la propiedad 'axis', que probablemente se refiera al PathView 'gameAxis'
            readonly property var currentGame: axis.currentItem ? axis.currentItem.game : null // Propiedad solo de lectura que devuelve el juego actualmente seleccionado en el PathView
            property string name: model.name // Propiedad que almacena el nombre del modelo de datos del elemento actual
            // Tamaño del elemento del delegado
            width: PathView.view.width // Establece el ancho del delegado igual al ancho de la vista PathView
            height: labelHeight + cellHeight // Establece la altura del delegado como la suma de la altura de la etiqueta y la altura de la celda
            visible: PathView.onPath // Establece la visibilidad del delegado basada en si está en la ruta de navegación o no
            opacity: sidebarFocused ? 0.2 : (PathView.isCurrentItem ? 1.0 : 0.5)
            //opacity: PathView.isCurrentItem ? 1.0 : 0.6 // Establece la opacidad del delegado según si es el elemento actual en la vista PathView o no
            Behavior on opacity { NumberAnimation { duration: 150 } } // Agrega una animación de cambio de opacidad al delegado

            Text {
                textFormat: Text.RichText // Establece el formato de texto como texto enriquecido
                height: labelHeight // Establece la altura del texto igual a la altura de la etiqueta
                verticalAlignment: Text.AlignVCenter // Alinea verticalmente el texto al centro
                // Ajustar la posición izquierda con márgenes relativos
                anchors.left: parent.left // Ancla el lado izquierdo del texto al lado izquierdo del elemento padre
                anchors.leftMargin: leftGuideline // - 70 // Establece el margen izquierdo del texto
                color: "white" // Establece el color del texto como blanco
                font {
                    pixelSize: labelFontSize // Establece el tamaño del texto según la variable 'labelFontSize'
                    family: globalFonts.sans // Establece la fuente del texto como una fuente sans-serif global
                    bold: true // Establece el texto en negrita
                    capitalization: name ? Font.MixedCase : Font.AllUppercase // Capitaliza el texto según el nombre del modelo: mixto si hay nombre, todo en mayúsculas si no
                }

                FontLoader {
                    id: netflixsansbold // Identificador de FontLoader
                    source: "font/NetflixSansBold.ttf" // Carga la fuente NetflixSansBold.ttf
                }

                Row {
                    id: imageContainer // Identificador de la fila contenedora
                    anchors.verticalCenter: parent.verticalCenter // Ancla el centro vertical de la fila al centro vertical del padre

                    Text {
                        id: collectionName // Identificador del texto de nombre de colección
                        text: name === "todoslosjuegos" ? "Todos los juegos" : // Asigna texto según el nombre de la colección
                              name === "milista" ? "Mi lista" :
                              name === "continuarjugando" ? "Continuar jugando" :
                              name // Usa el nombre de la colección si no coincide con ninguna condición
                        color: "white" // Establece el color del texto como blanco
                        font.family: netflixsansbold.name // Asigna la fuente NetflixSansBold a la familia de fuentes del texto
                        font.pixelSize: vpx(15) // Establece el tamaño de píxel de la fuente
                    }

                    Text {
                        id: gameCount // Identificador del texto de recuento de juegos
                        text: " | " + (gameAxis.currentIndex + 1) + "/" + (games ? games.count : 0) + "  " // Calcula y muestra el recuento de juegos actual
                        color: "grey" // Establece el color del texto como gris
                        font.family: netflixsansbold.name // Asigna la fuente NetflixSansBold a la familia de fuentes del texto
                        font.pixelSize: vpx(15) // Establece el tamaño de píxel de la fuente
                    }

                    Image {
                        id: favoriteYesImage // Identificador de la imagen de favorito
                        source: "assets/favoriteyes.png" // Asigna la ruta de la imagen
                        width: parent.height * 0.9 // Establece el ancho de la imagen como el 90% de la altura del padre
                        height: parent.height * 0.9 // Establece la altura de la imagen como el 90% de la altura del padre
                    }

                    Text {
                        text: "  Mi lista   " // Texto "Mi lista"
                        color: "white" // Establece el color del texto como blanco
                        font.family: netflixsansbold.name // Asigna la fuente NetflixSansBold a la familia de fuentes del texto
                        font.pixelSize: vpx(15) // Establece el tamaño de píxel de la fuente
                    }

                    Image {
                        id: favoriteImage // Identificador de la imagen de favorito
                        source: gameAxis.currentItem.game.favorite ? "assets/check.png" : "assets/plus.png" // Asigna la ruta de la imagen según el estado de favorito del juego actual
                        width: parent.height * 0.9 // Establece el ancho de la imagen como el 90% de la altura del padre
                        height: parent.height * 0.9 // Establece la altura de la imagen como el 90% de la altura del padre
                        rotation: gameAxis.currentItem.game.favorite ? 360 : 0 // Rota la imagen si el juego actual es favorito
                        Behavior on rotation { RotationAnimation { duration: 400 } } // Agrega una animación de rotación a la imagen
                    }
                }
            }
            
            // Cuadrícula de juegos en la colección actual
            PathView {
                // Propiedades generales de la cuadrícula de juegos
                id: gameAxis
                width: parent.width // Establece el ancho del PathView igual al ancho del elemento padre
                height: cellHeight // Establece la altura del PathView igual a la altura de la celda
                anchors.bottom: parent.bottom // Ancla el PathView al borde inferior del elemento padre
                model: games // Establece el modelo de datos para el PathView, donde 'games' probablemente sea un arreglo de juegos

                // Delegado para cada juego en la cuadrícula de juegos
                delegate: GameAxisCell {
                    // Propiedades del juego en el delegado de la cuadrícula de juegos
                    game: modelData // Establece la propiedad 'game' del GameAxisCell igual a los datos del juego actual
                    width: cellWidth // Establece el ancho del delegado igual al ancho de la celda
                    height: cellHeight // Establece la altura del delegado igual a la altura de la celda
                }

                // Lógica para la navegación y control de la cuadrícula de juegos
                readonly property var currentGame: gameAxis.currentItem ? gameAxis.currentItem.game : null // Propiedad solo de lectura que devuelve el juego actualmente seleccionado en el PathView
                readonly property int maxItemCount: 2 + Math.ceil(width / cellPaddedWidth) // Calcula el número máximo de elementos que pueden caber en el PathView
                pathItemCount: Math.min(maxItemCount, model ? model.count : 0) // Establece el número de elementos en la ruta como el mínimo entre 'maxItemCount' y el número de elementos en el modelo de datos

                // Lógica para la ruta de navegación
                property int fullPathWidth: pathItemCount * cellPaddedWidth // Calcula el ancho total de la ruta multiplicando el número de elementos en la ruta por el ancho de la celda
                path: Path {
                    startX: (gameAxis.model ? gameAxis.model.count >= gameAxis.maxItemCount : false) // Calcula la posición inicial en X de la ruta dependiendo de si hay más elementos que los que pueden caber en la vista
                        ? leftGuideline - cellPaddedWidth * 1.5 // Si hay más elementos que los que caben, ajusta la posición inicial hacia la izquierda
                        : leftGuideline + (cellPaddedWidth * 0.5 - cellSpacing * 0.5); // Si no, centra la posición inicial
                    startY: cellHeight * 0.5 // Establece la posición inicial en Y de la ruta en el centro vertical de la celda
                    PathLine {
                        x: gameAxis.path.startX + gameAxis.fullPathWidth // Establece la posición final en X de la ruta
                        y: gameAxis.path.startY // Mantiene la posición final en Y de la ruta igual a la posición inicial
                    }
                }

                snapMode: PathView.SnapOneItem // Establece el modo de ajuste para mostrar un elemento completo a la vez
                highlightRangeMode: PathView.StrictlyEnforceRange // Establece el modo de resaltado para asegurar que solo se resalte un rango de elementos
                clip: true // Habilita el recorte para asegurarse de que los elementos fuera del área visible no se dibujen
                preferredHighlightBegin: (gameAxis.model ? gameAxis.model.count >= gameAxis.maxItemCount : false) // Establece la posición de inicio preferida para el resaltado dependiendo de si hay más elementos que los que caben en la vista
                    ? (2 * cellPaddedWidth - cellSpacing / 2) / fullPathWidth // Calcula la posición de inicio preferida para el resaltado si hay más elementos que los que caben
                    : 0; // Si no, establece la posición de inicio preferida como cero
                preferredHighlightEnd: preferredHighlightBegin // Establece la posición final preferida para el resaltado igual a la posición de inicio preferida
            }
        }
    }
}
