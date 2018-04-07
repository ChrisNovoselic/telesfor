// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

//import "objectReality.js" as ScriptObjectReality
//import "timerspeed.js" as ScriptTimerSpeed

Item {
    property variant objectTextField: undefined //Текстовое ПОЛе, инициирующЕЕ появление 'rectanglePopup'

    property variant val: 0 //ГРАДУСЫ, км/ч, СЕКУНДы, метрЫ
    property variant default_val: 0  //Значение по УМОЛЧаниЮ для 'val'
    property variant min_val: 0  //Мин. значение для 'val'
    property variant max_val: 0 * 666  //Макс. значение для 'val'
    property variant step_val: 0 //Еденичный шаг для 'val'
    property variant coeff_val: 0 //КоэФФициенТ для УСКОРЕННОГо изменения 'val'
    onValChanged: {
        console.debug ("HValueParams::onValChanged = ", objectName, val)

        if (! (columnTraining === null)) {
//            if (objectName.indexOf ("StepsLength") > -1)
//                val = Math.round (val * 100) / 100
//            else
//                ;

//            if (val > max_val)
//                val = max_val

//            if (val < min_val)
//                val = min_val

            var field //ДЛя отправки изменения в БД

            if (objectName.indexOf ("TrackTilt") > -1) {
                field = 'tilt'

                sgnManagementTreadmill ("*605#" + (500 + (4000 - 500) / 12 * val).toFixed (2) + "*")

                console.debug ("*605#" + (500 + (4000 - 500) / 12 * val).toFixed (2) + "*")
                console.debug ("val = ", val)
            }
            else {
                if (objectName.indexOf ("TrackSpeed") > -1) {
                    field = 'speed'

                     console.debug ("sliderTrackSpeed::onValueChanged = ", val)

                    if (columnTreadmill.getButtonTrackRun ().checked) {
                        sgnManagementTreadmill ("*604#" + (val * 5).toFixed (2) + "*")

////                        timerTrackSpeedCountTick = 0
//                        sliderPreviousTime += sliderCurrentTime
//                        sliderCurrentTime = 0
//                        sliderPreviousDistance = sliderCurrentDistance
//                        sliderCurrentDistance = 0

                        console.debug ("*604#" + (paramTrackSpeed.val * 5).toFixed (1) + "*")
                    }
                    else
                        ;
                }
                else {
                    if (objectName.indexOf ("TrainingDistance") > -1) {
                        //НИЧЕГо не делаем
                        field = 'distance'
                    }
                    else {
                        if (objectName.indexOf ("TrainingTime") > -1) {
                            //НИЧЕГо не делаем
                            field = 'time'
                        }
                        else {
                            if (objectName.indexOf ("StepsLength") > -1) {
                                field = 'stepsLength'

//                                sgnRefitObjectReality ()
                            }
                            else {
                                if (objectName.indexOf ("...") > -1) {
                                    //НИЧЕГо не делаем
                                }
                                else {
                                }
                            }
                        }
                    }
                }
            }

//            ТОЛьКо ЕСЛИ треНИРовкА проходит ВООБЩе
            if (columnTreadmill.getButtonTrackRun ().checked) {
//                ТОЛьКо ЕСЛИ треНИРовкА проходит по ПРОИЗВОЛьномУ сценАРиЮ (btnPatientTask.checked === true && btnPatientTask.objectName === 'Custom')
                var btnPatientTask = columnPatientTask.getButtonTaskChecked (), taskJSON
                if (! (btnPatientTask === undefined))
                    if (! (btnPatientTask.taskJSON === undefined))
                        if (btnPatientTask.taskJSON ["_id"].indexOf ('Custom') > -1) {
//                            При 'taskCustom' это ОДНоРАЗовая АКЦия
                            sliderCurrentTrainingStage ++
                        }
                        else
                            ;
                    else
                        ;
                else
                    ;
            }
            else
                ;

//            if (columnTraining.getButtonTrainingRun ().checked) {
//                sgnTrainingChange (field, val)

//                console.debug ("HValueParams::onValChanged = ", field, val)
//            }
//            else
//                ;
        }
        else
            ;

//        console.debug ("HValueParams::onValChanged, columnTraining =", columnTraining)
    }

    Component.onCompleted: {
        console.debug (objectName, ".onCompleted = ", val)
    }
}
