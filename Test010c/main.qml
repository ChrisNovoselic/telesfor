import QtQuick 1.0
import "objectReality.js" as ScriptObjectReality
import "cvcapture.js" as ScriptCvCapture
import "timerspeed.js" as ScriptTimerSpeed
import "slidermanage.js" as ScriptSliderManage
import "trainings.js" as ScriptTrainings
import lib002 1.0 //QmlCVCapture, HObjectReality
//import Qt3D 1.0
//import Qt3D.Shapes 1.0
import QtDesktop 0.1 //Slider, Button e.t.c.
import "."
//import "/home/treadmill/QtSDK/Desktop/Qt/4.8.0/gcc/imports/QtDesktop/custom" as Components
// stuff

Rectangle
{
//    property list <HObjectReality> arObjectReality: ['', '']

    signal sgnRecoverySliderValueObject(string line, string itemManagement)
    signal sgnReplacmentObject(string line, string itemManagement)
    signal sgnManagementTreadmill(string cmd)

    signal sgnTrainingStart(double speed, int tilt, double stepsLength)
    signal sgnTrainingChange (double speed, int tilt, double stepsLength)
    signal sgnTrainingStop ()

    signal sgnQueryPulse (string cmd)
    function callbackQueryPulse (pulse) {
        console.debug ("recieve Pulse from treadmill = ", pulse)
        textPulseVal = parseFloat (pulse.substr (7, 4))
    }

    signal sgnResetTraining ()

    signal sgnDebugRepositionObject(string line, string itemManagement)

    //ХАРАКТЕРИСТИКи обЪектов расширеннОЙ реалЬностИ
    property int direction_track: -1 //Направление движения 'дорожки'

    property real begin_position_trace: 0.4 //Смещение позиции ПЕРВого СЛЕДа от центрА ФСК (вдоль ДВИЖЕНия ДОРОЖКи)
    property real offset_of_edge: 0.1 //Смещение от края 1-го следа (ПЕРПЕНДИКулЯрнО ДВИЖЕНию ДОРОЖКи)
    property real begin_position_track:  0.5 //Смещение НАЧАЛа виртуальной ДОРОЖКи от центрА ФСК
    property real length_track: 1.0 //Виртуальная ДЛИНа ДОРОЖКи (следы виднЫ)

    //Количество 'следов'
    property int count_of_trace: 6
    onCount_of_traceChanged: {
        console.debug ("count_of_trace::onCount_of_traceChanged = ", count_of_trace)
    }

    property int global_offset: 10 //Глобальное значения для смещения элементов управления на ФОРМе от Её КРАя
    property real relative_width_capture: 0.3 //Относительная величина размеров ВЫВОДа изображения с КАМЕР

    property real sliderTrackTilt: 0 //УГОл НАКЛОНа ДОРОЖКи
    property real min_track_tilt: 0  //Мин. значение для 'sliderTrackTilt'
    property real max_track_tilt: 12  //Макс. значение для 'sliderTrackTilt'
    property real step_track_tilt: 1 //Еденичный шаг для 'sliderTrackTilt'
    property real coeff_track_tilt: 2
    onSliderTrackTiltChanged: {
        if (sliderTrackTilt > max_track_tilt)
            sliderTrackTilt = max_track_tilt

        if (sliderTrackTilt < min_track_tilt)
            sliderTrackTilt = min_track_tilt

        sgnManagementTreadmill ("*605#" + (500 + (4000 - 500) / 12 * sliderTrackTilt).toFixed (2) + "*")

        if (timerTrackSpeed.running)
            sgnTrainingChange (sliderTrackSpeed, sliderTrackTilt, sliderStepsLength)

        console.debug ("*605#" + (500 + (4000 - 500) / 12 * sliderTrackTilt).toFixed (2) + "*")
    }

    property real sliderTrackSpeed: 0.8 //Скорость движения ДОРОЖКи
    property real min_track_speed: 0.8  //Мин. значение для 'sliderTrackSpeed'
    property real max_track_speed: 5  //Макс. значение для 'sliderTrackSpeed'
    property real step_track_speed: 0.1 //Еденичный шаг для 'sliderTrackSpeed'
    property real coeff_track_speed: 10
    onSliderTrackSpeedChanged: {
        if (sliderTrackSpeed > max_track_speed)
            sliderTrackSpeed = max_track_speed

        if (sliderTrackSpeed < min_track_speed)
            sliderTrackSpeed = min_track_speed

        if (timerTrackSpeed.running) {
            sgnManagementTreadmill ("*604#" + (sliderTrackSpeed * 5).toFixed (2) + "*")

            sgnTrainingChange (sliderTrackSpeed, sliderTrackTilt, sliderStepsLength)
        }

//        timerTrackSpeedCountTick = 0
        sliderPreviousTime += sliderCurrentTime
        sliderCurrentTime = 0
        sliderPreviousDistance = sliderCurrentDistance
        sliderCurrentDistance = 0


        console.debug ("*604#" + (sliderTrackSpeed * 5).toFixed (1) + "*")
    }

    property real sliderTrainingDistance: 0.2 //Дистанция для ТРЕНИРОВКи
    property real min_training_distance: 0.2  //Мин. значение для 'sliderTrainingDistance'
    property real max_training_distance: 10  //Макс. значение для 'sliderTrainingDistance'
    property real step_training_distance: 0.2 //Еденичный шаг для 'sliderTrainingDistance'
    property real coeff_training_distance: 10 //КоэФФициенТ для ускореННого изменения шагА для 'sliderTrainingDistance'
    onSliderTrainingDistanceChanged: {
        if (sliderTrainingDistance > max_training_distance)
            sliderTrainingDistance = max_training_distance

        if (sliderTrainingDistance < min_training_distance)
            sliderTrainingDistance = min_training_distance
    }

    property real sliderStepsLength: 0.3 //Длина (ширина) шага (расстояние между следами по направлению движения)
    property real min_steps_length: 0.15  //Мин. значение для 'sliderStepsLength'
    property real max_steps_length: 0.5  //Макс. значение для 'sliderStepsLength'
    property real step_steps_length: 0.05 //Еденичный шаг для 'sliderStepsLength'
    onSliderStepsLengthChanged: {
        sliderStepsLength = Math.round (sliderStepsLength * 100) / 100

        if (sliderStepsLength > max_steps_length)
            sliderStepsLength = max_steps_length

        if (sliderStepsLength < min_steps_length)
            sliderStepsLength = min_steps_length

        if (timerTrackSpeed.running) {
            sgnTrainingChange (sliderTrackSpeed, sliderTrackTilt, sliderStepsLength)
        }

        console.debug ("sliderStepsLength::onValueChanged = ", sliderStepsLength)

        if (m_synchCoordinates) {
            //ОТЛАДКа
            console.debug ("Количество objectReality (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality (), " ; C++:", m_synchCoordinates.getCountObjectReality ())

            count_of_trace = ScriptTimerSpeed.countOfTrace ()

            //Удалить ЛИШНие (создать необходимые)
            var i, obj, name, prefixName = "Trace",
                    countOfTrace = m_synchCoordinates.getCountObjectReality (prefixName),
                    propertyCountOfTrace = ScriptTimerSpeed.countOfTrace ()
    //        countOfTrace = ScriptObjectReality.getCountObjectReality (prefixName)
            console.debug ("sliderStepsLength::onValueChanged: ", propertyCountOfTrace,
                           "; Количество следов (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality (prefixName),
                           " ; C++:", countOfTrace)

            var indexMaxValue, posMaxValue, numLeadingTrace

    //        indexMinValue = ScriptObjectReality.getNumTraceOfMinPosition ()
    //        console.debug ("indexMinValue=", indexMinValue)
    //        posMinValue = ScriptObjectReality.getObjectReality ("Trace", indexMinValue).placements [0].sliders [0].sliderValue
    //        console.debug ("posMinValue=", posMinValue)

            indexMaxValue = ScriptObjectReality.getNumTraceOfMaxPosition ()
            console.debug ("indexMaxValue=", indexMaxValue)

            if (ScriptObjectReality.getObjectReality ("Trace", indexMaxValue)) {
                posMaxValue = ScriptObjectReality.getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue
                console.debug ("posMaxValue=", posMaxValue)
            }
            else
                ;

            console.debug ("Количество следов: ", propertyCountOfTrace)

            numLeadingTrace = indexMaxValue

            if (countOfTrace > -1) {
                if (! (propertyCountOfTrace === countOfTrace)) {
                    m_synchCoordinates.initValue (prefixName + indexMaxValue, "position", "X", begin_position_trace)
                    m_synchCoordinates.initValue ("Pole" + indexMaxValue, "position", "X", begin_position_trace)

                    if (propertyCountOfTrace > countOfTrace) {
                        //Создать необходимые
                        console.debug ("Создать необходимые: ", propertyCountOfTrace - ScriptObjectReality.getCountObjectReality (prefixName))
                        for (i = countOfTrace; i < propertyCountOfTrace; i ++) {
                            obj = ScriptObjectReality.createObjectReality (i + 1, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE)
                            console.debug ("objectReality.create with №", i + 1)
                            ScriptObjectReality.arObjectReality.push (obj)

                            console.debug ("m_synchCoordinates.insertObjectReality", obj.objectName, ScriptObjectReality.arObjectReality [ScriptObjectReality.arObjectReality.length - 1])
                            m_synchCoordinates.insertObjectReality (obj.objectName, ScriptObjectReality.arObjectReality [ScriptObjectReality.arObjectReality.length - 1]);
    //                        m_synchCoordinates.insertObjectReality (obj.objectName, obj);

    //                        Добавляем КОЛы
                            obj = ScriptObjectReality.createObjectReality (i + 1, ScriptObjectReality.TYPE_OBJECTREALITY.POLE)
                            ScriptObjectReality.arObjectReality.push (obj)
                            m_synchCoordinates.insertObjectReality (obj.objectName, ScriptObjectReality.arObjectReality [ScriptObjectReality.arObjectReality.length - 1]);

    //                        console.debug (obj.placements [0].sliders [0].sliderValue)
    //                        console.debug (ScriptObjectReality.getObjectReality (prefixName, i))
    //                        obj.placements [0].sliders [0].sliderValue = ScriptObjectReality.getObjectReality (prefixName, i).placements [0].sliders [0].sliderValue - direction_track * sliderStepsLength.value
                        }

                        console.debug ("Количество следов (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality (prefixName), "; C++: ", m_synchCoordinates.getCountObjectReality (prefixName))
                    }
                    else {
                        //Удалить ЛИШНие
                        console.debug ("Удалить ЛИШНие: ", ScriptObjectReality.getCountObjectReality (prefixName) - propertyCountOfTrace)
                        //Перед удалениеим ПРОВЕРить - не потеряем ли позицию следа
                        if (indexMaxValue > propertyCountOfTrace) {
                            //С удаление следа - ПОТЕРяем ЕГо ПОЗицию
                            if (indexMaxValue % 2 === 1) {
                                console.debug ("Потеря позиции: ", indexMaxValue, "НЕ чЁтный")
                                numLeadingTrace = 1
                            }
                            else {
                                console.debug ("Потеря позиции: ", indexMaxValue, "чЁтный")
                                numLeadingTrace = propertyCountOfTrace
                            }

                            console.debug ("Назначили numLeadingTrace=", numLeadingTrace)
                        }
                        else
                            ; //НиЧЕГо не делаем - ПОТЕРь позиции СЛЕДа НЕТ

                        for (i = 0; i < ScriptObjectReality.arObjectReality.length; i ++) {
                            name = ScriptObjectReality.arObjectReality [i].objectName
                            prefixName = "Trace"
                            if (name.indexOf (prefixName) > -1) {
                                console.debug (name.substr (prefixName.length, name.length - prefixName.length))
                                if (name.substr (prefixName.length, name.length - prefixName.length) > propertyCountOfTrace) {
                                    console.debug ("Удаляем: ", ScriptObjectReality.arObjectReality [i].objectName)
                                    m_synchCoordinates.deleteObjectReality (ScriptObjectReality.arObjectReality [i].objectName, ScriptObjectReality.arObjectReality [i]);
                                    obj = ScriptObjectReality.arObjectReality.splice (i, 1)
                                    console.debug ("УдалЁН: ", obj)

                                    i --
                                }
                                else
                                    ;
                            }
                            else
                                ;

                            prefixName = "Pole"
                            if (name.indexOf (prefixName) > -1) {
                                console.debug (name.substr (prefixName.length, name.length - prefixName.length))
                                if (name.substr (prefixName.length, name.length - prefixName.length) > propertyCountOfTrace) {
                                    console.debug ("Удаляем: ", ScriptObjectReality.arObjectReality [i].objectName)
                                    m_synchCoordinates.deleteObjectReality (ScriptObjectReality.arObjectReality [i].objectName, ScriptObjectReality.arObjectReality [i]);
                                    obj = ScriptObjectReality.arObjectReality.splice (i, 1)
                                    console.debug ("УдалЁН: ", obj)

                                    i --
                                }
                                else
                                    ;
                            }
                            else
                                ;
                        }
                        console.debug ("Количество следов (В НАЛИЧИИ) Qml: ", ScriptObjectReality.getCountObjectReality ("Trace"), "; C++: ", m_synchCoordinates.getCountObjectReality (prefixName))
                    }
                }
                else {
                }

    //            m_synchCoordinates.initValue (prefixName + 1, "position", "X", posMinValue)
                m_synchCoordinates.initValue (prefixName + numLeadingTrace, "position", "X", begin_position_trace)
    //            m_synchCoordinates.initValue ("Pole" + 1, "position", "X", posMinValue)
                m_synchCoordinates.initValue ("Pole" + numLeadingTrace, "position", "X", begin_position_trace)

                console.debug ("Переместили след в НАЧАЛо с ном.=", numLeadingTrace)

                ScriptObjectReality.setTracesPlacement ()
            }
            else {

            }
        }
        else {
            console.debug ("sliderStepsLength::onValueChanged", "m_synchCoordinates not initialized")
        }
    }

    function realTime () {
        var tm = new Date, val
        val = tm.getHours () * 60 * 60
        val += tm.getMinutes () * 60
        val += tm.getSeconds ()

        console.debug ("realTime () RETURN = ", val)
        return val
    }

    property real sliderRealTime: realTime ()

    property int sliderTrainingTime: 60 //СЕКУНДы
    property int min_training_time: 60  //Мин. значение для 'sliderTraingTime'
    property int max_training_time: 60 * 10  //Макс. значение для 'sliderTraingTime'
    property int step_training_time: 10 //Еденичный шаг для 'sliderTraingTime'
    property real coeff_training_time: 6 //КоэФФициенТ
    onSliderTrainingTimeChanged: {
        if (sliderTrainingTime > max_training_time)
            sliderTrainingTime = max_training_time

        if (sliderTrainingTime < min_training_time)
            sliderTrainingTime = min_training_time

//        console.debug ("::onSliderTrainingTimeChanged = ", sliderTrainingTime)
    }

    property real textPulseVal: 0
    onTextPulseValChanged: {
    }

//    property int textTrainingTimeVal: 0

    property real sliderPreviousDistance: 0
    property real sliderCurrentDistance: 0
    property int sliderPreviousTime: 0
    property real sliderCurrentTime: 0
    property int timerTrackSpeedCountTick: 0

    property real sliderStepsWidth: 0.2
    property real max_steps_width: 1.0 //База шага (расстояние между следами ПЕРПЕНДИКУЛЯРНо направлению движения)

    property int widthQmlCvCapture: relative_width_capture * rectangleForm.width
    property int widthCvCaptureArea: 2 * widthQmlCvCapture + global_offset
    property int widthManagmentArea: (rectangleForm.width - widthCvCaptureArea - 4 * global_offset) / 2

    property real ratioWidthTextField: 0.5
    property real heightControl: rectangleForm.height / 24
    property real coeffWidthControl: 1 / 6

    function virtualLengthTrack () {
        return begin_position_trace - count_of_trace * sliderStepsLength
    }

    function changeTrainingTime (part, text, val) {
        var arMinSec = text.split (":")

        console.debug (arMinSec)
        console.debug (parseInt (arMinSec [part], 10))
        console.debug ("part=", part)
        console.debug (parseInt (arMinSec [part]) + val)

        if (((parseInt (arMinSec [part], 10) + val) > -1) && (((parseInt (arMinSec [part], 10) + val) < 60)))
            arMinSec [part] = parseInt (arMinSec [part], 10) + val
        else
            ; //arMinSec [part] = 0

        console.debug (arMinSec [part])

        while (arMinSec [part].toString ().length < 2) {
            arMinSec [part] = "0" + arMinSec [part]
        }

        console.debug (arMinSec [0].toString ().concat (":", arMinSec [1]))

        return arMinSec [0].toString ().concat (":", arMinSec [1])
    }

    id: rectangleForm
    width: 800
    height: 640
    z: 0
    rotation: 0
    color: "gray"

    Component.onCompleted: {
        console.log ("root::OmCompleted")

        ScriptObjectReality.arObjectReality.push (centerPSC)
        ScriptObjectReality.arObjectReality.push (latticeFront)
        ScriptObjectReality.arObjectReality.push (latticeRear)

        ScriptObjectReality.arObjectReality.push (line1)
        ScriptObjectReality.arObjectReality.push (line2)

        ScriptObjectReality.arObjectReality.push (trace1)
        ScriptObjectReality.arObjectReality.push (trace2)

        ScriptObjectReality.arObjectReality.push (pole1)
        ScriptObjectReality.arObjectReality.push (pole2)

        var i, trace, pole
//        , ar = new Array ()
        console.debug ("Количество следов", count_of_trace)
        for (i = 3; i <= count_of_trace; i ++) {
            trace = ScriptObjectReality.createObjectReality (i, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE)
            pole = ScriptObjectReality.createObjectReality (i, ScriptObjectReality.TYPE_OBJECTREALITY.POLE)

//            console.debug ("objectReality.create with №", i)
            ScriptObjectReality.arObjectReality.push (trace)
            ScriptObjectReality.arObjectReality.push (pole)
//            ar.push (i)
        }

        console.debug ("Size array of Trace=", ScriptObjectReality.getCountObjectReality ("Trace"))
        console.debug ("Size array of Pole=", ScriptObjectReality.getCountObjectReality ("Pole"))
//        console.debug ("Size array of TEMP=", ar.length)

        sgnManagementTreadmill ("*105#110" + "1.17" + "*")
        sgnManagementTreadmill ("*105#112" + "1" + "*")

        console.debug ("НастройКИ ДЛЯ дорожкИ")
    }

//    Component.onStatusChanged: {
//        console.log ("root::onStatusChanged=", status)
//    }

    onHeightChanged: { ScriptCvCapture.resizeQmlCVCapture () }
    onWidthChanged: { ScriptCvCapture.resizeQmlCVCapture () }

    Timer {
        id: timerTrackSpeed
        interval: 5 / sliderTrackSpeed
//        interval: 13
        running: false //true
        repeat: true

        onTriggeredOnStartChanged: {
            console.debug ("timerTrackSpeed::onTriggeredOnStartChanged", "running=", running)
        }

        onTriggered: {
            ScriptTimerSpeed.motionTrace ()
//            console.debug ("timerTrackSpeed::interval = ", interval)
//            sliderCurrentTime = sliderPreviousTime + 5 / sliderTrackSpeed * timerTrackSpeedCountTick / 1000
//            sliderCurrentDistance = sliderPreviousDistance + sliderTrackSpeed * 5 / sliderTrackSpeed * timerTrackSpeedCountTick / 3600 / 1000
            sliderCurrentDistance = sliderPreviousDistance + sliderCurrentTime * sliderTrackSpeed / 3600

//            timerTrackSpeedCountTick ++

//            console.debug ("timerTrackSpeedCountTick = ", timerTrackSpeedCountTick)
//            console.debug ("sliderCurrentTime = ", sliderCurrentTime)
//            console.debug ("sliderCurrentDistance = ", sliderCurrentDistance)
        }
    }

    Timer {
        id: timerPulse
        interval: 500
//        interval: 13
        running: true
        repeat: true

        onTriggered: {
            sgnQueryPulse ("*111#34*")

            sliderRealTime += interval / 1000

            if (timerTrackSpeed.running)
                sliderCurrentTime += interval / 1000
        }
    }

    //Столбец - управление ДОРОЖКой
    HColumnTreadmill { id: columnTreadmill}

    //Столбец - управление ТРЕНИРОВКАми
    HColumnTraining {}

    //Столбец - управление КАМЕРАми
    Column {
        id: columnCamera
        spacing: 3

//        x: ScriptCvCapture.posXItem (2, 0)
        width: widthManagmentArea

        anchors.right: parent.right
        anchors.rightMargin: global_offset
        anchors.top: parent.top
        anchors.topMargin: global_offset

        //Строка - описание
        Row {
            parent: columnCamera
            width: parent.width
            Text {
                text: "Камеры"
                font {
                    pixelSize: Math.round (parent.width * 0.15)
                }
            }
        }
        //Строка - КАМЕРа №1
        Row {
            id: rowCameraBase

            width: parent.width

            HButton {
                id: btnCameraBase
                parent: rowCameraBase
                width: parent.width
                height: heightControl
                textUnchecked: "Камера 1"
                textChecked: "Камера 1"

                checked: false
                checkable: true

                onClicked: {

                }

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        btnCameraFace.checked = !checked

//                        recoverySliderValueCamera ()
                    }
                    else {
                        if (! btnCameraFace.checked) {
//                            btnVectorEye.checked = false
//                            btnVectorCenter.checked = false
//                            btnVectorUp.checked = false
                        }
                    }
                }

                onDoubleClicked: {
                }

                Connections {
//                    target:
                }
            }
        }
        //Строка - КАМЕРа №2
        Row {
            id: rowCameraFace

            width: parent.width

            enabled: true

//            CheckBox {
//                id: checkBoxCameraFace
//                objectName: "checkBoxCameraFace"
//                parent: rowCameraFace
//                width: 0.2 * parent.width

//                checked: false

//                onCheckedChanged: {
//                    console.debug ("checkBoxCameraFace::onCheckedChanged", checkBoxCameraFace.checked)
//                }
//            }

//            Button {
//                id: btnCameraFace
//                parent: rowCameraFace
////                width: parent.width - checkBoxCameraFace.width
//                width: parent.width

//                text: "Камера 2"

//                checkable: true

//                onCheckedChanged: {
//                    if (checked) {
//                        //Остальные 'ПОДНИМаем'
//                        btnCameraBase.checked = false

////                        recoverySliderValueCamera ()
//                    }
//                    else {
//                        if (! btnCameraBase.checked) {
////                            btnVectorEye.checked = false
////                            btnVectorCenter.checked = false
////                            btnVectorUp.checked = false
//                        }
//                    }
//                }
//            }

            HButton {
                id: btnCameraFace
                parent: rowCameraFace
                width: parent.width
                height: heightControl
                textUnchecked: "Камера 2"
                textChecked: "Камера 2"

                checked: false
                checkable: true

                onClicked: {

                }

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        btnCameraBase.checked = !checked

//                        recoverySliderValueCamera ()
                    }
                    else {
                        if (! btnCameraBase.checked) {
//                            btnVectorEye.checked = false
//                            btnVectorCenter.checked = false
//                            btnVectorUp.checked = false
                        }
                    }
                }

                onDoubleClicked: {
                }

                Connections {
//                    target:
                }
            }
        }

        //Строка - Фиксация центра фиизмческих координат
        Row {
            id: rowFixedPSC

            width: parent.width

            enabled: true

            HButton {
                id: btnFixedPSC
                parent: rowFixedPSC
                width: parent.width
                height: heightControl
                textUnchecked: "Поиск ЦФСК"
                textChecked: "Поиск ЦФСК"

                checked: false
                checkable: true

                onClicked: {
                }

                onCheckedChanged: {
                    m_synchCoordinates.fixedPSC (checked)
                }

                onDoubleClicked: {
                }

                Connections {
//                    target:
                }
            }
        }

    }

//    Столбец - управление ОбЪектАМи расширенной реальности
//    HManagementObjectReality {
//        id: columnManagementObjectReality
//    }

//    Столбец - управление ОбЪектАМи расширенной реальности
    Column {
    //    id: columnManagementObjectReality

    //    x: ScriptCvCapture.posXItem (2, 0)
        width: widthManagmentArea

        anchors.right: parent.right
        anchors.rightMargin: global_offset
        anchors.bottom: parent.bottom
        anchors.bottomMargin: global_offset

        //Строка - слайдер для управления 1-ой координатой ПАРАМЕТРа обЪекта
        Row {
            id: rowSliderLineX
            enabled: btnPosition.checked || btnRotation.checked || btnSize.checked

            width: parent.width

            TextField {
                id: textFieldSliderLineX
                parent: rowSliderLineX
                width: 0.2 * parent.width

                text: ScriptSliderManage.textFieldText (sliderObjectX.value)
                font {
                    pixelSize: Math.round (width * 0.3)
                }
                horizontalalignment: TextInput.AlignHCenter
            }

            Slider {
                id: sliderObjectX
                objectName: "sliderObjectX"
                width: parent.width - textFieldSliderLineX.width

                tickmarksEnabled: true
                tickPosition: "BothSides"

                onValueChanged: {
                    ScriptObjectReality.replacementObjectReality ()
                }

                onEnabledChanged: {
                    console.debug (objectName, "::onEnabledChanged")
                }
            }
        }
        //Строка - слайдер для управления 2-ой координатой ПАРАМЕТРа обЪекта
        Row {
            id: rowSliderLineY
            enabled: btnPosition.checked || btnRotation.checked || btnSize.checked

            width: parent.width

            TextField {
                id: textFieldSliderLineY
                parent: rowSliderLineY
                width: 0.2 * parent.width

                text: ScriptSliderManage.textFieldText (sliderObjectY.value)
                font {
                    pixelSize: Math.round (width * 0.3)
                }
                horizontalalignment: TextInput.AlignHCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                    }
                }
            }

            Slider {
                id: sliderObjectY
                objectName: "sliderObjectY"
                width: parent.width - textFieldSliderLineY.width

                tickmarksEnabled: true
                tickPosition: "BothSides"

                onValueChanged: {
                    ScriptObjectReality.replacementObjectReality ()
                }

                onEnabledChanged: {
                    console.debug (objectName, "::onEnabledChanged")
                }
            }
        }
        //Строка - слайдер для управления 3-ей координатой ПАРАМЕТРа обЪекта
        Row {
            id: rowSliderLineZ
            enabled: btnPosition.checked || btnRotation.checked || btnSize.checked

            width: parent.width

            TextField {
                id: textFieldSliderLineZ
                parent: rowSliderLineZ
                width: 0.2 * parent.width

                text: ScriptSliderManage.textFieldText (sliderObjectZ.value)
                font {
                    pixelSize: Math.round (width * 0.3)
                }
                horizontalalignment: TextInput.AlignHCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                    }
                }
            }

            Slider {
                id: sliderObjectZ
                objectName: "sliderObjectZ"
                width: parent.width - textFieldSliderLineZ.width

                tickmarksEnabled: true
                tickPosition: "BothSides"

                onValueChanged: {
                    ScriptObjectReality.replacementObjectReality ()
                }

                onEnabledChanged: {
                    console.debug (objectName, "::onEnabledChanged")
                }
            }
        }

        //Строка - 'Позиция'
        Row {
            id: rowButtonPosition
            width: parent.width

            enabled: ScriptObjectReality.enabledRowReplacement ()

            Button {
                id: btnPosition
                parent: rowButtonPosition
                width: parent.width

                text: "Позиция"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnRotation.checked)
                            btnRotation.checked = false
                        if (btnSize.checked)
                            btnSize.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else
                        //Очистить 'sliderValue'
                        if (! btnRotation.checked && ! btnSize.checked)
                            ScriptSliderManage.sliderNonValue (sliderObjectX, sliderObjectY, sliderObjectZ)
                }
            }
        }
        //Строка - 'Вращение'
        Row {
            id: rowButtonRotation
            width: parent.width

            enabled: ScriptObjectReality.enabledRowReplacement ()

            Button {
                id: btnRotation
                parent: rowButtonRotation
                width: parent.width

                text: "Вращение"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnPosition.checked)
                            btnPosition.checked = false
                        if (btnSize.checked)
                            btnSize.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else
                        //Очистить 'sliderValue'
                        if (! btnPosition.checked && ! btnSize.checked)
                            sliderNonValue (sliderObjectX, sliderObjectX, sliderObjectZ)
                }
            }
        }
        //Строка - 'Размер'
        Row {
            id: rowButtonSize
            width: parent.width

            enabled: ScriptObjectReality.enabledRowReplacement ()

            Button {
                id: btnSize
                parent: rowButtonSize
                width: parent.width

                text: "Размер"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        btnPosition.checked = false
                        btnRotation.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else
                        //Очистить 'sliderValue'
                        if (! btnPosition.checked && ! btnRotation.checked)
                            ScriptSliderManage.sliderNonValue (sliderObjectX, sliderObjectX, sliderObjectZ)
                }
            }
        }

        //Строка - Центр ФСК
        Row {
            id: rowCenterPSC
    //            enabled: cameraBase.visible || cameraFace.visible

            width: parent.width

            CheckBox {
                id: checkBoxCenterPSC
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
                    if (checked) {
                    }
                    else {
                    }
                        centerPSC.visible = checked
    //                    console.log (checked, cubeCenter.visible)
                }
            }

            Button {
                id: btnCenterPSC
                objectName: "btnCenterPSC"
                parent: rowCenterPSC
                width: parent.width - checkBoxCenterPSC.width

                text: "ЦентрФСК"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnLine1.checked)
                            btnLine1.checked = false
                        if (btnLine2.checked)
                            btnLine2.checked = false
                        if (btnTrace1.checked)
                            btnTrace1.checked = false
                        if (btnTrace2.checked)
                            btnTrace2.checked = false
                        if (btnGamma.checked)
                            btnGamma.checked = false
                        if (btnLattice.checked)
                            btnLattice.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()

                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }

        //Строка - Линия 1
        Row {
            id: rowLine1
            enabled: cameraBase.visible || cameraFace.visible
    //            enabled: false

            width: parent.width

            CheckBox {
                id: checkBoxLine1
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
                    if (checked) {
                    }
                    else {
                    }

                    line1.visible = checked
                }
            }

            Button {
                id: btnLine1
                objectName: "btnLine1"
                parent: rowLine1
                width: parent.width - checkBoxLine1.width

                text: "Линия 1"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnCenterPSC.checked)
                            btnCenterPSC.checked = false
                        if (btnLine2.checked)
                            btnLine2.checked = false
                        if (btnTrace1.checked)
                            btnTrace1.checked = false
                        if (btnTrace2.checked)
                            btnTrace2.checked = false
                        if (btnGamma.checked)
                            btnGamma.checked = false
                        if (btnLattice.checked)
                            btnLattice.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }
        //Строка - Линия 2
        Row {
            id: rowLine2
            enabled: cameraBase.visible || cameraFace.visible
    //            enabled: false

            width: parent.width

            CheckBox {
                id: checkBoxLine2
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
                    if (checked) {
                    }
                    else {
                    }

                    line2.visible = checked
                }
            }

            Button {
                id: btnLine2
                objectName: "btnLine2"
                parent: rowLine2
                width: parent.width - checkBoxLine2.width

                text: "Линия 2"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnCenterPSC.checked)
                            btnCenterPSC.checked = false
                        if (btnLine1.checked)
                            btnLine1.checked = false
                        if (btnTrace1.checked)
                            btnTrace1.checked = false
                        if (btnTrace2.checked)
                            btnTrace2.checked = false
                        if (btnGamma.checked)
                            btnGamma.checked = false
                        if (btnLattice.checked)
                            btnLattice.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }

        //Строка - След 1
        Row {
            id: rowTrace1

            width: parent.width

            CheckBox {
                id: checkBoxTrace1
                parent: rowTrace1
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
    //                Отладка
                    console.debug ("checkBoxTrace1::onCheckedChanged, checked = ", checked)
                    console.debug ("count_of_trace = ", count_of_trace)

                    var i, trace
                    for (i = 1; i < count_of_trace; i += 2) {
    //                        console.debug (ScriptObjectReality.arObjectReality [i])
                        ScriptTimerSpeed.visibleTrace (i, checked)
    //                        if (checked) {
    //                            if ((! (m_synchCoordinates.getValue (trace, "position", "X") < begin_position_track + direction_track * length_track)) &&
    //                                (! (m_synchCoordinates.getValue (trace, "position", "X") > begin_position_track)))
    //                                m_synchCoordinates.setVisible (trace, true)
    //                            else
    //                                m_synchCoordinates.setVisible (trace, false)
    //                        }
    //                        else {
    //                            m_synchCoordinates.setVisible (trace, false)
    //                        m_synchCoordinates.setVisible (trace, checked)
    //                        }
                    }
                }
            }

            Button {
                id: btnTrace1
                objectName: "btnTrace1"
                parent: rowTrace1
                width: parent.width - checkBoxTrace1.width

                text: "След 1"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnCenterPSC.checked)
                            btnCenterPSC.checked = false
                        if (btnLine1.checked)
                            btnLine1.checked = false
                        if (btnLine2.checked)
                            btnLine2.checked = false
                        if (btnTrace2.checked)
                            btnTrace2.checked = false
                        if (btnGamma.checked)
                            btnGamma.checked = false
                        if (btnLattice.checked)
                            btnLattice.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }
        //Строка - След 2
        Row {
            id: rowTrace2

            width: parent.width

            CheckBox {
                id: checkBoxTrace2
                parent: rowTrace2
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
                    var i, trace
                    for (i = 2; i <= count_of_trace; i += 2) {
    //                        console.debug (ScriptObjectReality.arObjectReality [i])
                        ScriptTimerSpeed.visibleTrace (i, checked)
    //                        if (checked) {
    //                            if ((! (m_synchCoordinates.getValue (trace, "position", "X") < begin_position_track + direction_track * length_track)) &&
    //                                (! (m_synchCoordinates.getValue (trace, "position", "X") > begin_position_track)))
    //                                m_synchCoordinates.setVisible (trace, true)
    //                            else
    //                                m_synchCoordinates.setVisible (trace, false)
    //                        }
    //                        else {
    //                            m_synchCoordinates.setVisible (trace, false)
    //                        m_synchCoordinates.setVisible (trace, checked)
    //                        }
                    }
                }
            }

            Button {
                id: btnTrace2
                objectName: "btnTrace2"
                parent: rowTrace2
                width: parent.width - checkBoxTrace2.width

                text: "След 2"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        if (btnCenterPSC.checked)
                            btnCenterPSC.checked = false
                        if (btnLine1.checked)
                            btnLine1.checked = false
                        if (btnLine2.checked)
                            btnLine2.checked = false
                        if (btnTrace1.checked)
                            btnTrace1.checked = false
                        if (btnGamma.checked)
                            btnGamma.checked = false
                        if (btnLattice.checked)
                            btnLattice.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }

        //Строка - Гамма
        Row {
            id: rowGamma
            enabled: cameraBase.visible || cameraFace.visible
    //            enabled: false

            width: parent.width

            CheckBox {
                id: checkBoxGamma
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
                    if (checked) {
                    }
                    else {
                    }

                    gamma1.visible = checked
                    gamma2.visible = checked
                }
            }

            Button {
                id: btnGamma
                objectName: "btnGamma"
                parent: rowGamma
                width: parent.width - checkBoxGamma.width

                text: "Гамма"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
    //                        unCheckableButton (btnGamma)
                        if (btnCenterPSC.checked)
                            btnCenterPSC.checked = false
                        if (btnLine1.checked)
                            btnLine1.checked = false
                        if (btnLine2.checked)
                            btnLine2.checked = false
                        if (btnTrace1.checked)
                            btnTrace1.checked = false
                        if (btnTrace2.checked)
                            btnTrace2.checked = false
                        if (btnLattice.checked)
                            btnLattice.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }

        //Строка - Стена (РЕШёТКа - ФРОНТ (REAR))
        Row {
            id: rowLattice
            enabled: cameraBase.visible || cameraFace.visible
    //            enabled: false

            width: parent.width

            CheckBox {
                id: checkBoxLattice
                width: 0.2 * parent.width
                enabled: cameraBase.visible || cameraFace.visible

                checked: false

                onCheckedChanged: {
                    if (checked) {
                    }
                    else {
                    }

                    if (cameraBase.visible)
                        latticeFront.visible = checked
                    else
                        latticeFront.visible = false

                    if (cameraFace.visible)
                        latticeRear.visible = checked
                    else
                        latticeRear.visible = false
                }
            }

            Button {
                id: btnLattice
                objectName: "btnLattice" //"btn" + latticeFront.objectName
                parent: rowLattice
                width: parent.width - checkBoxLattice.width

                text: "Решётка"

                checkable: true

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
    //                        unCheckableButton (btnGamma)
                        if (btnCenterPSC.checked)
                            btnCenterPSC.checked = false
                        if (btnLine1.checked)
                            btnLine1.checked = false
                        if (btnLine2.checked)
                            btnLine2.checked = false
                        if (btnTrace1.checked)
                            btnTrace1.checked = false
                        if (btnTrace2.checked)
                            btnTrace2.checked = false
                        if (btnGamma.checked)
                            btnGamma.checked = false

                        ScriptSliderManage.recoverySliderValueObject ()
                    }
                    else {
                        btnPosition.checked = false
                        btnRotation.checked = false
                        btnSize.checked = false
                    }
                }
            }
        }

        //_Отладка
        Button {
            id: btnDebug

            width: parent.width
            text: "Отладка"

            onClicked: {
                var gText = ""
                console.log ("\n")

                var doc = new XMLHttpRequest ();
                console.debug (JSON.stringify (doc))
                doc.onreadystatechange = function () {
                    function showRequestInfo (text) {
                        text = gText + "\n" + text
                        console.log (text)
                    }

                    function showRequestInfoXMLHttpRequest (obj) {
                        showRequestInfo ("Headers -->");
                        showRequestInfo (doc.getAllResponseHeaders ());
                        showRequestInfo ("Last modified -->");
                        showRequestInfo (doc.getResponseHeader ("Last-Modified"));
                    }

                    if (doc.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                        showRequestInfoXMLHttpRequest (doc)
                    }
                    else
                        if (doc.readyState === XMLHttpRequest.DONE) {
                            var a = doc.responseText;
    //                            for (var ii = 0; ii < a.childNodes.length; ++ii) {
    //                                showRequestInfo(a.childNodes[ii].nodeName);
    //                            }

                            console.debug (a)

                            showRequestInfoXMLHttpRequest (doc)
                        }
                }

                doc.open ("GET", "http://localhost:5984/blablabla/_design/pushkins/_view/get_by_name");
                doc.send();
            }
        }
    }

    //ОбЪектЫ расширенной реальности
    //Центр ФСК
    HObjectReality {
        id: centerPSC
        objectName: "CenterPSC"
        opacity: 0.8
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

    //    Component.onCompleted: {
    //        ScriptObjectReality.traceOnCompleted (traceX, X)
    //    }
    }

    //РешЁтка - ФРОНт
    HObjectReality {
        id: latticeFront
        objectName: "LatticeFront" //НЕ ЗАБЫВАть ИЗМЕНить 'id' соответствуюЩЕй КНОПКи
        opacity: 0.8
        visible: false
//        sourceEntity: "Plane.mesh"
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            placements [0].sliders [0].sliderValue = 0.0
            placements [0].sliders [1].sliderValue = 0.0
            placements [0].sliders [2].sliderValue = -1.0

            placements [2].sliders [0].sliderValue = 6.0
            placements [2].sliders [1].sliderValue = 6.0
            placements [2].sliders [2].sliderValue = 6.0
        }
    }
    //РешЁтка - вид СЗАДи
    HObjectReality {
        id: latticeRear
        objectName: "LatticeRear" //НЕ ЗАБЫВАть ИЗМЕНить 'id' соответствуюЩЕй КНОПКи
        opacity: 0.6
        visible: false
//        sourceEntity: "Plane.mesh"
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            placements [0].sliders [0].sliderValue = 0.0
            placements [0].sliders [1].sliderValue = 1.0
            placements [0].sliders [2].sliderValue = 0.0

            placements [2].sliders [0].sliderValue = 6.0
            placements [2].sliders [1].sliderValue = 6.0
            placements [2].sliders [2].sliderValue = 6.0
        }
    }

    //Линия №1
    HObjectReality {
        id: line1
        objectName: "Line1"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            placements [0].sliders [0].sliderValue = 0.1
            placements [0].sliders [1].sliderValue = 0.2
            placements [0].sliders [2].sliderValue = 0.0

            placements [2].sliders [0].sliderValue = 0.1
            placements [2].sliders [1].sliderValue = 0.1
            placements [2].sliders [2].sliderValue = 4.0
        }
    }
    //Линия №2
    HObjectReality {
        id: line2
        objectName: "Line2"
        opacity: 0.6
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            placements [0].sliders [0].sliderValue = -0.3
            placements [0].sliders [1].sliderValue = 0.3
            placements [0].sliders [2].sliderValue = 0.0

            placements [2].sliders [0].sliderValue = 0.1
            placements [2].sliders [1].sliderValue = 0.1
            placements [2].sliders [2].sliderValue = 4.0
        }
    }

    //Составной обЪект ГАММА
    //Гамма №1
    HObjectReality {
        id: gamma1
        objectName: "Gamma1"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            var vec3D = ScriptObjectReality.getPositionTrace (3, 0)
            placements [0].sliders [0].sliderValue = vec3D.x
            placements [0].sliders [1].sliderValue = vec3D.y
            placements [0].sliders [2].sliderValue = vec3D.z
//            ШиринА следа
            placements [0].sliders [2].sliderValue -= 0.02754

            placements [2].sliders [0].sliderValue = 0.1
            placements [2].sliders [1].sliderValue = 1.0
            placements [2].sliders [2].sliderValue = 1.0
        }
    }
    //Гамма №2
    HObjectReality {
        id: gamma2
        objectName: "Gamma2"
        opacity: 0.6
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            var vec3D = ScriptObjectReality.getPositionTrace (3, 0)
            placements [0].sliders [0].sliderValue = vec3D.x
            placements [0].sliders [1].sliderValue = vec3D.y
//            ВысотА 1-ой части
            placements [0].sliders [1].sliderValue += 2 * 0.02754
            placements [0].sliders [2].sliderValue = vec3D.z
//            ШиринА следа
            placements [0].sliders [2].sliderValue -= 0.02754

            placements [2].sliders [0].sliderValue = 1.0
            placements [2].sliders [1].sliderValue = 0.1
            placements [2].sliders [2].sliderValue = 1.0
        }
    }

    //След №1
    HObjectReality {
        id: trace1
        objectName: "Trace1"
        opacity: 0.9
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            ScriptObjectReality.traceOnCompleted (trace1, 1, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE);
        }
    }
    //След №2
    HObjectReality {
        id: trace2
        objectName: "Trace2"
        opacity: 0.6
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            ScriptObjectReality.traceOnCompleted (trace2, 2, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE);
        }
    }

    //Кол №1 (для следа №1)
    HObjectReality {
        id: pole1
        objectName: "Pole1"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            var vec3DPos = ScriptObjectReality.getPositionPole (1, 0)
            placements [0].sliders [0].sliderValue = vec3DPos.x
            placements [0].sliders [1].sliderValue = vec3DPos.y
            placements [0].sliders [2].sliderValue = vec3DPos.z

            vec3DPos = ScriptObjectReality.getSizePole ()
            placements [2].sliders [0].sliderValue = vec3DPos.x
            placements [2].sliders [1].sliderValue = vec3DPos.y
            placements [2].sliders [2].sliderValue = vec3DPos.z
        }
    }
    //Кол №2 (для следа №2)
    HObjectReality {
        id: pole2
        objectName: "Pole2"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HItemManagement { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HItemManagement { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HItemManagement { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
            var vec3DPos = ScriptObjectReality.getPositionPole (2, 0)
            placements [0].sliders [0].sliderValue = vec3DPos.x
            placements [0].sliders [1].sliderValue = vec3DPos.y
            placements [0].sliders [2].sliderValue = vec3DPos.z

            vec3DPos = ScriptObjectReality.getSizePole ()
            placements [2].sliders [0].sliderValue = vec3DPos.x
            placements [2].sliders [1].sliderValue = vec3DPos.y
            placements [2].sliders [2].sliderValue = vec3DPos.z
        }
    }

    QmlCVCapture {
        id: cameraBase
        x: ScriptCvCapture.posXItem (1, 0)
        objectName: "cameraBase"
        parent: rectangleForm
        numPort: 0
        interval: 1
//        width: cameraBase.visible && cameraFace.visible ? widthQmlCvCapture : widthCvCaptureArea
        width: widthCvCaptureArea
        anchors.top: parent.top
        anchors.topMargin: global_offset
        anchors.bottom: parent.bottom
        anchors.bottomMargin: global_offset
        rcOutput {
            x: 0 //Отрезать СЛЕВа
            y: 0 //Отрезать СВЕРХу
            width: 640 //Ширина
            height: 480 //Высота
        }
//        visible: buttonCameraBase.checked
        visible: btnCameraBase.checked
//        visible: true
//        opacity: 0

        Component.onCompleted: completed ();

        onVisibleChanged: {
            console.debug ("cameraBase::onVisibleChanged", visible)

            if (visible)
                cameraBase.start ()
            else
                cameraBase.stop ()

            ScriptCvCapture.resizeQmlCVCapture ()
        }
    }

    QmlCVCapture {
        id: cameraFace
        x: cameraBase.visible ? ScriptCvCapture.posXItem (1, 1) : ScriptCvCapture.posXItem (1, 0)
        objectName: "cameraFace"
        parent: rectangleForm
        numPort: 2
        interval: 1
        width: cameraBase.visible && cameraFace.visible ? widthQmlCvCapture : widthCvCaptureArea
        anchors.top: parent.top
        anchors.topMargin: global_offset
        anchors.bottom: parent.bottom
        anchors.bottomMargin: global_offset
        rcOutput {
            x: 0
            y: 0
            width: 640
            height: 480
        }

//        visible: checkBoxCameraFace.checked
        visible: btnCameraFace.checked

        onVisibleChanged: {
            console.debug ("cameraFace::onVisibleChanged", visible)

            if (visible)
                cameraFace.start ()
            else
                cameraFace.stop ()

            ScriptCvCapture.resizeQmlCVCapture ()
        }
    }

    HSynchCoordinates {
        id: m_synchCoordinates
        objectName: "m_SynchCoordinates"

        idMarkerPSC: 166
        szMarkerPSC: 0.06
    }
}

/*
Rectangle {
     id: forwarder
     width: 100; height: 100

     signal send()
     onSend: console.log("Send clicked")

     MouseArea {
         id: mousearea
         anchors.fill: parent
         onClicked: console.log("MouseArea clicked")
     }
     Component.onCompleted: {
         mousearea.clicked.connect(send)
     }
}
*/
