import QtQuick 1.0

import "hcouch.js" as ScriptHCouchDB

import "objectReality.js" as ScriptObjectReality
import "cvcapture.js" as ScriptCvCapture
//import "timerspeed.js" as ScriptTimerSpeed
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
    signal sgnReplacmentObject(string line, string itemManagement) //???

//    signal sgnReplacmentObjectReality(string line, string itemManagement) //???
//    onSgnReplacmentObjectReality: { ScriptObjectReality.replacementObjectReality () } //ПосЫл 'sgnReplacmentObject' ???

    //    signal sgnRefitObjectReality ()
//    onSgnRefitObjectReality: { ScriptObjectReality.refit () }

//    signal sgnAddStaticObjectReality (variant obj)
//    onSgnAddStaticObjectReality: {
////        console.debug ("::onSgnAddStaticObjectReality", obj.objectName)
////        ScriptObjectReality.arObjectReality.push (obj)
//    }

    signal sgnIsCreateObjectReality (string namePrefix, int num)
    function onSgnCreateObjectReality (namePrefix, num) {
        var src = "objectReality.qml"
        var obj = Qt.createComponent (src)

        if (obj.status === Component.Ready) {
            obj = obj.createObject (descObjectsReality, {})
            if (obj === null)
                // Error Handling
                console.debug ("Ошибка создания 'objectReality'")
            else {

                obj.objectName = namePrefix + num
                console.debug  ("Создание по запросу со стороНЫ C++ обЪекта с имеНЕм =", obj.objectName)

                sgnIsCreateObjectReality (namePrefix, num)
            }
        }
        else {
            console.log ("Ошибка загрузки 'objectReality':", obj.errorString ())
        }
    }

    signal sgnSetPlacementsMovable (string name)
    signal sgnMotionTrace ()
    signal sgnSetVisibleObjectReality (string prefix, int num, bool val)

    signal sgnManagementTreadmill(string cmd) //ПодачА командЫ для ДОРОЖКи

//    Во времЯ тренировки в БД есть 2 (ДВа) открытых ДОКументА
//    Свойство для хранения '_id' 1-го из них
    property string idTraining: ""
    onIdTrainingChanged: {
        console.debug ("::onIdTrainingChanged = ", idTraining)
        if (idTraining.length) {
            var postData = '{' +
                            '"id_training":"' + idTraining + '",' +
                            '"id_patient":"' + btnPatientTitle.patientJSON ["_id"] + '",' +
//                            '"discrete":"' + timerPulse.interval + '",' +
                            '"discrete":"' + sliderDBDiscretePulse + '",' +
                            '"type":"' + 'pulse' + '",' +
//                            '"pulse":{"value":"' + textPulseVal + '"}' +
                    '"pulse":{"' + numberMeasurement + '":"' + textPulseVal + '"}' +
                            '}'

//            sgnPostCouchDB (nameDB, typeContent, JSON.parse (postData), function (id) { idTrainingPulse = id })
            ScriptHCouchDB.postCouchdb (nameDB, typeContent, JSON.parse (postData), function (id) { idTrainingPulse = id })
        }
        else {
            idTrainingPulse = ""
        }
    }

//    property string revTraining: ""

//    Свойство для хранения '_id' 2-го из них
    property string idTrainingPulse: ""
    onIdTrainingPulseChanged: {
        console.debug ("::onIdTrainingPulseChanged =", idTrainingPulse)
    }

    function makePutData (field, num, val) {
        return '"' + field + '":{"' + num + '":{"timeStamp":"' + (new Date ()).toTimeString () + '","value":"' + val + '"}}'
    }

    signal sgnGetPatientTask (string key) //Взять заданиЯ для пациЕНЬа из БД
    signal sgnSetPatientTask (string task) //Установить текущее задание (значения ДЛЯ всех 'param' тренировки)
    property variant patientTaskJSON: undefined
    property variant defaultTaskJSON: undefined

//    Сигнал для взаимодействия полей с элементами управления 'Статистика' и 'Тренировка'
//    При увеличеннии высоты одного высота уменьшается у другого
//    signal sgnTrainingStatisticActivate ()

//    Сигнал по нажатию кнопки НАЧАЛО (тренировки) ИЛИ выбор ИНогО пациента
//    Очистить статистику (левая частЬ)
    signal sgnResetStatistic ()
    onSgnResetStatistic: {
//        var btnPatientTask = columnPatientTask.getButtonTaskChecked ()
//        console.debug ("::onSgnResetStatistic:btnPatientTask =", btnPatientTask)
//        if (btnPatientTask === undefined) {
//            paramTrackSpeed.val = paramTrackSpeed.default_val
//            paramTrackTilt.val = paramTrackTilt.default_val
//            paramStepsLength.val = paramStepsLength.default_val
//            paramTrainingDistance.val = paramTrainingDistance.default_val

//            paramTrainingTime.val = paramTrainingTime.default_val
//        }
//        else
//            ;

        sliderCurrentTrainingStage = 0

//        timerTrackSpeedCountTick = 0
        sliderPreviousTime = 0
        sliderCurrentTime = 0
        sliderPreviousDistance = 0
        sliderCurrentDistance = 0

        columnStatistic.setIdTrainingResult ("")
    }

    signal sgnTrainingStart(double speed, double tilt, double stepsLength)
    onSgnTrainingStart: {
//        Останов находящейся в движении дорожки
//        ДО того, как получИМ 'idTraining'
        if (columnTreadmill.getButtonTrackRun ().checked)
            columnTreadmill.getButtonTrackRun ().checked = false
        else
            ;

        var dtBegin = new Date () //Qt.formatTime(tm, "hh:mm:ss")
//        var postData = '{' +
//                    '"id_patient":"' + btnPatientTitle.patientJSON ["_id"] + '",' +
//                    '"' + 'id_pulse' + '":"' + '' + '",' +
//                    '"' + 'countStage' + '":"' + parseInt (sliderCurrentTrainingStage + 1) + '"' + ',' +
//                    '"' + 'id_task' + '":"' + columnPatientTask.getButtonTaskChecked ().taskJSON ["_id"] + '",' +
//                    '"dttm":{"start":{"":"' + dtBegin.toDateString () + ' ' +  dtBegin.toTimeString () + '"}},' +
//                    '"type":"' + 'training' + '",' +
//                    '"speed":{"0":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + paramTrackSpeed.val + '"}},' +
//                    '"incline":{"0":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + paramTrackTilt.val + '"}},' +
////                    '"duration":{"task":"' + paramTrainingTime.val + '"},' +
////                    '"duration":{"0":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + paramTrainingTime.val + '"}},' +
//                    '"duration":"",' +
////                    '"distance":{"task":"' + paramTrainingDistance.val + '"},' +
////                    '"distance":{"0":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + paramTrainingDistance.val + '"}},' +
//                    '"distance":"",' +
////                    '"pulse":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + textPulseVal.toFixed (2) + '"},' +
//                    '"stepsLength":{"0":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + paramStepsLength.val + '"}}' +
//                    '}'

        var postData = '{' +
                    '"id_patient":"' + btnPatientTitle.patientJSON ["_id"] + '",' +
                    '"' + 'id_pulse' + '":"' + '' + '",' +
//                    '"' + 'countStage' + '":"' + parseInt (sliderCurrentTrainingStage + 1) + '"' + ',' +
                    '"' + 'countStage' + '":"' + 1 + '"' + ',' +
//                    '"' + 'countTask' + '":"' + sliderTrainingTask + '",' +
                    '"dttm":{"start":{"":"' + dtBegin.toDateString () + ' ' +  dtBegin.toTimeString () + '"}},' +
                    '"type":"' + 'training' + '",' +
                    '"phases":{' +
                        '"0":{' +
                            '"type":"idle"' + ',' +
                            '"timeStamp":"' + dtBegin.toTimeString () + '"' + ',' +
                            '"speed":"0"' + ',' +
                            '"incline":"0"' + ',' +
                            '"duration":"0"' + ',' +
                            '"distance":"0"' + ',' +
                            '"stepsLength":"0"' +
                            '}' +
                        '}' +
                    '}'

        console.debug ("::onSgnTrainingStart postData =", postData)

//        function setIdTraining (id) { idTraining = id }

//        sgnPostCouchDB (nameDB, typeContent, JSON.parse (postData), function setIdTraining (id) { idTraining = id })
        ScriptHCouchDB.postCouchdb (nameDB, typeContent, JSON.parse (postData), function (id) { idTraining = id })
    }

//    Сигнал и ЕгО обработчик на стороНЕ 'Qml' по изменению параметров тренировки и сохранению их в БД
    signal sgnTrainingChange (string nameParam, double valueParam)
    onSgnTrainingChange: {
//        console.debug ("::onSgnTrainingChange =", nameParam, valueParam)
        sgnPutCouchDB (nameDB, typeContent, idTraining, JSON.parse ('{' + makePutData (nameParam, sliderCurrentTrainingStage, valueParam) + '}'))
    }

//    Сигнал и ЕгО обработчик на стороНЕ 'Qml' по окончательноЙ записи значений параметров тренировки в БД
    signal sgnTrainingStop ()
    onSgnTrainingStop: {
//        Останов находящейся в движении дорожки
//        ДО того, как оСВОБОДим 'idTraining'
        if (columnTreadmill.getButtonTrackRun ().checked)
            columnTreadmill.getButtonTrackRun ().checked = false
        else
            ;

        var dtNow = new Date (), timeTotal = (sliderPreviousTime + sliderCurrentTime) + ((sliderPreviousTime + sliderCurrentTime) % 60), putData
//            , stageTraining = sliderCurrentTrainingStage > 0 ? sliderCurrentTrainingStage : 1
//            , stageParam = sliderCurrentTrainingStage + 1
        , stage = sliderTrainingStage
//        if (! (columnPatientTask.getButtonTaskChecked ().taskJSON ['_id'].indexOf ('Custom') > -1))
////        if (isLimit ()) после нажатия кнопки СТОП БЕСПОЛЕЗНа ???
//            ; //stage --
//        else
//            stage --

        putData = '{' +
                    '"' + 'id_pulse' + '":"' + idTrainingPulse + '"' + ',' +
                    '"' + 'countStage' + '":"' + parseInt (stage) + '"' + ',' +
                    '"' + 'countTask' + '":"' + sliderTrainingTask + '",' +
                    '"dttm":{"end":{"":"' + dtNow.toDateString () + ' ' +  dtNow.toTimeString () + '"}},' +
                    '"phases":{' +
                    '"' + (stage - 1) + '":{' +
//                            '"type":"query"' + ',' + //Если TreadmillRun === true, то ???
//                            '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
//                            '"speed":"0"' + ',' +
//                            '"incline":"0"' + ',' +
                            '"duration":"' + sliderCurrentTime + '"' + ',' +
                            '"distance":"' + sliderCurrentDistance + '"' + //',' +
//                            '"stepsLength":"0"' +
                            '}' +
                        '}' +
                    '}'

        console.debug (parseFloat (sliderPreviousTime), parseFloat (sliderCurrentTime))
        console.debug ("::onSgnTrainingStop () putData =", putData)

        sgnPutCouchDB (nameDB, typeContent, idTraining, JSON.parse (putData))

        sgnPutCouchDB (nameDB, typeContent, idTrainingPulse, JSON.parse ('{"pulse":{"' + ++numberMeasurement + '":"' + textPulseVal + '"}}'))

        columnStatistic.setIdTrainingResult (idTraining)
        idTraining = ""
    }

    signal sgnTreadmillStart ()
    onSgnTreadmillStart: {
        timerTrackSpeed.start ()

        if (idTraining.length) {
            var dtNow = new Date (), timeTotal = (sliderPreviousTime + sliderCurrentTime) + ((sliderPreviousTime + sliderCurrentTime) % 60), putData
                , stage = sliderTrainingStage - 1

             putData = '{' +
                        '"tasks":{' +
                            '"' + sliderTrainingTask + '":{' +
                            '"stageStart":"' + stage + '"' + ',' +
                            '"countStage":"' + columnPatientTask.getButtonTaskChecked ().taskJSON ["countStage"] + '"' + ',' +
                            '"id_task":"' + columnPatientTask.getButtonTaskChecked ().taskJSON ["_id"] + '"' + //',' +
                            '}' +
                        '}' + ',' +
                        '"phases":{' +
                            '"' + (stage - 1) + '":{' +
//                                '"type":"query"' + ',' + //Если TreadmillRun === true, то ???
//                                '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
//                                '"speed":"0"' + ',' +
//                                '"incline":"0"' + ',' +
                                '"duration":"' + sliderCurrentTime + '"' + ',' +
                                '"distance":"' + sliderCurrentDistance + '"' + //',' +
//                                '"stepsLength":"0"' +
                            '}' + ',' +
                            '"' + (stage) + '":{' +
                                '"type":"work"' + ',' + //Если TreadmillRun === true, то ???
                                '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
                                '"speed":"' + paramTrackSpeed.val + '"' + ',' +
                                '"incline":"' + paramTrackTilt.val + '"' + ',' +
//                                '"duration":"' + sliderCurrentTime + '"' + ',' +
//                                '"distance":"' + sliderCurrentDistance + '"' + //',' +
                                '"stepsLength":"' + paramStepsLength.val + '"' +
                            '}' +
                        '}' +
                    '}'

            console.debug ("::onSgnTreadmillStart ()", parseFloat (sliderPreviousTime), parseFloat (sliderCurrentTime))
            console.debug ("::onSgnTreadmillStart () putData =", putData)

            sgnPutCouchDB (nameDB, typeContent, idTraining, JSON.parse (putData))
        }
        else
            ;
    }

    signal sgnTreadmillStop ()
    onSgnTreadmillStop: {
        timerTrackSpeed.stop ()

        if (idTraining.length) {
            console.debug ("::onSgnTreadmillStop ()", sliderTrainingStage, sliderCurrentTrainingStage, sliderCurrentTime, sliderCurrentDistance)

            var dtNow = new Date (), timeTotal = (sliderPreviousTime + sliderCurrentTime) + ((sliderPreviousTime + sliderCurrentTime) % 60), putData
                , stage = sliderTrainingStage - 1

//            if (isLimit ())
//                stage --
//            else
//                ;

            putData = '{' +
                        '"phases":{' +
                            '"' + (stage - 1) + '":{' +
//                            '"type":"query"' + ',' + //Если TreadmillRun === true, то ???
//                            '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
//                            '"speed":"0"' + ',' +
//                            '"incline":"0"' + ',' +
                                '"duration":"' + sliderCurrentTime + '"' + ',' +
                                '"distance":"' + sliderCurrentDistance + '"' + //',' +
//                            '"stepsLength":"0"' +
                            '}' + ',' +
                            '"' + (stage) + '":{' +
                                '"type":"idle"' + ',' + //Если TreadmillRun === true, то ???
                                '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
                                '"speed":"0"' + ',' +
                                '"incline":"0"' + ',' +
//                                '"duration":"' + sliderCurrentTime + '"' + ',' +
//                                '"distance":"' + sliderCurrentDistance + '"' + //',' +
                                '"stepsLength":"0"' +
                            '}' +
                        '}' +
                    '}'

            console.debug ("::onSgnTreadmillStop ()", parseFloat (sliderPreviousTime), parseFloat (sliderCurrentTime))
            console.debug ("::onSgnTreadmillStop () putData =", putData)

            sgnPutCouchDB (nameDB, typeContent, idTraining, JSON.parse (putData))
        }
        else
            ;
    }

//    Сигнал для изменения параметров тренировки 'Произвольно'
//    signal sgnChangeTaskCustom

    signal sgnTrainingReport (string content, string lastName, string dt)

//    Определяет по какой причине увеличился текущий номер тренировки по ЛИМИТу/решениЮ пользователЯ
    function isLimit () {
        if ((paramTrainingTime.val < (sliderCurrentTime + timerPulse.interval / 1000)) ||
            (paramTrainingDistance.val < (sliderCurrentDistance + (timerPulse.interval / 1000 / 3600 * paramTrackSpeed.val)))) {
            return true
        }
        else
            return false
    }

//    Определяет по какой причине увеличился текущий номер тренировки по изменениЮ параметра ???
    function isParamTrainingChanged (taskJSON, stage) {
        var bIsParamTrainingChanged = false
        if ((taskJSON ["speed"] ["value"] [stage.toString ()] === paramTrackSpeed.val) &&
            (taskJSON ["tilt"] ["value"] [stage.toString ()] === paramTrackTilt.val) &&
            (taskJSON ["stepsLength"] ["value"] [stage.toString ()] === paramStepsLength.val) &&
            (taskJSON ["time"] ["value"] [stage.toString ()] === paramTrainingTime.val) &&
            (taskJSON ["distance"] ["value"] [stage.toString ()] === paramTrainingDistance.val))
            ;
        else {
            bIsParamTrainingChanged = true

//                console.debug (taskJSON ["speed"] ["value"] [stage.toString ()], paramTrackSpeed.val)
//                console.debug (taskJSON ["tilt"] ["value"] [stage.toString ()], paramTrackTilt.val)
//                console.debug (taskJSON ["stepsLength"] ["value"] [stage.toString ()], paramStepsLength.val)
//                console.debug (taskJSON ["time"] ["value"] [stage.toString ()], paramTrainingTime.val)
//                console.debug (taskJSON ["distance"] ["value"] [stage.toString ()], paramTrainingDistance.val)
        }

//            console.debug ("::onSliderCurrentTrainingStageChanged (), bIsParamTrainingChanged =", bIsParamTrainingChanged)
        return bIsParamTrainingChanged
    }

//    Счётчик общего НОМЕРа ЗАДАНия
    property int sliderTrainingTask: 0
//    Счётчик общего НОМЕРа этапа ТРЕНИРОВКи
    property int sliderTrainingStage: 1
//    Счётчик НОМЕРа этапа ТРЕНИРОВКи
    property int sliderCurrentTrainingStage: 0
    onSliderCurrentTrainingStageChanged: {
        var btnPatientTask = columnPatientTask.getButtonTaskChecked ()
        console.debug ("::onSliderCurrentTrainingStageChanged =", sliderCurrentTrainingStage, btnPatientTask, btnPatientTask.taskJSON ["countStage"])
        if (! (btnPatientTask === undefined)) {
            if (btnPatientTask.taskJSON ["_id"].indexOf ("Custom") > -1) {
//                if (isParamTrainingChanged (btnPatientTask.taskJSON, sliderCurrentTrainingStage - 1) === true) {
                if (! isLimit ()) {
                    var task = btnPatientTask.taskJSON
                    task ["countStage"] ++

                    task ["speed"] ["value"] [sliderCurrentTrainingStage.toString ()] = paramTrackSpeed.val
                    task ["tilt"] ["value"] [sliderCurrentTrainingStage.toString ()] = paramTrackTilt.val
                    task ["stepsLength"] ["value"] [sliderCurrentTrainingStage.toString ()] = paramStepsLength.val
                    task ["time"] ["value"] [sliderCurrentTrainingStage.toString ()] = paramTrainingTime.val
                    task ["distance"] ["value"] [sliderCurrentTrainingStage.toString ()] = paramTrainingDistance.val

                    btnPatientTask.taskJSON = task
                    console.debug ("CustomCustomCustomCustomCustomCustomCustomCustomCustom...", task ["countStage"], btnPatientTask.taskJSON ["countStage"])
                }
                else
//                    columnTraining.getButtonTrainingRun ().checked = false
                    columnTreadmill.getButtonTrackRun ().checked = false
            }
            else
                if (sliderCurrentTrainingStage < btnPatientTask.taskJSON ["countStage"]) {
                    sgnSetPatientTask (JSON.stringify (btnPatientTask.taskJSON))
                }
                else {
                    columnTreadmill.getButtonTrackRun ().checked = false
                }


        }
        else
            columnTreadmill.getButtonTrackRun ().checked = false
    }

//    Сигнал для кнопок выбора режима программЫ
//    обЪединяет их в 'RadioGroup' - в моменТ времени м.б. выбранА ОДНа и ТОЛьКО ОДНа
    signal sgnCheckedButtonGroupCamera (variant obj)
    onSgnCheckedButtonGroupCamera: {
        console.debug ("::onSgnCheckedButtonGroupCamera", obj.objectName)

        if (! (obj === btnCameraBase))
            btnCameraBase.checked = false

        if (! (obj === btnCameraFace))
            btnCameraFace.checked = false

        if (! (obj === btnPatientArea))
            btnPatientArea.checked = false

        console.debug (btnCameraBase.checked, btnCameraFace.checked, btnPatientArea.checked)
    }

//    Сигнал для кнопок управления обЪектами расширенной реальности в режиме РЕДАКТИРОВАНИЕ
//    обЪединяет их в 'RadioGroup' - в моменТ времени м.б. выбранА ОДНа и ТОЛьКО ОДНа
    signal sgnEditedButtonGroupObjectReality (variant obj)
    onSgnEditedButtonGroupObjectReality: {
        var objGroup = columnManagementObjectReality.getButton ("CenterPSC")
        if (! (obj === objGroup))
            objGroup.edited = false

        objGroup = columnManagementObjectReality.getButton ("Line1")
        if (! (obj === objGroup))
            objGroup.edited = false
        objGroup = columnManagementObjectReality.getButton ("Line2")
        if (! (obj === objGroup))
            objGroup.edited = false

        objGroup = columnManagementObjectReality.getButton ("Trace1")
        if (! (obj === objGroup))
            objGroup.edited = false
        objGroup = columnManagementObjectReality.getButton ("Trace2")
        if (! (obj === objGroup))
            objGroup.edited = false

        objGroup = columnManagementObjectReality.getButton ("Gamma")
        if (! (obj === objGroup))
            objGroup.edited = false

        objGroup = columnManagementObjectReality.getButton ("Lattice")
        if (! (obj === objGroup))
            objGroup.edited = false

        console.debug ("::onSgnEditedButtonGroupObjectReality для", obj.objectName)
    }

//    функция связывается на стороне C++
//    Индикация состояния сцены РАСШИРЕННой реальносТи - найден МАРКер иЛи НеТ
    function callbackPSCChanged (fixedPSC) {
        console.debug ("::callbackPSCChanged = ", fixedPSC)
        columnManagementObjectReality.setButtonChecked ("FixedPSC", fixedPSC)
    }
    //Сигнал заставляЕТ с НУЛя искать маркер, обозначающий ЦентР ФСК
    signal sgnResetPSC ()

//    signal sgnPopupTitle (string title)
//    signal sgnPopupValue (variant value)

//    Сигнал сообщает C++ номер линии РеШЁтКи, которую надО подСВЕТить
//    Здесь м. обойтись и без сигнала, А вызвать 'objCamera.checkedLatticeLine (num)' из 'HLatticeLine.qml'
    signal sgnCheckedLatticeLine (int num, bool checked, string color)
//    onSgnCheckedLatticeLine: {
//        console.debug ("onSgnCheckedLatticeLine", num)

//        var objCamera = undefined
//        if (cameraBase.visible)
//            objCamera = cameraBase
//        else
//            if (cameraFace.visible)
//                objCamera = cameraFace

//        if (! (objCamera === undefined))
//            objCamera.checkedLatticeLine (num)
//        else
//            ;
//    }

    signal sgnDebugRepositionObject(string line, string itemManagement)

//    Создание документа в БД
    signal sgnPostCouchDB (string nameDB, string content, variant obj, variant f)
    onSgnPostCouchDB: {
        ScriptHCouchDB.postCouchdb (nameDB, content, obj, f)
    }
//    Изменение документа в БД
    signal sgnPutCouchDB (string nameDB, string content, string idDoc, variant obj)
    onSgnPutCouchDB: {
        ScriptHCouchDB.putCouchdb (nameDB, content, idDoc, obj)
    }

    //Функции и своЙства для 'columnStatistic'
    property real sliderRealTime: realTime ()
    function realTime () {
        var tm = new Date, val
        val = tm.getHours () * 60 * 60
        val += tm.getMinutes () * 60
        val += tm.getSeconds ()

        console.debug ("realTime () RETURN = ", val)
        return val
    }

//    Сигнал запроса на сторону C++ к ДОРОЖКе о возврате значения измеренного датчиком пульсА пациента
    signal sgnQueryPulse (string cmd)
    function callbackQueryPulse (pulse) {
        console.debug ("recieve Pulse from treadmill = ", pulse)
        textPulseVal = parseFloat (pulse.substr (7, 4)) //Из строкИ ответа от ДОРОЖКи '*111#35#VALUe*'

        if (((textPulseVal === NaN) || (textPulseVal === undefined) || (textPulseVal === null) || (textPulseVal === 0)) && (pulse.substr (5, 1) === '4'))
//            ПовторНый запрос к ВТОРому датчику, если 1-ый не вернул значение
            sgnQueryPulse ('*111#35*')
        else {
//            if ((columnTraining.getButtonTrainingRun ().checked) && (idTrainingPulse.length)) {
//                if (sliderDBCurrentPulse > 0)
//                    sliderDBCurrentPulse -= sliderQueryDiscretePulse
//                else {
//                    sliderDBCurrentPulse = sliderDBDiscretePulse

//                    console.debug ("::callbackQueryPulse:sgnPutCouchDB =", '{"pulse":{"value":"' + textPulseVal + '"}}')
//                    sgnPutCouchDB (nameDB, typeContent, idTrainingPulse, JSON.parse ('{"pulse":{"value":"' + textPulseVal + '"}}'))
//                }
//            }
//            else
//                ;
        }
    }

//    Дискретность записи в БД измерениЯ пульса (в секундах)
//    Изменнеие происходит в 'onTriggered' ТАЙМЕРа пульса ('timerPulse')
    property real sliderDBDiscretePulse: 5
    property real sliderDBCurrentPulse: 5
    property int numberMeasurement: 0
    onSliderDBCurrentPulseChanged: {
        if (sliderDBCurrentPulse < 0) {
            if (idTrainingPulse.length) { //Проверка на наличие активной СЕССИИ тренировки
//                sgnPutCouchDB (nameDB, typeContent, idTrainingPulse, JSON.parse ('{"pulse":{"value":"' + textPulseVal + '"}}'))
                sgnPutCouchDB (nameDB, typeContent, idTrainingPulse, JSON.parse ('{"pulse":{"' + ++numberMeasurement + '":"' + textPulseVal + '"}}'))
            }
            else
                ;

            sliderDBCurrentPulse = sliderDBDiscretePulse
        }
        else
            ;
    }

//    Дискретность посылки ЗАПРОСов к датчикАМ измерениЯ пульса (в секундах)
//    Изменнеие происходит в 'onTriggered' ТАЙМЕРа пульса ('timerPulse')
    property real sliderQueryDiscretePulse: 1
    property real sliderQueryCurrentPulse: 1
    onSliderQueryCurrentPulseChanged: {
        if (sliderQueryCurrentPulse < 0) {
            sgnQueryPulse ("*111#34*")
            sliderQueryCurrentPulse = sliderQueryDiscretePulse
        }
        else
            ;
    }

//    Для ОтображениЯ пульса в поле 'Статистика'
    property real textPulseVal: 0
    onTextPulseValChanged: {}

    property real sliderPreviousDistance: 0
    property real sliderCurrentDistance: 0
    onSliderCurrentDistanceChanged: {
        console.debug ("::onSliderCurrentDistanceChanged =", paramTrainingDistance.val,
                                                            (sliderCurrentDistance + (timerPulse.interval / 1000 / 3600 * paramTrackSpeed.val)),
                                                            sliderCurrentDistance,
                                                            paramTrackSpeed.val)
        if (paramTrainingDistance.val < (sliderCurrentDistance + (timerPulse.interval / 1000 / 3600 * paramTrackSpeed.val))) {
            sliderCurrentTrainingStage ++
        }
        else
            ;
    }
    property real sliderPreviousTime: 0
    property real sliderCurrentTime: 0
    onSliderCurrentTimeChanged: {
        if ((idTraining.length > 0) && (columnTreadmill.getButtonTrackRun ().checked === true)) {
//            Проверка на превышение лимита (переход к следующему ЭТАПу
            if (paramTrainingTime.val < (sliderCurrentTime + timerPulse.interval / 1000)) {
                sliderCurrentTrainingStage ++
            }
            else
                ;
        }
        else
            ;
    }
//    property int timerTrackSpeedCountTick: 0

//    Характеристики областей отображения
    property int global_offset: 10 //Глобальное значения для смещения элементов управления на ФОРМе от Её КРАя
    property real relative_width_capture: 0.3 //Относительная величина размеров ВЫВОДа изображения с КАМЕР

//    Ширина области для ОДНОЙ из КАМЕР при ПАРАЛЛЕЛьно ВКЛ-ых ДВУХ камерах
    property int widthQmlCvCapture: relative_width_capture * rectangleForm.width
//    property int heightQmlCvCapture: rectangleForm.height - 4 * global_offset
//    Ширина области для ОБЕих КАМЕР, при их ПАРАЛЛЕЛьном ВКЛючении
//    ИЛИ ОДНой камеры, если ОНА ВКЛючена ОДНа
    property int widthCvCaptureArea: 2 * widthQmlCvCapture + global_offset
//    Ширина области для размещения элементов управления (слева или справа)
    property int widthManagmentArea: (rectangleForm.width - widthCvCaptureArea - 4 * global_offset) / 2

    property real ratioHeightTextField: 0.5
    property real ratioWidthSliderTextField: 0.3
    property real heightControl: rectangleForm.height / 24 //СТАНДАРТная высота элемента управления
    property real coeffWidthControl: 1 / 6 //Единица ширинЫ элемента управления

    property string ipDB: "localhost"
    property string portDB: "5984"
    property string nameDB: "test"
    property string typeContent: "json"

    id: rectangleForm
    width: 800
    height: 840
    z: 6
    rotation: 0
    color: "gray"

    Component.onCompleted: {
        console.log ("root::OmCompleted - begin")

//        ScriptObjectReality.createObjectsReality ()

//        БесПОЛЕЗНые вызовы (связывание сигнАЛ-СЛот НЕ произошло ('hqdeclarativeviewform.cpp::init ()'))
        sgnManagementTreadmill ("*105#110" + "1.17" + "*")
        sgnManagementTreadmill ("*105#112" + "1" + "*")

        console.debug ("НастройКИ ДЛЯ дорожкИ")

//        _ОТЛАДкА
//        btnDebug.clicked ()

        console.log ("root::OmCompleted - end")
    }

//    Прям-ик - область камерЫ
    Rectangle {
        id: rectangleWidthCvCaptureArea
        z: -666

        anchors.top: rectangleForm.top
        anchors.topMargin: global_offset

        anchors.left: columnTreadmill.right
        anchors.leftMargin: global_offset

        anchors.bottom: rectangleForm.bottom
        anchors.bottomMargin: global_offset

        anchors.right: columnCamera.left
        anchors.rightMargin: global_offset

//        color: "black"
        color: parent.color

        Component.onCompleted: {
            console.log ("rectangleWidthCvCaptureArea::OmCompleted")

            ScriptObjectReality.createObjectsReality ()
        }
    }

    onHeightChanged: {
        ScriptCvCapture.resizeQmlCVCapture ()
    }
    onWidthChanged: {
        ScriptCvCapture.resizeQmlCVCapture ()
    }

    Timer {
        id: timerTrackSpeed
        interval: 5 / paramTrackSpeed.val
//        interval: 13
        running: false //true
        repeat: true

        onTriggeredOnStartChanged: {
            console.debug ("timerTrackSpeed::onTriggeredOnStartChanged", "running =", running)
        }

        onTriggered: {
            sgnMotionTrace ()
//            sliderCurrentDistance = sliderPreviousDistance + sliderCurrentTime * paramTrackSpeed.val / 3600
//            sliderCurrentDistance += sliderCurrentTime * paramTrackSpeed.val / 3600
//            ПеренЁс в 'timerPulse::onTriggered'

//            console.debug ("timerTrackSpeed::onTriggered (), sliderCurrentDistance =", sliderCurrentDistance)
        }
    }

    Timer {
        id: timerPulse
        interval: 250
//        interval: 13
        running: true
        repeat: true

        onTriggered: {
            var seconds = interval / 1000
            sliderQueryCurrentPulse -= seconds //sliderQueryDiscretePulse

//            console.debug ("timerPulse::onTriggered:sliderCurrentPulse =", sliderCurrentPulse)

            sliderRealTime += seconds

            if (timerTrackSpeed.running) {
//                БЕЗ УСЛОВий (КРОМе наличия СЕССии тренировки, ПРОВЕРяю ЗдеСЬ)
//                sliderCurrentTime += seconds
//                БЕЗ УСЛОВий (КРОМе наличия СЕССии тренировки, но она проверяеТся в 'onSliderDBCurrentPulseChanged')
//                sliderDBCurrentPulse -= seconds
                sliderCurrentDistance += seconds * paramTrackSpeed.val / 3600
            }
            else
                ;

//            if (true)
            if (idTraining.length || timerTrackSpeed.running)
//            if (idTrainingPulse.length)
//            if (columnTraining.getButtonTrainingRun ().checked)
                sliderCurrentTime += seconds
            else
                ;

            sliderDBCurrentPulse -= seconds
        }
    }

//    Объект с параметрами управления НАКЛОНом дорожки
    HValueParams {
        id: paramTrackTilt
        objectName: "paramTrackTilt";
//        val: 0; default_val: 0; min_val: 0; max_val: 12; step_val: 1; coeff_val: 2
    }

//    Объект с параметрами управления СКОРОСТьЮ дорожки
    HValueParams {
        id: paramTrackSpeed
        objectName: "paramTrackSpeed";
//        val: 0.8; default_val: 0.8; min_val: 0.8; max_val: 5; step_val: 0.1; coeff_val: 10
    }

//    Объект с параметрами управления ДИСТАНЦиеЙ тренировки
    HValueParams {
        id: paramTrainingDistance
        objectName: "paramTrainingDistance";
//        val: 0.2; default_val: 0.2; min_val: 0.2; max_val: 10; step_val: 0.2; coeff_val: 10
    }

//    Объект с параметрами управления длительностЬю (ВРЕМя) тренировки
    HValueParams {
        id: paramTrainingTime
        objectName: "paramTrainingTime";
//        val: 60; default_val: 60; min_val: 60; max_val: 60 * 10; step_val: 10; coeff_val: 6
    }

//    Объект с параметрами управления ДЛИНой ШАГа тренировки
    HValueParams {
        id: paramStepsLength
        objectName: "paramStepsLength";
        //        val: 0.3; default_val: 0.3; min_val: 0.15; max_val: 0.5; step_val: 0.05; coeff_val: 1
    }

//    ОбъектЫ с параметрами АЛФАвитА для писка пациента по ФАМИЛии, ИМЕНи, ОТЧЕСТВу
    HValueParams {
        id: paramPatientFindLastName
        objectName: "paramPatientFindLastName";  val: 0; default_val: 0; min_val: 0; max_val: 33; step_val: 1; coeff_val: 6
    }
    HValueParams {
        id: paramPatientFindFirstName
        objectName: "paramPatientFindFirstName";  val: 0; default_val: 0; min_val: 0; max_val: 33; step_val: 1; coeff_val: 6
    }
    HValueParams {
        id: paramPatientFindMiddleName
        objectName: "paramPatientFindMiddleName";  val: 0; default_val: 0; min_val: 0; max_val: 33; step_val: 1; coeff_val: 6
    }
//    ОбъектЫ с параметрами ЗНАЧений для писка пациента по возрасту (МИНим., МАКСим.)
    HValueParams {
        id: paramPatientFindAgeMin
        objectName: "paramPatientFindAgeMin";  val: 19; default_val: 19; min_val: 6; max_val: 99; step_val: 1; coeff_val: 6
    }
    HValueParams {
        id: paramPatientFindAgeMax
        objectName: "paramPatientFindAgeMax";  val: 89; default_val: 89; min_val: 6; max_val: 99; step_val: 1; coeff_val: 6
    }
//    ОбъектЫ с параметрами ЗНАЧений для писка пациента по РОСТу (МИНим., МАКСим.)
    HValueParams {
        id: paramPatientFindHeightMin
        objectName: "paramPatientFindHeightMin";  val: 56; default_val: 56; min_val: 56; max_val: 199; step_val: 1; coeff_val: 6
    }
    HValueParams {
        id: paramPatientFindHeightMax
        objectName: "paramPatientFindHeightMax";  val: 199; default_val: 199; min_val: 56; max_val: 199; step_val: 1; coeff_val: 6
    }
//    ОбъектЫ с параметрами ЗНАЧений для писка пациента по ВЕСу (МИНим., МАКСим.)
    HValueParams {
        id: paramPatientFindWeightMin
        objectName: "paramPatientFindWeightMin";  val: 36; default_val: 36; min_val: 36; max_val: 139; step_val: 1; coeff_val: 6
    }
    HValueParams {
        id: paramPatientFindWeightMax
        objectName: "paramPatientFindWeightMax";  val: 139; default_val: 139; min_val: 36; max_val: 139; step_val: 1; coeff_val: 6
    }

    //Столбец - управление ДОРОЖКой
    HColumnTreadmill {
        id: columnTreadmill

        anchors.top: btnPatientTitle.bottom
        anchors.topMargin: global_offset
    }

    //Столбец - статистика (пулЬс, время, пройденная дистанция)
    HColumnStatistic { id: columnStatistic }

    //Столбец - управление ТРЕНИРОВКАми
    HColumnTraining { id: columnTraining }

    HColumnPatientList { id: columnPatientList }

    HColumnPatientFind { id: columnPatientFind }

    HColumnPatientTask { id: columnPatientTask }

    //УЖе НЕ исПОЛьЗуется
    signal sgnNotClearScreen ()
    onSgnNotClearScreen: {
        console.debug ("::onSgnNotClearScreen =", btnCameraBase.checked, btnCameraBase.checked, btnPatientArea.checked)

        if (btnCameraBase.enabled && (! btnCameraBase.checked))
                btnCameraBase.checked = true
            else
                if (btnCameraFace.enabled && (! btnCameraFace.checked))
                    btnCameraFace.checked = true
                else
                    if (! columnTraining.getButtonTrainingRun ().checked)
                        btnPatientArea.checked = true
                    else
                        ;
    }

//    Столбец - управление КАМЕРАми
    Column {
        id: columnCamera
        spacing: 6

//        x: ScriptCvCapture.posXItem (2, 0)
        width: widthManagmentArea

        anchors.right: parent.right
        anchors.rightMargin: global_offset
//        anchors.top: parent.top
//        anchors.topMargin: global_offset
        anchors.top: btnPatientTitle.bottom
        anchors.topMargin: global_offset

        //Строка - описание
        Row {
            parent: columnCamera
            width: parent.width
            height: heightControl
            Text {
                y: parent.height / 2 - height / 2
                text: "Камеры"
                font {
                    pixelSize: Math.round (parent.width * 0.1)
                }
            }
        }
        //Строка - Камеры
        Row {
            id: rowCamera
            parent: columnCamera
            spacing: 6

            width: parent.width

//            КАМЕРа №1
            HButton {
                id: btnCameraBase
                objectName: "btnCameraBase"
                parent: rowCamera
                width: parent.width / 2 - parent.spacing / 2
                height: heightControl * 2
                textUnchecked: "Камера 1"
//                textChecked: "Камера 1"
                textRatio: 0.3

                checked: ((! btnCameraFace.checked) && (! btnPatientArea.checked)) ? true : false
                checkable: true

                enabled: cameraBase.enabled  && (btnCameraFace.enabled || btnPatientArea.enabled)
//                onEnabledChanged: {
//                    if (enabled === false)
//                        checked = false
//                }

                onClicked: {

                }

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        sgnCheckedButtonGroupCamera (btnCameraBase)

//                        enabledFixedPSC ()
//                        btnFixedPSC.checked = cameraBase.fixedPSC
//                        ScriptObjectReality.getObjectReality ("CenterPSC").checked = cameraBase.fixedPSC
                        columnManagementObjectReality.setButtonChecked ("FixedPSC", cameraBase.fixedPSC)

//                        recoverySliderValueCamera ()
                    }
                    else {
                        if (btnCameraFace.checked) {
//                            columnManagementObjectReality.setButtonChecked ("FixedPSC", cameraFace.fixedPSC)

//                            btnVectorEye.checked = false
//                            btnVectorCenter.checked = false
//                            btnVectorUp.checked = false
                        }
                        else
                            if (btnPatientArea.checked)
                                ;
                            else
                                if (btnPatientArea.enabled)
                                    btnPatientArea.checked = true
                                else
                                    ; //sgnNotClearScreen

//                        btnFixedPSC.checked = false
                    }
                }

                onDoubleClicked: {
                }

                Connections {
//                    target:
                }
            }

//            КАМЕРа №2
            HButton {
                id: btnCameraFace
                objectName: "btnCameraFace"
                parent: rowCamera
                width: parent.width / 2 - parent.spacing / 2
                height: heightControl * 2
                textUnchecked: "Камера 2"
//                textChecked: "Камера 2"
                textRatio: 0.3

                checked: { //checkedButtonGroupCamera (btnCameraFace)
                    if ((! btnCameraBase.checked) && (! btnPatientArea.checked))
                        return true
                    else
                        return false;
                }
                checkable: true

                enabled: cameraFace.enabled && (btnCameraBase.enabled || btnPatientArea.enabled)
//                onEnabledChanged: {
//                    if (enabled === false)
//                        checked = false
//                }

                onClicked: {

                }

                onCheckedChanged: {
                    if (checked) {
                        //Остальные 'ПОДНИМаем'
                        sgnCheckedButtonGroupCamera (btnCameraFace)

//                        enabledFixedPSC ()
//                        btnFixedPSC.checked = cameraFace.fixedPSC
                        columnManagementObjectReality.setButtonChecked ("FixedPSC", cameraFace.fixedPSC)

//                        recoverySliderValueCamera ()
                    }
                    else {
                        if (btnCameraBase.checked) {
//                            columnManagementObjectReality.setButtonChecked ("FixedPSC", cameraBase.fixedPSC)

//                            btnVectorEye.checked = false
//                            btnVectorCenter.checked = false
//                            btnVectorUp.checked = false
                        }
                        else
                            if (btnPatientArea.checked)
                                ;
                            else
                                if (btnPatientArea.enabled)
                                    btnPatientArea.checked = true
                                else
                                    ; //sgnNotClearScreen

//                        btnFixedPSC.checked = false
                    }
                }

                onDoubleClicked: {
                }

                Connections {
//                    target:
                }
            }
        }

        Row {
            id: rowPatient
            parent: columnCamera
            spacing: 6

            width: parent.width


//            КНОПКа ПАЦиЕНтЫ
            HButton {
                id: btnPatientArea
                width: parent.width
                height: heightControl * 2
                textUnchecked: "<center>Пациенты</center>"
                textRatio: 0.3

                colorUncheked: "black"
                colorChecked: "white"

                colorTextUnchecked: colorChecked
                colorTextChecked: colorUncheked

                checked: true
//                { //checkedButtonGroupCamera (btnCameraFace)
//                    if ((! btnCameraBase.checked) && (! btnCameraFace.checked))
//                        return true
//                    else
//                        return false;
//                }
                checkable: true

//                enabled: (! columnTraining.getButtonTrainingRun ().checked) && (! columnTreadmill.getButtonTrackRun ().checked)
                enabled: ! columnTreadmill.getButtonTrackRun ().checked

                onCheckedChanged: {
                    if (checked) {
//                        Остальные 'ПОДНИМаем'
                        sgnCheckedButtonGroupCamera (btnPatientArea)
                    }
                    else {
                        //Не ЭСТЕТИЧно, но РАБОТает
                        if (btnCameraBase.checked)
                            ; //Ничего не делаем, если 'unchecked' произошЁл по причине 'btnCameraBase.checked'
                        else
                            if (btnCameraFace.checked)
                                ; //Ничего не делаем, если 'unchecked' произошЁл по причине 'btnCameraFace.checked'
                            else
                                //Здесь попытаемся включить ОДНУ из ДОСТУПных камер
                                if (btnCameraBase.enabled)
                                    btnCameraBase.checked = true
                                else
                                    if (btnCameraFace.enabled)
                                        btnCameraFace.checked = true
                                    else
                                        ;
                    }
                }

                onClicked: {
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
    HManagementObjectReality {
        id: columnManagementObjectReality
    }

//    Кнопка без 'checkable', 'editable' для отображения ТКУЩего пациента
    HButtonPatient {
        id: btnPatientTitle
//        parent: unknown
        width: parent.width
        height: heightControl
        colorChecked: 'black'
        colorUnchecked: 'black'
        textUnchecked: "Пациент:"
//        textChecked: "Листать ВВЕРХ"

        anchors.top: parent.top
        anchors.topMargin: 0 //global_offset

        anchors.left: parent.left
        anchors.leftMargin: 0 //global_offset

        anchors.right: parent.right
        anchors.rightMargin: 0 //global_offset

        enabled: true
        checkable: true

        onClicked: {
        }

        onDoubleClicked: {
        }

        onCheckedChanged: {
            if (checked) {
            }
            else {
            }
        }

        Component.onCompleted: {
            function setTextButtonPatient (responseText) {
//                console.debug (responseText)
                var responseJSON = JSON.parse (responseText), offset = responseJSON ['offset']
                if (responseJSON ['total_rows']) {
                    isTitle = true
                    patientJSON = responseJSON ['rows'][offset.toString ()]['value']
//                    ScriptHCouchDB.coutJSON (responseJSON ['rows'])
                }
                else
                    ;
            }

            ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "patients", "patientGuest", setTextButtonPatient)
        }
    }

    //ОбЪектЫ расширенной реальности
    HDescObjectReality {
        id: descObjectsReality
        objectName: "descObjectsReality"

        Component.onCompleted: {
//            console.debug ("HDescObjectReality::onCompleted")
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

        enabled: true
        onEnabledChanged: {
            console.debug ("cameraBase::onEnabledChanged", enabled)
        }

        Component.onCompleted: completed ();

        onVisibleChanged: {
            console.debug ("cameraBase::onVisibleChanged", visible)

            if (visible) {
                cameraBase.start ()

                columnManagementObjectReality.enabledFixedPSC ()
            }
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
        numPort: 1
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
        enabled: true
        onEnabledChanged: {
            console.debug ("cameraFace::onEnabledChanged", enabled)
        }

        onVisibleChanged: {
            console.debug ("cameraFace::onVisibleChanged", visible)

            if (visible) {
                cameraFace.start ()

                columnManagementObjectReality.enabledFixedPSC ()
            }
            else
                cameraFace.stop ()

            ScriptCvCapture.resizeQmlCVCapture ()
        }
    }

//    Виртуальная длина ДОРОЖКи, по всЕЙ еЁ длинЕ размещены следы, числом = 'count_of_trace'
//    Следы м.б. иметь свойство 'visible' = true ИЛИ false (true, ЕСЛи находятСя внУТри 'length_track')
//    function virtualLengthTrack () {
//        return begin_position_trace - count_of_trace * paramStepsLength.val
//    }

//    Connections {
//        target: m_synchCoordinates
//        onSgnCreateObjectReality: {
//            console.debug ("HSynchCoordinates::onSgnCreateObjectReality =", namePrefix, num)
//        }
//    }

    HSynchCoordinates {
        id: m_synchCoordinates
        objectName: "m_SynchCoordinates"

        idMarkerPSC: -1 //166
        szMarkerPSC: -1 //0.06

        //ХАРАКТЕРИСТИКи СЦЕНы расширеннОЙ реалЬностИ
        direction_track: 0 //Направление движения 'дорожки' (положителЬное знач. - К ДВИГАТЕЛю)

        begin_position_trace: -1 //0.4 //Смещение позиции ПЕРВого СЛЕДа от центрА ФСК (вдоль ДВИЖЕНия ДОРОЖКи)
        begin_position_track:  -1 //0.4 //Смещение НАЧАЛа виртуальной ДОРОЖКи от центрА ФСК
        length_track: -1 //1.0 //Виртуальная ДЛИНа ДОРОЖКи (следы виднЫ)

        sliderStepsLength: paramStepsLength.val

        sliderSpeedTrack: paramTrackSpeed.val
        coeffSpeedTrack: -1 //0.03

        count_lattice_line: 11 //13

//        Эти свойства используются, если ВВЕДЕНа величина БАЗа ШАГа
//        расстояние между правым и левым следом перпендикулярно направленю движения
        count_line: 1 //Количество линИй следов, если == '1' - остальнЫЕ параметрЫ значения НЕ ИМЕЮт
        sliderStepsWidth: 0.2 //База шага (расстояние между следами ПЕРПЕНДИКУЛЯРНо направлению движения)
        max_steps_width: 1.0 //МАКСимальное значение для 'sliderStepsWidth'

        Component.onCompleted: {
//            var postData = ""
//            postData += '{' +
//                    '"idMarkerPSC":' + idMarkerPSC + ',' +
//                    '"szMarkerPSC":' + szMarkerPSC + ',' +
//                    '"direction_track":' + direction_track + ',' +
//                    '"begin_position_trace":' + begin_position_trace + ',' +
//                    '"begin_position_track":' + begin_position_track + ',' +
//                    '"length_track":' + length_track + ',' +
//                    '"coeffSpeedTrack":' + coeffSpeedTrack + ',' +
//                    '"count_lattice_line":' + count_lattice_line +
//                    '}'

//            console.debug ("HSynchCoordinates::onCompleted::postData =", JSON.parse (postData) ["coeffSpeedTrack"])

            function setValue (responseText) {
                var responseJSON = JSON.parse (responseText), offset = responseJSON ['offset']
                console.debug ("HSynchCoordinates::onCompleted:total_rows =", responseJSON ['total_rows'])
                for (var i = 0; i < responseJSON ['total_rows'] - offset; i ++) {
                    if (! (responseJSON ['rows'][i.toString ()] === undefined)) {
                        idMarkerPSC = responseJSON ['rows'][i.toString ()]['value'] ["idMarkerPSC"]
                        szMarkerPSC = responseJSON ['rows'][i.toString ()]['value'] ["szMarkerPSC"]
                        direction_track = responseJSON ['rows'][i.toString ()]['value'] ["direction_track"]
                        begin_position_trace = responseJSON ['rows'][i.toString ()]['value'] ["begin_position_trace"]
                        begin_position_track = responseJSON ['rows'][i.toString ()]['value'] ["begin_position_track"]
                        length_track = responseJSON ['rows'][i.toString ()]['value'] ["length_track"]
                        coeffSpeedTrack = responseJSON ['rows'][i.toString ()]['value'] ["coeffSpeedTrack"]
                        count_lattice_line = responseJSON ['rows'][i.toString ()]['value'] ["count_lattice_line"]
                    }
                    else
                        ;
                }

                columnManagementObjectReality.createPseudoLattice ()
            }

            ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "options", "synchCoordinates", setValue)
        }
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
