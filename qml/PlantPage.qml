import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Settings 1.0

Rectangle {
    property var plant

    Item {
        id: leftPart
        width: parent.width / 2; height: parent.height
        anchors.left: parent.left

        Image {
            anchors.fill: parent
            source: plant.path
            fillMode: Image.PreserveAspectCrop
            mipmap: true; antialiasing: true
            OpacityAnimator on opacity { from: 0; to: 1; duration: 1000 }
        }

        LeftArrow {}
    }

    Item {
        id: rightPart
        width: parent.width / 2; height: parent.height
        anchors.right: parent.right

        Item {
            width: parent.width * 0.8; height: parent.height * 0.9
            anchors.centerIn: parent
            anchors.margins: 30

            Item {
                id: name
                width: parent.width
                height: parent.height / 7
                anchors.top: parent.top
                Text {
                    text: plant.name
                    anchors.bottom: parent.bottom
                    horizontalAlignment: Text.AlignLeft
                    font.family: AppSettings.font.font.family
                    font.pixelSize: plant.name.split(' ').length < 2 ? 48 : 40
                }
            }

            Item {
                id: description
                width: parent.width
                height: parent.height / 1.8
                anchors.top: name.bottom
                anchors.topMargin: 30
                Text {
                    text: plant.description
                    width: parent.width; height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    font.family: AppSettings.font.font.family
                    font.pixelSize: 18
                    wrapMode: Text.WordWrap
                    maximumLineCount: 7
                }
            }

            Rectangle {
                id: line
                width: parent.width; height: 2;
                anchors.top: description.bottom
                color: "#0C5834"
            }

            RowLayout {
                width: parent.width
                anchors.top: line.bottom
                anchors.bottom: parent.bottom
                spacing: 0

                Repeater {
                    model: [
                        {"characteristic": plant.care.water, "image": "../images/plant_care/water-drop", "font": AppSettings.font },
                        {"characteristic": plant.care.temperature, "image": "../images/plant_care/thermometer", "font": AppSettings.digitFont },
                        {"characteristic": plant.care.light, "image": "../images/plant_care/sun", "font": AppSettings.font },
                    ]
                    delegate: Rectangle {
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillHeight: true
                        Image {
                            anchors.centerIn: parent
                            width: parent.width / 2.5; height: parent.height / 2.5
                            source: modelData.image
                            fillMode: Image.PreserveAspectFit
                            mipmap: true; antialiasing: true
                        }
                        Text {
                            text: modelData.characteristic
                            width: parent.width; height: parent.height
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom
                            font.family: modelData.font.font.family
                            font.pixelSize: 16
                        }
                    }
                }
            }
        }
    }
}