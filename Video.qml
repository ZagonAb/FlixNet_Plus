import QtQuick 2.7
import QtMultimedia 5.7
import QtGraphicalEffects 1.0

Item {
    property var game: null
    property bool videoEnded: false
    property alias screenshot: screenshotImg.source

    width: vid.width
   // height: 600

    visible: game

    Video {
        id: vid

        anchors.top: parent.top
        anchors.right: parent.right

        source: game.assets.video || ""
        fillMode: VideoOutput.Stretch
        autoPlay: true
        height: parent.height / 1.12
        anchors.bottomMargin: parent.height / 1
        width: parent.width / 0.80
        anchors.leftMargin: parent.width / 2

        onStatusChanged: if (status == MediaPlayer.Loaded) {
            width = height * videoWidth / videoHeight;
        }

        onStopped: {
            // Show screenshot when video ends
            if (vid.position === vid.duration) {
                screenshotImg.source = (game && game.assets.screenshots[0]) || "";
                videoEnded = true;
                screenshotGrad.visible = true;
            }
        }

        onPositionChanged: {
            // Hide screenshot when video starts playing again
            if (videoEnded && vid.position < vid.duration) {
                screenshotImg.source = "";
                videoEnded = false;
                screenshotGrad.visible = false;
            }
        }
    }

    Image {
        id: screenshotImg
        width: vid.width
        height: vid.height
        fillMode: Image.Stretch

        visible: videoEnded

        LinearGradient {
            id: screenshotGrad
            width: parent.width
            height: labelHeight * 0.5
            visible: false
        
            anchors.bottom: screenshotImg.bottom
            anchors.right: screenshotImg.right
            
            start: Qt.point(0, height)
            end: Qt.point(0, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }
    
        LinearGradient {
            width: screenshotImg.width * 0.5
            height: screenshotImg.height
        
            anchors.left: screenshotImg.left
            
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }
    }

    LinearGradient {
        width: vid.width
        height: labelHeight * 0.50

        anchors.bottom: vid.bottom
        anchors.right: vid.right

        start: Qt.point(0, height)
        end: Qt.point(0, 0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FF000000" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        width: vid.width * 0.75
        height: vid.height

        anchors.left: vid.left

        start: Qt.point(0, 0)
        end: Qt.point(width, 0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FF000000" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    // Change the video source and reset the screenshot when game changes
    onGameChanged: {
        vid.source = game.assets.video || "";
        screenshotImg.source = "";
        videoEnded = false;
    }
}
