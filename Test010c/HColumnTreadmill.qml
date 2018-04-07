// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.

//import "slidermanage.js" as ScriptSliderManage
import "cvcapture.js" as ScriptCvCapture

Column {
    id: columnTrack
    spacing: 3

//    x: ScriptCvCapture.posXItem (0, 0)
    width: widthManagmentArea

    anchors.left: parent.left
    anchors.leftMargin: global_offset
    anchors.top: parent.top
    anchors.topMargin: global_offset

    //Строка - описание
    Row {
        parent: columnTrack
        width: parent.width
        Text {
            text: "Дорожка"
            font {
                pixelSize: Math.round (parent.width * 0.15)
            }
        }
    }
    //Строка старт/останов дорожки
    Row {
        width: parent.width

        HButton {
            id: btnTrackStartStop
            width: parent.width
            height: heightControl
            textUnchecked: "Запуск"
            textChecked: "Останов"

            checked: false
            checkable: true

            onClicked: {
                console.debug ("btnTrackStartStop::onClicked", "checked=", checked)
            }

            onCheckedChanged: {
                if (checked) {
                    timerTrackSpeed.start ()
//                    timerTrackSpeedOut.start ()

                    sgnManagementTreadmill ("*600*")

                    sgnManagementTreadmill ("*604#" + (sliderTrackSpeed * 5).toFixed (2) + "*")
                    sgnManagementTreadmill ("*605#" + (500 + (4000 - 500) / 12 * sliderTrackTilt).toFixed (2) + "*")

                    sgnTrainingStart (sliderTrackSpeed, sliderTrackTilt, sliderStepsLength)
                }
                else {
                    timerTrackSpeed.stop ()
//                    timerTrackSpeedOut.stop ()

                    sgnManagementTreadmill ("*601*")
                }
            }

            onDoubleClicked: {
            }

            Connections {
                target: rectangleForm
                onSgnResetTraining: {
                    console.debug ("rectangleForm::onSgnResetTraining")
                    if (btnTrackStartStop.checked)
                        btnTrackStartStop.checked = false
                }
            }
        }
    }

    //Строка - РАЗДЕЛИТЕЛь

    //Строка - Управление ОБДУВом доржкИ (вклю/выкл.)
    Row {
        id: rowObduvTrack

        width: parent.width

        enabled: true

//        Кнопка Обдув
        HButton {
            id: btnObduvTrack
            width: parent.width
            height: heightControl
            textUnchecked: "Обдув"
            textChecked: "Обдув"

            checked: false
            checkable: true

            onCheckedChanged: {
                if (checked) {
                    sgnManagementTreadmill ("*602*")
                }
                else {
                    sgnManagementTreadmill ("*603*")
                }
            }

            onClicked: {
            }

            onDoubleClicked: {
            }

            Connections {
//                target:
            }
        }
    }

    //Строка - описание (Скорость)
    Row {
        parent: columnTrack
        width: parent.width
        Text {
            text: "Скорость (км/ч)"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }

    //Строка - слайдер для управления скоростью ДОРОЖКи
    Row {
        id: rowSliderTrackSpeed
//        enabled: buttonTrackStart.checked
        enabled: true

        width: parent.width

        HButton {
            id: btnSliderTrackSpeedBelowBelow
            parent: rowSliderTrackSpeed
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<<"
//            textChecked: "<<"

            enabled: sliderTrackSpeed > min_track_speed ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackSpeed > min_track_speed) {
                    sliderTrackSpeed -= step_track_speed * coeff_track_speed
                }
                else {
                }
            }
        }

        HButton {
            id: btnSliderTrackSpeedBelow
            parent: rowSliderTrackSpeed
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<"

            enabled: sliderTrackSpeed > min_track_speed ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackSpeed > min_track_speed) {
                    sliderTrackSpeed -= step_track_speed
                }
                else {
                }
            }
        }

        TextField {
            id: textFieldSliderTrackSpeed
            parent: rowSliderTrackSpeed
            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            backgroundColor: "green"

            text: sliderTrackSpeed.toFixed (1)
            font {
                pixelSize: Math.round (height * ratioWidthTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

            onClipChanged: {
                console.debug ("textFieldSliderTrackSpeed::onClipChanged")
            }
        }

        HButton {
            id: btnSliderTrackSpeedAbove
            parent: rowSliderTrackSpeed
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">"

            enabled: sliderTrackSpeed < max_track_speed ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackSpeed < max_track_speed) {
                    sliderTrackSpeed += step_track_speed
                }
                else {
                }
            }
        }

        HButton {
            id: btnSliderTrackSpeedAboveAbove
            parent: rowSliderTrackSpeed
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">>"

            enabled: sliderTrackSpeed < max_track_speed ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackSpeed < max_track_speed) {
                    sliderTrackSpeed += step_track_speed * coeff_track_speed
                }
                else {
                }
            }
        }
    }

    //        Row {
    //            id: rowSliderTrackSpeed
    //            enabled: buttonTrackStart.checked

    //            width: parent.width

    //            TextField {
    //                id: textFieldSliderTrackSpeed
    //                parent: rowSliderTrackSpeed
    //                width: 0.2 * parent.width

    //                text: ScriptSliderManage.textFieldText (sliderTrackSpeed.value)
    //                font {
    //                    pixelSize: Math.round (width * 0.3)
    //                }
    //                horizontalalignment: TextInput.AlignHCenter
    //            }

    //            Slider {
    //                id: sliderTrackSpeed
    //                objectName: "sliderTrackSpeed"
    //                width: parent.width - textFieldSliderTrackSpeed.width

    //                tickmarksEnabled: true
    //                tickPosition: "BothSides"

    //                minimumValue: 0
    //                maximumValue: 5
    //                stepSize: 0.1

    //                value: 0

    //                onValueChanged: {
    //                    sgnManagementTreadmill ("*604#" + (value * 10).toString () + "*")
    //                }

    //                onEnabledChanged: {
    //                    console.debug (objectName, "::onEnabledChanged")
    //                }
    //            }
    //        }

    //Строка - описание (Наклон)
    Row {
        parent: columnTrack
        width: parent.width
        Text {
            text: "Наклон (град.)"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }

    //Строка постоянных значений НАКЛОНа дорожкИ
//    Row {
//        id: rowSliderTrackTilthConst
////        enabled: buttonTrackStart.checked
//        enabled: true

//        width: parent.width

//        Button {
//            id: btnSliderTrackTiltConst0
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "0"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }

//        Button {
//            id: btnSliderTrackTiltConst1
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "2"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }

//        Button {
//            id: btnSliderTrackTiltConst2
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "4"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }

//        Button {
//            id: btnSliderTrackTiltConst3
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "6"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }

//        Button {
//            id: btnSliderTrackTiltConst4
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "8"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }

//        Button {
//            id: btnSliderTrackTiltConst5
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "10"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }

//        Button {
//            id: btnSliderTrackTiltConst6
//            parent: rowSliderTrackTilthConst
//            width: parent.width / 7
//            height: heightControl

//            text: "12"

//            onClicked: { sliderTrackTilt = parseInt (text) }
//        }
//    }

    //Строка - слайдер для управления наклоном ДОРОЖКи
    Row {
        id: rowSliderTrackTilt
//        enabled: buttonTrackStart.checked
        enabled: true

        width: parent.width

        HButton {
            id: btnSliderTrackTiltBelowBelow
            parent: rowSliderTrackTilt
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<<"

            enabled: sliderTrackTilt > min_track_tilt ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackTilt > min_track_tilt)
                    sliderTrackTilt -= step_track_tilt * coeff_track_tilt
                else
                    ;
            }
        }

        HButton {
            id: btnSliderTrackTiltBelow
            parent: rowSliderTrackTilt
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<"

            enabled: sliderTrackTilt > min_track_tilt ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackTilt > min_track_tilt)
                    sliderTrackTilt -= step_track_tilt
                else
                    ;
            }
        }

        TextField {
            id: textFieldSliderTrackTilt
            parent: rowSliderTrackTilt
            width: parent.width * 2 * coeffWidthControl
            height: heightControl

            text: sliderTrackTilt
            font {
                pixelSize: Math.round (height * ratioWidthTextField)
            }
            horizontalalignment: TextInput.AlignHCenter
        }

        HButton {
            id: btnSliderTrackTiltAbove
            parent: rowSliderTrackTilt
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">"

            enabled: sliderTrackTilt < max_track_tilt ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackTilt < max_track_tilt)
                    sliderTrackTilt += step_track_tilt
                else
                    ;
            }
        }

        HButton {
            id: btnSliderTrackTiltAboveAbove
            parent: rowSliderTrackTilt
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">>"

            enabled: sliderTrackTilt < max_track_tilt ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrackTilt < max_track_tilt)
                    sliderTrackTilt += step_track_tilt * coeff_track_tilt
                else
                    ;
            }
        }
    }

//        Row {
//            id: rowSliderTrackTilt
//            enabled: buttonTrackStart.checked

//            width: parent.width

//            TextField {
//                id: textFieldSliderTrackTilt
//                parent: rowSliderTrackTilt
//                width: 0.2 * parent.width

//                text: ScriptSliderManage.textFieldText (sliderTrackTilt.value)
//                font {
//                    pixelSize: Math.round (width * 0.3)
//                }
//                horizontalalignment: TextInput.AlignHCenter
//            }

//            Slider {
//                id: sliderTrackTilt
//                objectName: "sliderTrackSpeed"
//                width: parent.width - textFieldSliderTrackTilt.width

//                tickmarksEnabled: true
//                tickPosition: "BothSides"

//                minimumValue: 0
//                maximumValue: 11
//                stepSize: 1

//                value: 0

//                onValueChanged: {
//                    sgnManagementTreadmill ("*605#" + (500 + value * 300).toString () + "*")
//                }
//            }
//        }

//        Row {
//            width: parent.width

//            Button {
//                width: parent.width
//                height: 5

//                ColorAnimation { from: "white"; to: "black"; duration: 200 }

////                background: "red"
//            }
//        }

    //Строка - РАЗДЕЛИТЕЛь

    //Строка ПУЛЬС
    Row {
        id: rowPulse

        width: parent.width
        height: heightControl

//            enabled: checkBoxCameraBase.checked || checkBoxCameraFace.checked
        enabled: true

        Text {
            parent: rowPulse
            text: "Пульс"
            width: parent.width * 4 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
        }

        Text {
            parent: rowPulse
            text: textPulseVal.toFixed (2)
            width: parent.width * 2 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    //Строка ВРЕМя от НАЧАЛа тренировки
    Row {
        id: rowTraining

        width: parent.width
        height: heightControl

//            enabled: checkBoxCameraBase.checked || checkBoxCameraFace.checked
        enabled: true

        Text {
            parent: rowTraining
            text: "Время"
            width: parent.width * 4 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
        }

        Text {
            parent: rowTraining
//            text: textTrainingTimeVal
            text: {
                var tm = new Date (), val
                val = sliderPreviousTime + sliderCurrentTime
                tm.setSeconds (val % 60)
                tm.setMinutes (val / 60)
                Qt.formatTime(tm, "mm:ss")
            }
            width: parent.width * 2 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    //Строка ДИСТАНЦИя от НАЧАЛа тренировки
    Row {
        id: rowDistance

        width: parent.width
        height: heightControl

//            enabled: checkBoxCameraBase.checked || checkBoxCameraFace.checked
        enabled: true

        Text {
            parent: rowDistance
            text: "Дистанция"
            width: parent.width * 4 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
        }

        Text {
            parent: rowDistance
            text: sliderCurrentDistance.toFixed (3)
            width: parent.width * 2 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }


    //Строка ВРЕМя от НАЧАЛа тренировки
    Row {
        id: rowRealTime

        width: parent.width
        height: heightControl

//            enabled: checkBoxCameraBase.checked || checkBoxCameraFace.checked
        enabled: true

        Text {
            parent: rowRealTime
            text: "Реальн.вр."
            width: parent.width * 4 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
        }

        Text {
            parent: rowRealTime
//            text: textTrainingTimeVal
            text: {
                var tm = new Date ()
                tm.setHours (sliderRealTime / 60 / 24)
                tm.setMinutes (sliderRealTime / 60)
                tm.setSeconds (sliderRealTime % 60)

                Qt.formatTime(tm, "hh:mm:ss")
            }
            width: parent.width * 2 * coeffWidthControl
            font.pixelSize: Math.round (parent.width * 0.1)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }


//    //Строка - РАЗДЕЛИТЕЛь
//    Row {
//        parent: columnTrack
//        width: parent.width
//        Text {
//            text: " "

//            font {
//                pixelSize: Math.round (parent.width * 0.05)
//            }
//        }
//    }
}
