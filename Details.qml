import QtQuick 2.7

import "qrc:/qmlutils" as PegasusUtils

Item {
    property var game: null

    visible: game

    Image {
        id: logoImage
        
        asynchronous: true
        source: game && game.assets && game.assets.logo ? game.assets.logo : ""
        sourceSize.width: 100
        sourceSize.height: 100
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: game && game.assets && game.assets.logo
        
        anchors {
            top: parent.top
            left: parent.left
            margins: vpx(10)
        }
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
            text: game ? game.description : ""
            
            width: parent.width
            wrapMode: Text.Wrap

            font.family: customFont.name 
            color: "#aeaeae"
            font {
                pixelSize: vpx(13.5)
                //family: globalFonts.sans
            }
        }
    }
}
