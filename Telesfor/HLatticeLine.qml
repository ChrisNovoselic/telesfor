// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
//import "."

Item {
    id: parentLine

    property string type: ""
    property int number: 0
//    property int totalLine: 0
    property bool checked: false

    function getWidth () {
//        if (totalLine > 0) {
            if (type.indexOf ("vertical") > -1)
                return parent.width / ((m_synchCoordinates.count_lattice_line - 1) * 2 - 1) / 2
            else
                if (type.indexOf ("horizontal") > -1)
                    return parent.width
                else
                    return -1
//        }
//        else
//            ;
    }

    function getHeight () {
        if (type.indexOf ("vertical") > -1)
            return parent.width
        else
            if (type.indexOf ("horizontal") > -1)
                return parent.width / ((m_synchCoordinates.count_lattice_line - 1) * 2 - 1) / 2
            else
                return -1
    }

    Rectangle {
        id: line
        width: getWidth ()
        height: getHeight ()
        color: parent.checked ? "#5bc0de" : Qt.darker (rectangleForm.color)
//        border {
//            width: checked ? 2 : 0
//            color: "blue"
//        }


//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
////                console.debug ("line.MouseArea.onClicked =", parentLine.type, line.color.toString (), Qt.darker (rectangleForm.color), line.color.toString () === Qt.darker (rectangleForm.color).toString ())
//                if (type.indexOf ("horizontal") > -1) {
//                    checked = ! checked

//                    if (checked) {
//                        ; //ОтменитЬ выделениЕ ВСЕМ осталЬным линиЯм
//                        var ppp = parent.parent.parent
//    //                    console.debug (parentLine.children.length)
//                        for (var i = 0; i < ppp.children.length; i ++) {
//                            if (! (ppp.children [i] === parentLine))
//                                ppp.children [i].checked = false
//                            else
//                                ;
//                        }
//                    }
//                    else
//                        ;

//                    sgnCheckedLatticeLine (number, checked, "blue")
//                }
//                else
//                    ;
//            }
//        }
    }

    Component.onCompleted: {
//        if (type.indexOf ("vertical") > -1) {
//            line.anchors.left = left
//            line.anchors.leftMargin = (number * 2 - 1) * getWidth ()
//        }
//        else
//            if (type.indexOf ("horizontal") > -1) {
//                line.anchors.top = top
//                line.anchors.topMargin = (number * 2 - 1) * getHeight ()
//            }
//            else
//                ;
    }

    onWidthChanged: {
//        console.debug ("HLatticeLine::onWidthChanged")

        if (type.indexOf ("vertical") > -1) {
            line.anchors.left = parentLine.left
            line.anchors.leftMargin = (number * 2 - 1) * getWidth () * 2
//            console.debug ("type of LatticeLine", type, line.anchors.leftMargin)
        }
        else
            if (type.indexOf ("horizontal") > -1) {
                line.anchors.top = parentLine.top
                line.anchors.topMargin = (number * 2 - 1) * getHeight () * 2
//                line.y = (number * 2 - 1) * getHeight ()
//                console.debug ("type of LatticeLine", type, line.y)
            }
            else
                ;
    }
}
