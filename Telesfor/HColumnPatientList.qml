// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.

import "hcouch.js" as ScriptHCouchDB
import "patient.js" as ScriptPatient

Rectangle {
//    id:columnPatientList
//    objectName: "columnPatientList"

//    property variant arPatients: new Array

    property int spacing: 6
    property int countButton: 15
    property int iScrollItem: 0
    onIScrollItemChanged: {
        var i, indxPrevChecked, indxChecked
        for (i = 0; i < countButton; i ++) { //3 - Индекс ПервОЙ кнопкИ с ФИО ПАЦиенТа
            if (children [i + 3].checked)
                indxPrevChecked = i

            children [i + 3].patientJSON = ScriptPatient.arPatients [i + iScrollItem]

//            children [i].checked = children [i].checkedButtonPatient ()

            if (children [i + 3].checked)
                indxChecked = i
        }

        console.debug (indxPrevChecked, indxChecked)

        if (indxChecked === undefined) {
            if (indxPrevChecked === (countButton - 1))
                children [indxPrevChecked + 3].checked = true
            else {
                if (indxPrevChecked === 0) {
                    children [3].checked = true
                }
                else
                    ;
            }
        }
        else
            ;

        btnPatientListDown.enabled = enableButtonDown ()
    }

//    width: parent.width - columnColumnPatientFind.width
//    width: widthCvCaptureArea - widthManagmentArea - global_offset
//    height: parent.height

    visible: btnPatientArea.checked
    enabled: (! columnTraining.getButtonTrainingRun ().checked) && (! columnTreadmill.getButtonTrackRun ().checked)

    anchors.left: columnPatientFind.right
    anchors.leftMargin: global_offset

    anchors.right: columnCamera.left
    anchors.rightMargin: global_offset

    anchors.top: btnPatientTitle.bottom
    anchors.topMargin: global_offset

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1 * global_offset

//    color: parent.color
    color: "darkgray"

    function createButtonWithPatient (num) {
        var src = "HButtonPatient.qml"
        var obj = Qt.createComponent (src)

        if (obj.status === Component.Ready) {
            obj = obj.createObject (columnPatientList, {})
            if (obj === null)
                // Error Handling
                console.debug ("Ошибка создания", src)
            else {
                obj.objectName = "btnPatientList" + num
//                console.debug  (obj.objectName)

                obj.width = columnPatientList.width
//                obj.height = heightControl
                obj.height = btnPatientListUp.height
//                color: 'blue'
                obj.textUnchecked = "Пациент №" + num
//                textChecked: "Пациент №1"

                obj.colorUnchecked = "white"
                obj.colorChecked = "black"

                obj.colorText = "black"

                obj.checkable = true
//                obj.enabled = false
            }
        }
        else {
            console.log ("Ошибка загрузки", src, ":", obj.errorString ())
        }

        return obj;
    }

    Component.onCompleted: {
        var i, obj, objPrev

        for (i = 1; i < countButton + 1; i ++) {
            obj = createButtonWithPatient (i)
//            console.debug ("columnPatientList::onCompleted () = ", obj.objectName)

            if (i === 1) {
//                obj.parent = columnPatientList
                obj.anchors.top = btnPatientListUp.bottom
                obj.anchors.topMargin = spacing
                obj.anchors.topMargin += 2 //???

//                console.debug (btnPatientListDown.objectName, "btnPatientListDown.anchors.top = ", btnPatientListDown.anchors.top)
//                btnPatientListDown.anchors.top = obj.bottom
//                btnPatientListDown.anchors.topMargin = spacing
            }
            else {
                obj.anchors.top = objPrev.bottom
                obj.anchors.topMargin = spacing
            }

            obj.anchors.left = left
            obj.anchors.leftMargin = 0

            obj.anchors.right = right
            obj.anchors.rightMargin = 0

            obj.checkedButtonPatient ()

            objPrev = obj
        }

//        btnPatientListDown.anchors.top = obj.bottom
//        btnPatientListDown.anchors.topMargin = spacing

//        btnPatientListDown.top = countButton * heightControl + (countButton - 1) * parent.spacing
//        btnPatientListDown.top = (countButton + 1) * (heightControl + parent.spacing)

        function setTextButtonPatient (responseText) {
//            console.debug ("HColumnPatientList::setTextButtonPatient (), responseText =", responseText)
            var i, j, indxPatientChecked

            while (ScriptPatient.arPatients.length)
                ScriptPatient.arPatients.pop ()

            var responseJSON = JSON.parse (responseText), offset = eval (responseJSON ['offset'])
//            console.debug (children.length, responseJSON ['total_rows'])
            if (responseJSON ['total_rows']) {
                if ((countButton + 1) < responseJSON ['total_rows'])
                    btnPatientListDown.enabled = true
                else
                    ;

                for (i = offset, indxPatientChecked = 0; i < responseJSON ['total_rows']; i ++) {
                    ScriptPatient.arPatients.push (responseJSON ['rows'] [i.toString ()]['value'])
//                    console.debug ("БД данные =", arPatients [arPatients.length - 1], arPatients.length, responseJSON ['rows'][i.toString ()]['value'])
                    if (ScriptPatient.arPatients [ScriptPatient.arPatients.length - 1] ['_id'] === btnPatientTitle.patientJSON ['_id'])
                        indxPatientChecked = i
                }

                console.debug ("HColumnPatientList::setTextButtonPatient (), arPatients.length =", ScriptPatient.arPatients.length, j, indxPatientChecked)
                iScrollItem = indxPatientChecked

//                for (i = 1; i < (((countButton + 1) < responseJSON ['total_rows'] ? (countButton + 1) : responseJSON ['total_rows']) + 1); i ++, offset ++) {
                for (i = 3, j = indxPatientChecked; i < countButton + 3; i ++, j ++) { //3 - Индекс ПервОЙ кнопкИ с ФИО ПАЦиенТа
//                    console.debug (i, children [i].objectName)
//                    children [i].enabled = true

                    if (! (ScriptPatient.arPatients [i - 3] === undefined))
                        children [i].patientJSON = ScriptPatient.arPatients [j]
                    else
                        ;
                }
            }
            else
                ;
        }

        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "patients", "all", setTextButtonPatient)
    }

    function enableButtonDown () {
        if ((ScriptPatient.arPatients.length - countButton - iScrollItem) > 0)
            return true
        else
            return false
    }

    //Строка - описание
    Row {
        id: rowPatientListDesc
        parent: columnPatientList
        width: parent.width
        height: heightControl
        Text {
            y: parent.height / 2 - height / 2
            text: "Список"
            font {
                pixelSize: Math.round (widthManagmentArea * 0.1)
            }
        }
    }

    //Строка - Кнопка "Листать ВВЕРХ"
    HButton {
        id: btnPatientListUp
//        parent: unknown
        width: parent.width
        height: heightControl

        anchors.top: rowPatientListDesc.bottom
        anchors.topMargin: spacing

        colorChecked: '#5bc0de'
        colorUncheked: '#2f96b4'
        textUnchecked: "Листать ВВЕРХ"
//        textChecked: "Листать ВВЕРХ"

        colorTextUnchecked: "white"
        colorTextChecked: "white"

        checkable: false
        enabled: iScrollItem > 0 ? true : false

        onClicked: {
            iScrollItem --

            console.debug ("HButton::onClicked (); checked =", checkable, checked)
        }

        onDoubleClicked: {
        }

        Component.onCompleted: {
        }

        onHeightChanged: {
            if (parent.height) {
                var listChildren = parent.children, heightChildren = 0

//                console.debug ("btnPatientListUp::onHeightChanged:parent.children.length =", listChildren.length, "height =", height, "parent.height =", parent.height)

                spacing = (parent.height - listChildren.length * height) / (listChildren.length - 1)
                console.debug ("(parent.height - listChildren.length * height) / (listChildren.length - 1) =", spacing)

                for (var i = 3; i < listChildren.length; i ++) {
                    var obj = listChildren [i]
//                    console.debug (obj.objectName)
                    obj.height = height
                    obj.anchors.topMargin = spacing

                    if (i === 3)
                        obj.anchors.topMargin += 2 //???
                }
            }
            else
                ;
        }
    }

    //Строка - Кнопка "Листать ВНИЗ"
//    Row {
//        id: rowColumnPatientListDown
//        width: parent.width

        HButton {
            id: btnPatientListDown
            objectName: "btnPatientListDown"
//            parent: rowColumnPatientListDown

            width: parent.width
            height: heightControl

            colorChecked: '#5bc0de'
            colorUncheked: '#2f96b4'
//            color: 'blue'
            textUnchecked: "Листать ВНИЗ"
//            textChecked: "Листать ВНИЗ"

            colorTextUnchecked: "white"
            colorTextChecked: "white"

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            checkable: false
            enabled: enableButtonDown ()

            onClicked: {
                iScrollItem ++
            }

            onDoubleClicked: {
            }
        }
//    }
}
