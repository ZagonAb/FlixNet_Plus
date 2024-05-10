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
import "qrc:/qmlutils" as PegasusUtils

Item {
    property var game: null

    visible: game

    Image {
        id: logoImage
        
        asynchronous: true
        source: game && game.assets && game.assets.logo ? game.assets.logo : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: game && game.assets && game.assets.logo && game.assets.logo !== ""
        width: parent.width * 0.4
        height: parent.height * 0.4

        anchors {
            top: parent.top
            left: parent.left
            margins: vpx(10)
        }

        opacity: 0

        Behavior on opacity {
            OpacityAnimator { duration: 2500 }
        }
    }

    onGameChanged: {
        logoImage.opacity = 0;
        logoImage.opacity = 1;
    }

    DetailsInfoBar {
        id: infobar

        anchors {
            top: logoImage.bottom
            left: parent.left
            right: parent.right
            topMargin: vpx(10)
        }
    }

    PegasusUtils.AutoScroll {
        anchors {
            top: infobar.bottom
            left: parent.left
            right: parent.right
            topMargin: vpx(25)
            bottom: parent.bottom 
        }

        FontLoader {
            id: customFont
            source: "font/NetflixSansMedium.ttf"
        }

        Text {
            text: {
                if (game) {
                    var firstDotIndex = game.description.indexOf(".");
                    var secondDotIndex = game.description.indexOf(".", firstDotIndex + 1);
                    if (secondDotIndex !== -1) {
                        return game.description.substring(0, secondDotIndex + 1);
                    } else {
                        return game.description;
                    }
                } else {
                    return "";
                }
            }
            width: parent.width
            wrapMode: Text.Wrap
            font.family: customFont.name 
            color: "#aeaeae"
            font {
                pixelSize: vpx(14)
            }
        }
    }
}
