// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
//    id: rectanglePopup

    property variant object: undefined //Тип обЪекта = 'HValueParams'

    property variant objectRowTop: undefined //стРОКа сверХу
    onObjectRowTopChanged: {
        if (! (objectRowTop === undefined)) {
            anchors.top = objectRowTop.bottom
            anchors.topMargin = objectRowTop.parent.spacing

//            objectRowTop.anchors.bottom = top
//            objectRowTop.anchors.bottomMargin = objectRowTop.parent.spacing
        }
        else
            ;
    }
    property variant objectRowBottom: undefined //стРОКа снИЗу
    onObjectRowBottomChanged: {
        if (! (objectRowBottom === undefined)) {
//            anchors.bottom = objectRowBottom.top
//            anchors.bottomMargin = objectRowBottom.parent.spacing

            objectRowBottom.anchors.top = bottom
            objectRowBottom.anchors.topMargin = objectRowBottom.parent.spacing
        }
        else
            ;
    }

//    property variant objectRowReplace: undefined //стРОКа ПОДМЕНяемАя

    function minValue (val) {
        if (object.objectName.indexOf ("StepsLength") > -1)
            val = Math.round (val * 100) / 100
        else
            ;

        if (val < object.min_val)
            return object.min_val
        else
            return val
    }

    function maxValue (val) {
        if (object.objectName.indexOf ("StepsLength") > -1)
            val = Math.round (val * 100) / 100
        else
            ;

        if (val > object.max_val)
            return object.max_val
        else
            return val
    }

    function exitOK () {
        visible = false

//        objectRowTop.anchors.bottom = objectRowBottom.top
//        objectRowTop.anchors.bottomMargin = objectRowBottom.parent.spacing

        if (! (objectRowBottom === undefined)) {
            objectRowBottom.anchors.top = objectRowTop.bottom
            objectRowBottom.anchors.topMargin = objectRowTop.parent.spacing
        }
        else
            ;

        objectRowTop = undefined
        objectRowBottom = undefined

//        objectRowReplace = undefined

        object = undefined
    }

    function enabledButton () {
        var bRes

        if (object === undefuned)
            bRes = false
        else {
        }

        return bRes
    }

    function heightButton () {
//        return ((parent.height - 3 * global_offset / 2) / 2)
        return ((height - 3 * global_offset / 2) / 2)
    }

    visible: false

    x: -1
    y: -1
//    width: parent.width / 4
    width: parent.width
    height: rectangleForm.height / 6

//    z: object === undefined ? -1 : 6
    rotation: 0

    color: "gray"
    border {
        width: 3
        color: "black"
    }

    radius: radius

    Connections {
//        target: rectangleForm
//        onSgnPopupTitle: {
//            console.debug ("::onSgnPopupTitle")
//            textPopupTitle.text = title
//        }

//        onSgnPopupValue: {
//            console.debug ("::onSgnPopupValue")
//            object = value
//        }
    }

    onObjectChanged: {
//        textPopupTitle.text = object.objectName
    }

    onVisibleChanged: {
        if (visible === false)
            exitOK ()
        else
            ;
    }

//        Кнопка - 'popupMinusMinus'
    HButton {
        id: btnPopupMinusMinus
        width: (parent.width - 3 * global_offset / 2) / 2
        height: heightButton ()
        z: parent.z + 1

        colorChecked: '#5bc0de'
        colorUncheked: '#2f96b4'

        anchors.left: parent.left
        anchors.leftMargin: global_offset / 2
        anchors.top: parent.top
        anchors.topMargin: global_offset / 2

        textUnchecked: "<<"
//            textRatio: 0.7

        checked: false
        checkable: false

        enabled: object === undefined ? false : object.val > object.min_val ? true : false

        onCheckedChanged: {
            if (checked) {
            }
            else {
            }
        }

        onClicked: {
//            object.val -= object.step_val * object.coeff_val
            object.val = minValue (object.val - object.step_val * object.coeff_val)
        }

        onDoubleClicked: {
        }

        Connections {
//                target:
        }
    }

//        Кнопка - 'popupPlusPlus'
    HButton {
        id: btnPopupPlusPlus
        width: (parent.width - 3 * global_offset / 2) / 2
        height: heightButton ()
        z: parent.z + 1

        colorChecked: '#5bc0de'
        colorUncheked: '#2f96b4'

        anchors.right: parent.right
        anchors.rightMargin: global_offset / 2
        anchors.top: parent.top
        anchors.topMargin: global_offset / 2

        textUnchecked: ">>"
//            textRatio: 0.7

        checked: false
        checkable: false

//        enabled: enabledButton ()
        enabled: object === undefined ? false : object.val < object.max_val ? true : false

        onCheckedChanged: {
            if (checked) {
            }
            else {
            }
        }

        onClicked: {
//            object.val += object.step_val * object.coeff_val
            object.val = maxValue (object.val + object.step_val * object.coeff_val)
        }

        onDoubleClicked: {
        }

        Connections {
//                target:
        }
    }

//        Кнопка - 'popupMinus'
    HButton {
        id: btnPopupMinus
        width: (parent.width - 3 * global_offset / 2) / 2
        height: heightButton ()
        z: parent.z + 1

        colorChecked: '#5bc0de'
        colorUncheked: '#2f96b4'

        anchors.left: parent.left
        anchors.leftMargin: global_offset / 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: global_offset / 2
//        anchors.top: btnPopupMinusMinus.bottom
//        anchors.topMargin: global_offset / 2

//            borderWidth: 3

        textUnchecked: "<"
//            textRatio: 0.7

        checked: false
        checkable: false

        enabled: object === undefined ? false : object.val > object.min_val ? true : false

        onCheckedChanged: {
            if (checked) {
            }
            else {
            }
        }

        onClicked: {
//            object.val -= object.step_val
//            objectPopupWindow.text --
            object.val = minValue (object.val - object.step_val)
        }

        onDoubleClicked: {
        }

        Connections {
//                target:
        }
    }

//        Кнопка - 'popupPlus'
    HButton {
        id: btnPopupPlus
        width: (parent.width - 3 * global_offset / 2) / 2
        height: heightButton ()
        z: parent.z + 1

        colorChecked: '#5bc0de'
        colorUncheked: '#2f96b4'

        anchors.right: parent.right
        anchors.rightMargin: global_offset / 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: global_offset / 2

//            borderWidth: 3

        textUnchecked: ">"
//            textRatio: 0.7

        checked: false
        checkable: false

        enabled: object === undefined ? false : object.val < object.max_val ? true : false

        onCheckedChanged: {
            if (checked) {
            }
            else {
            }
        }

        onClicked: {
//            object.val += object.step_val
//            objectPopupWindow.text ++
            object.val = maxValue (object.val + object.step_val)
        }

        onDoubleClicked: {
        }

        Connections {
//                target:
        }
    }

    MouseArea {
        anchors.fill: parent
    }
}
