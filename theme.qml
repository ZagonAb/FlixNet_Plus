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

import QtQuick 2.7
import SortFilterProxyModel 0.2

// Definición del enfoque principal del ámbito
FocusScope {
    focus: true
    // Propiedades para el diseño de los íconos en cuadrícula
    // Propiedades relacionadas con el tamaño y el espaciado de los íconos en la cuadrícula
    readonly property real cellRatio: 10 / 16
    readonly property int cellHeight: vpx(255)
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(10)
    readonly property int cellPaddedWidth: cellWidth + cellSpacing

    // Propiedades para las etiquetas de categoría de las filas
    readonly property int labelFontSize: vpx(18)
    readonly property int labelHeight: labelFontSize * 2.5

    // Propiedad para la guía izquierda del diseño
    readonly property int leftGuideline: vpx(100)

    // Video: Pantalla principal del juego actual
    // Muestra el video del juego seleccionado en la parte principal de la pantalla

        Video {
            game: collectionAxis.currentItem.currentGame
            anchors {
                top: parent.top
                left: parent.horizontalCenter // Anclando al centro horizontal del padre
                right: parent.right
                bottom: selectionMarker.top
                bottomMargin: -5 // Puedes ajustar este valor según tus necesidades
                leftMargin: -150 // Ajusta este valor para mover más a la izquierda o derecha
            }
        }


    // Detalles del juego actual
    // Muestra detalles adicionales del juego seleccionado en la parte inferior izquierda de la pantalla
    Details {
        game: collectionAxis.currentItem.currentGame
        anchors {
            top: parent.top
            left: parent.left; leftMargin: leftGuideline - 70
            bottom: collectionAxis.top; bottomMargin: labelHeight * 0.63
            right: parent.horizontalCenter
        }
    }
    // Marcador de selección en la cuadrícula
    // Un rectángulo transparente que resalta la selección actual en la cuadrícula de juegos
    Rectangle {
        id: selectionMarker

        width: cellWidth
        height: cellHeight
        z: 100

        anchors {
            left: parent.left
            leftMargin: leftGuideline
            bottom: parent.bottom
            bottomMargin: labelHeight - cellHeight + vpx(304.5)
        }

        color: "transparent"
        border { width: 4; color: "white" }
    }
    // Cuadrícula de colecciones
    PathView {
    // Propiedades generales de la cuadrícula de colecciones
        id: collectionAxis

        width: parent.width
        height: 1.3 * (labelHeight + cellHeight) + vpx(5)
        anchors.bottom: parent.bottom
        
        // Modelo de las colecciones de juegos
        model: api.collections

        // Delegado para cada elemento de la cuadrícula de colecciones
        delegate: collectionAxisDelegate

        // Propiedades del recorrido de la cuadrícula
        // Lógica para la navegación y control de la cuadrícula de colecciones
        pathItemCount: 4
        readonly property int pathLength: (labelHeight + cellHeight) * 4
        path: Path {
            startX: collectionAxis.width * 0.5
            startY: (labelHeight + cellHeight) * -0.5
            PathLine {
                x: collectionAxis.path.startX
                y: collectionAxis.path.startY + collectionAxis.pathLength
            }
        }
        // Lógica para la inicialización de la cuadrícula de colecciones al completar
        snapMode: PathView.SnapOneItem
        highlightRangeMode: PathView.StrictlyEnforceRange
        movementDirection: PathView.Positive
        clip: true

        preferredHighlightBegin: 1 / 4
        preferredHighlightEnd: preferredHighlightBegin

        focus: true
        Keys.onUpPressed: decrementCurrentIndex()
        Keys.onDownPressed: incrementCurrentIndex()
        Keys.onLeftPressed: currentItem.axis.decrementCurrentIndex()
        Keys.onRightPressed: currentItem.axis.incrementCurrentIndex()
        Keys.onPressed: {
            if (!event.isAutoRepeat) {
                if (api.keys.isDetails(event)) {
                    // Obtén el juego actual
                    var game = currentItem.currentGame; //original
                    // Alterna el estado de favoritos del juego
                    game.favorite = !game.favorite;

                    // Puedes guardar el estado de favoritos en algún lugar, como "favorites.txt"
                    if (game.favorite) {
                        // Agregar la ubicación del juego a la lista de favoritos
                        // Aquí debes definir cómo deseas gestionar la lista de favoritos
                    } else {
                        // Quitar la ubicación del juego de la lista de favoritos
                        // Aquí debes definir cómo deseas gestionar la lista de favoritos
                    }
                }
                else if (api.keys.isAccept(event)) {
                    // Lanza el juego si se presiona el botón "aceptar"
                    var game = currentItem.currentGame;
                    api.memory.set('collection', currentItem.name);
                    api.memory.set('game', currentItem.currentGame.title); // corregir, no restablece la el ultimo lanzado
                    //api.memory.set('game', gameAxis.currentItem.currentGame.title);
                    game.launch();
                }
            }
        }
    }
    // Componente para el delegado de la cuadrícula de colecciones
    // Define cómo se muestra cada fila de la cuadrícula de colecciones
    Component {
        // Propiedades específicas del delegado de la cuadrícula de colecciones
        id: collectionAxisDelegate
        
        Item {
            // Propiedades para el delegado de la cuadrícula de colecciones
            property alias axis: gameAxis
            readonly property var currentGame: axis.currentGame
            property string name: modelData.name

            // Tamaño del elemento del delegado
            width: PathView.view.width
            height: labelHeight + cellHeight

            visible: PathView.onPath
            opacity: PathView.isCurrentItem ? 1.0 : 0.6
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Text {
                textFormat: Text.RichText
                height: labelHeight
                verticalAlignment: Text.AlignVCenter

                // Ajustar la posición izquierda con márgenes relativos
                anchors.left: parent.left
                anchors.leftMargin: leftGuideline - 70

                color: "white"
                font {
                    pixelSize: labelFontSize
                    family: globalFonts.sans
                    bold: true
                    capitalization: modelData.name ? Font.MixedCase : Font.AllUppercase
                }

                // Concatenar el texto con la etiqueta de imagen y ajustar el tamaño
                text: modelData.name + "<font color='grey'> | " + (gameAxis.currentIndex + 1) + "/" + games.count +
                      "<font color='grey'> | <font color='white'> <img src='assets/favoriteyes.png' width='" + parent.height * 0.05 + "' height='" + parent.height * 0.05 + "'> Favorito on/off" + "</font>"

                // Añadir un elemento anclado a la derecha del texto para ajustar la posición de la imagen
                Text {
                    id: imageContainer
                    anchors.verticalCenter: parent.verticalCenter // Centrar verticalmente el contenedor de la imagen

                    // Utilizar un ancla a la derecha del texto para alinear la imagen
                    anchors.right: parent.right
                    width: parent.height * 0.1 // Ancho de la imagen igual al tamaño deseado
                    height: parent.height * 0.1 // Altura de la imagen igual al tamaño deseado
                }
            }



            // Lógica para la inicialización del componente del delegado de la cuadrícula de colecciones
            Component.onCompleted: {
                const lastCollectionName = api.memory.get('collection');
                const lastGameTitle = api.memory.get('game');

                if (lastCollectionName && lastGameTitle && name === lastCollectionName) {
                    // Obtén el índice en el modelo proxy
                    const proxyIndex = gameAxis.currentIndex;

                    // Convierte el índice del modelo proxy al índice en el modelo de origen
                    const sourceIndex = gameAxis.model.mapToSource(proxyIndex);

                    // Encuentra el juego en el modelo de origen por su título
                    const gameIndex = games.toVarArray().findIndex(g => g.title === lastGameTitle);

                    if (gameIndex >= 0) {
                        console.log("Juego encontrado en el índice:", gameIndex);

                        // Verifica si el índice en el modelo de origen coincide con el índice del juego encontrado
                        if (sourceIndex === gameIndex) {
                            // Si coinciden, establece el índice en el modelo proxy
                            gameAxis.currentIndex = proxyIndex;
                        } else {
                            // Si no coinciden, busca el nuevo índice en el modelo proxy
                            let newProxyIndex = -1;
                            for (let index = 0; index < gameAxis.model.count; ++index) {
                                if (gameAxis.model.mapToSource(index) === gameIndex) {
                                    newProxyIndex = index;
                                    break;
                                }
                            }

                            if (newProxyIndex >= 0) {
                                console.log("Nuevo índice del juego encontrado en el modelo proxy:", newProxyIndex);
                                gameAxis.currentIndex = newProxyIndex;
                            }
                        }
                        //Borra la colección y el juego lanzado de la memoria al cerrar pegasus frontend
                        //Solo comente con "//" las 2 lineas de codigo de abajo para evitar limpiar la memoria del tema.
                        api.memory.set('collection', '');
                        api.memory.set('game', '');
                    }
                }
            }
               
            // Cuadrícula de juegos en la colección actual
            PathView {
                // Propiedades generales de la cuadrícula de juegos
                id: gameAxis
                width: parent.width
                height: cellHeight
                anchors.bottom: parent.bottom

                // Modelo de juegos en la colección actual
                 //model: games
                    model: SortFilterProxyModel {
                        sourceModel: games // Esto se refiere al modelo original de juegos de la colección
                        sorters: RoleSorter { roleName: "favorite"; sortOrder: Qt.DescendingOrder }
                    }
                // Delegado para cada juego en la cuadrícula de juegos
                delegate: GameAxisCell {
                    // Propiedades del juego en el delegado de la cuadrícula de juegos
                    game: modelData
                    //gameAxisIndex: index
                    width: cellWidth
                    height: cellHeight
                }
                //Lógica para la navegación y control de la cuadrícula de juegos
                readonly property var currentGame: gameAxis.currentItem.game
                //readonly property var currentGame: games.get(currentIndex)
                readonly property int maxItemCount: 2 + Math.ceil(width / cellPaddedWidth)
                pathItemCount: Math.min(maxItemCount, model.count)

                // Lógica para la navegación y control de la cuadrícula de juegos
                property int fullPathWidth: pathItemCount * cellPaddedWidth
                path: Path {
                    startX: (gameAxis.model.count >= gameAxis.maxItemCount)
                        ? leftGuideline - cellPaddedWidth * 1.5
                        : leftGuideline + (cellPaddedWidth * 0.5  - cellSpacing * 0.5);
                    startY: cellHeight * 0.5
                    PathLine {
                        x: gameAxis.path.startX + gameAxis.fullPathWidth
                        y: gameAxis.path.startY
                    }
                }
                snapMode: PathView.SnapOneItem
                highlightRangeMode: PathView.StrictlyEnforceRange
                clip: true

                preferredHighlightBegin: (gameAxis.model.count >= gameAxis.maxItemCount)
                    ? (2 * cellPaddedWidth - cellSpacing / 2) / fullPathWidth
                    : 0;
                preferredHighlightEnd: preferredHighlightBegin
            }
        }
    }
    // Lógica para la inicialización del enfoque principal al completar
    Component.onCompleted: {
        // Lógica para restaurar el estado de la última colección seleccionada
        const lastCollectionName = api.memory.get('collection');

        if (lastCollectionName) {
            const collectionIndex = api.collections.toVarArray().findIndex(c => c.name === lastCollectionName);
            if (collectionIndex >= 0) {
                collectionAxis.currentIndex = collectionIndex;
            }
        }
    }
}
