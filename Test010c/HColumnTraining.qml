// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.

import "timerspeed.js" as ScriptTimerSpeed

//import "slidermanage.js" as ScriptSliderManage

Column {
    id: columnTraining
    spacing: 3

//        x: ScriptCvCapture.posXItem (0, 0)
    width: widthManagmentArea

    anchors.left: parent.left
    anchors.leftMargin: global_offset
    anchors.bottom: parent.bottom
    anchors.bottomMargin: global_offset

    //Строка - описание (Тренировка)
    Row {
        width: parent.width
        Text {
            text: "Тренировка"
            font {
                pixelSize: Math.round (parent.width * 0.15)
            }
        }
    }

    //Строка - Начало (сброс) тренировки
    Row {
        width: parent.width
        HButton {
            id: btnBeginTraining
//            parent: rowBeginTraining
            width: parent.width
            height: heightControl
//                color: 'blue'
            textUnchecked: "Начало"
            textChecked: "Конец"

            checkable: false

            onClicked: {
                sliderTrackSpeed = min_track_speed
                sliderTrackTilt = min_track_tilt
                sliderStepsLength = min_steps_length
                sliderTrainingDistance = min_training_distance

                sgnResetTraining ()

                timerTrackSpeedCountTick = 0
                sliderPreviousTime = 0
                sliderCurrentTime = 0
                sliderPreviousDistance = 0
                sliderCurrentDistance = 0

                console.debug ("HButton::onClicked")
            }

            onDoubleClicked: {
            }
        }
    }

    //Строка - описание (Дистанция)
    Row {
        parent: columnTraining
        width: parent.width
        Text {
            text: "Дистанция (км)"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }

    //Строка - слайдер для управления дистанцией
    Row {
        id: rowSliderTrainingDistance
        enabled: true

        width: parent.width

        HButton {
            id: btnSliderTrainingDistanceBelowBelow
            parent: rowSliderTrainingDistance
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<<"

            enabled: sliderTrainingDistance > min_training_distance ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingDistance > min_training_distance)
                    sliderTrainingDistance -= step_training_distance * coeff_training_distance
                else
                    ;
            }
        }

        HButton {
            id: btnSliderTrainingDistanceBelow
            parent: rowSliderTrainingDistance
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<"

            enabled: sliderTrainingDistance > min_training_distance ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingDistance > min_training_distance)
                    sliderTrainingDistance -= step_training_distance
                else
                    ;
            }
        }

        TextField {
            id: textFieldSliderTrainingDistance
            parent: rowSliderTrainingDistance
            width: parent.width * 2 * coeffWidthControl
            height: heightControl

            text: sliderTrainingDistance.toFixed (1)
            font {
                pixelSize: Math.round (height * ratioWidthTextField)
            }
            horizontalalignment: TextInput.AlignHCenter
//                verticalCenter: TextInput.baseline
        }

        HButton {
            id: btnSliderTrainingDistanceAbove
            parent: rowSliderTrainingDistance
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">"

            enabled: sliderTrainingDistance < max_training_distance ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingDistance < max_training_distance)
                    sliderTrainingDistance += step_training_distance
                else
                    ;
            }
        }

        HButton {
            id: btnSliderTrainingDistanceAboveAbove
            parent: rowSliderTrainingDistance
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">>"

            enabled: sliderTrainingDistance < max_training_distance ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingDistance < max_training_distance)
                    sliderTrainingDistance += step_training_distance * coeff_training_distance
                else
                    ;
            }
        }
    }

    //Строка - описание (Время)
    Row {
        parent: columnTraining
        width: parent.width
        Text {
            text: "Время (мин:сек)"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }

    //Строка - слайдер для управления временем тренировки
    Row {
        id: rowSliderTrainingTime
        enabled: true

        width: parent.width

        HButton {
            id: btnSliderTrainingTimeBelowBelow
            parent: rowSliderTrainingTime
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<<"

            enabled: sliderTrainingTime > min_training_time ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingTime > min_training_time)
                    sliderTrainingTime -= step_training_time * coeff_training_time
                else
                    ;
            }
        }

        HButton {
            id: btnSliderTrainingTimeBelow
            parent: rowSliderTrainingTime
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: "<"

            enabled: sliderTrainingTime > min_training_time ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingTime > min_training_time)
                    sliderTrainingTime -= step_training_time
                else
                    ;

//                console.debug ("btnSliderTrainingTimeBelow::onClicked = ", sliderTrainingTime)
            }
        }

        TextField {
            id: textFieldSliderTrainingTime
            parent: rowSliderTrainingTime
            width: parent.width * (2 / 6)
            height: heightControl

            readOnly: true
//            enabled: false

//            Вариант №1
//            text: "10:00"

//            Вариант №2
            text: {
                var tm = new Date ()
                tm.setSeconds (sliderTrainingTime % 60)
                tm.setMinutes (sliderTrainingTime / 60)
                Qt.formatTime(tm, "mm:ss")
            }
//            font {
//                pixelSize: Math.round (height * ratioWidthTextField)
//            }
//            horizontalalignment: TextInput.AlignHCenter

//            Вариант №3
//            text: sliderTrainingTime.toFixed (1)
            font {
                pixelSize: Math.round (height * ratioWidthTextField)
            }
            horizontalalignment: TextInput.AlignHCenter

//            validator: DoubleValidator { bottom: 0.1; top: 1.0; decimals: 2; }
        }

        HButton {
            id: btnSliderTrainingTimeAbove
            parent: rowSliderTrainingTime
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">"

            enabled: sliderTrainingTime < max_training_time ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingTime < max_training_time)
                    sliderTrainingTime += step_training_time
                else
                    ;

//                console.debug ("btnSliderTrainingTimeAbove::onClicked = ", sliderTrainingTime)
            }
        }

        HButton {
            id: btnSliderTrainingTimeAboveAbove
            parent: rowSliderTrainingTime
            width: parent.width * 1 * coeffWidthControl
            height: heightControl
            textUnchecked: ">>"

            enabled: sliderTrainingTime < max_training_time ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderTrainingTime < max_training_time)
                    sliderTrainingTime += step_training_time * coeff_training_time
                else
                    ;
            }
        }
    }

//        //Строка - описание "База шага" - StepsWidth
//        Row {
//            width: parent.width
//            Text {
//                text: "База шага"
//                font {
//                    pixelSize: Math.round (parent.width * 0.1)
//                }
//            }
//        }
//        //Строка - слайдер для управлениян БАЗой ШАГа (расстояние между следами ПОПЕРёК дорожки)
//        Row {
//            id: rowSliderStepsWidth
////            enabled: buttonTrackStart.checked
//            enabled: false

//            width: parent.width

//            TextField {
//                id: textFieldSliderStepsWidth
//                parent: rowSliderStepsWidth
//                width: 0.2 * parent.width

//                text: ScriptSliderManage.textFieldText (sliderStepsWidth.value)
//                font {
//                    pixelSize: Math.round (width * 0.3)
//                }
//                horizontalalignment: TextInput.AlignHCenter
//            }

//            Slider {
//                id: sliderStepsWidth
////                objectName: "sliderTrackSpeed"
//                width: parent.width - textFieldSliderStepsWidth.width

//                tickmarksEnabled: true
//                tickPosition: "BothSides"

//                minimumValue: 0.1
//                maximumValue: max_steps_width
//                stepSize: 0.01

//                value: 0.25

//                onValueChanged: {
//                    var i, obj, ar = Array.constructor
//                    for (i = 1; i <= count_of_trace; i ++) {
//                        obj = "Trace" + i.toString ()
//                        if (i % 2 === 0) {
//                            m_synchCoordinates.initValue (obj, "position", "Z", -offset_of_edge - sliderStepsWidth.value)
//                        }
//                        else
//                            ;
//                    }

//                    console.log ("sliderStepsWidth::onValueChanged, value=", value)

////                    m_synchCoordinates.setTraceLength (value);
//                }
//            }
//        }

    //Строка - описание "Длина шага" - StepsLength
    Row {
        width: parent.width
        Text {
            text: "Длина шага (м)"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }

    //Строка - слайдер для управления длиной шага
    Row {
        id: rowSliderStepsLength
        enabled: true

        width: parent.width

        HButton {
            id: btnSliderStepsLengthBelow
            parent: rowSliderStepsLength
            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            textUnchecked: "<"

            enabled: sliderStepsLength > min_steps_length ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderStepsLength > min_steps_length)
                    sliderStepsLength -= step_steps_length
                else
                    ;
            }
        }

        TextField {
            id: textFieldSliderStepsLength
            parent: rowSliderStepsLength
            width: parent.width * (2 / 6)
            height: heightControl

//            validator: DoubleValidator { bottom: 0.1; top: 1.0 }

            text: sliderStepsLength.toFixed (2)
            font {
                pixelSize: Math.round (height * ratioWidthTextField)
            }
            horizontalalignment: TextInput.AlignHCenter
        }

        HButton {
            id: btnSliderStepsLengthAbove
            parent: rowSliderStepsLength
            width: parent.width * 2 * coeffWidthControl
            height: heightControl
            textUnchecked: ">"

            enabled: sliderStepsLength < max_steps_length ? true : false

            checked: false
            checkable: false

            onClicked: {
                if (sliderStepsLength < max_steps_length)
                    sliderStepsLength += step_steps_length
                else
                    ;
            }
        }
    }

//        //Строка - слайдер для управлениян длиной ШАГа (расстояние между следами ВДОЛь дорожки)
//        Row {
//            id: rowSliderStepsLength
//            enabled: buttonTrackStart.checked

//            width: parent.width

//            TextField {
//                id: textFieldSliderStepsLength
//                parent: rowSliderStepsLength
//                width: 0.2 * parent.width

//                text: ScriptSliderManage.textFieldText (sliderStepsLength.value)
//                font {
//                    pixelSize: Math.round (width * 0.3)
//                }
//                horizontalalignment: TextInput.AlignHCenter
//            }

//            Slider {
//                id: sliderStepsLength
////                objectName: "sliderTrackSpeed"
//                width: parent.width - textFieldSliderStepsLength.width

//                tickmarksEnabled: true
//                tickPosition: "BothSides"

//                minimumValue: 0.1
//                maximumValue: max_steps_length
//                stepSize: 0.01

//                value: 0.2

//                onValueChanged: {
//                    console.debug ("sliderStepsLength::onValueChanged", value)

//                    if (m_synchCoordinates) {
//                        //ОТЛАДКа
//                        console.debug ("Количество objectReality (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality (), " ; C++:", m_synchCoordinates.getCountObjectReality ())
//                        //Удалить ЛИШНие (создать необходимые)
//                        var i, obj, name, prefixName = "Trace",
//                                countOfTrace = m_synchCoordinates.getCountObjectReality (prefixName),
//                                propertyCountOfTrace = ScriptTimerSpeed.countOfTrace ()
//                //        countOfTrace = ScriptObjectReality.getCountObjectReality (prefixName)
//                        console.debug ("sliderStepsLength::onValueChanged: ", propertyCountOfTrace,
//                                       "; Количество следов (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality (prefixName),
//                                       " ; C++:", countOfTrace)

//                        var indexMaxValue, posMaxValue, numLeadingTrace

//                //        indexMinValue = ScriptObjectReality.getNumTraceOfMinPosition ()
//                //        console.debug ("indexMinValue=", indexMinValue)
//                //        posMinValue = ScriptObjectReality.getObjectReality ("Trace", indexMinValue).placements [0].sliders [0].sliderValue
//                //        console.debug ("posMinValue=", posMinValue)

//                        indexMaxValue = ScriptObjectReality.getNumTraceOfMaxPosition ()
//                        console.debug ("indexMaxValue=", indexMaxValue)

//                        if (ScriptObjectReality.getObjectReality ("Trace", indexMaxValue)) {
//                            posMaxValue = ScriptObjectReality.getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue
//                            console.debug ("posMaxValue=", posMaxValue)
//                        }
//                        else
//                            ;

//                        console.debug ("Количество следов: ", propertyCountOfTrace)

//                        numLeadingTrace = indexMaxValue

//                        if (countOfTrace > -1) {
//                            if (! (propertyCountOfTrace === countOfTrace)) {
//                                m_synchCoordinates.initValue (prefixName + indexMaxValue, "position", "X", begin_position_trace)
//                                m_synchCoordinates.initValue ("Pole" + indexMaxValue, "position", "X", begin_position_trace)

//                                if (propertyCountOfTrace > countOfTrace) {
//                                    //Создать необходимые
//                                    console.debug ("Создать необходимые: ", propertyCountOfTrace - ScriptObjectReality.getCountObjectReality (prefixName))
//                                    for (i = countOfTrace; i < propertyCountOfTrace; i ++) {
//                                        obj = ScriptObjectReality.createObjectReality (i + 1, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE)
//                                        console.debug ("objectReality.create with №", i + 1)
//                                        ScriptObjectReality.arObjectReality.push (obj)

//                                        console.debug ("m_synchCoordinates.insertObjectReality", obj.objectName, ScriptObjectReality.arObjectReality [ScriptObjectReality.arObjectReality.length - 1])
//                                        m_synchCoordinates.insertObjectReality (obj.objectName, ScriptObjectReality.arObjectReality [ScriptObjectReality.arObjectReality.length - 1]);
//                //                        m_synchCoordinates.insertObjectReality (obj.objectName, obj);

//                //                        Добавляем КОЛы
//                                        obj = ScriptObjectReality.createObjectReality (i + 1, ScriptObjectReality.TYPE_OBJECTREALITY.POLE)
//                                        ScriptObjectReality.arObjectReality.push (obj)
//                                        m_synchCoordinates.insertObjectReality (obj.objectName, ScriptObjectReality.arObjectReality [ScriptObjectReality.arObjectReality.length - 1]);

//                //                        console.debug (obj.placements [0].sliders [0].sliderValue)
//                //                        console.debug (ScriptObjectReality.getObjectReality (prefixName, i))
//                //                        obj.placements [0].sliders [0].sliderValue = ScriptObjectReality.getObjectReality (prefixName, i).placements [0].sliders [0].sliderValue - direction_track * sliderStepsLength.value
//                                    }

//                                    console.debug ("Количество следов (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality (prefixName), "; C++: ", m_synchCoordinates.getCountObjectReality (prefixName))
//                                }
//                                else {
//                                    //Удалить ЛИШНие
//                                    console.debug ("Удалить ЛИШНие: ", ScriptObjectReality.getCountObjectReality (prefixName) - propertyCountOfTrace)
//                                    //Перед удалениеим ПРОВЕРить - не потеряем ли позицию следа
//                                    if (indexMaxValue > propertyCountOfTrace) {
//                                        //С удаление следа - ПОТЕРяем ЕГо ПОЗицию
//                                        if (indexMaxValue % 2 === 1) {
//                                            console.debug ("Потеря позиции: ", indexMaxValue, "НЕ чЁтный")
//                                            numLeadingTrace = 1
//                                        }
//                                        else {
//                                            console.debug ("Потеря позиции: ", indexMaxValue, "чЁтный")
//                                            numLeadingTrace = propertyCountOfTrace
//                                        }

//                                        console.debug ("Назначили numLeadingTrace=", numLeadingTrace)
//                                    }
//                                    else
//                                        ; //НиЧЕГо не делаем - ПОТЕРь позиции СЛЕДа НЕТ

//                                    for (i = 0; i < ScriptObjectReality.arObjectReality.length; i ++) {
//                                        name = ScriptObjectReality.arObjectReality [i].objectName
//                                        prefixName = "Trace"
//                                        if (name.indexOf (prefixName) > -1) {
//                                            console.debug (name.substr (prefixName.length, name.length - prefixName.length))
//                                            if (name.substr (prefixName.length, name.length - prefixName.length) > propertyCountOfTrace) {
//                                                console.debug ("Удаляем: ", ScriptObjectReality.arObjectReality [i].objectName)
//                                                m_synchCoordinates.deleteObjectReality (ScriptObjectReality.arObjectReality [i].objectName, ScriptObjectReality.arObjectReality [i]);
//                                                obj = ScriptObjectReality.arObjectReality.splice (i, 1)
//                                                console.debug ("УдалЁН: ", obj)

//                                                i --
//                                            }
//                                            else
//                                                ;
//                                        }
//                                        else
//                                            ;

//                                        prefixName = "Pole"
//                                        if (name.indexOf (prefixName) > -1) {
//                                            console.debug (name.substr (prefixName.length, name.length - prefixName.length))
//                                            if (name.substr (prefixName.length, name.length - prefixName.length) > propertyCountOfTrace) {
//                                                console.debug ("Удаляем: ", ScriptObjectReality.arObjectReality [i].objectName)
//                                                m_synchCoordinates.deleteObjectReality (ScriptObjectReality.arObjectReality [i].objectName, ScriptObjectReality.arObjectReality [i]);
//                                                obj = ScriptObjectReality.arObjectReality.splice (i, 1)
//                                                console.debug ("УдалЁН: ", obj)

//                                                i --
//                                            }
//                                            else
//                                                ;
//                                        }
//                                        else
//                                            ;
//                                    }
//                                    console.debug ("Количество следов (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality ("Trace"), "; C++: ", m_synchCoordinates.getCountObjectReality (prefixName))
//                                }
//                            }
//                            else {
//                            }

//                //            m_synchCoordinates.initValue (prefixName + 1, "position", "X", posMinValue)
//                            m_synchCoordinates.initValue (prefixName + numLeadingTrace, "position", "X", begin_position_trace)
//                //            m_synchCoordinates.initValue ("Pole" + 1, "position", "X", posMinValue)
//                            m_synchCoordinates.initValue ("Pole" + numLeadingTrace, "position", "X", begin_position_trace)

//                            console.debug ("Переместили след в НАЧАЛо с ном.=", numLeadingTrace)

//                            ScriptObjectReality.setTracesPlacement ()
//                        }
//                        else {

//                        }
//                    }
//                    else
//                        console.debug ("sliderStepsLength::onValueChanged", "m_synchCoordinates not initialized")
//                }
//            }
//        }
}
