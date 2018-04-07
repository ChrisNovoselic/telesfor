// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "patient.js" as ScriptPatient
import "hcouch.js" as ScriptHCouchDB

Rectangle {
//    id: columnPatientRoutine
    property int spacing: 6
    property int countButton: 5

    property int countButtonVisible: -1 //Math.floor (heightAreaButton / (heightControl + spacing))
    onCountButtonVisibleChanged: {
        btnPatientRoutineDown.enabled = enableButtonDown ()
    }
    property int heightAreaButton: height - 3 * heightControl - (3 - 1) * spacing
    onHeightAreaButtonChanged: {
        console.debug ("columnPatientRoutine::onHeightAreaButton:", height, heightAreaButton, heightControl)

        countButtonVisible = Math.floor (heightAreaButton / (heightControl + spacing))

        var spcng
        if (countButtonVisible > countButton)
            spcng = Math.round ((heightAreaButton - countButton * heightControl) / (countButton + 1))
        else
            spcng = Math.round ((heightAreaButton - countButtonVisible * heightControl) / (countButtonVisible + 1))

        console.debug ("columnPatientRoutine::onHeightAreaButtonChanged:", heightAreaButton, countButtonVisible, heightControl, spcng)

        if (children.length > 3) {
            var btnPatientRoutineChecked = undefined,
                indexPatientRoutineChecked = getIndexRoutineChecked ()

            console.debug ("HColumnPatientRoutine::onHeightAreaButtonChanged:indexPatientRoutineChecked =", indexPatientRoutineChecked)

            if (indexPatientRoutineChecked > -1) {
                for (var i = 3; i < countButton + 3; i ++) {
                    if (i <  (3 + countButtonVisible))
                    {
                        children [i].anchors.topMargin = spcng //spacingButton ()
                        children [i].visible = true

//                        console.debug ("columnPatientRoutine::onHeightAreaButtonChanged:btnPatientRoutineChecked =", btnPatientRoutineChecked.objectName)

                        if (! (indexPatientRoutineChecked < countButtonVisible)) {
                            iScrollItem = indexPatientRoutineChecked
                            children [i].routineJSON = ScriptPatient.arRoutines [indexPatientRoutineChecked + (i - 3)]
    //                        btnPatientRoutineChecked = undefined
                        }
                        else {
                            iScrollItem = 0
                            children [i].routineJSON = ScriptPatient.arRoutines [i - 3]
                        }
                    }
                    else
                        children [i].visible = false

                    console.debug ("columnPatientRoutine::onHeightAreaButtonChanged (visible, spacing) =", children [i].objectName, children [i].visible, children [i].anchors.topMargin)
                }

                console.debug ("columnPatientRoutine::onHeightAreaButtonChanged (indexPatientRoutineChecked) =", indexPatientRoutineChecked)

                var indexButtonPatientRoutineChecked = -1
                if (! (indexPatientRoutineChecked < countButtonVisible)) {
                    indexButtonPatientRoutineChecked = 3
                }
                else {
                    indexButtonPatientRoutineChecked = indexPatientRoutineChecked + 3
                }

                console.debug ("columnPatientRoutine::onHeightAreaButtonChanged (indexPatientRoutineChecked, children [].checked) =", indexPatientRoutineChecked, children [indexPatientRoutineChecked].checked)

                if (children [indexButtonPatientRoutineChecked].checked === true) {
////                uncheckedButtonRoutine (button)
//                sgnSetPatientRoutine (JSON.stringify (children [indexButtonPatientRoutineChecked].routineJSON))
                }
                else
                    children [indexButtonPatientRoutineChecked].checked = true

    //            sgnSetPatientRoutine (JSON.stringify (children [indexButtonPatientRoutineChecked].routineJSON))

                children [3].anchors.topMargin += 2 //??? Как в 'Component.onCompleted'
            }
            else
                ;  //Нет ещё индекСа ???
        }
        else
            ;
    }

    property int iScrollItem: 0
    onIScrollItemChanged: {
        var i, indxPrevChecked, indxChecked
        for (i = 0; i < countButtonVisible; i ++) { //3 - Индекс ПервОЙ кнопкИ с ФИО ПАЦиенТа
            if (children [i + 3].checked)
                indxPrevChecked = i

            children [i + 3].routineJSON = ScriptPatient.arRoutines [i + iScrollItem]

//            children [i].checked = children [i].checkedButtonRoutine ()

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

        btnPatientRoutineDown.enabled = enableButtonDown ()
    }

    width: widthManagmentArea

    visible: btnPatientArea.checked
//    enabled: ! columnTreadmill.getButtonTrackRun ().checked

    anchors.left: columnTreadmill.right
    anchors.leftMargin: global_offset

    anchors.top: columnPatientFind.bottom
    anchors.topMargin: global_offset

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1 * global_offset

    color: "darkgray"

    function createButtonWithRoutine (num) {
        var src = "HButtonRoutine.qml"
        var obj = Qt.createComponent (src)

        if (obj.status === Component.Ready) {
            obj = obj.createObject (columnPatientRoutine, {})
            if (obj === null)
                // Error Handling
                console.debug ("Ошибка создания", src)
            else {
                var textUnchecked, name
                switch (num) {
//                    case 1:
//                        name = "btnPatientRoutine" + 'Default'
//                        textUnchecked = "По умолчанию"
//                        break
//                    case 2:
//                        name = "btnPatientRoutine" + 'Custom'
//                        textUnchecked = "Произвольно"
//                        break
                    default:
                        name = "btnPatientRoutine" + num
                        textUnchecked = "Задание №" + num
                }

                obj.objectName = name
                obj.textUnchecked = textUnchecked

                obj.width = columnPatientRoutine.width
                obj.height = btnPatientRoutineUp.height

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

    function enableButtonDown () {
        if (((ScriptPatient.arRoutines.length) - countButtonVisible - iScrollItem) > 0)
//        if (((ScriptPatient.arRoutines.length + 1) - countButtonVisible - iScrollItem) > 0) //Без дублирования в 'ScriptPatient.arRoutines'
            return true
        else
            return false
    }

    function spacingButton () {
//        var heightAreaButton = height - 3 * heightControl - (3 - 1) * spacing
        return Math.ceil ((heightAreaButton - countButton * heightControl) / (countButton + 1))
    }

    function getIndexRoutineChecked () {
        var resIndex = -1, btnPatientRoutineChecked = getButtonRoutineChecked ()
        if (! (btnPatientRoutineChecked === undefined)) {
            for (var i = 0; i < ScriptPatient.arRoutines.length; i ++) {
                console.debug ("HColumnPatientRoutine::getIndexRoutineChecked () =", btnPatientRoutineChecked.routineJSON ["_id"],
                                                                                    ScriptPatient.arRoutines [i] ["_id"],
                                                                                    btnPatientRoutineChecked.routineJSON ["_id"] === ScriptPatient.arRoutines [i] ["_id"])
                if (btnPatientRoutineChecked.routineJSON ["_id"] === ScriptPatient.arRoutines [i] ["_id"]) {
                    resIndex = i
                    break
                }
                else
                    ;
            }
        }
        else
            ;

//        console.debug ("HColumnPatientRoutine::getIndexRoutineChecked () =", ScriptPatient.arRoutines.length, btnPatientRoutineChecked, resIndex)
        return resIndex
    }

    function getButtonRoutineChecked () {
        var resObj = undefined
        for (var i = 3; i < children.length; i ++) {
            var obj = children [i]
//            console.debug ("HColumnPatientRoutine::getButtonRoutineChecked () =", obj.objectName, obj.checked)
            if (obj.checked === true) {
                resObj = obj
                break
            }
            else
                ;
        }

        if (resObj === undefined)
            ; //console.debug ("HColumnPatientRoutine::getButtonRoutineChecked () =", resObj)
        else
            ; //console.debug ("HColumnPatientRoutine::getButtonRoutineChecked () =", resObj.objectName, resObj.checked)

        return resObj
    }

    Connections {
        target: rectangleForm
        onSgnGetPatientRoutine: {
            console.debug ("::onSgnGetPatientRoutine =", key)

            function setTextButtonRoutine (responseText) {
                var i
//                while (ScriptPatient.arRoutines.length > 1) { //Оставляем ТРЕНИРОВку по умолчанию
                while (ScriptPatient.arRoutines.length > 2) {  //НЕ НУЖНое ДУБЛирование ???
                    ScriptPatient.arRoutines.pop ()
                }

                var responseJSON = JSON.parse (responseText), offset = responseJSON ['offset']
                console.debug ("::onSgnGetPatientRoutine () total_rows =", responseJSON ['total_rows'])
                for (i = 0; i < responseJSON ['total_rows'] - offset; i ++) {
                    console.debug ("::onSgnGetPatientRoutine (arRoutines.push) =", i.toString ())
                    if (! (responseJSON ['rows'] [i.toString ()] === undefined))
                        ScriptPatient.arRoutines.push (responseJSON ['rows'] [i.toString ()] ['value'])
                    else
                        ;
                }

//                if ((countButtonVisible + 1) < ScriptPatient.arRoutines.length)
//                    btnPatientRoutineDown.enabled = true
//                else
//                    btnPatientRoutineDown.enabled = false

                console.debug ("::onSgnGetPatientRoutine:ScriptPatient.arRoutines.length =", ScriptPatient.arRoutines.length)
                if (ScriptPatient.arRoutines.length) {
                    for (i = 1; i < countButton + 1; i ++) { //3 - Индекс ПервОЙ кнопкИ с ЗАДАНИЕм дЛя ПАЦиенТа
//                        if (! (ScriptPatient.arRoutines [i - 1] === undefined))
//                            if (i - 1 < ScriptPatient.arRoutines.length) {
                                var routine
//                                switch (i) {
//                                    case 1:
//                                    case 2:
//                                        routine = ScriptPatient.arRoutines [0]
//                                        break
//                                    default:
//                                        routine = ScriptPatient.arRoutines [i - 2]
//                                }

                                routine = ScriptPatient.arRoutines [i - 1]

//                                console.debug ("::onSgnGetPatientRoutine: routineJSON =", i, JSON.stringify (routine))
                                children [2 + i].routineJSON = routine
//                            }
//                            else
//                                ;
//                        else
//                            children [i].routineJSON = undefined
                    }
                }
                else { //НИКОГДа НЕ ВЫПОЛНяЕТСя, т.к. 'ScriptPatient.arRoutines.length >= 1' (заданиЕ по умолчанию)
                    for (i = 3; i < countButton + 3; i ++) { //3 - Индекс ПервОЙ кнопкИ с ЗАДАНИЕм дЛя ПАЦиенТа
                        children [i].routineJSON = undefined
                    }

                    console.debug ("HColumnPatientRoutine::onSgnGetPatientRoutine:SetParamDefault...")

                    paramTrackSpeed.val = paramTrackSpeed.default_val
                    paramTrackTilt.val = paramTrackTilt.default_val
                    paramStepsLength.val = paramStepsLength.default_val
                    paramTrainingDistance.val = paramTrainingDistance.default_val

                    paramTrainingTime.val = paramTrainingTime.default_val
                }

                iScrollItem = 0
                btnPatientRoutineDown.enabled = enableButtonDown ()

                children [3].checked = true
            }

            ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "routines", "patient", setTextButtonRoutine, key)
        }
    }

    Component.onCompleted: {
        console.debug ("columnPatientRoutine::onCompleted", height, heightControl, children.length)

        var i, obj, objPrev

        for (i = 1; i < countButton + 1; i ++) {
            obj = createButtonWithRoutine (i)
            console.debug ("columnPatientRoutine::onCompleted () = ", obj.objectName)

            if (i === 1) {
//                obj.parent = columnPatientRoutine
                obj.anchors.top = btnPatientRoutineUp.bottom
                obj.anchors.topMargin = spacing
                obj.anchors.topMargin += 2 //???

//                console.debug (btnPatientRoutineDown.objectName, "btnPatientRoutineDown.anchors.top = ", btnPatientRoutineDown.anchors.top)
//                btnPatientRoutineDown.anchors.top = obj.bottom
//                btnPatientRoutineDown.anchors.topMargin = spacing
            }
            else {
                obj.anchors.top = objPrev.bottom
                obj.anchors.topMargin = spacingButton () //spacing
            }

            obj.anchors.left = left
            obj.anchors.leftMargin = 0

            obj.anchors.right = right
            obj.anchors.rightMargin = 0

//            obj.checkedButtonRoutine ()

            objPrev = obj
        }

        function setParams (obj, paramJSON) {
            console.debug ("HColumnPatientRoutine::onCompleted::setParams =", JSON.stringify (paramJSON), paramJSON [""])

            obj.min_val = paramJSON ["params"] ["min"]
            obj.max_val = paramJSON ["params"] ["max"]
            obj.step_val = paramJSON ["params"] ["step"]
            obj.coeff_val = paramJSON ["params"] ["coeff"]

            obj.default_val = paramJSON ["params"] ["default"]
            obj.val = paramJSON [""]
        }

        function setRoutineDefault (responseText) {
            console.debug ("HColumnPatientRoutine::onCompleted::setRoutineDefault () =", responseText)
            var i

            var responseJSON = JSON.parse (responseText), offset = responseJSON ['offset']
            console.debug ("HColumnPatientRoutine::onCompleted::setDefaultRoutine () total_rows =", responseJSON ['total_rows'])
            setParams (paramTrackTilt, responseJSON ['rows'] [offset.toString ()] ["value"] ["intervals"] ["0"] ["incline"])
            setParams (paramTrackSpeed, responseJSON ['rows'] [offset.toString ()] ["value"] ["intervals"] ["0"] ["speed"])
            setParams (paramTrainingDistance, responseJSON ['rows'] [offset.toString ()] ["value"] ["intervals"] ["0"] ["distance"])
            setParams (paramTrainingTime, responseJSON ['rows'] [offset.toString ()] ["value"] ["intervals"] ["0"] ["duration"])
            setParams (paramStepsLength, responseJSON ['rows'] [offset.toString ()] ["value"] ["intervals"] ["0"] ["stepsLength"])

            ScriptPatient.arRoutines.push (responseJSON ['rows'] [offset.toString ()] ["value"])
            //НЕ НУЖНое ДУБЛироваНие ???
            //Но избегаем проблеМ со скроЛЛингОМ в эТОй 'column'
//            ScriptPatient.arRoutines.push (responseJSON ['rows'] [offset.toString ()] ["value"])
        }

        function setRoutineCustom (responseText) {
            console.debug ("HColumnPatientRoutine::onCompleted::setRoutineCustom () =", responseText)
            ScriptPatient.arRoutines.push (JSON.parse (responseText) ['rows'] [JSON.parse (responseText) ['offset'].toString ()] ["value"])
        }

        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "routines", "default", setRoutineDefault)
        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "routines", "custom", setRoutineCustom)
    }

    onHeightChanged: {
        console.debug ("columnPatientRoutine::onHeightChanged:", height, heightControl)
    }

    //Строка - описание
    Row {
        id: rowColumnPatientRoutineDesc
//        parent: rowPatient
        width: parent.width
        height: heightControl
        Text {
            y: parent.height / 2 - height / 2
            text: "Задания"
            font {
                pixelSize: Math.round (widthManagmentArea * 0.1)
            }
        }
    }

    //Кнопка "Листать ВВЕРХ"
    HButton {
        id: btnPatientRoutineUp
//        parent: unknown
        width: parent.width
        height: heightControl

        anchors.top: rowColumnPatientRoutineDesc.bottom
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

//                console.debug ("btnPatientRoutineUp::onHeightChanged:parent.children.length =", listChildren.length, "height =", height, "parent.height =", parent.height)

//                spacing = Math.floor ((parent.height - listChildren.length * height) / (listChildren.length - 1))
//                console.debug ("(parent.height - listChildren.length * height) / (listChildren.length - 1) =", spacing)

                for (var i = 3; i < listChildren.length; i ++) {
                    var obj = listChildren [i]
//                    console.debug (obj.objectName)
                    obj.height = height
                    obj.anchors.topMargin = spacingButton ()

                    if (i === 3)
                        obj.anchors.topMargin += 2 //???
                }
            }
            else
                ;
        }
    }

//    //Кнопка "Тренировка по умолчанию"
//    HButtonRoutine {
//        id: btnPatientRoutineDefault
//        objectName: "btnPatientRoutineDefault"

//        width: parent.width
//        height: heightControl

//        colorChecked: '#5bc0de'
//        colorUncheked: '#2f96b4'
//        textUnchecked: "По умолчанию"

//        colorTextUnchecked: "white"
//        colorTextChecked: "white"

//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 0

//        checkable: true
//        enabled: enableButtonDown ()

//        onClicked: {
//        }

//        onDoubleClicked: {
//        }
//    }

//    //Кнопка "Тренировка по умолчанию"
//    HButtonRoutine {
//        id: btnPatientRoutineCustom
//        objectName: "btnPatientRoutineCustom"

//        width: parent.width
//        height: heightControl

//        colorChecked: '#5bc0de'
//        colorUncheked: '#2f96b4'
//        textUnchecked: "Произвольно"

//        colorTextUnchecked: "white"
//        colorTextChecked: "white"

//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 0

//        checkable: true
//        enabled: enableButtonDown ()

//        onClicked: {
//        }

//        onDoubleClicked: {
//        }
//    }

    //Кнопка "Листать ВНИЗ"
    HButton {
        id: btnPatientRoutineDown
        objectName: "btnPatientRoutineDown"

        width: parent.width
        height: heightControl

        colorChecked: '#5bc0de'
        colorUncheked: '#2f96b4'
        textUnchecked: "Листать ВНИЗ"

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
}
