pragma Singleton
import QtQuick 2.15

QtObject {
    property var font: FontLoader { source: '../../fonts/Baskervville-Regular.ttf' }
    property var digitFont: FontLoader { source: '../../fonts/InriaSerif-Regular.ttf' }
    property url socialMediaUrl: "https://feey.ch/"
}
