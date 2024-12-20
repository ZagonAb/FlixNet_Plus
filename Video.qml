import QtQuick 2.7
import QtMultimedia 5.7
import QtGraphicalEffects 1.0

Item {
    property var game: null
    property bool videoEnded: false
    property alias screenshot: screenshotImg.source
    property int screenshotDuration: 500
    property bool isPaused: false

    onIsPausedChanged: {
        if (isPaused) {
            if (vid.source && !videoEnded) {
                vid.pause();
            }

            if (!vid.source || videoEnded) {
                screenshotImg.opacity = 1;
            }
        } else {
            if (vid.source) {
                vid.play();
                screenshotImg.opacity = 0;
            }
        }
    }

    width: vid.width
    height: vid.height
    visible: game

    Timer {
        id: screenshotTimer
        interval: screenshotDuration
        running: false
        onTriggered: {
            if (vid.source) {
                vid.play();
                screenshotImg.opacity = 0;
            }
        }
    }

    Video {
        id: vid
        anchors.fill: parent
        source: game ? (game.assets ? game.assets.video : "") : ""
        fillMode: VideoOutput.Stretch
        autoPlay: false
        visible: true

        onStopped: {
            if (vid.position === vid.duration) {
                screenshotImg.source = (game && game.assets.screenshots.length > 0) ? game.assets.screenshots[0] : "";
                screenshotImg.opacity = 1;
                videoEnded = true;
            }
        }

        onPositionChanged: {
            if (videoEnded && vid.position < vid.duration) {
                screenshotImg.source = ""
                videoEnded = false
            }
        }
    }

    Image {
        anchors.fill: parent
        source: "assets/crt.png"
        fillMode: Image.Tile
        visible: true
        opacity: 0.2
    }

    Image {
        id: screenshotImg
        anchors.fill: parent
        source: (game && game.assets.screenshots.length > 0) ? game.assets.screenshots[0] : ""
        opacity: 1.0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        Image {
            anchors.fill: parent
            source: "assets/crt.png"
            fillMode: Image.Tile
            visible: true
            opacity: 0.2
        }

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

    Image {
        anchors.fill: vid
        source: "assets/crt.png"
        fillMode: Image.Tile
        visible: videoEnded
        opacity: 0.2
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

    onGameChanged: {
        vid.source = game ? (game.assets ? game.assets.video : "") : ""
        screenshotImg.source = ""
        videoEnded = false
        if (game && game.assets.screenshots.length > 0) {
            screenshotImg.source = game.assets.screenshots[0]
            screenshotImg.opacity = 1
            screenshotTimer.restart()
        } else {
            vid.play()
        }
    }
}
