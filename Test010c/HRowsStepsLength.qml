// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider e.t.c.

Item {
    Row {
        width: parent.width
        Text {
            text: "Длина шага"
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

        Button {
            id: btnSliderStepsLengthBelow
            parent: rowSliderStepsLength
            width: parent.width * (2 / 7)
            height: heightControl

            text: "<"

            onClicked: {
    //                    sgnManagementTreadmill ("*604#" + (textFieldSliderTrackSpeed * 10).toString () + "*")
            }
        }

        TextField {
            id: textFieldSliderStepsLength
            parent: rowSliderStepsLength
            width: parent.width * (3 / 7)
            height: heightControl

            validator: DoubleValidator { bottom: 0.1; top: 1.0 }

            text: "0.30"
            font {
                pixelSize: Math.round (width * 0.3)
            }
            horizontalalignment: TextInput.AlignHCenter
        }

        Button {
            id: btnSliderStepsLengthAbove
            parent: rowSliderStepsLength
            width: parent.width * (2 / 7)
            height: heightControl

            text: ">"

            onClicked: {
            }
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
