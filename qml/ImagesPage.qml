/*
All of the photos were taken from:
https://unsplash.com/photos/2r2RUsEU1Aw
https://unsplash.com/photos/xLwy5mAh1KU
https://unsplash.com/photos/AU5F441QvvQ
https://unsplash.com/photos/OFJ6DnNij1M
https://unsplash.com/photos/shtqdHUNcO0
https://unsplash.com/photos/2X9PfLKSuh4
https://unsplash.com/photos/OSBEqWnoDYo
https://unsplash.com/photos/YvRVB_c9cZk
https://unsplash.com/photos/af7c0GwLsGU
https://unsplash.com/photos/uP2QOCUBu7A
https://unsplash.com/photos/MBsReSZ2WNM
https://unsplash.com/photos/pZwxnQ8lA24
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import Settings 1.0

GridView {
    id: grid

    delegate: Item {
        width: grid.cellWidth; height: grid.cellHeight
        Item {
            anchors.fill: parent

            Image {
                anchors.fill: parent
                source: modelData.path
                fillMode: Image.PreserveAspectCrop
                mipmap: true; antialiasing: true
            }

            Rectangle {
                id: plantName
                width: parent.width / 2; height: 25
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                opacity: 0.6

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: modelData.name
                    font.family: AppSettings.font.font.family
                    font.pixelSize: 16
                }
            }

            OpacityAnimator on opacity { from: 0; to: 1; duration: 1500 }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: plantName.color = '#49A078'
                onExited: plantName.color = 'white'
                onClicked: {
                    stack.push("PlantPage.qml", {"plant": modelData })
                }
            }
        }
    }
}