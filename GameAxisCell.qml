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
    property int maxBarWidth: 150
    property int maxHours: 1

    function formatTiempoReproduccion(tiempoSegundos) {
        var horas = Math.floor(tiempoSegundos / (60 * 60));
        var minutos = Math.floor((tiempoSegundos % (60 * 60)) / 60);
        return horas + " h y " + minutos + " min";
    }

    function isRecentlyPlayed(lastPlayedDate, playTimeInSeconds) {
        var currentDate = new Date();
        var twoWeeksAgo = new Date(currentDate.getTime() - (7 * 24 * 60 * 60 * 1000));
        var oneMinuteInSeconds = 60;

        return lastPlayedDate > twoWeeksAgo && lastPlayedDate <= currentDate && playTimeInSeconds >= oneMinuteInSeconds;
    }
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
        sourceSize { width: 456; height: 456 }
    }

    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width * 0.9
        height: parent.height * 0.9

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 1.2
            height: parent.height * 1.2
            color: "black"
            opacity: 0.7
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
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            width: parent.width * 1
            height: vpx(6)
            color: "#5b5a5b"
            border.color: "#5b5a5b"
            radius: vpx(4)
            visible: islastPlayed

            Rectangle {
                width: game && game.playTime < 3600
                ? Math.min(parent.width, maxBarWidth * (game.playTime / 3600))
                : 0
                height: parent.height
                color: "#2ecc71"
                radius: vpx(6)
                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }

            Rectangle {
                width: game && game.playTime >= 3600 && game.playTime < (4 * 3600)
                ? Math.min(parent.width, maxBarWidth * ((game.playTime - 3600) / (3 * 3600)))
                : 0
                height: parent.height
                color: "#3498db"
                radius: vpx(6)
                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }

            Rectangle {
                width: game && game.playTime >= (4 * 3600) && game.playTime < (20 * 3600)
                ? Math.min(parent.width, maxBarWidth * ((game.playTime - (4 * 3600)) / (16 * 3600)))
                : 0
                height: parent.height
                color: "#f1c40f"
                radius: vpx(6)
                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }

            Rectangle {
                width: game && game.playTime >= (20 * 3600)
                ? Math.min(parent.width, maxBarWidth * ((((game.playTime - (20 * 3600)) % (10 * 3600)) / (10 * 3600))))
                : 0
                height: parent.height
                color: "#e74c3c"
                radius: vpx(6)
                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: game && game.playTime > 0
        repeat: true
    }
}
