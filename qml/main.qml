import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Settings 1.0


ApplicationWindow {
    id: root
    visible: true
    width: 951; height: 650
    color: "white"
    property QtObject plantModel

    Component.onCompleted: {
        plantModel.update_care()
    }

    StackView {
        id: stack
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: footer.top
        initialItem: plantComponent
    }

    Component {
       id: plantComponent
       SwipeView {
            id: swipe
            Repeater {
                anchors.fill: parent
                model: plantModel.plants.length / 6
                ImagesPage {
                    model: Array.from(plantModel.plants).slice(0 + 6*index, 6 + 6*index)
                    cellWidth: swipe.width / 3; cellHeight: swipe.height / 2
                }
            }
        }
    }

    footer: Item {
        id: footer
        width: parent.width; height: parent.height / 14
        state: "active"

        states: [
            State {
                name: "active"
                PropertyChanges { target: footer; enabled: true }
                PropertyChanges { target: footer; opacity: 1 }
                when: stack.depth <= 2
            },
            State {
                name: "inactive"
                PropertyChanges { target: footer; enabled: false }
                PropertyChanges { target: footer; opacity: 0.5 }
                when: stack.depth > 2
            }
        ]

        RowLayout {
            width: parent.height * 3; height: parent.height
            anchors.centerIn: parent

            Repeater {
                model: ListModel {
                    ListElement { name: "twitter"; image: "../images/footer/twitter" }
                    ListElement { name: "facebook"; image: "../images/footer/instagram" }
                    ListElement { name: "instagram"; image: "../images/footer/facebook" }
                }
                delegate: Rectangle {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true
                    Image {
                        width: parent.width / 2; height: parent.height / 2
                        anchors.centerIn: parent
                        source: image
                        fillMode: Image.PreserveAspectFit
                        mipmap: true; antialiasing: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stack.push("MediaPage.qml", {"currentUrl": AppSettings.socialMediaUrl})
                        }
                    }
                }
            }
        }
    }
}