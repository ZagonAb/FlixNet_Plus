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

Column {
    property int fontSize: vpx(16)
    property int maxHours: 1
    property int maxBarWidth: 260

    height: fontSize + vpx(2)
    spacing: vpx(1)

    FontLoader {
        id: customFontLoader
        source: "font/NetflixSansBold.ttf"
    }

    Row {
        spacing: vpx(9)

        RatingBar {
            percent: game ? game.rating : 0
            size: fontSize
            visible: percent > 0
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            textFormat: Text.RichText
            text: "<font color='white'>Release: </font><font color='#aeaeae'>" + (game && game.releaseYear > 0 ? game.releaseYear : "") + "</font>"
            font.pixelSize: vpx(14)
            font.family: customFont.name
            anchors.verticalCenter: parent.verticalCenter
        }


        Text {
            textFormat: Text.RichText
            text: "<font color='white'>Developer: </font><font color='#aeaeae'>" + (game ? game.developer : "") +  "</font>"
            font.pixelSize: vpx(14)
            font.family: customFont.name
            anchors.verticalCenter: parent.verticalCenter
        }

        PlayerBar {
            size: fontSize
            playerCount: game ? game.players : 1
            visible: playerCount > 1
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Row {
        spacing: vpx(10)

        Rectangle {
            width: maxBarWidth
            anchors.verticalCenter: parent.verticalCenter
            height: vpx(6)
            color: "#5b5a5b"
            border.color: "#5b5a5b"
            radius: vpx(4)
            visible: game && game.playTime >= 60

            Rectangle {
                width: game && game.playTime < 1800
                ? Math.min(parent.width, maxBarWidth * (game.playTime / 1800))
                : 0
                height: parent.height
                color: "#2ecc71"
                radius: vpx(6)

                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }

            Rectangle {
                width: game && game.playTime >= 1800 && game.playTime < 3600
                ? Math.min(parent.width, maxBarWidth * ((game.playTime - 1800) / 1800))
                : 0
                height: parent.height
                color: "#3498db"
                radius: vpx(6)

                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }

            Rectangle {
                width: game && game.playTime >= 3600
                ? Math.min(parent.width, maxBarWidth * ((Math.floor(game.playTime / 3600) % 10) / 10))
                : 0
                height: parent.height
                color: {
                    if (!game || game.playTime < 3600) return "#2ecc71";
                    else if (game.playTime < 3600 * 20) return "#f1c40f";
                    else return "#e74c3c";
                }
                radius: vpx(6)

                Behavior on width {
                    NumberAnimation { duration: 500 }
                }
            }
        }

        Row {
            spacing: vpx(5)
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: {
                    function formatTiempoReproduccion(tiempoSegundos) {
                        var horas = Math.floor(tiempoSegundos / (60 * 60));
                        var minutos = Math.floor((tiempoSegundos % (60 * 60)) / 60);
                        return "Play time: " + horas + " h and " + minutos + " min";
                    }
                    return "" + formatTiempoReproduccion(game ? game.playTime : 0);
                }
                color: "#eee"
                font.pixelSize: vpx(13)
                font.family: customFontLoader.name
                visible: game && game.playTime >= 60
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: {
                    if (game && game.playTime < 1800) {
                        return "Phase: 0";
                    } else if (game && game.playTime >= 1800 && game.playTime < 3600) {
                        return "Phase: 1";
                    } else if (game && game.playTime >= 3600) {
                        let hoursPlayed = Math.floor(game.playTime / 3600);
                        let currentPhase = Math.floor(hoursPlayed / 10) + 1;
                        return "Phase: " + currentPhase;
                    }
                }
                color: "#ccc"
                font.pixelSize: vpx(13)
                font.family: customFontLoader.name
                verticalAlignment: Text.AlignVCenter
                visible: game && game.playTime >= 60
            }
        }
    }

    Timer {
        interval: 1000
        running: game && game.playTime > 0
        repeat: true
    }
}
