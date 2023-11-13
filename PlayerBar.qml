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
