// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.

//import "timerspeed.js" as ScriptTimerSpeed

import "hcouch.js" as ScriptHCouchDB

Column {
//    id: columnTraining
    spacing: 6

    move: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.OutBounce }
    }

//    x: ScriptCvCapture.posXItem (0, 0)
    width: widthManagmentArea

    anchors.left: parent.left
    anchors.leftMargin: global_offset
    anchors.bottom: parent.bottom
    anchors.bottomMargin: global_offset

//    Для того, чтобы убрать/вставить одну строку необходимы изменения в 2-х местах
//    1) сама строка visible = false
//    2) сама строка onCompleted ВСЕ anchors заремаркировать
//    3) в строке выше изменить вызовы 'parent.magnifier' в 'magnifier' ДВАжды
//    4) в строке ниже anchors на строку выше

    function hidePopupWindow () { rectanglePopupTraining.visible = false }

    function magnifier (objParam, objTop, objBottom) {
//        sgnTrainingStatisticActivate ()
        columnStatistic.hideButtonsReport ()

        rectanglePopupTraining.object = objParam
        console.debug ("columnTraining::magnifier ()", rectanglePopupTraining.object.val,
                                                        rectanglePopupTraining.object.min_val,
                                                        rectanglePopupTraining.object.max_val,
                                                        rectanglePopupTraining.object.step_val,
                                                        rectanglePopupTraining.object.coeff_val)

        rectanglePopupTraining.visible = true

        rectanglePopupTraining.objectRowTop = objTop
        rectanglePopupTraining.objectRowBottom = objBottom
    }

    function enabledParam () {
        var btnPatientRoutine = columnPatientRoutine.getButtonRoutineChecked (), bRes = false
        if (! (btnPatientRoutine === undefined)) {
            if (btnPatientRoutine.routineJSON ["_id"].indexOf ("custom") > -1) {
//                if (! columnTreadmill.getButtonTrackRun ().checked)
                    bRes = true
//                else
//                    ;
            }
            else
                ;
        }
        else
            ;

//        bRes = bRes && (! columnTreadmill.getButtonTrackRun ().checked)

        if (bRes === false)
            rectanglePopupTraining.visible = false
        else
            ;

        return bRes
    }

    function getButtonTrainingRun () { return btnTrainingRun }

    Connections {
        target: rectangleForm
        onSgnSetPatientRoutine: {
            var routineJSON = JSON.parse (routine), putData = ""
            console.debug ("HColumnTraining::onSgnSetPatientRoutine:routine =", routine)
//            console.debug ("rectangleForm::onSgnSetPatientRoutine = ", routine, routineJSON ["speed"] [sliderCurrentTrainingStage.toString ()] ["value"])
//            console.debug ("HColumnTraining::onSgnSetPatientRoutine =", routineJSON ["speed"] [sliderCurrentTrainingStage.toString ()] ["value"])

            function paramChangeValue (name, obj, val) {
                console.debug ("HColumnTraining::onSgnSetPatientRoutine:paramChangeValue =", name, obj, val)
                if (! (obj.val === val)) {
                    obj.val = val
                }
                else
                    ;

//                Накопливаем для ЗАПИСи толЬкО в случае проведения ТРЕНИРОВКи
//                if (columnTreadmill.getButtonTrackRun ().checked && columnTraining.getButtonTrainingRun ().checked) {
                if (columnTreadmill.getButtonTrackRun ().checked) { //При отладке
//                    console.debug ("HColumnTraining::onSgnSetPatientRoutine:paramChangeValue =", name, obj.val)

//                    if (name.indexOf ("time") > -1) {
//                        putData += makePutData (name, sliderCurrentTrainingStage - 1, sliderCurrentTime) + ','
//                        console.debug ("HColumnTraining::onSgnSetPatientRoutine:paramChangeValue =", "TIME", sliderCurrentTime)
//                    }
//                    else {
//                        if (name.indexOf ("distance") > -1) {
//                            putData += makePutData (name, sliderCurrentTrainingStage - 1, sliderCurrentDistance) + ','
//                            console.debug ("HColumnTraining::onSgnSetPatientRoutine:paramChangeValue =", "DISTANCE", sliderCurrentDistance)
//                        }
//                        else {
//                            putData += makePutData (name, sliderCurrentTrainingStage, val) + ','
//                            console.debug ("HColumnTraining::onSgnSetPatientRoutine:paramChangeValue =", name, val)
//                        }
//                    }
                }
                else
                    ;
            }

            console.debug ("HColumnTraining::onSgnSetPatientRoutine (sliderCurrentTrainingStage, sliderCurrentTime, sliderCurrentDistance)", sliderCurrentTrainingStage, sliderCurrentTime, sliderCurrentDistance)

            if (routineJSON ["_id"].indexOf ("default") > -1) {
                paramChangeValue ("tilt", paramTrackTilt, routineJSON ["intervals"] [sliderCurrentTrainingStage.toString ()] ["incline"] [""])
                paramChangeValue ("distance", paramTrainingDistance, routineJSON ["intervals"] [sliderCurrentTrainingStage.toString ()] ["distance"] [""])
                paramChangeValue ("time", paramTrainingTime, routineJSON ["intervals"] [sliderCurrentTrainingStage.toString ()] ["duration"] [""])
                paramChangeValue ("stepsLength", paramStepsLength, routineJSON ["intervals"] [sliderCurrentTrainingStage.toString ()] ["stepsLength"] [""])
                paramChangeValue ("speed", paramTrackSpeed, routineJSON ["intervals"] [sliderCurrentTrainingStage.toString ()] ["speed"] [""])
            }
            else {
                var stage

                 if (routineJSON ["_id"].indexOf ("custom") > -1)
                    stage = ((sliderTrainingStage - 1) + sliderCurrentTrainingStage).toString ()
                 else
                     stage = sliderCurrentTrainingStage.toString ()

                paramChangeValue ("tilt", paramTrackTilt, routineJSON ["intervals"] [stage] ["incline"])
                paramChangeValue ("distance", paramTrainingDistance, routineJSON ["intervals"] [stage] ["distance"])
                paramChangeValue ("time", paramTrainingTime, routineJSON ["intervals"] [stage] ["duration"])
                paramChangeValue ("stepsLength", paramStepsLength, routineJSON ["intervals"] [stage] ["stepsLength"])
                paramChangeValue ("speed", paramTrackSpeed, routineJSON ["intervals"] [stage] ["speed"])
            }

//            ЗаписЬ ТОЛьКО в слУчаЕ проведения ТРЕНИРОВКи
//            if (columnTraining.getButtonTrainingRun ().checked) {
            if (columnTreadmill.getButtonTrackRun ().checked && columnTraining.getButtonTrainingRun ().checked) {
//            if (columnTreadmill.getButtonTrackRun ().checked) { //При отладке
//                putData = putData.substring (0, putData.length - 1) //УдалЯем КРАЙнЮЮ запЯтуЮ

                var dtStamp = new Date ()
//                putData = JSON.parse ('{"intervals":{"' + (sliderCurrentTrainingStage - 1).toString () + '":{}},{"' + (sliderCurrentTrainingStage - 0).toString () + '":{}}}')
////                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['type'] = 'idle'
////                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['timeStamp'] = dtStamp.toTimeString ()
////                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['speed'] = '666'
////                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['tilt'] = '666'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['time'] = '667'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['distance'] = '667'
////                putData ['intervals'] [(sliderCurrentTrainingStage - 1).toString ()] ['stepsLength'] = '666'

//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['type'] = 'work'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['timeStamp'] = dtStamp.toTimeString ()
//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['speed'] = '667'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['tilt'] = '667'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['time'] = '0'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['distance'] = '0'
//                putData ['intervals'] [(sliderCurrentTrainingStage - 0).toString ()] ['stepsLength'] = '667'

                putData = '{"intervals":{' +
                                '"' + (((sliderTrainingStage - 1) + sliderCurrentTrainingStage) - 1).toString () + '":{' +
//                                    '"type":"idle"' + ',' +
//                                    '"timeStamp":"' + dtStamp.toTimeString () + '"' + ',' +
//                                    '"speed":"666"' + ',' +
//                                    '"incline":"666"' + ',' +
                                    '"duration":"' + sliderCurrentTime + '"' + ',' +
                                    '"distance":"' + sliderCurrentDistance + '"' + //',' +
//                                    '"stepsLength":"666"' + '' +
                                '}' + ',' +
                                '"' + (((sliderTrainingStage - 1) + sliderCurrentTrainingStage) - 0).toString () + '":{' +
                                    '"type":"work"' + ',' +
                                    '"timeStamp":"' + dtStamp.toTimeString () + '"' + ',' +
                                    '"speed":"' + paramTrackSpeed.val + '"' + ',' +
                                    '"incline":"' + paramTrackTilt.val + '"' + ',' +
//                                    '"duration":"666"' + ',' +
//                                    '"distance":"666"' + ',' +
                                    '"stepsLength":"' + paramStepsLength.val + '"' + '' +
                                '}' + //',{' +
                            '}}' //Обрамление '{}' длЯ 'JSON.parse'

                console.debug ("HColumnTraining::onSgnSetPatientRoutine putData =", JSON.stringify (putData))

                sgnPutCouchDB (nameDB, typeContent, idTraining, JSON.parse (putData ))

                nextStageTimeDistance ()
            }
            else
                ;
        }
    }

    Component.onCompleted: {
    }

    //Строка - описание (Тренировка)
    Row {


        width: parent.width
        Text {
            y: parent.height / 2 - height / 2
            text: "Тренировка"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }

    //Строка - Начало (сброс) тренировки
    Row {
        id: rowColumnTrainingButton
        width: parent.width
        HButton {
            id: btnTrainingRun
//            parent: rowBeginTraining
            width: parent.width
            height: heightControl
//            color: 'blue'
            textUnchecked: "Начало"
            textChecked: "Конец"

            checkable: true
            enabled: ! columnTreadmill.getButtonTrackRun ().checked
            onEnabledChanged: {
                console.debug ("btnTrainingRun::onEnabledChanged")
            }

            onCheckedChanged: {
                console.debug ("btnTrainingRun::onCheckedChanged", checked)

                if (checked) {
                    sgnTrainingStart (paramTrackSpeed.val, paramTrackTilt.val, paramStepsLength.val)

                    sgnResetStatistic ()
                }
                else {
                    sgnTrainingStop ()
                }
            }

            onClicked: {
//                console.debug ("btnTrainingRun::onClicked")
            }

            onDoubleClicked: {
            }
        }
    }

    //Строка - описание (Скорость)
    Row {
        id: rowColumnTrainingSpeed
        parent: columnTraining
        width: parent.width
        height: heightControl

        enabled: enabledParam () //&& (! columnTreadmill.getButtonTrackRun ().checked))

        function magnifier () {
            console.debug ("rowColumnTrainingSpeed::magnifier () rectanglePopupTraining.object =", rectanglePopupTraining.object)
            if (rectanglePopupTraining.object === undefined)
                parent.magnifier (paramTrackSpeed, rowColumnTrainingSpeed, rowColumnTrainingTilt)
            else {
                if (rectanglePopupTraining.object === paramTrackSpeed)
                    rectanglePopupTraining.visible = false
                else {
                    rectanglePopupTraining.visible = false
                    parent.magnifier (paramTrackSpeed, rowColumnTrainingSpeed, rowColumnTrainingTilt)
                }
            }
        }

        Component.onCompleted: {
//            anchors.bottom = rowColumnTrainingTilt.top
//            anchors.bottomMargin = parent.spacing
        }

        Text {
            id: textRowTrackSpeedDescription
            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl
            text: "Скорость (км/ч)"
            font {
                pixelSize: Math.round (parent.width * 0.08)
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignLeft"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingSpeed.magnifier ()
                }
            }
        }

        TextField {
            id: textFieldSliderTrackSpeed
//            parent: rowSliderTrackSpeed
            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            backgroundColor: "green"

            text: paramTrackSpeed.val.toFixed (1)
            font {
                pixelSize: Math.round (height * ratioHeightTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

            onClipChanged: {
                console.debug ("textFieldSliderTrackSpeed::onClipChanged")
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingSpeed.magnifier ()
                }
            }

            Component.onCompleted: {
//                paramTrackSpeed.objectTextField = textFieldSliderTrackSpeed
            }
        }
    }

    //Строка - описание (Наклон)
    Row {
        id: rowColumnTrainingTilt
        parent: columnTraining
        width: parent.width

        enabled: enabledParam ()

        function magnifier () {
            if (rectanglePopupTraining.object === undefined)
                parent.magnifier (paramTrackTilt, rowColumnTrainingTilt, rowColumnTrainingTime)
            else {
                if (rectanglePopupTraining.object === paramTrackTilt)
                    rectanglePopupTraining.visible = false
                else {
                    rectanglePopupTraining.visible = false
                    parent.magnifier (paramTrackTilt, rowColumnTrainingTilt, rowColumnTrainingTime)
                }
            }
        }

        Component.onCompleted: {
            anchors.top = rowColumnTrainingSpeed.bottom
            anchors.topMargin = parent.spacing
        }

        Text {
            id: textRowTrackTiltDescription

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Наклон (град.)"
            font {
                pixelSize: Math.round (parent.width * 0.08)
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignLeft"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingTilt.magnifier ()
                }
            }
        }

        TextField {
            id: textFieldSliderTrackTilt
//            parent: rowSliderTrackTilt
            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            readOnly: true

            text: paramTrackTilt.val
            font {
                pixelSize: Math.round (height * ratioHeightTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingTilt.magnifier ()
                }
            }

            Component.onCompleted: {
                paramTrackTilt.objectTextField = textFieldSliderTrackTilt
            }
        }
    }

    //Строка - описание/управление (Время)
    Row {
        id: rowColumnTrainingTime
        parent: columnTraining
        width: parent.width

        enabled: (enabledParam ()) && (! btnTrainingRun.checked)

        function magnifier () {
            if (rectanglePopupTraining.object === undefined)
//                parent.magnifier (paramTrainingTime, rowColumnTrainingTime, rowColumnTrainingDistance)
                parent.magnifier (paramTrainingTime, rowColumnTrainingTime, rowColumnTrainingStepsLength)
            else {
//                rectanglePopupTraining.visible = false !!!
                if (rectanglePopupTraining.object === paramTrainingTime)
                    rectanglePopupTraining.visible = false
                else {
                    rectanglePopupTraining.visible = false
//                    parent.magnifier (paramTrainingTime, rowColumnTrainingTime, rowColumnTrainingDistance)
                    parent.magnifier (paramTrainingTime, rowColumnTrainingTime, rowColumnTrainingStepsLength)
                }
            }
        }

        Component.onCompleted: {
            anchors.top = rowColumnTrainingTilt.bottom
            anchors.topMargin = parent.spacing
        }

        Text {
            id: textRowTrainingTimeDescription

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Время (мин:сек)"
            font {
                pixelSize: Math.round (parent.width * 0.08)
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignLeft"

            MouseArea {
                anchors.fill: parent

                onClicked: {
//                    posPopupWindow (paramTrainingTime, textRowTrainingTimeDescription.text)

                    parent.parent.magnifier ()
                }
            }
        }

        TextField {
            id: textFieldSliderTrainingTime
            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            readOnly: true

            text: {
                var tm = new Date ()
                tm.setSeconds (paramTrainingTime.val % 60)
                tm.setMinutes (paramTrainingTime.val / 60)
                Qt.formatTime(tm, "mm:ss")
            }
            font {
                pixelSize: Math.round (height * ratioHeightTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    parent.parent.magnifier ()
                }
            }

            Component.onCompleted: {
                paramTrainingTime.objectTextField = textFieldSliderTrainingTime
            }
        }
    }

    //Строка - описание/управление (Дистанция)
    Row {
        id: rowColumnTrainingDistance
        parent: columnTraining
        width: parent.width

        visible: false
        enabled: (enabledParam ()) && (! btnTrainingRun.checked)

        function magnifier () {
            if (rectanglePopupTraining.object === undefined)
                parent.magnifier (paramTrainingDistance, rowColumnTrainingDistance, rowColumnTrainingStepsLength)
            else {
                if (rectanglePopupTraining.object === paramTrainingDistance)
                    rectanglePopupTraining.visible = false
                else{
                    rectanglePopupTraining.visible = false
                    parent.magnifier (paramTrainingDistance, rowColumnTrainingDistance, rowColumnTrainingStepsLength)
                }
            }
        }

        Component.onCompleted: {
//            anchors.top = rowColumnTrainingTime.bottom
//            anchors.topMargin = parent.spacing
        }

        Text {
            id: textRowTrainingDistanceDescription

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Дистанция (км)"
            font {
                pixelSize: Math.round (parent.width * 0.08)
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignLeft"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingDistance.magnifier ()
                }
            }
        }

        TextField {
            id: textFieldSliderTrainingDistance

            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            readOnly: true

            text: paramTrainingDistance.val.toFixed (3)
            font {
                pixelSize: Math.round (height * ratioHeightTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingDistance.magnifier ()
                }
            }

            Component.onCompleted: {
                paramTrainingDistance.objectTextField = textFieldSliderTrainingDistance
            }
        }
    }

    //Строка - описание "Длина шага" - StepsLength
    Row {
        id: rowColumnTrainingStepsLength
        parent: columnTraining
        width: parent.width

        enabled: enabledParam ()

        function magnifier () {
            if (rectanglePopupTraining.object === undefined)
                parent.magnifier (paramStepsLength, rowColumnTrainingStepsLength, undefined)
            else {
                if (rectanglePopupTraining.object === paramStepsLength)
                    rectanglePopupTraining.visible = false
                else{
                    rectanglePopupTraining.visible = false
                    parent.magnifier (paramStepsLength, rowColumnTrainingStepsLength, undefined)
                }
            }
        }

        Component.onCompleted: {
            anchors.top = rowColumnTrainingTime.bottom
//            anchors.top = rowColumnTrainingDistance.bottom
            anchors.topMargin = parent.spacing
        }

        Text {
            id: textRowStepsLengthDescription

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Длина шага (м)"
            font {
                pixelSize: Math.round (parent.width * 0.08)
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignLeft"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    rowColumnTrainingStepsLength.magnifier ()
                }
            }
        }

        TextField {
            id: textFieldSliderStepsLength

            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            readOnly: true

            text: paramStepsLength.val.toFixed (2)
            font {
                pixelSize: Math.round (height * ratioHeightTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

            MouseArea {
                anchors.fill: parent

                onClicked: {
//                    Вариант ПРЕДЫДУщиЙ
//                    posPopupWindow (paramStepsLength, textRowStepsLengthDescription.text)

//                    Вариант №1
//                    console.debug ("Tilt.anchors =", rowColumnTrainingTilt.anchors.top, JSON.stringify (rowColumnTrainingTilt.anchors.bottom))
//                    console.debug (JSON.stringify ("Distance.anchors =", rowColumnTrainingDistance.anchors))
//                    console.debug (JSON.stringify ("Time.anchors =", rowColumnTrainingTime.anchors))
//                    console.debug ("StepsLenght.anchors =", JSON.stringify (rowColumnTrainingStepsLength.anchors))

//                    Вариант №2
//                    rowColumnTrainingDistance.anchors.top = rowColumnTrainingTilt.bottom
//                    rowColumnTrainingDistance.anchors.topMargin = rowColumnTrainingDistance.parent.spacing
//                    rowColumnTrainingTime.anchors.top = rowColumnTrainingDistance.bottom
//                    rowColumnTrainingTime.anchors.topMargin = rowColumnTrainingTime.parent.spacing

//                    Вариант №3
//                    rectanglePopupTraining.object = paramStepsLength
//                    rectanglePopupTraining.title = textRowStepsLengthDescription.text
//                    paramStepsLength.objectTextField.parent.visible = false
//                    rectanglePopupTraining.visible = true
//                    rectanglePopupTraining.anchors.top = paramStepsLength.objectTextField.parent.top
//                    rectanglePopupTraining.anchors.topMargin = paramStepsLength.objectTextField.parent.parent.spacing

                    rowColumnTrainingStepsLength.magnifier ()
                }
            }

            Component.onCompleted: {
                paramStepsLength.objectTextField = textFieldSliderStepsLength
            }
        }
    }

    HPopupWindow {
        id: rectanglePopupTraining
        //visible: object === undefined ? false : true
    }
}
