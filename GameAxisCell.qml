// Pegasus Frontend - Flixnet theme
// Copyright (C) 2017  Mátyás Mustoha
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

Item {
    property var game
    property bool isFavorite: game.favorite

    // Verifica si el juego fue lanzado recientemente y tiene al menos 1 minuto de juego
    function isRecentlyPlayed(lastPlayedDate, playTimeInSeconds) {
        var currentDate = new Date();
        var twoWeeksAgo = new Date(currentDate.getTime() - (7 * 24 * 60 * 60 * 1000));
        var oneMinuteInSeconds = 60; // 1 minuto en segundos

        return lastPlayedDate > twoWeeksAgo && lastPlayedDate <= currentDate && playTimeInSeconds >= oneMinuteInSeconds;
    }

    // Propiedad que indica si el juego fue lanzado recientemente
    property bool islastPlayed: isRecentlyPlayed(game.lastPlayed, game.playTime)

    Rectangle {
        anchors.fill: parent
        color: "#333"
        visible: image.status !== Image.Ready

        Image {
            anchors.centerIn: parent

            visible: image.status === Image.Loading
            source: "assets/loading-spinner.png"

            RotationAnimator on rotation {
                loops: Animator.Infinite
                from: 0; to: 360
                duration: 500
            }
        }

        Text {
            text: game.title

            width: parent.width * 0.8
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap

            anchors.centerIn: parent
            visible: !game.assets.gridicon

            color: "#eee"
            font {
                pixelSize: vpx(16)
                family: globalFonts.sans
            }
        }
    }

    Image {
        id: image

        anchors.fill: parent
        visible: source

        asynchronous: true
        fillMode: Image.Stretch

        source: game.assets.banner || game.assets.steam || game.assets.marquee ||
                game.assets.tile || game.assets.boxFront || game.assets.poster ||
                game.assets.cartridge

        sourceSize { width: 497; height: 680 }
    }

    Item {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width * 0.2
        height: parent.height * 0.2

        Image {
            id: favoriteImage

            anchors.centerIn: parent
            visible: isFavorite
            source: "assets/favorite.png"
            fillMode: Image.PreserveAspectFit
            // Ajustar el tamaño relativo al Item padre
            width: parent.width * 4.6
            height: parent.height * 4.6
        }
    }
    
    Item {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width * 0.2
        height: parent.height * 0.2

        Image {
            id: lastPlayedImage
            anchors.top: parent.top  // Corrección aquí
            anchors.horizontalCenter: parent.horizontalCenter

            visible: islastPlayed
            source: "assets/lastplayed.png"
            width: parent.width * 4.8  // Mantén el ancho
            height: parent.height * 0.5  // Ajusta este valor para reducir la altura y hacerla más delgada
        }
    }
}
