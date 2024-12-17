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
    id: root
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

    onSidebarFocusedChanged: {
        if (!sidebarFocused) {
            selectedIndex = -1;
        } else {
            if (selectedIndex === -1) {
                selectedIndex = 1;
            }
        }
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

        Column {
            id: iconContainer
            spacing: 15
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: sidebarFocused ? 20 : 10

            Repeater {

                model: ListModel {
                    ListElement { name: "Search"; icon: "assets/search.png"; iconInactive: "assets/search_inactive.png" }
                    ListElement { name: "Home"; icon: "assets/home.png"; iconInactive: "assets/home_inactive.png" }
                    ListElement { name: "Recommended"; icon: "assets/trending.png"; iconInactive: "assets/trending_inactive.png" }
                    ListElement { name: "Categories"; icon: "assets/category.png"; iconInactive: "assets/category_inactive.png" }
                    ListElement { name: "My list"; icon: "assets/plus.png"; iconInactive: "assets/plus_inactive.png" }
                    ListElement { name: "Play something"; icon: "assets/play_something.svg"; iconInactive: "assets/play_something_inactive.svg" }
                }

                delegate: Row {
                    spacing: 10
                    width: sidebar.width
                    height: sidebar.height * 0.08

                    Image {
                        id: menuIcon
                        source: index === selectedIndex ? model.icon : model.iconInactive
                        width: root.width * 0.020
                        height: root.height * 0.032
                        anchors.verticalCenter: parent.verticalCenter
                        mipmap: true
                    }

                    Text {
                        id: menuText
                        text: model.name
                        font.pixelSize: sidebarFocused && index === selectedIndex
                        ? Math.round(root.width * 0.020)
                        : Math.round(root.width * 0.016)

                        font.bold: index === selectedIndex
                        color: index === selectedIndex ? "white" : "#8c8c8c"
                        visible: sidebarFocused
                        anchors.verticalCenter: parent.verticalCenter

                        x: sidebarFocused ? menuIcon.width + 10 : menuIcon.width - 20
                        Behavior on x {
                            NumberAnimation {
                                duration: (index + 1) * 100
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }
                }
            }
        }

        Keys.onUpPressed: {
            selectedIndex = Math.max(selectedIndex - 1, 0)
        }

        Keys.onDownPressed: {
            selectedIndex = Math.min(selectedIndex + 1, 5)
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
                if (selectedIndex === 1) {
                    sidebarFocused = false;
                    searchFocused = false;
                    selectionMarker.opacity = 1.0;
                    collectionAxis.focus = true;
                    collectionAxis.currentIndex = 0;
                } else if (selectedIndex === 0) {
                    searchVisible = true;
                    sidebarFocused = false;
                    selectionMarker.opacity = 0.0;
                    virtualKeyboardContainer.visible = true;
                    virtualKeyboardContainer.focus = true;
                } else if (selectedIndex === 4) {
                    sidebarFocused = false;
                    searchFocused = false;
                    selectionMarker.opacity = 1.0;
                    collectionAxis.focus = true;
                    if (favoritesProxyModel.count > 0) {
                        collectionAxis.currentIndex = collectionsListModel.favoritesIndex;
                    }
                } else if (selectedIndex === 2) {
                    sidebarFocused = false;
                    searchFocused = false;
                    selectionMarker.opacity = 1.0;
                    collectionAxis.focus = true;
                    collectionAxis.currentIndex = 1;
                } else if (selectedIndex === 3) {
                    collectionAxis.focus = false;
                    sidebarFocused = false;
                    genereVisible = true;
                    genereListView.visible = true;
                    genereListView.focus = true;
                } else if (selectedIndex === 5) {
                    if (api.allGames.count > 0) {
                        var randomIndex = Math.floor(Math.random() * api.allGames.count);
                        var randomGame = api.allGames.get(randomIndex);
                        randomGame.launch();
                    }
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

    FontLoader {
        id: mediumFontLoader
        source: "font/NetflixSansLight.ttf"
    }

    FontLoader {
        id: boldFontLoader
        source: "font/NetflixSansBold.ttf"
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
            id: conteiner
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
                            source: index === 0 ? "assets/del.svg" : (index === 1 ? "assets/spacebar.svg" : (index === 2 ? "assets/sidebar.svg" : ""))
                            fillMode: Image.PreserveAspectFit
                            sourceSize { width: 156; height: 156 }
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
                                        font.pixelSize: Math.min(keyboardGrid.width / keyboardGrid.columns, keyboardGrid.height / keyboardGrid.rows) * 0.5
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
                        text: "Newly released games"
                        font.bold: true
                        color: "white"
                        font.pixelSize: conteiner.width * 0.07  //20
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

                        RowLayout {
                            //anchors.fill: parent
                            width: parent.width * 0.8
                            anchors.centerIn: parent
                            spacing: 2

                            Text {
                                id: titleText
                                text: model.title !== undefined ? model.title : ""
                                font.family: netflixSansBold.name
                                font.pixelSize: conteiner.width * 0.05
                                color: "white"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                //verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                text: model.collections && model.collections.count > 0
                                ? "(" + model.collections.get(0).shortName + ")" : ""
                                font.family: netflixSansBold.name
                                font.pixelSize: conteiner.width * 0.04
                                color: "white"
                                elide: Text.ElideRight
                                Layout.alignment: Qt.AlignRight
                                //verticalAlignment: Text.AlignVCenter
                            }
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
                            let selectedGame = continuePlayingProxyModel.get(resultsList.currentIndex);

                            if (selectedGame) {
                                let collectionFound = false;
                                for (let i = 0; i < api.collections.count; i++) {
                                    const collection = api.collections.get(i);

                                    for (let j = 0; j < collection.games.count; j++) {
                                        const game = collection.games.get(j);
                                        if (game.title === selectedGame.title &&
                                            game.assets.video === selectedGame.assets.video &&
                                            game.assets.boxFront === selectedGame.assets.boxFront) {

                                            game.launch();
                                        collectionFound = true;
                                        break;
                                            }
                                    }

                                    if (collectionFound) break;
                                }

                                sidebarFocused = false;
                                searchVisible = false;
                                searchFocused = false;
                                selectionMarker.opacity = 1.0;
                                collectionAxis.focus = true;
                            }

                            event.accepted = true;

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
                                mipmap: true

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
                                text: "Recommended games"
                                color: "white"
                                y: 28
                                font.family: netflixSansMedium.name
                                font.pixelSize: searchBar.width * 0.024 //24
                                anchors.verticalCenter: parent.verticalCenter
                                visible: searchInput.length === 0

                                Behavior on opacity {
                                    NumberAnimation { duration: 50 }
                                }

                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }

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
                                    //sourceSize { width: 456; height: 456 }
                                    asynchronous: true
                                    fillMode: Image.Stretch
                                    mipmap: true
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
                                        text: model.title !== undefined ? model.title : ""
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
                                            radius: 5
                                            samples: 32
                                            spread: 0.8
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
                                    let selectedGame;
                                    if (searchInput.text.trim() !== "") {
                                        selectedGame = gamesFiltered.get(resultsGrid.currentIndex);
                                    } else {
                                        selectedGame = gameListModel.get(resultsGrid.currentIndex);
                                    }

                                    if (selectedGame) {
                                        let collectionFound = false;
                                        for (let i = 0; i < api.collections.count; i++) {
                                            const collection = api.collections.get(i);

                                            for (let j = 0; j < collection.games.count; j++) {
                                                const game = collection.games.get(j);
                                                if (game.title === selectedGame.title &&
                                                    game.assets.video === selectedGame.assets.video &&
                                                    game.assets.boxFront === selectedGame.assets.boxFront) {

                                                    //console.log("Colección actual:", collection.name);
                                                //console.log("Lanzando juego:", game.title);
                                                game.launch();
                                                collectionFound = true;
                                                break;
                                                    }
                                            }

                                            if (collectionFound) break;
                                        }

                                        if (!collectionFound) {
                                            //console.log("El juego no se encontró en ninguna colección.");
                                        }

                                        sidebarFocused = false;
                                        searchVisible = false;
                                        searchFocused = false;
                                        selectionMarker.opacity = 1.0;
                                        collectionAxis.focus = true;
                                    }

                                    event.accepted = true;

                                } else if (!event.isAutoRepeat && api.keys.isCancel(event)) {
                                    event.accepted = true;
                                    virtualKeyboardContainer.focus = true;
                                    virtualKeyboardIndex = 0;
                                    resultsGrid.focus = false;
                                    navigatedDown = false;
                                }
                            }

                            Rectangle {
                                width: resultsGrid.width
                                height: resultsGrid.height
                                color: "transparent"
                                visible: !gamesFiltered.hasResults

                                Text {
                                    text: "There are no matches for your search"
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

    function updateInitialImages() {
        if (genreFilteredModel.count > 0) {
            var firstGame = genreFilteredModel.get(0);

            if (firstGame.assets.screenshots.length > 0) {
                genreImage.source = firstGame.assets.screenshots[0];
            }

            if (firstGame.assets.logo) {
                whellImage.source = firstGame.assets.logo;
            }
        } else {

            genreImage.source = "";
            whellImage.source = "";
        }
    }

    function createCategoriesFromGenres() {
        var storedCategories = api.memory.has('gameCategories')
        ? api.memory.get('gameCategories')
        : null;

        if (storedCategories) {
            var validatedCategories = storedCategories.map(function(category) {
                var validGames = category.games.filter(function(gameTitle) {
                    for (var i = 0; i < api.allGames.count; i++) {
                        if (api.allGames.get(i).title === gameTitle) {
                            return true;
                        }
                    }
                    return false;
                });

                return {
                    name: category.name,
                    count: validGames.length,
                    games: validGames
                };
            });

            validatedCategories = validatedCategories.filter(function(category) {
                return category.count > 0;
            });
            api.memory.set('gameCategories', validatedCategories);
            if (validatedCategories.length > 0) {
                return validatedCategories;
            }
        }

        var allGenres = {};
        for (var i = 0; i < api.allGames.count; i++) {
            var game = api.allGames.get(i);
            game.genreList.forEach(function(genre) {
                var baseCategory = genre.split(/[\s\/-]/)[0].toLowerCase();
                if (!allGenres[baseCategory]) {
                    allGenres[baseCategory] = [];
                }
                allGenres[baseCategory].push(game.title);
            });
        }

        var categoriesArray = [];
        Object.keys(allGenres).forEach(function(category) {
            categoriesArray.push({
                name: category,
                count: allGenres[category].length,
                games: allGenres[category]
            });
        });

        categoriesArray.sort((a, b) => b.count - a.count);
        api.memory.set('gameCategories', categoriesArray);
        return categoriesArray;
    }

    ListModel {
        id: genreFilteredModel

        function filterCategory(category) {
            clear();
            for (var i = 0; i < api.allGames.count; i++) {
                var game = api.allGames.get(i);
                var gameCategories = game.genreList.map(function(genre) {
                    return genre.split(/[\s\/-]/)[0].toLowerCase();
                });

                if (gameCategories.includes(category.toLowerCase())) {
                    append(game);
                }
            }
            updateInitialImages();
        }
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
            visible: gameGridView.currentIndex >= 0
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
            visible: gameGridView.currentIndex >= 0
            fillMode: Image.PreserveAspectFit
            opacity: 0
            width: parent.width * 0.2
            height: parent.height * 0.3
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: parent.height * 0.45
            anchors.rightMargin: parent.width * 0.10

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
                duration: 1500
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

        Component.onCompleted: {
            if (genereListView.model.length > 0) {
                genereListView.currentIndex = 0;
            }
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
                        //sourceSize { width: 456; height: 456 }
                        fillMode: Image.Stretch
                        mipmap: true
                        asynchronous: true
                        z: 0
                    }
                }

                onCurrentIndexChanged: {
                    if (currentIndex !== -1) {
                        var game = genreFilteredModel.get(currentIndex);

                        if (game && game.assets.logo) {
                            whellImage.source = game.assets.logo;
                        }

                        if (game && game.assets.screenshots.length > 0) {
                            genreImage.source = game.assets.screenshots[0];
                        }
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
                    if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                        let selectedGame = genreFilteredModel.get(gameGridView.currentIndex);

                        if (selectedGame) {
                            let collectionFound = false;
                            for (let i = 0; i < api.collections.count; i++) {
                                const collection = api.collections.get(i);

                                for (let j = 0; j < collection.games.count; j++) {
                                    const game = collection.games.get(j);
                                    if (game.title === selectedGame.title &&
                                        game.assets.video === selectedGame.assets.video &&
                                        game.assets.boxFront === selectedGame.assets.boxFront) {

                                        console.log("Colección actual:", collection.name);
                                    console.log("Lanzando juego:", game.title);
                                    game.launch();
                                    collectionFound = true;
                                    break;
                                        }
                                }

                                if (collectionFound) break;
                            }

                            if (!collectionFound) {
                                console.log("El juego no se encontró en ninguna colección.");
                            }
                        }

                        event.accepted = true;
                    } else if (api.keys.isCancel(event)) {
                        event.accepted = true;
                        genereListView.visible = true;
                        genereListView.focus = true;
                        genereListView.opacity = 1;
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
                width: parent.width
                height: parent.height * 0.90
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 15
                clip: true

                property int indexToPosition: -1
                property var categoriesModel: []

                model: categoriesModel

                property string selectedCategory: ""

                delegate: Item {
                    width: ListView.view.width
                    height: root.height * 0.08

                    Text {
                        text: modelData.name.charAt(0).toUpperCase() + modelData.name.slice(1) + " (" + modelData.count + " games)"
                        anchors.fill: parent
                        color: genereListView.currentIndex === index ? "white" : "gray"
                        font.family: index === genereListView.currentIndex ? boldFontLoader.name : mediumFontLoader.name
                        font.bold: index === genereListView.currentIndex
                        font.pixelSize: genereListView.currentIndex === index
                        ? Math.round(root.width * 0.020)
                        : Math.round(root.width * 0.016)
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

                onCurrentIndexChanged: {
                    indexToPosition = currentIndex;
                    selectedCategory = model[currentIndex].name;
                    genreFilteredModel.filterCategory(selectedCategory);
                }

                Component.onCompleted: {
                    categoriesModel = createCategoriesFromGenres();
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
                var allCollection = { name: "All games", shortName: "allgames", games: gamesRandon };
                collectionsListModel.append(allCollection);

                var recommendedCollection = { name: "Recommended games", shortName: "recommendedgames", games: gameListModel };
                collectionsListModel.append(recommendedCollection);

                var allCollection = { name: "Play with Friends: Guaranteed Multiplayer Fun", shortName: "multiplayer", games: multiplayer };
                collectionsListModel.append(allCollection);

                if (favoritesProxyModel.count > 0) {
                    var favoritesCollection = { name: "My list", shortName: "mylist", games: favoritesProxyModel };
                    collectionsListModel.append(favoritesCollection);
                    collectionsListModel.favoritesIndex = collectionsListModel.count - 1;
                    collectionsListModel.favoritesAvailable = true;
                }

                if (continuePlayingProxyModel.count > 0) {
                    var continuePlayingCollection = { name: "Continue playing", shortName: "continueplaying", games: continuePlayingProxyModel };
                    collectionsListModel.append(continuePlayingCollection);
                    collectionsListModel.continuePlayingIndex = collectionsListModel.count - 1;
                }

                for (var i = 0; i < api.collections.count; ++i) {
                    var collection = api.collections.get(i);
                    if (collection.name !== "My list" && collection.name !== "Continue playing") {
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
                        if (collectionsListModel.get(i).shortName === "recommendedgames") {
                            continuePlayingIndex = i + 1;
                            break;
                        }
                    }
                    if (continuePlayingIndex !== -1) {
                        var continuePlayingCollection = { name: "Continue playing", shortName: "continueplaying", games: continuePlayingProxyModel };
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
                        if (collectionsListModel.get(i).shortName === "recommendedgames") {
                            favoritesIndex = i + 1;
                            break;
                        }
                    }
                    if (favoritesIndex !== -1) {
                        var favoritesCollection = { name: "My list", shortName: "mylist", games: favoritesProxyModel };
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
                        text: name === "allgames" ? "All games" :
                        name === "mylist" ? "My list" :
                        name === "continueplaying" ? "Continue playing" :
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
                        sourceSize { width: 45; height: 45 }
                    }

                    Text {
                        text: "  My list   "
                        color: "white"
                        font.family: netflixsansbold.name
                        font.pixelSize: vpx(15)
                    }

                    Image {
                        id: favoriteImage
                        source: gameAxis.currentItem.game.favorite ? "assets/check.svg" : "assets/plus.png"
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
