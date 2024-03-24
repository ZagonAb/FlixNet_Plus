// Pegasus Frontend - Flixnet theme.
// Copyright (C) 2017  Mátyás Mustoha
// Author: Mátyás Mustoha - modified by Gonzalo Abbate for GNU/LINUX - WINDOWS
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
    readonly property real cellRatio: 10 / 16
    readonly property int cellHeight: vpx(255)
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(10)
    readonly property int cellPaddedWidth: cellWidth + cellSpacing
    readonly property int labelFontSize: vpx(18)
    readonly property int labelHeight: labelFontSize * 2.5
    readonly property int leftGuideline: vpx(100)
    ///////////////////////////////////////////
    property bool searchVisible: false
    readonly property int sidebarWidth: 60
    property bool navigatedDown: false
    property bool sidebarFocused: false
    property bool searchFocused: false
    property int selectedIndex: sidebarFocused ? 1 : -1
    property int virtualKeyboardIndex: 0
    
    onSidebarFocusedChanged: {
        if (!sidebarFocused) {
            selectedIndex = -1;
        } else {
            if (selectedIndex === -1) {            
                selectedIndex = 1;
            }
        }
    }
    //Barra lateral izquierda
    Rectangle {
        id: sidebar
        width: sidebarFocused ? 150 : 60
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
                GradientStop { position: 0.0; color: "#FF000000" } 
                GradientStop { position: 0.7; color: "#88000000" } 
                GradientStop { position: 1.0; color: "#00000000" } 
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
            width: 24 
            height: 20
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: parent.height * 0.4 
            }
        }

        Image {
            source: selectedIndex === 1 ? "assets/search.png" : "assets/search_inactive.png" 
            width: 24 
            height: 20 
            anchors.centerIn: parent

        }

        Image {
            source: selectedIndex === 2 ? "assets/plus.png" : "assets/plus_inactive.png" 
            width: 24 
            height: 24
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * 0.4 
            }
        }

        Image {
            source: selectedIndex === 3 ? "assets/Trending.png" : "assets/Trending_inactive.png" 
            width: 24 
            height: 20 
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * 0.32
            }
        }


        Keys.onUpPressed: {
            selectedIndex = Math.max(selectedIndex - 1, 0)
        }

        Keys.onDownPressed: {
            selectedIndex = Math.min(selectedIndex + 1, 3) 
        }

        // Lógica para enfocar/desenfocar la barra lateral
        Keys.onLeftPressed: {
            selectionMarker.opacity = 0.0;
            sidebarFocused = true;
            searchFocused = true; 
            collectionAxis.focus = false;
        }
        Keys.onRightPressed: {
            if (sidebarFocused) {
                sidebarFocused = false;
                searchFocused = false; 
                selectionMarker.opacity = 1.0;
                collectionAxis.focus = true;
                collectionAxis.currentIndex = Math.min(collectionAxis.currentIndex, collectionAxis.model.count - 1);
            }
        }

        Keys.onPressed: {
            if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                if (selectedIndex === 0) {
                    collectionAxis.currentIndex = 0
                } else if (selectedIndex === 1) {
                    searchVisible = true;
                    sidebarFocused = false;
                    selectionMarker.opacity = 0.0;
                    virtualKeyboardContainer.visible = true;
                    virtualKeyboardContainer.focus = true;
                } else if (selectedIndex === 2) {
                    if (favoritesProxyModel.count > 0) {
                        collectionAxis.currentIndex = collectionsListModel.favoritesIndex;
                    }
                } else if (selectedIndex === 3) {
                    collectionAxis.currentIndex = 1;
                }
            }
        }
    }

    //Filtrado de api.allGames
    SortFilterProxyModel {
        id: gamesFiltered
        sourceModel: api.allGames
        property string searchTerm: "" 
        
        filters: [
            RegExpFilter {
                roleName: "title"; 
                pattern: "^" + gamesFiltered.searchTerm.trim().replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&') + ".+";
                caseSensitivity: Qt.CaseInsensitive; 
                enabled: gamesFiltered.searchTerm !== "";
            }
        ]
    }

    //Barra de busqueda, teclado virtual y rectangulo de resultados        
    Item {
        id: searchBarAndKeyboard
        width: parent.width * 0.20
        height: parent.height 
        z: 100
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.04 

        Rectangle {
            width: parent.width 
            height: parent.height 
            color: "transparent" 
            visible: searchVisible
            
            // Barra de búsqueda
            Rectangle {
                id: searchBar
                width: parent.width
                height: 50
                color: "#1f1f1f"
                radius: 15
                border.width: 3
                z: 100

                Row {
                    anchors.fill: parent

                    Rectangle {
                        width: vpx(16)
                        height: parent.height
                        color: "transparent"
                    }

                    Image {
                        id: searchIcon
                        source: "assets/search_inactive.png"
                        width: vpx(18)
                        height: vpx(18)
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: searchInput.text.trim().length > 0 ? 0.2 : 1
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    TextInput {
                        id: searchInput
                        visible: searchVisible
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                        FontLoader {
                            id: netflixSansBold
                            source: "font/NetflixSansBold.ttf"
                        }
                        font.family: netflixSansBold.name
                        font.pixelSize: 24
                        leftPadding: vpx(10)
                        rightPadding: vpx(10)
                        anchors.verticalCenter: parent.verticalCenter
                        onTextChanged: {
                            // Lógica de búsqueda
                            gamesFiltered.searchTerm = searchInput.text.trim();
                            //searchResults.visible = searchInput.text.trim() !== ""; // Mostrar resultados solo si hay texto en la búsqueda
                        }
                    }

                    Text {
                        id: searchPlaceholder
                        text: "Buscar el juego..."
                        color: "#8c8c8c"
                        font.family: netflixSansBold.name
                        font.pixelSize: 24
                        anchors.centerIn: parent.horizontal
                        anchors.verticalCenter: searchIcon.verticalCenter
                        anchors.leftMargin: vpx(10)
                        anchors.rightMargin: vpx(10)
                        visible: searchInput.length === 0
                        opacity: searchInput.length > 0 ? 0 : 0.7
                        Behavior on opacity {
                            NumberAnimation { duration: 50 }
                        }
                        wrapMode: Text.Wrap
                    }
                }
            }

            //Teclado virtual
            Rectangle {
                id: virtualKeyboardContainer
                width: parent.width
                height: parent.height * 0.38 //300
                color: "#1f1f1f"
                border.color: "#1f1f1f"
                radius: 0
                border.width: 3
                anchors {
                    top: searchBar.bottom
                    left: parent.left
                }
                focus: searchVisible
                z: 100  

                Column {
                    anchors.fill: parent
                    spacing: 5

                    Rectangle {
                        width: (parent.width - (6 * 40 + 5 * 5)) / 2
                        height: 1
                        color: "transparent"
                    }

                    GridLayout {
                        id: keyboardGrid
                        columns: 6
                        rows: 6
                        anchors.horizontalCenter: parent.horizontalCenter
                        columnSpacing: (parent.width - (6 * 40)) / 7
                        rowSpacing: (parent.height - (6 * 40)) / 7
                         
                        Repeater {
                            model: 26 + 10
                            Rectangle {
                                width: 40
                                height: 40
                                clip: true
                                color: "transparent"
                                border.color: virtualKeyboardIndex === index && virtualKeyboardContainer.focus ? "#d9d9d9" : (virtualKeyboardContainer.focus ? "transparent" : "#1f1f1f")
                                border.width: 2
                                radius: 7

                                Item {
                                    anchors.fill: parent
                                    Text {
                                        anchors.centerIn: parent
                                        text: index < 26 ? String.fromCharCode(97 + index) : (index < 26 + 10 ? index - 26 : "")
                                        font.pixelSize: 20
                                        color: "grey"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }

                Keys.onPressed: {
                    if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                        if (virtualKeyboardIndex < 26) {
                            searchInput.text += String.fromCharCode(97 + virtualKeyboardIndex);
                        } else {
                            searchInput.text += virtualKeyboardIndex - 26;
                        }
                    } else if (event.key === Qt.Key_Left && virtualKeyboardIndex === 0) {
                        searchVisible = false;
                        sidebarFocused = true;
                    } else if (event.key === Qt.Key_Left) {
                        if (virtualKeyboardIndex > 0 ){
                            virtualKeyboardIndex--;
                            if (virtualKeyboardIndex === 5 || virtualKeyboardIndex === 11 || virtualKeyboardIndex === 17 || virtualKeyboardIndex === 23 || virtualKeyboardIndex === 29 || virtualKeyboardIndex === 35 || virtualKeyboardIndex === 41) {
                                searchVisible = false;
                                sidebarFocused = true;
                                
                            }
                        }
                    } else if (event.key === Qt.Key_Right) {
                        if (virtualKeyboardIndex < (26 + 12) - 1) {
                            virtualKeyboardIndex++;
                            if (virtualKeyboardIndex === 6 || virtualKeyboardIndex === 12 || virtualKeyboardIndex === 18 || virtualKeyboardIndex === 24 || virtualKeyboardIndex === 30 || virtualKeyboardIndex === 36) {
                                searchResults.visible 
                                resultsGrid.focus = true;
                                //navigatedDown = true;
                            }
                        }
                    } else if (event.key === Qt.Key_Up) {
                        if (virtualKeyboardIndex >= 6) {
                            virtualKeyboardIndex -= 6;
                        }
                    } else if (event.key === Qt.Key_Down) {
                        if (virtualKeyboardIndex < (26 + 10) - 6) {
                            virtualKeyboardIndex += 6;
                        } else if (virtualKeyboardIndex >= 30 && virtualKeyboardIndex <= 35) {
                            if (buttonKeyContainer.focus = true) {
                                navigatedDown = false;
                            }
                        }
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (virtualKeyboardIndex < 26) {
                            searchInput.text += String.fromCharCode(65 + virtualKeyboardIndex);
                        } else {
                            searchInput.text += virtualKeyboardIndex - 26;
                        }
                    }
                }
            }

            //botones con iconos
            Rectangle {
                id: buttonKeyContainer
                width: parent.width
                height: 35
                color: "#1f1f1f"
                border.color: "#1f1f1f"
                radius: 0
                border.width: 3
                visible: searchVisible
                anchors {
                    top: virtualKeyboardContainer.bottom
                    left: parent.left
                }
                property int selectedIndex: 0

                Row {
                    width: parent.width
                    height: parent.height
                    spacing: 0

                    Repeater {
                        model: 3
                        Image {
                            width: buttonKeyContainer.width / 3
                            height: parent.height
                            source: index === 0 ? "assets/del.png" : (index === 1 ? "assets/espacio.png" : (index === 2 ? "assets/sidebar.png" : ""))
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Rectangle {
                    id: selectorRectangle
                    width: buttonKeyContainer.width / 3
                    height: 35
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                    visible: buttonKeyContainer.focus
                    clip: true
                    radius: 7
                }

                Keys.onPressed: {
                    if (!event.isAutoRepeat) {
                        if (event.key === Qt.Key_Left) {
                            if (buttonKeyContainer.selectedIndex > 0) {
                                buttonKeyContainer.selectedIndex--;
                                selectorRectangle.x -= buttonKeyContainer.width / 3;
                            }
                        } else if (event.key === Qt.Key_Right) {
                            if (buttonKeyContainer.selectedIndex < 2) {
                                buttonKeyContainer.selectedIndex++;
                                selectorRectangle.x += buttonKeyContainer.width / 3;
                            }
                        } else if (event.key === Qt.Key_Up) {
                            virtualKeyboardContainer.focus = true;
                            buttonKeyContainer.focus = false;
                            navigatedDown = false;
                        } else if (event.key === Qt.Key_Down) {
                            if (buttonKeyContainer.selectedIndex >= 0 && buttonKeyContainer.selectedIndex <= 2) {
                                if (searchResults.visible) {
                                    resultsList.focus = true;
                                    navigatedDown = true;
                                }
                            }
                        } else if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                            if (buttonKeyContainer.selectedIndex === 0) {
                                searchInput.text = searchInput.text.slice(0, -1);
                            } else if (buttonKeyContainer.selectedIndex === 1) {
                                searchInput.text += " ";
                            } else if (buttonKeyContainer.selectedIndex === 2) {
                                searchVisible = false;
                                sidebarFocused = true;
                            }
                        }
                    }
                }
            }
            //Historial de juegos lanzados
            Rectangle {
                id: historySearch
                width: parent.width
                height: parent.height * 0.48
                color: "transparent"
                border.color: "transparent"
                border.width: 5
                visible: searchVisible
                anchors {
                    top: buttonKeyContainer.bottom
                    left: parent.left
                }

                SortFilterProxyModel {
                    id: lastPlayedList
                    sourceModel: api.allGames
                    sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
                }

                Rectangle {
                    id: recentGames
                    width: parent.width
                    height: 40
                    color: "transparent"
                    visible: searchVisible

                    Text {
                        text: "Juegos recién lanzados"
                        font.bold: true
                        color: "white"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter 
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent 
                    }
                }

                ListView {
                    id: resultsList
                    width: parent.width
                    height: parent.height - recentGames.height
                    anchors.top: recentGames.bottom 
                    model: lastPlayedList
                    clip: true

                    delegate: Rectangle {
                        width: parent ? parent.width : 0
                        height: 30
                        color: ListView.isCurrentItem && navigatedDown ? "red" : "transparent" 
                        border.color: ListView.isCurrentItem && navigatedDown ? "red" : "transparent"
                        border.width: ListView.isCurrentItem && navigatedDown ? 3 : 0 
                        radius: 7
                        FontLoader {
                          id: netflixSansBold
                          source: "font/NetflixSansBold.ttf"
                        }
                        Text {
                            anchors.fill: parent
                            text: model.title !== undefined ? model.title : "Title not available"
                            font.family: netflixSansBold.name
                            font.pixelSize: 18
                            verticalAlignment: Text.AlignVCenter
                            padding: 5 
                            color: "white"
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }
                    }

                    // Manejar evento de tecla para mover el foco hacia arriba
                    Keys.onUpPressed: {
                        if (resultsList.currentIndex === 0) {
                            buttonKeyContainer.focus = true;
                            navigatedDown = false;
                        } else {
                            resultsList.currentIndex--;
                        }
                    }

                    // Manejar evento de tecla para lanzar el juego seleccionado
                    Keys.onPressed: {
                        if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                            var selectedGame = lastPlayedList.get(resultsList.currentIndex);
                            var selectedTitle = selectedGame.title;
                            var gamesArray = api.allGames.toVarArray();
                            var gameFound = gamesArray.find(function(game) {
                                return game.title === selectedTitle;
                            });
                            // Verificar si se encontró el juego
                            if (gameFound) {
                                console.log("Se lanzará el juego seleccionado:", gameFound.title);
                                sidebarFocused = false;
                                searchVisible = false;
                                searchFocused = false; 
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
        //Resultado de busqueda
        Item {
            id: searchResultsContainer
            width: parent.width * 3.80
            height: parent.height
            z: 100
            anchors.left: parent.right
            anchors.rightMargin: parent.width
            Rectangle {
                id: searchResults
                width: parent.width
                height: parent.height 
                color: "black"
                //radius: 7
                border.width: 2
                visible: searchVisible
                z: 100 
                    
                GridView {
                    id: resultsGrid
                    width: parent.width - 10
                    height: parent.height - 10
                    anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter 
                    anchors.verticalCenter: parent.verticalCenter
                    cellWidth: (parent.width - 10) / 4
                    cellHeight: resultsGrid.width / 2.95
                    model: gamesFiltered
                    clip: true
                    delegate: Item {
                        width: resultsGrid.cellWidth - 5
                        height: resultsGrid.cellHeight - 5
                        anchors {
                            margins: 5
                        }

                        Rectangle {
                            width: parent.width - 3
                            height: parent.height - 3
                            color: "transparent"
                            border.color: resultsGrid.currentIndex === index && resultsGrid.focus ? "white" : (resultsGrid.focus ? "transparent" : "black")
                            border.width: resultsGrid.currentIndex === index ? 5 : 0
                            radius: 7
                            z: 1 
                        }

                        Image {
                            id: gameImage
                            source: model.assets.boxFront 
                            anchors.centerIn: parent
                            width: parent.width - 10
                            height: parent.height - 10
                            sourceSize { width: 456; height: 456 }
                            fillMode: Image.Stretch
                            z: 0
                        }

                        FontLoader {
                            id: netflixSansBold
                            source: "font/NetflixSansBold.ttf"
                        }

                        Item {
                            width: parent.width
                            height: parent.height

                            Text {
                                anchors.fill: parent
                                text: model.title !== undefined ? model.title : "Title not available"
                                font.family: netflixSansBold.name
                                font.pixelSize: 18
                                verticalAlignment: Text.AlignBottom
                                padding: 5
                                color: "white"
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                clip: true
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "black"
                                    radius: 3
                                    samples: 16
                                    spread: 0.5
                                }
                            }
                        }
                    }

                    Keys.onUpPressed: {
                        if (resultsGrid.currentIndex < 4) {
                        } else {
                            resultsGrid.currentIndex -= 4;
                        }
                    }

                    Keys.onDownPressed: {
                        if (resultsGrid.currentIndex >= (resultsGrid.count - 4)) {
                        } else {
                            resultsGrid.currentIndex += 4;
                        }
                    }

                    Keys.onLeftPressed: {
                        if (resultsGrid.currentIndex % 4 === 0) {
                            virtualKeyboardContainer.focus = true;
                            virtualKeyboardIndex = 0
                            resultsGrid.focus = false
                            navigatedDown = false;
                        } else {
                            resultsGrid.currentIndex--;
                        }
                    }

                    Keys.onPressed: {
                        if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                            var selectedGame = gamesFiltered.get(resultsGrid.currentIndex);
                            var selectedTitle = selectedGame.title;

                            var gamesArray = api.allGames.toVarArray();
                            var gameFound = gamesArray.find(function(game) {
                                return game.title === selectedTitle;
                            });

                            if (gameFound) {
                                console.log("Se lanzará el juego seleccionado:", gameFound.title);
                                sidebarFocused = false;
                                searchVisible = false;
                                searchFocused = false;
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
            property bool favoritesAvailable: false

            Component.onCompleted: {
                var allCollection = { name: "Todos los juegos", shortName: "todoslosjuegos", games: api.allGames };
                collectionsListModel.append(allCollection);

                var recommendedCollection = { name: "Juegos recomendados", shortName: "recomendados", games: gameListModel };
                collectionsListModel.append(recommendedCollection);

                if (favoritesProxyModel.count > 0) {
                    var favoritesCollection = { name: "Mi lista", shortName: "milista", games: favoritesProxyModel };
                    collectionsListModel.append(favoritesCollection);
                    collectionsListModel.favoritesIndex = collectionsListModel.count - 1;
                    collectionsListModel.favoritesAvailable = true;
                }

                if (continuePlayingProxyModel.count > 0) {
                    var continuePlayingCollection = { name: "Seguir jugando", shortName: "seguirjugando", games: continuePlayingProxyModel };
                    collectionsListModel.append(continuePlayingCollection);
                    collectionsListModel.continuePlayingIndex = collectionsListModel.count - 1;
                }

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
                var sevenDaysAgo = new Date(currentDate.getTime() - 7 * 24 * 60 * 60 * 1000)
                for (var i = 0; i < filteredGames1.count; ++i) {
                    var game = filteredGames1.get(i)
                    var lastPlayedDate = new Date(game.lastPlayed)
                    var playTimeInMinutes = game.playTime / 60
                    if (lastPlayedDate >= sevenDaysAgo && playTimeInMinutes > 1) {
                        continuePlayingProxyModel.append(game)
                    }
                }

                if (count === 0 && collectionsListModel.continuePlayingIndex !== -1) {
                    collectionsListModel.remove(collectionsListModel.continuePlayingIndex, 1);
                    collectionsListModel.continuePlayingIndex = -1;
                } else if (count > 0 && collectionsListModel.continuePlayingIndex === -1) {
                    var allIndex = collectionsListModel.allIndex;
                    var continuePlayingIndex = -1;
                    for (var i = 0; i < collectionsListModel.count; ++i) {
                        if (collectionsListModel.get(i).shortName === "recomendados") {
                            continuePlayingIndex = i + 1;
                            break;
                        }
                    }
                    if (continuePlayingIndex !== -1) {
                        var continuePlayingCollection = { name: "Continuar jugando", shortName: "continuarjugando", games: continuePlayingProxyModel };
                        collectionsListModel.insert(continuePlayingIndex, continuePlayingCollection);
                        collectionsListModel.continuePlayingIndex = continuePlayingIndex;
                    }
                }
            }
        }

        SortFilterProxyModel {
            id: favoritesProxyModel
            sourceModel: api.allGames
            filters: ValueFilter { roleName: "favorite"; value: true }
            onCountChanged: {
                if (count === 0 && collectionsListModel.favoritesIndex !== -1) {
                    collectionsListModel.remove(collectionsListModel.favoritesIndex, 1);
                    collectionsListModel.favoritesIndex = -1;
                } else if (count > 0 && collectionsListModel.favoritesIndex === -1) {
                    var allIndex = collectionsListModel.allIndex;
                    var favoritesIndex = -1;
                    for (var i = 0; i < collectionsListModel.count; ++i) {
                        if (collectionsListModel.get(i).shortName === "recomendados") {
                            favoritesIndex = i + 1;
                            break;
                        }
                    }
                    if (favoritesIndex !== -1) {
                        var favoritesCollection = { name: "Mi lista", shortName: "milista", games: favoritesProxyModel };
                        collectionsListModel.insert(favoritesIndex, favoritesCollection);
                        collectionsListModel.favoritesIndex = favoritesIndex;
                    }
                }
            }
        }
    }

    Video {
        game: collectionAxis.currentItem ? collectionAxis.currentItem.currentGame : null
        anchors {
            top: parent.top
            left: parent.horizontalCenter
            right: parent.right
            bottom: selectionMarker.top
            bottomMargin: -5
            leftMargin: -150
        }
    }

    Details {
        id: detailsID
        game: collectionAxis.currentItem ? collectionAxis.currentItem.currentGame : null
        anchors {
            top: parent.top
            left: parent.left; leftMargin: leftGuideline
            bottom: collectionAxis.top; bottomMargin: labelHeight * 0.63
            right: parent.horizontalCenter
        }
        opacity: virtualKeyboardContainer.focus ? 0.5 :  buttonKeyContainer.focus? 0.5 : resultsGrid.focus? 0.5 : sidebarFocused ? 0.5 : 1.0 
    }

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
        id: collectionAxis
        property real collectionAxisOpacity: searchVisible ? 0.07 : 1.0
        width: parent.width
        height: 1.3 * (labelHeight + cellHeight) + vpx(5)
        anchors.bottom: parent.bottom
        model: collectionsListModel
        delegate: collectionAxisDelegate

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
        snapMode: PathView.SnapOneItem
        highlightRangeMode: PathView.StrictlyEnforceRange
        movementDirection: PathView.Positive
        clip: true
        preferredHighlightBegin: 1 / 4
        preferredHighlightEnd: preferredHighlightBegin
        focus: true
        Keys.onUpPressed: decrementCurrentIndex()
        Keys.onDownPressed: incrementCurrentIndex()

        Keys.onLeftPressed: {
            if (currentItem.axis.currentIndex === 0) {
                selectionMarker.opacity = 0.0;
                sidebarFocused = true;
                searchFocused = true;
                collectionAxis.focus = false;
            } else {
                if (currentItem.axis.currentIndex > 0) {
                    currentItem.axis.decrementCurrentIndex()
                }
            }
        }

        Keys.onRightPressed: {
            if (sidebarFocused) {
                selectionMarker.opacity = 1.0;
                sidebarFocused = false
                searchFocused = false
                collectionAxis.focus = true
                collectionAxis.currentIndex = Math.min(collectionAxis.currentIndex, collectionAxis.model.count - 1)
            } else {
                if (currentItem.axis.currentIndex < currentItem.axis.model.count - 1) {
                    currentItem.axis.incrementCurrentIndex()
                }
            }
        }

        Keys.onPressed: {
            if (!event.isAutoRepeat) {
                if (api.keys.isDetails(event)) {
                    var game = currentItem.currentGame;
                    console.log("Juego actual:", game.title);
                    game.favorite = !game.favorite;
                    if (game.favorite) {
                        console.log("Juego marcado como favorito:", game.title);
                    } else {
                        console.log("Juego desmarcado como favorito:", game.title);
                    }
                } else if (api.keys.isAccept(event)) {
                    var game = currentItem.currentGame;
                    api.memory.set('collection', currentItem.name);
                    api.memory.set('game', currentItem.currentGame.title);
                    game.launch();
                }
            }
        }
        opacity: collectionAxisOpacity
    }
    // Componente para el delegado de la cuadrícula de colecciones
    // Define cómo se muestra cada fila de la cuadrícula de colecciones
    Component {
        id: collectionAxisDelegate
        Item {
            property alias axis: gameAxis
            readonly property var currentGame: axis.currentItem ? axis.currentItem.game : null
            property string name: model.name
            width: PathView.view.width
            height: labelHeight + cellHeight
            visible: PathView.onPath
            opacity: sidebarFocused ? 0.2 : (PathView.isCurrentItem ? 1.0 : 0.5)
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Text {
                textFormat: Text.RichText
                height: labelHeight
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: leftGuideline
                color: "white"
                font {
                    pixelSize: labelFontSize
                    family: globalFonts.sans
                    bold: true
                    capitalization: name ? Font.MixedCase : Font.AllUppercase
                }

                FontLoader {
                    id: netflixsansbold
                    source: "font/NetflixSansBold.ttf"
                }

                Row {
                    id: imageContainer
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: collectionName
                        text: name === "todoslosjuegos" ? "Todos los juegos" :
                              name === "milista" ? "Mi lista" :
                              name === "continuarjugando" ? "Continuar jugando" :
                              name
                        color: "white"
                        font.family: netflixsansbold.name
                        font.pixelSize: vpx(15)
                    }

                    Text {
                        id: gameCount
                        text: " | " + (gameAxis.currentIndex + 1) + "/" + (games ? games.count : 0) + "  "
                        color: "grey"
                        font.family: netflixsansbold.name
                        font.pixelSize: vpx(15)
                    }

                    Image {
                        id: favoriteYesImage
                        source: "assets/favoriteyes.png"
                        width: parent.height * 0.9
                        height: parent.height * 0.9
                    }

                    Text {
                        text: "  Mi lista   "
                        color: "white"
                        font.family: netflixsansbold.name
                        font.pixelSize: vpx(15)
                    }

                    Image {
                        id: favoriteImage
                        source: gameAxis.currentItem.game.favorite ? "assets/check.png" : "assets/plus.png"
                        width: parent.height * 0.9
                        height: parent.height * 0.9
                        rotation: gameAxis.currentItem.game.favorite ? 360 : 0
                        Behavior on rotation { RotationAnimation { duration: 400 } }
                    }
                }
            }

            PathView {
                id: gameAxis
                width: parent.width
                height: cellHeight
                anchors.bottom: parent.bottom
                model: games

                delegate: GameAxisCell {
                    game: modelData
                    width: cellWidth
                    height: cellHeight
                }

                readonly property var currentGame: gameAxis.currentItem ? gameAxis.currentItem.game : null
                readonly property int maxItemCount: 2 + Math.ceil(width / cellPaddedWidth)
                pathItemCount: Math.min(maxItemCount, model ? model.count : 0)

                property int fullPathWidth: pathItemCount * cellPaddedWidth
                path: Path {
                    startX: (gameAxis.model ? gameAxis.model.count >= gameAxis.maxItemCount : false)
                        ? leftGuideline - cellPaddedWidth * 1.5
                        : leftGuideline + (cellPaddedWidth * 0.5 - cellSpacing * 0.5);
                    startY: cellHeight * 0.5
                    PathLine {
                        x: gameAxis.path.startX + gameAxis.fullPathWidth
                        y: gameAxis.path.startY
                    }
                }

                snapMode: PathView.SnapOneItem
                highlightRangeMode: PathView.StrictlyEnforceRange
                clip: true
                preferredHighlightBegin: (gameAxis.model ? gameAxis.model.count >= gameAxis.maxItemCount : false)
                    ? (2 * cellPaddedWidth - cellSpacing / 2) / fullPathWidth
                    : 0;
                preferredHighlightEnd: preferredHighlightBegin
            }
        }
    }
}
