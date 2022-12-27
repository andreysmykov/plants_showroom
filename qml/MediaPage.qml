import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtWebEngine


Item {
    property url currentUrl

    WebEngineView {
        anchors.fill: parent
        url: currentUrl
    }

    LeftArrow { }
}

