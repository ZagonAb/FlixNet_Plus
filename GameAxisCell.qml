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
import QtGraphicalEffects 1.0

Item {
    property var game

    function isRecentlyPlayed(lastPlayedDate, playTimeInSeconds) {
        var currentDate = new Date();
        var twoWeeksAgo = new Date(currentDate.getTime() - (7 * 24 * 60 * 60 * 1000));
        var oneMinuteInSeconds = 60; // 1 minuto en segundos

        return lastPlayedDate > twoWeeksAgo && lastPlayedDate <= currentDate && playTimeInSeconds >= oneMinuteInSeconds;
    }

    property bool islastPlayed: isRecentlyPlayed(game.lastPlayed, game.playTime)

    property int maxHours: 1
    property int maxBarWidth: 150 //parent.width * 0.1

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

        sourceSize { width: 456; height: 456 }
    }

    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width * 0.9
        height: parent.height * 0.9

        Rectangle {
            anchors.centerIn: parent // Centrar el rectángulo dentro del Item
            width: parent.width * 1.2 // Hacer el rectángulo un poco más grande que el Item
            height: parent.height * 1.2 // Hacer el rectángulo un poco más grande que el Item
            color: "black" // Color del fondo del contenedor
            opacity: 0.7 // Ajusta el nivel de opacidad según tus preferencias
            visible: islastPlayed
        }

        Image {
            anchors.fill: parent

            visible: islastPlayed
            source: "assets/continuegame.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            anchors {
                bottom: parent.bottom // Alinea la parte inferior del rectángulo exterior con la parte inferior del contenedor padre
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 1 // Establecer un ancho predefinido para el rectángulo exterior
            height: vpx(6)
            color: "#5b5a5b"
            visible: islastPlayed
            border.color: "#5b5a5b"
            radius: vpx(4)

            Rectangle {
                width: parent.width * 1 * (game && game.playTime / (maxHours * 60 * 60)) // Ancho de la barra de progreso como porcentaje del rectángulo exterior
                height: parent.height
                color: "#ea0000"
                radius: vpx(6)

                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }
        }

        Timer {
            interval: 1000
            running: game && game.playTime > 0
            repeat: true
            onTriggered: {
                if (game.playTime >= maxHours * 60 * 60) {
                    maxHours++;
                }
            }
        }
    }
}
