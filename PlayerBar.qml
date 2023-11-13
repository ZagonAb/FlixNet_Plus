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

import QtQuick 2.7

Item {
    id: root

    property int playerCount
    property int size

    readonly property real padding: size * 0.2
    readonly property real textWidth: size * 4 // Ancho fijo para el texto

    FontLoader {
        id: customFont
        source: "font/NetflixSansMedium.ttf"
    }

    width: textWidth + padding * 2
    height: size + padding * 2

    Text {
        width: root.textWidth // Ancho fijo para el Text
        anchors.verticalCenter: parent.verticalCenter
        height: size

        text: {
            var textColor = "#aeaeae";
            return "<font color='white'>Jugador:</font> <font color='" + textColor + "'>" + playerCount + "</font>";
        }
        font.pixelSize: size * 0.90 // Ajusta el tamaño de la fuente aquí
        font.family: customFont.name 
        color: "#aeaeae"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.RichText // Permite el uso de etiquetas HTML en el texto
    }
}
