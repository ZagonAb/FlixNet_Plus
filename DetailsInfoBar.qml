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
    property int maxHours: 1
    property int maxBarWidth: 150

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
        width: maxBarWidth
        anchors.verticalCenter: parent.verticalCenter
        height: vpx(6)
        color: "#5b5a5b"
        visible: game.playTime > 0
        border.color: "#5b5a5b"
        radius: vpx(4)

        Rectangle {
            width: Math.min(parent.width, maxBarWidth * (Math.min(game.playTime / (60 * 60), maxHours) / maxHours))
            height: parent.height
            color: "#ea0000"
            radius: vpx(6)

            Behavior on width {
                NumberAnimation { duration: 500 }
            }
        }
    }

    Text {
        text: {
            function formatTiempoReproduccion(tiempoSegundos) {
                var horas = Math.floor(tiempoSegundos / (60 * 60));
                var minutos = Math.floor((tiempoSegundos % (60 * 60)) / 60);
                return "Tiempo de juego:  " + horas + " h y " + minutos + " min";

                //return horas + " horas y " + minutos + " minutos";
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

    Timer {
        interval: 1000 // Actualizar cada segundo
        running: game.playTime > 0
        repeat: true
        onTriggered: {
            if (game.playTime >= maxHours * 60 * 60) {
                maxHours++;
            }
        }
    }
}
