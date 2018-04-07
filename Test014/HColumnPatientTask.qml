// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "patient.js" as ScriptPatient
import "hcouch.js" as ScriptHCouchDB

Rectangle {
//    id: columnPatientTask
    property int spacing: 6
    property int countButton: 5

    property int countButtonVisible: -1 //Math.floor (heightAreaButton / (heightControl + spacing))
    onCountButtonVisibleChanged: {
        btnPatientTaskDown.enabled = enableButtonDown ()
    }
    property int heightAreaButton: height - 3 * heightControl - (3 - 1) * spacing
    onHeightAreaButtonChanged: {
        console.debug ("columnPatientTask::onHeightAreaButton:", height, heightAreaButton, heightControl)

        countButtonVisible = Math.floor (heightAreaButton / (heightControl + spacing))

        var spcng
        if (countButtonVisible > countButton)
            spcng = Math.round ((heightAreaButton - countButton * heightControl) / (countButton + 1))
        else
            spcng = Math.round ((heightAreaButton - countButtonVisible * heightControl) / (countButtonVisible + 1))

        console.debug ("columnPatientTask::onHeightAreaButtonChanged:", heightAreaButton, countButtonVisible, heightControl, spcng)

        if (children.length > 3) {
            var btnPatientTaskChecked = undefined,
                indexPatientTaskChecked = getIndexTaskChecked ()

            console.debug ("HColumnPatientTask::onHeightAreaButtonChanged:indexPatientTaskChecked =", indexPatientTaskChecked)

            for (var i = 3; i < countButton + 3; i ++) {
                if (i <  (3 + countButtonVisible))
                {
                    children [i].anchors.topMargin = spcng //spacingButton ()
                    children [i].visible = true

//                    console.debug ("columnPatientTask::onHeightAreaButtonChanged:btnPatientTaskChecked =", btnPatientTaskChecked.objectName)

                    if (! (indexPatientTaskChecked < countButtonVisible)) {
                        iScrollItem = indexPatientTaskChecked
                        children [i].taskJSON = ScriptPatient.arTasks [indexPatientTaskChecked + (i - 3)]
//                        btnPatientTaskChecked = undefined
                    }
                    else {
                        iScrollItem = 0
                        children [i].taskJSON = ScriptPatient.arTasks [i - 3]
                    }
                }
                else
                    children [i].visible = false

                console.debug ("columnPatientTask::onHeightAreaButtonChanged (visible, spacing) =", children [i].objectName, children [i].visible, children [i].anchors.topMargin)
            }

            console.debug ("columnPatientTask::onHeightAreaButtonChanged (indexPatientTaskChecked) =", indexPatientTaskChecked)

            var indexButtonPatientTaskChecked = -1
            if (! (indexPatientTaskChecked < countButtonVisible)) {
                indexButtonPatientTaskChecked = 3
            }
            else {
                indexButtonPatientTaskChecked = indexPatientTaskChecked + 3
            }

            console.debug ("columnPatientTask::onHeightAreaButtonChanged (indexPatientTaskChecked, children [].checked) =", indexPatientTaskChecked, children [indexPatientTaskChecked].checked)

            if (children [indexButtonPatientTaskChecked].checked === true) {
////                uncheckedButtonTask (button)
//                sgnSetPatientTask (JSON.stringify (children [indexButtonPatientTaskChecked].taskJSON))
            }
            else
                children [indexButtonPatientTaskChecked].checked = true

//            sgnSetPatientTask (JSON.stringify (children [indexButtonPatientTaskChecked].taskJSON))

            children [3].anchors.topMargin += 2 //??? Как в 'Component.onCompleted'
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

            children [i + 3].taskJSON = ScriptPatient.arTasks [i + iScrollItem]

//            children [i].checked = children [i].checkedButtonTask ()

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

        btnPatientTaskDown.enabled = enableButtonDown ()
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

    function createButtonWithTask (num) {
        var src = "HButtonTask.qml"
        var obj = Qt.createComponent (src)

        if (obj.status === Component.Ready) {
            obj = obj.createObject (columnPatientTask, {})
            if (obj === null)
                // Error Handling
                console.debug ("Ошибка создания", src)
            else {
                var textUnchecked, name
                switch (num) {
//                    case 1:
//                        name = "btnPatientTask" + 'Default'
//                        textUnchecked = "По умолчанию"
//                        break
//                    case 2:
//                        name = "btnPatientTask" + 'Custom'
//                        textUnchecked = "Произвольно"
//                        break
                    default:
                        name = "btnPatientTask" + num
                        textUnchecked = "Задание №" + num
                }

                obj.objectName = name
                obj.textUnchecked = textUnchecked

                obj.width = columnPatientTask.width
                obj.height = btnPatientTaskUp.height

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
        if (((ScriptPatient.arTasks.length) - countButtonVisible - iScrollItem) > 0)
//        if (((ScriptPatient.arTasks.length + 1) - countButtonVisible - iScrollItem) > 0) //Без дублирования в 'ScriptPatient.arTasks'
            return true
        else
            return false
    }

    function spacingButton () {
//        var heightAreaButton = height - 3 * heightControl - (3 - 1) * spacing
        return Math.ceil ((heightAreaButton - countButton * heightControl) / (countButton + 1))
    }

    function getIndexTaskChecked () {
        var resIndex = -1, btnPatientTaskChecked = getButtonTaskChecked ()
        for (var i = 0; i < ScriptPatient.arTasks.length; i ++) {
            if (btnPatientTaskChecked.taskJSON ["_id"] === ScriptPatient.arTasks [i] ["_id"]) {
                resIndex = i
                break
            }
            else
                ;
        }

        return resIndex
    }

    function getButtonTaskChecked () {
        var resObj = undefined
        for (var i = 3; i < children.length; i ++) {
            var obj = children [i]
//            console.debug ("HColumnPatientTask::getButtonTaskChecked () =", obj.objectName, obj.checked)
            if (obj.checked === true) {
                resObj = obj
                break
            }
            else
                ;
        }

        if (resObj === undefined)
            console.debug ("HColumnPatientTask::getButtonTaskChecked () =", resObj)
        else
            console.debug ("HColumnPatientTask::getButtonTaskChecked () =", resObj.objectName, resObj.checked)
        return resObj
    }

    Connections {
        target: rectangleForm
        onSgnGetPatientTask: {
            console.debug ("::onSgnGetPatientTask =", key)

            function setTextButtonTask (responseText) {
                var i
//                while (ScriptPatient.arTasks.length > 1) { //Оставляем ТРЕНИРОВку по умолчанию
                while (ScriptPatient.arTasks.length > 2) {  //НЕ НУЖНое ДУБЛирование ???
                    ScriptPatient.arTasks.pop ()
                }

                var responseJSON = JSON.parse (responseText), offset = responseJSON ['offset']
                console.debug ("::onSgnGetPatientTask () total_rows =", responseJSON ['total_rows'])
                for (i = 0; i < responseJSON ['total_rows'] - offset; i ++) {
                    console.debug ("::onSgnGetPatientTask (arTasks.push) =", i.toString ())
                    if (! (responseJSON ['rows'][i.toString ()] === undefined))
                        ScriptPatient.arTasks.push (responseJSON ['rows'][i.toString ()]['value'])
                    else
                        ;
                }

//                if ((countButtonVisible + 1) < ScriptPatient.arTasks.length)
//                    btnPatientTaskDown.enabled = true
//                else
//                    btnPatientTaskDown.enabled = false

                console.debug ("::onSgnGetPatientTask:ScriptPatient.arTasks.length =", ScriptPatient.arTasks.length)
                if (ScriptPatient.arTasks.length) {
                    for (i = 1; i < countButton + 1; i ++) { //3 - Индекс ПервОЙ кнопкИ с ЗАДАНИЕм дЛя ПАЦиенТа
//                        if (! (ScriptPatient.arTasks [i - 1] === undefined))
//                            if (i - 1 < ScriptPatient.arTasks.length) {
                                var task
//                                switch (i) {
//                                    case 1:
//                                    case 2:
//                                        task = ScriptPatient.arTasks [0]
//                                        break
//                                    default:
//                                        task = ScriptPatient.arTasks [i - 2]
//                                }

                                task = ScriptPatient.arTasks [i - 1]

//                                console.debug ("::onSgnGetPatientTask: taskJSON =", i, JSON.stringify (task))
                                children [2 + i].taskJSON = task
//                            }
//                            else
//                                ;
//                        else
//                            children [i].taskJSON = undefined
                    }
                }
                else { //НИКОГДа НЕ ВЫПОЛНяЕТСя, т.к. 'ScriptPatient.arTasks.length >= 1' (заданиЕ по умолчанию)
                    for (i = 3; i < countButton + 3; i ++) { //3 - Индекс ПервОЙ кнопкИ с ЗАДАНИЕм дЛя ПАЦиенТа
                        children [i].taskJSON = undefined
                    }

                    console.debug ("HColumnPatientTask::onSgnGetPatientTask:SetParamDefault...")

                    paramTrackSpeed.val = paramTrackSpeed.default_val
                    paramTrackTilt.val = paramTrackTilt.default_val
                    paramStepsLength.val = paramStepsLength.default_val
                    paramTrainingDistance.val = paramTrainingDistance.default_val

                    paramTrainingTime.val = paramTrainingTime.default_val
                }

                iScrollItem = 0
                btnPatientTaskDown.enabled = enableButtonDown ()

                children [3].checked = true
            }

            ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "tasks", "tasksPatient", setTextButtonTask, key)
        }
    }

    Component.onCompleted: {
        console.debug ("columnPatientTask::onCompleted", height, heightControl, children.length)

        var i, obj, objPrev

        for (i = 1; i < countButton + 1; i ++) {
            obj = createButtonWithTask (i)
            console.debug ("columnPatientTask::onCompleted () = ", obj.objectName)

            if (i === 1) {
//                obj.parent = columnPatientTask
                obj.anchors.top = btnPatientTaskUp.bottom
                obj.anchors.topMargin = spacing
                obj.anchors.topMargin += 2 //???

//                console.debug (btnPatientTaskDown.objectName, "btnPatientTaskDown.anchors.top = ", btnPatientTaskDown.anchors.top)
//                btnPatientTaskDown.anchors.top = obj.bottom
//                btnPatientTaskDown.anchors.topMargin = spacing
            }
            else {
                obj.anchors.top = objPrev.bottom
                obj.anchors.topMargin = spacingButton () //spacing
            }

            obj.anchors.left = left
            obj.anchors.leftMargin = 0

            obj.anchors.right = right
            obj.anchors.rightMargin = 0

//            obj.checkedButtonTask ()

            objPrev = obj
        }

        function setParams (obj, paramJSON) {
            console.debug ("HColumnPatientTask::onCompleted::setParams =", JSON.stringify (paramJSON), paramJSON ["value"] ["0"])

            obj.min_val = paramJSON ["min"]
            obj.max_val = paramJSON ["max"]
            obj.step_val = paramJSON ["step"]
            obj.coeff_val = paramJSON ["coeff"]

            obj.default_val = paramJSON ["default"]
            obj.val = paramJSON ["value"] ["0"]
        }

        function setTaskDefault (responseText) {
            console.debug ("HColumnPatientTask::onCompleted::setTaskDefault () =", responseText)
            var i

            var responseJSON = JSON.parse (responseText), offset = responseJSON ['offset']
//            console.debug ("HColumnPatientTask::onCompleted::setDefaultTask () total_rows =", responseJSON ['total_rows'])
            setParams (paramTrackTilt, responseJSON ['rows'] [offset.toString ()] ["value"] ["tilt"])
            setParams (paramTrackSpeed, responseJSON ['rows'] [offset.toString ()] ["value"] ["speed"])
            setParams (paramTrainingDistance, responseJSON ['rows'] [offset.toString ()] ["value"] ["distance"])
            setParams (paramTrainingTime, responseJSON ['rows'] [offset.toString ()] ["value"] ["time"])
            setParams (paramStepsLength, responseJSON ['rows'] [offset.toString ()] ["value"] ["stepsLength"])

            ScriptPatient.arTasks.push (responseJSON ['rows'] [offset.toString ()] ["value"])
            //НЕ НУЖНое ДУБЛироваНие ???
            //Но избегаем проблеМ со скроЛЛингОМ в эТОй 'column'
//            ScriptPatient.arTasks.push (responseJSON ['rows'] [offset.toString ()] ["value"])
        }

        function setTaskCustom (responseText) {
            console.debug ("HColumnPatientTask::onCompleted::setTaskCustom () =", responseText)
            ScriptPatient.arTasks.push (JSON.parse (responseText) ['rows'] [JSON.parse (responseText) ['offset'].toString ()] ["value"])
        }

        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "tasks", "taskDefault", setTaskDefault)
        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "tasks", "taskCustom", setTaskCustom)
    }

    onHeightChanged: {
        console.debug ("columnPatientTask::onHeightChanged:", height, heightControl)
    }

    //Строка - описание
    Row {
        id: rowColumnPatientTaskDesc
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
        id: btnPatientTaskUp
//        parent: unknown
        width: parent.width
        height: heightControl

        anchors.top: rowColumnPatientTaskDesc.bottom
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

//                console.debug ("btnPatientTaskUp::onHeightChanged:parent.children.length =", listChildren.length, "height =", height, "parent.height =", parent.height)

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
//    HButtonTask {
//        id: btnPatientTaskDefault
//        objectName: "btnPatientTaskDefault"

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
//    HButtonTask {
//        id: btnPatientTaskCustom
//        objectName: "btnPatientTaskCustom"

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
        id: btnPatientTaskDown
        objectName: "btnPatientTaskDown"

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
