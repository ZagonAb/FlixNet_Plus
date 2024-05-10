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
import SortFilterProxyModel 0.2
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12

FocusScope {
    focus: true
    readonly property real cellRatio: 7 / 10
    readonly property int cellHeight: vpx(216)
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(10)
    readonly property int cellPaddedWidth: cellWidth + cellSpacing
    readonly property int labelFontSize: vpx(18)
    readonly property int labelHeight: labelFontSize * 2.5
    readonly property int leftGuideline: vpx(100)
    ////////////////////////////////////////////
    property bool searchVisible: false
    property bool genereVisible: false
    readonly property int sidebarWidth: 60
    property bool navigatedDown: false
    property bool sidebarFocused: false
    property bool searchFocused: false
    property int selectedIndex: sidebarFocused ? 1 : -1
    property int virtualKeyboardIndex: 0
    property string currentText: ""
    property int maxIndex: 36
    property bool wrapAround: true
    property real iconAncho: 0.30
    property real iconAlto: 0.03
    property string selectedGenreName: ""
    
    onSidebarFocusedChanged: {
        if (!sidebarFocused) {
            selectedIndex = -1;
        } else {
            if (selectedIndex === -1) {            
                selectedIndex = 1;
            }
        }
    }

    FontLoader {
        id: mediumFontLoader
        source: "font/NetflixSansLight.ttf"
    }

    FontLoader {
        id: boldFontLoader
        source: "font/NetflixSansBold.ttf"
    }
       
    Rectangle {
        id: sidebar
        width: parent.width * 0.06 
        height: parent.height
        color: "transparent" 
        opacity: sidebarFocused ? 1 : 75
        z: sidebarFocused ? 101 : 99
        focus: sidebarFocused


        LinearGradient {
            width: sidebar.width * 2   
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

        Item {
            id: icoContainer
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: -5

            Image {
                id: homeIcon
                source: selectedIndex === 0 ? "assets/home.png" : "assets/home_inactive.png" 
                width: parent.width * iconAncho
                height: parent.height * iconAlto
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top 
                    topMargin: parent.height * 0.40 
                }
                Item {          
                    width: parent.width 
                    height: homeIcon.height 
                    y: homeIcon.height - 25
                    x: sidebarFocused ? homeIcon.width + 20 : 0

                    Text {
                        id: homeText
                        text: "Inicio"
                        font.pixelSize: sidebarFocused && selectedIndex === 0 ?  26 : 24
                        font.family: selectedIndex === 0 ? boldFontLoader.name : mediumFontLoader.name
                        color: selectedIndex === 0 ? "white" : "#8c8c8c"
                        visible: sidebarFocused
                    }

                    Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic  } } 
                    x: sidebarFocused ? homeIcon.width + 5 : 0 
                }
            }

            Image {
                id: searchIcon2
                source: selectedIndex === 1 ? "assets/search.png" : "assets/search_inactive.png" 
                width: parent.width * iconAncho
                height: parent.height * iconAlto
                anchors.centerIn: parent

                Item {
                    width: parent.width 
                    height: searchIcon2.height
                    y: searchIcon2.height -27
                    x: sidebarFocused ? categoryIcon.width + 20 : 0

                    Text {
                        id: searchText
                        text: "Búsqueda"
                        font.pixelSize: sidebarFocused && selectedIndex === 1 ? 26 : 24
                        font.family: selectedIndex === 1 ? boldFontLoader.name : mediumFontLoader.name
                        color: selectedIndex === 1 ? "white" : "#8c8c8c"
                        visible: sidebarFocused
                    }

                    Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }
                    x: sidebarFocused ? searchIcon2.width + 5 : 0 
                }
            }

            Image {
                id: categoryIcon
                source: selectedIndex === 2 ? "assets/plus.png" : "assets/plus_inactive.png" 
                width: parent.width * iconAncho
                height: parent.height * iconAlto
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.40 
                }

                Item {
                    width: parent.width
                    height: categoryIcon.height
                    y: categoryIcon.height -29
                    x: sidebarFocused ? categoryIcon.width + 20 : 0

                    Text {
                        id: categoryText
                        text: "Mi lista"
                        font.pixelSize: sidebarFocused && selectedIndex === 2 ? 26 : 24

                        font.family: selectedIndex === 2 ? boldFontLoader.name : mediumFontLoader.name
                        color: selectedIndex === 2 ? "white" : "#8c8c8c"
                        visible: sidebarFocused
                    }

                    Behavior on x { NumberAnimation { duration: 600; easing.type: Easing.InOutCubic } }
                    x: sidebarFocused ? categoryIcon.width + 5 : 0
                }
            }

            Image {
                id: trendingIcon
                source: selectedIndex === 3 ? "assets/Trending.png" : "assets/Trending_inactive.png" 
                width: parent.width * iconAncho 
                height: parent.height * iconAlto 
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.32
                }

                Item {
                    width: parent.width
                    height: trendingIcon.height
                    y: trendingIcon.height -27
                    x: sidebarFocused ? trendingIcon.width + 20 : 0

                    Text {
                        id: trendingText
                        text: "Recomendados"
                        font.pixelSize: sidebarFocused && selectedIndex === 3 ? 26 : 24
                        font.family: selectedIndex === 3 ? boldFontLoader.name : mediumFontLoader.name
                        color: selectedIndex === 3 ? "white" : "#8c8c8c"
                        visible: sidebarFocused
                    }

                    Behavior on x { NumberAnimation { duration: 700; easing.type: Easing.InOutCubic } }
                    x: sidebarFocused ? trendingIcon.width + 5 : 0
                }
            }

            Image {
                id: categoriagIcon
                source: selectedIndex === 4 ? "assets/categoria.png" : "assets/categoria_inactive.png" 
                width: parent.width * iconAncho 
                height: parent.height * iconAlto 
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.25
                }

                Item {
                    width: parent.width
                    height: categoriagIcon.height
                    y: categoriagIcon.height -27
                    x: sidebarFocused ? categoriagIcon.width + 20 : 0

                    Text {
                        id: categoriaText
                        text: "Categoria"
                        font.pixelSize: sidebarFocused && selectedIndex === 4 ? 26 : 24
                        font.family: selectedIndex === 4 ? boldFontLoader.name : mediumFontLoader.name
                        color: selectedIndex === 4 ? "white" : "#8c8c8c"
                        visible: sidebarFocused
                    }

                    Behavior on x { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic } }
                    x: sidebarFocused ? categoriagIcon.width + 5 : 0
                }
            }
        }

        Keys.onUpPressed: {
            selectedIndex = Math.max(selectedIndex - 1, 0)
        }

        Keys.onDownPressed: {
            selectedIndex = Math.min(selectedIndex + 1, 4) 
        }

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
                    sidebarFocused = false;
                    searchFocused = false; 
                    selectionMarker.opacity = 1.0;
                    collectionAxis.focus = true;
                    collectionAxis.currentIndex = 0;
                } else if (selectedIndex === 1) {
                    searchVisible = true;
                    sidebarFocused = false;
                    selectionMarker.opacity = 0.0;
                    virtualKeyboardContainer.visible = true;
                    virtualKeyboardContainer.focus = true;
                } else if (selectedIndex === 2) {
                    sidebarFocused = false;
                    searchFocused = false; 
                    selectionMarker.opacity = 1.0;
                    collectionAxis.focus = true;
                    if (favoritesProxyModel.count > 0) {
                        collectionAxis.currentIndex = collectionsListModel.favoritesIndex;
                    }
                } else if (selectedIndex === 3) {
                    sidebarFocused = false;
                    searchFocused = false; 
                    selectionMarker.opacity = 1.0;
                    collectionAxis.focus = true;
                    collectionAxis.currentIndex = 1;
                } else if (selectedIndex === 4) {
                    collectionAxis.focus = false;
                    sidebarFocused = false;
                    genereVisible = true;
                    genereListView.visible = true;
                    genereListView.focus = true;
                }
            } else if (!event.isAutoRepeat && api.keys.isCancel(event)) {
                event.accepted = true;
                sidebarFocused = false;
                searchFocused = false; 
                selectionMarker.opacity = 1.0;
                collectionAxis.focus = true;
                collectionAxis.currentIndex = Math.min(collectionAxis.currentIndex, collectionAxis.model.count - 1);
            }
        }
    }

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
        
        property bool hasResults: count > 0
    }

    Item {
        id: searchBarAndKeyboard
        width: parent.width
        height: parent.height 
        z: 100
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.04 

        Rectangle {
            width: parent.width * 0.20
            height: parent.height 
            color: "black" 
            visible: searchVisible

            Rectangle {
                id: buttonKeyContainer
                width: parent.width
                height: 35
                color: "#171717"
                border.color: "#171717"
                radius: 0
                border.width: 3
                visible: searchVisible
                y:45

                anchors {
                    bottom: virtualKeyboardContainer.top
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
                    radius:0
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
                        } else if (event.key === Qt.Key_Down) {
                            virtualKeyboardContainer.focus = true;
                            buttonKeyContainer.focus = false;
                            navigatedDown = false;
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

            Rectangle {
                id: virtualKeyboardContainer
                width: parent.width
                height: parent.height * 0.38 
                color: "#171717"
                border.color: "#171717"
                radius: 0
                border.width: 3

                anchors {
                    top:buttonKeyContainer.bottom
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
                                border.color: virtualKeyboardIndex === index && virtualKeyboardContainer.focus ? "white" : (virtualKeyboardContainer.focus ? "transparent" : "#171717")
                                border.width: 0.5
                                radius: 0

                                Item {
                                    anchors.fill: parent
                                    Text {
                                        anchors.centerIn: parent
                                        text: index < 26 ? String.fromCharCode(97 + index) : (index < 26 + 10 ? index - 26 : "")
                                        font.pixelSize: Math.min(keyboardGrid.width / keyboardGrid.columns, keyboardGrid.height / keyboardGrid.rows) * 0.5 // Tamaño del texto proporcional al tamaño de la celda
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
                        }   else if (virtualKeyboardIndex >= 0 && virtualKeyboardIndex <= 5) {
                            if (buttonKeyContainer.focus = true) {
                                navigatedDown = false;
                            }
                        }
                    } else if (event.key === Qt.Key_Down) {
                        if (virtualKeyboardIndex < (26 + 10) - 6) {
                            virtualKeyboardIndex += 6;
                        }  else if (event.key === Qt.Key_Down) {
                            if (virtualKeyboardIndex < (26 + 10) - 6) {
                                virtualKeyboardIndex += 6;
                            } else if (virtualKeyboardIndex >= 30 && virtualKeyboardIndex <= 35) {
                                if (searchResults.visible && resultsList.model.count > 0) {
                                    resultsList.focus = true;
                                    navigatedDown = true;
                                }
                            }
                        }
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (virtualKeyboardIndex < 26) {
                            searchInput.text += String.fromCharCode(65 + virtualKeyboardIndex);
                        } else {
                            searchInput.text += virtualKeyboardIndex - 26;
                        }
                    } else if (!event.isAutoRepeat && api.keys.isCancel(event)) {
                        event.accepted = true;
                        searchVisible = false;
                        sidebarFocused = true;
                    }
                }
            }

            Rectangle {
                id: historySearch
                width: parent.width
                height: parent.height * 0.48
                color: "transparent"
                border.color: "transparent"
                border.width: 5
                visible: searchVisible

                anchors {
                    top: virtualKeyboardContainer.bottom
                    left: parent.left
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
                    model: continuePlayingProxyModel 
                    clip: true

                    delegate: Rectangle {
                        width: parent ? parent.width : 0
                        height: 30
                        color: ListView.isCurrentItem && navigatedDown ? "red" : "transparent" 
                        border.color: ListView.isCurrentItem && navigatedDown ? "red" : "transparent"
                        border.width: ListView.isCurrentItem && navigatedDown ? 3 : 0 
                        radius: 5

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

                    Keys.onUpPressed: {
                        if (resultsList.currentIndex === 0) {
                            virtualKeyboardContainer.focus = true;
                            resultsList.focus = false;
                            navigatedDown = false;
                        } else {
                            resultsList.currentIndex--;
                        }
                    }

                    Keys.onPressed: {
                        if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                            var selectedGame = continuePlayingProxyModel.get(resultsList.currentIndex);
                            var selectedTitle = selectedGame.title;
                            var gamesArray = api.allGames.toVarArray();
                            var gameFound = gamesArray.find(function(game) {
                                return game.title === selectedTitle;
                            });
                            if (gameFound) {
                                sidebarFocused = false;
                                searchVisible = false;
                                searchFocused = false; 
                                selectionMarker.opacity = 1.0;
                                collectionAxis.focus = true;
                                gameFound.launch();
                            } else {
                            }
                        } else if (!event.isAutoRepeat && api.keys.isCancel(event)) {
                            event.accepted = true;
                            virtualKeyboardContainer.focus = true;
                            resultsList.focus = false;
                            navigatedDown = false;
                        }
                    }
                }
            }                

            Item {
                id: searchResultsContainer
                width: parent.width * 3.80
                height: parent.height 
                anchors.left: parent.right
                anchors.rightMargin: parent.width
                z: 100 
                
                Rectangle {
                    id: searchBarContainer
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    border.color: "transparent"
                    visible: searchVisible
                    
                    Rectangle {
                        id: searchBar
                        width: parent.width
                        height:60
                        color: "black"
                        border.width: 3
                        z: 100

                        Row {
                            anchors.fill: parent

                            Rectangle {
                                width: vpx(16)
                                height: parent.height
                                color: "transparent"
                            }
                            
                            Item {
                              width: vpx(7)
                              height: parent.height
                            }
                            
                            Image {
                                id: searchIcon
                                source: "assets/search.png"
                                width: vpx(16)
                                height: vpx(16)
                                y:35
                                visible: searchInput.text.trim().length > 0

                                Behavior on opacity {
                                    NumberAnimation { duration: 200 }
                                }
                            }

                            TextInput {
                                id: searchInput
                                visible: searchVisible
                                verticalAlignment: TextInput.AlignBottom
                                color: "white"
                                y: 28
                                leftPadding: + 10

                                FontLoader {
                                    id: netflixSansMedium
                                    source: "font/NetflixSansMedium.ttf"
                                }

                                font.family: netflixSansMedium.name
                                font.pixelSize: 26

                                onTextChanged: {
                                    gamesFiltered.searchTerm = searchInput.text.trim();
                                }
                            }

                            Text {
                                id: searchPlaceholder
                                text: "Juegos recomendados"
                                color: "white"
                                y: 28
                                font.family: netflixSansMedium.name
                                font.pixelSize: 24
                                visible: searchInput.length === 0

                                Behavior on opacity {
                                    NumberAnimation { duration: 50 }
                                }

                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
                //GridView
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "black"
                    y: 60

                    Rectangle {
                        id: searchResults
                        width: parent.width - 40
                        height: parent.height -50
                        color: "black"
                        border.width: 2
                        visible: searchVisible
                        z: 100
                        x:30
                        
                        GridView {
                            id: resultsGrid
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.horizontalCenter: parent.horizontalCenter 
                            anchors.verticalCenter: parent.verticalCenter
                            model: searchInput.text.trim() === "" ? gameListModel : gamesFiltered
                            cellWidth: (parent.width - 50) / 4
                            cellHeight: (parent.height -50) / 2.10
                            highlightRangeMode: GridView.StrictlyEnforceRange 
                            snapMode: GridView.SnapOneRow
                            clip: true

                            delegate: Item {

                                width: resultsGrid.cellWidth - 5
                                height: resultsGrid.cellHeight - 5
                                anchors {
                                    margins: -5
                                }

                                Image {
                                    id: gameImage
                                    source: model.assets.boxFront 
                                    anchors.centerIn: parent
                                    width: parent.width - 5
                                    height: parent.height - 5
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
                            
                            Rectangle {
                                id: selectionRectangle
                                width: resultsGrid.cellWidth - 5
                                height: resultsGrid.cellHeight - 5
                                color: "transparent"
                                border.color: resultsGrid.focus ? "white" : "transparent"
                                border.width: 2
                                visible: resultsGrid.currentIndex !== -1
                                Behavior on x { SmoothedAnimation { duration: 150 } }
                                Behavior on y { SmoothedAnimation { duration: 150 } }
                                x: (resultsGrid.currentItem ? resultsGrid.currentItem.x : 0) + resultsGrid.contentX
                            }
                            
                            Keys.onDownPressed: {
                                resultsGrid.moveCurrentIndexDown()
                            }

                            Keys.onUpPressed: {
                                resultsGrid.moveCurrentIndexUp()
                            }
                            
                            Keys.onRightPressed: {
                            resultsGrid.moveCurrentIndexRight()
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
                                    var selectedGame;
                                    var selectedTitle;
                                    var gameFound;
                                    
                                    if (searchInput.text.trim() !== "") {                                       
                                        selectedGame = gamesFiltered.get(resultsGrid.currentIndex);
                                        selectedTitle = selectedGame.title;

                                        var gamesArray = api.allGames.toVarArray();
                                        gameFound = gamesArray.find(function(game) {
                                            return game.title === selectedTitle;
                                        });
                                    } else {
                                        selectedGame = gameListModel.get(resultsGrid.currentIndex);
                                        selectedTitle = selectedGame.title;

                                        var gamesArray = api.allGames.toVarArray();
                                        gameFound = gamesArray.find(function(game) {
                                            return game.title === selectedTitle;
                                        });
                                    }

                                    if (gameFound) {
                                        sidebarFocused = false;
                                        searchVisible = false;
                                        searchFocused = false;
                                        selectionMarker.opacity = 1.0;
                                        collectionAxis.focus = true;
                                        gameFound.launch();
                                    } else {
                                    }
                                } else if (!event.isAutoRepeat && api.keys.isCancel(event)) {
                                        event.accepted = true;
                                        virtualKeyboardContainer.focus = true;
                                        virtualKeyboardIndex = 0
                                        resultsGrid.focus = false
                                        navigatedDown = false;
                                }
                            }

                            Rectangle {
                                width: resultsGrid.width
                                height: resultsGrid.height
                                color: "transparent"
                                visible: !gamesFiltered.hasResults  
                                
                                Text {
                                    text: "No hay coicidencias para tu búsqueda"
                                    color: "white"
                                    font.pixelSize: 26
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }
                }             
            }
        }
    }

    function updateImage(index) {
        var genresString = api.memory.get("genres");
        if (genresString) {
            try {
                var genresArray = JSON.parse(genresString);
                if (genresArray && genresArray.length > 0) {
                    var genreObject = genresArray.find(function(item) {
                        return item.index === index;
                    });

                    if (genreObject) {
                        var genre = genreObject.name;
                        var game = findGameWithGenre(genre);
                        if (game && game.assets.screenshots.length > 0) {
                            var screenshotPath = game.assets.screenshots[0];;
                            genreImage.source = screenshotPath;
                        } else {
                            genreImage.source = "";
                        }
                    } else {
                        genreImage.source = "";
                    }
                } else {
                    genreImage.source = "";
                }
            } catch (e) {
                genreImage.source = "";
            }
        } else {
            genreImage.source = "";
        }
    }

    function updateImageLogo(index) {
        var genresString = api.memory.get("genres");
        if (genresString) {
            try {
                var genresArray = JSON.parse(genresString);
                if (genresArray && genresArray.length > 0) {
                    var genreObject = genresArray.find(function(item) {
                        return item.index === index;
                    });

                    if (genreObject) {
                        var genre = genreObject.name;
                        var game = findGameWithGenre(genre);
                        if (game && game.assets.logo.length > 0) {
                            var logoPath = game.assets.logo;
                            whellImage.source = logoPath;
                        } else {
                            whellImage.source = "";
                        }
                    } else {
                        whellImage.source = "";
                    }
                } else {
                    whellImage.source = "";
                }
            } catch (e) {
                whellImage.source = "";
            }
        } else {
            whellImage.source = "";
        }
    }
    
    function findGameWithGenre(genre) {
        for (var i = 0; i < api.allGames.count; ++i) {
            var game = api.allGames.get(i);
            if (game.genreList.includes(genre)) {
                return game;
            }
        }
        return null; 
    }

    SortFilterProxyModel {
        id: genreFilteredModel
        sourceModel: api.allGames

        filters: [
            ExpressionFilter {
                id: customExpressionFilter
                enabled: selectedGenreName !== ""
                expression: (selectedGenreName !== "") && genreList.some(genre => genre === selectedGenreName)
            }
        ]
    }

    Rectangle {
        id: screenBackGround
        width: parent.width
        height: parent.height 
        color: "transparent" 
        x: parent.width * 0.05
        visible: genereVisible
        clip: true
        z: 100

        Image {
            id: genreImage
            source: ""
            width: parent.width * 1.05
            height: parent.height * 1.05
            visible: genereListView.currentIndex >= 0
            fillMode: Image.Stretch
            scale: 1.2

            SequentialAnimation on x {
                loops: Animation.Infinite
                PropertyAnimation {
                    from: 0 
                    to: parent.width - genreImage.width 
                    duration: 10000 
                }
                PropertyAnimation {
                    from: parent.width - genreImage.width
                    to: 0
                    duration: 10000
                }
            }
        }

        LinearGradient {
            width: genreImage.width
            height: height * 3.50
            anchors.bottom: genreImage.bottom
            anchors.right: genreImage.right
            start: Qt.point(0, height)
            end: Qt.point(0, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }

        LinearGradient {
            width: screenBackGround.width * 1
            height: screenBackGround.height
            anchors.left: screenBackGround.left
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }

        Image {
            id: whellImage
            source: ""
            visible: genereListView.currentIndex >= 0
            width: parent.width * 0.2 
            height: parent.height * 0.1 
            x: screenBackGround.x + screenBackGround.width * 0.75 - width * 0.5 
            y: rectangleGridView.y - height - parent.height * 0.05
            opacity: 0 
           
            onSourceChanged: {
                if (source !== "") {
                    whellImageOpacityAnimation.start();
                } else {
                    whellImageOpacityAnimation.direction = Animation.Backward;
                    whellImageOpacityAnimation.start();
                }
            }

            PropertyAnimation {
                id: whellImageOpacityAnimation
                target: whellImage
                property: "opacity"
                from: 0
                to: 1
                duration: 1000
                easing.type: Easing.OutQuad
            }
        }

        Image {
            anchors.fill: parent
            source: "assets/crt.png" 
            fillMode: Image.Tile
            visible: true
            opacity: 0.2 
        }

        Rectangle {
            id: rectangleGridView
            width: parent.width * 0.75 
            height: parent.height / 4 
            x: parent.width * 0.25 
            y: parent.height - rectangleGridView.height
            z: 100
            color: "transparent"

            GridView {
                id: gameGridView
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.horizontalCenter: parent.horizontalCenter 
                anchors.verticalCenter: parent.verticalCenter
                cellWidth: (parent.width - 100) / 6
                cellHeight: parent.height  / 1
                highlightRangeMode: GridView.StrictlyEnforceRange 
                snapMode: GridView.SnapOneRow
                clip: true
                model: genreFilteredModel
                
                delegate: Item {
                    width: gameGridView.cellWidth -5
                    height: gameGridView.cellHeight -5
                    
                    anchors {
                        margins: - 5
                    }

                    Image {
                        id: gameImage
                        source: model.assets.boxFront 
                        anchors.centerIn: parent
                        width: parent.width - 5
                        height: parent.height - 5
                        sourceSize { width: 456; height: 456 }
                        fillMode: Image.Stretch
                        z: 0
                    }
                }

                Rectangle {
                    id: selectionRectangle2
                    width: gameGridView.cellWidth - 5
                    height: gameGridView.cellHeight - 5
                    color: "transparent"
                    border.color: gameGridView.focus ? "white" : "transparent"
                    border.width: 2
                    visible: gameGridView.currentIndex !== -1
                    Behavior on x { SmoothedAnimation { duration: 150 } }
                    Behavior on y { SmoothedAnimation { duration: 150 } }

                    x: (gameGridView.currentItem ? gameGridView.currentItem.x : 0) + gameGridView.contentX
                }

                LinearGradient {
                    width: gameGridView.width
                    height: labelHeight * 3.50
                    anchors.bottom: gameGridView.bottom
                    anchors.right: gameGridView.right
                    start: Qt.point(0, height)
                    end: Qt.point(0, 0)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#FF000000" }
                        GradientStop { position: 1.0; color: "#00000000" }
                    }
                }

                Keys.onDownPressed: {
                    gameGridView.moveCurrentIndexDown()
                }

                Keys.onUpPressed: {
                    gameGridView.moveCurrentIndexUp()
                }
                
                Keys.onRightPressed: {
                gameGridView.moveCurrentIndexRight()
                }

                Keys.onLeftPressed: {
                    if (gameGridView.currentIndex === 0) {
                        genereListView.visible = true;
                        genereListView.focus = true;
                        genereListView.opacity = 1;
                    } else {
                        gameGridView.moveCurrentIndexLeft();
                    }
                }

                Keys.onPressed: {
                    if (api.keys.isCancel(event)) {
                        event.accepted = true;
                        genereListView.visible = true;
                        genereListView.focus = true;
                        genereListView.opacity = 1;
                    } else if (api.keys.isAccept(event)) {
                        event.accepted = true;
                        var selectedGameTitle = genreFilteredModel.get(gameGridView.currentIndex).title;
                        var foundGame = null;

                        for (var i = 0; i < api.allGames.count; i++) {
                            if (api.allGames.get(i).title === selectedGameTitle) {
                                foundGame = api.allGames.get(i);
                                break;
                            }
                        }

                        if (foundGame !== null) {
                            //console.log("Lanzando el juego:", selectedGameTitle);
                            foundGame.launch();
                        } else {
                            //console.log("Juego no encontrado en api.allGames.");
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rectangleListView
            width: screenBackGround.width / 4
            height: parent.height
            color: "transparent"
            clip: true
            visible: genereVisible
            z: 100

            LinearGradient {
                width: rectangleListView.width * 1
                height: rectangleListView.height
                anchors.left: rectangleListView.left
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FF000000" }
                    GradientStop { position: 1.0; color: "#00000000" }
                }
            }

            ListView {
                id: genereListView
                anchors.fill: parent
                spacing: 15
                
                property int indexToPosition: -1

                model: {
                    var genres = [];
                    for (var i = 0; i < api.allGames.count; ++i) {
                        var game = api.allGames.get(i);
                        for (var j = 0; j < game.genreList.length; ++j) {
                            var genre = game.genreList[j];
                            if (!genres.includes(genre)) {
                                genres.push(genre);
                            }
                        }
                    }
                    genres.sort();
                    return genres;
                }

                delegate: Item {
                    width: ListView.view.width
                    height: 50

                    Text {
                        text: modelData
                        anchors.fill: parent
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: genereListView.currentIndex === index ? "white" : "gray"
                        font.family: index === genereListView.currentIndex ? boldFontLoader.name : mediumFontLoader.name
                        font.bold: index === genereListView.currentIndex
                        font.pixelSize: genereListView.currentIndex === index ? 24 : 18
                        opacity: genereListView.currentIndex === index ? 1.0 : 0.5
                    }
                }
                    
                Keys.onLeftPressed: {
                    genereVisible = false;
                    sidebarFocused = true;
                    searchFocused = true; 
                }

                Keys.onRightPressed: {
                    genereListView.focus = false
                    gameGridView.focus = true
                    genereListView.opacity = 0.5;
                }

                Keys.onPressed: {
                    if (api.keys.isCancel(event)) {
                        event.accepted = true;
                        genereVisible = false;
                        sidebarFocused = true;
                        searchFocused = true; 
                    }
                }

                onCurrentItemChanged: {
                    indexToPosition = currentIndex
                    updateImage(currentIndex)
                    updateImageLogo(currentIndex)

                    var genresString = api.memory.get("genres");
                    if (genresString) {
                        try {
                            var genresArray = JSON.parse(genresString);
                            if (genresArray && genresArray.length > 0) {
                                var genreObject = genresArray.find(function(item) {
                                    return item.index === currentIndex;
                                });

                                if (genreObject) {
                                    selectedGenreName = genreObject.name;
                                } else {
                                }
                            }
                        } catch (e) {
                        }
                    } else {
                    }
                }

                Behavior on indexToPosition {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                onIndexToPositionChanged: {
                    if (indexToPosition >= 0) {
                        positionViewAtIndex(indexToPosition, ListView.Center)
                    }
                }
            }
        }

        Component.onCompleted: {
            var genresString = api.memory.get("genres");
            if (!genresString) {
                var genres = [];
                for (var i = 0; i < api.allGames.count; ++i) {
                    var game = api.allGames.get(i);
                    for (var j = 0; j < game.genreList.length; ++j) {
                        var genre = game.genreList[j];
                        if (!genres.includes(genre)) {
                            genres.push(genre);
                        }
                    }
                }
                genres.sort();
                const formattedGenres = genres.map((genre, index) => ({ index, name: genre }));
                genresString = JSON.stringify(formattedGenres);
                api.memory.set("genres", genresString);
            };

            if (genresString) {
                try {
                    var genresArray = JSON.parse(genresString);
                    if (genresArray && genresArray.length > 0) {
                        var firstGenreObject = genresArray[0];
                        if (firstGenreObject) {
                            selectedGenreName = firstGenreObject.name;
                        }
                    }
                } catch (e) {
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
            leftMargin: - 200
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

        opacity: virtualKeyboardContainer.focus ? 0.0 :  buttonKeyContainer.focus? 0.0 : resultsGrid.focus? 0.0 : sidebarFocused ? 0.5 : 1.0 
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
            bottomMargin: labelHeight - cellHeight + vpx(255)
        }
        color: "transparent"
        border { width: 3; color: "white" }
    }

    Item {
        id: collectionsItem
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
                var allCollection = { name: "Todos los juegos", shortName: "todoslosjuegos", games: gamesRandon };
                collectionsListModel.append(allCollection);

                var recommendedCollection = { name: "Juegos recomendados", shortName: "recomendados", games: gameListModel };
                collectionsListModel.append(recommendedCollection);

                var allCollection = { name: "Juega con Amigos: Diversión Multijugador Garantizada", shortName: "multijugador", games: multiplayer };
                collectionsListModel.append(allCollection);

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
            id: gamesFiltered4
            sourceModel: api.allGames
            sorters: RoleSorter {
                roleName: "players"
                sortOrder: Qt.AscendingOrder
            }
            filters: [
                ExpressionFilter {
                    expression: players > 1
                }
            ]
        }

        ListModel {
            id: gamesRandon

            function shuffle(array) {
                var currentIndex = array.length, temporaryValue, randomIndex;

                while (0 !== currentIndex) {

                    randomIndex = Math.floor(Math.random() * currentIndex);
                    currentIndex -= 1;

                    temporaryValue = array[currentIndex];
                    array[currentIndex] = array[randomIndex];
                    array[randomIndex] = temporaryValue;
                }

                return array;
            }

            Component.onCompleted: {
                var games = [];
                for (var i = 0; i < gamesFiltered2.count; ++i) {
                    games.push(gamesFiltered2.get(i));
                }
                // Mezclar los juegos
                games = shuffle(games);
                // Añadir los juegos mezclados al ListModel
                for (var j = 0; j < games.length; ++j) {
                    gamesRandon.append(games[j]);
                }
            }
        }

        ListModel {
            id: multiplayer

            function getRandomIndices(count) {
                var indices = [];
                for (var i = 0; i < count; ++i) {
                    indices.push(i);
                }
                indices.sort(function() { return 0.5 - Math.random() });
                return indices;
            }

            Component.onCompleted: {
                var maxGames = 10;
                var randomIndices = getRandomIndices(gamesFiltered4.count);
                for (var j = 0; j < maxGames && j < randomIndices.length; ++j) {
                    var gameIndex = randomIndices[j];
                    var game = gamesFiltered4.get(gameIndex);
                    multiplayer.append(game);
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

    PathView {
        id: collectionAxis
        property real collectionAxisOpacity: (searchVisible || genereVisible) ? 0.0 : 1
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
                    game.favorite = !game.favorite;
                    if (game.favorite) {
                    } else {
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
