import QtQuick 2.15

Image {
    width: 30
    anchors.top: parent.top; anchors.left: parent.left
    anchors.leftMargin: 10
    source: "../images/left-arrow"
    fillMode: Image.PreserveAspectFit
    mipmap: true; antialiasing: true
    opacity: 0.4

    MouseArea {
        anchors.fill: parent
        onClicked: { stack.pop() }
    }
}