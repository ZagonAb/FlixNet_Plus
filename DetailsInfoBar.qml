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

Row {
    property int fontSize: vpx(16)

    height: fontSize + vpx(2)
    spacing: vpx(10)


    RatingBar {
        percent: game ? game.rating : 0
        size: fontSize

        visible: percent > 0
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: (game && game.releaseYear > 0) ? game.releaseYear : ""
        color: "#eee"
        font {
            pixelSize: fontSize
            family: globalFonts.sans
        }

        visible: text
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: game ? game.developer : ""
        color: "#eee"
        font {
            pixelSize: fontSize
            family: globalFonts.sans
        }

        anchors.verticalCenter: parent.verticalCenter
    }

    PlayerBar {
        size: fontSize
        playerCount: game ? game.players : 1
        visible: playerCount > 1
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        width: 120 // Longitud fija de la barra de progreso
        //width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        height: vpx(7)
        color: "lightgray"
        visible: game.playTime > 0
        border.color: "gray"
        radius: vpx(4)

        Rectangle {
            width: parent.width * (game.playTime / (60 * 60))
            height: parent.height
            color: "red"
            radius: vpx(4)
        }

        Behavior on width {
            NumberAnimation { duration: 500 }
        }
    }

    Text {
        text: {
            function formatTiempoReproduccion(tiempoSegundos) {
                var minutos = Math.floor(tiempoSegundos / 60);
                return "Tiempo jugado:  " + minutos + " minutos";
            }
            return "" + formatTiempoReproduccion(game ? game.playTime : 0);
        }
        color: "#eee"
        font {
            pixelSize: fontSize
            family: globalFonts.sans
        }

        visible: game && game.playTime > 0
        anchors.verticalCenter: parent.verticalCenter
    }
}
