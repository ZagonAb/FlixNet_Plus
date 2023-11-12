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
    //property int gameAxisIndex: -1 // Propiedad para almacenar el índice del juego
    property bool isFavorite: game.favorite // Propiedad para rastrear si el juego es favorito
    
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
    // Capa adicional para el icono de favoritos
    Item {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: -40  // Ajusta este valor para cambiar la distancia desde la parte inferior
        width: 220
        height: 140

        Image {
            id: favoriteImage

            anchors.fill: parent
            visible: isFavorite
            source: "assets/favorite.png"
            fillMode: Image.PreserveAspectFit
        }
    }
}

