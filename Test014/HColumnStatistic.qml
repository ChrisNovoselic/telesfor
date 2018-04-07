// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "."
import "hcouch.js" as ScriptHCouchDB

Column {
    id: columnStatistic
    spacing: 6

//    x: ScriptCvCapture.posXItem (0, 0)
    width: widthManagmentArea

    anchors.left: parent.left
    anchors.leftMargin: global_offset
    anchors.top: columnTreadmill.bottom
    anchors.topMargin: global_offset

    function hideButtonsReport () { btnReport.checked = false }

    function setIdTrainingResult (id) {
        if (! (id === undefined))
            btnReportTraining.idTrainingResult = id
        else
            ;

        console.debug ("HColumnStatistic::setIdTrainingResult id =", btnReportTraining.idTrainingResult)
    }

    //Строка - описание
    Row {
        parent: columnStatistic
        width: parent.width
        height: heightControl
        Text {
            y: parent.height / 2 - height / 2
            text: "Статистика"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }
    //Строка Кнопка отчЁты
    Row {
        id: rowButtonReport

        width: parent.width
        height: heightControl

        enabled: ! columnTraining.getButtonTrainingRun ().checked

        HButton {
            id: btnReport
            objectName: "btnReport"
            parent: rowButtonReport
            width: parent.width
            height: heightControl
            textUnchecked: "Отчёты"
            textChecked: "Отчёты"

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checked: false
            checkable: true

            onClicked: {
            }

            onCheckedChanged: {
                if (checked) {
                    columnTraining.hidePopupWindow ()
                }
                else
                    ;
            }

            onEnabledChanged: {
                if (! enabled)
                    checked = false
                else
                    ;
            }
        }
    }
    //Строка Кнопка отчЁты - по пациенту
    Row {
        id: rowButtonReportPatient

        width: parent.width
        height: heightControl

        visible: btnReport.checked

        HButton {
            id: btnReportPatient
            objectName: "btnReportPatient"
            parent: rowButtonReportPatient
            width: parent.width
            height: heightControl
            textUnchecked: "По пациенту"

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checked: false
            checkable: false

            onClicked: {
                var countTraining = 0, arIdTrainings = new Array () /*Длина = countTraining*/, trainingJSON, patientJSON, pulseJSON, content,
                    middlePulse = 0, middleSpeed = 0, middleTilt = 0, middleStepsLength = 0, totalDistance = 0, totalTime = 0
                    , dtStart, dtEnd
                function getTemplate (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTemplate () = ", responseText)

                    if (! (JSON.parse (responseText) ['rows'] === undefined)) {
                        content = JSON.parse (responseText) ['rows'] ['0'] ['value'] ['content']

                        var dtNow = new Date (), tmFull = new Date (), tmMiddle = new Date ()
                        tmFull.setSeconds (totalTime % 60); tmMiddle.setSeconds ((totalTime / countTraining) % 60)
                        tmFull.setMinutes (totalTime / 60); tmMiddle.setMinutes ((totalTime / countTraining) / 60)
                        tmFull.setHours (totalTime / 60 / 60); tmMiddle.setHours ((totalTime / countTraining) / 60 / 60)
                        content = content.replace ('patientLastNameValue', patientJSON ['lastName'])
                        content = content.replace ('patientMiddleNameValue', patientJSON ['middleName'])
                        content = content.replace ('patientFirstNameValue', patientJSON ['firstName'])
                        content = content.replace ('trainingCountValue', countTraining)
                        content = content.replace ('trainingTimeValue', Qt.formatTime (tmFull, "hh:mm:ss") + '/' + Qt.formatTime (tmMiddle, "hh:mm:ss"))
                        content = content.replace ('trainingDistanceValue', totalDistance + '/' + (totalDistance / countTraining).toFixed (3) + ' км')
                        content = content.replace ('trainingPulseValue', middlePulse)
//                        content = content.replace ('trackSpeedValue', middleSpeed)
//                        content = content.replace ('trackTiltValue', middleTilt)
//                        content = content.replace ('stepsLengthValue', middleStepsLength)
                        content = content.replace ('reportDateTimeValue', dtNow)

                        console.debug (content)
                        sgnTrainingReport (content, patientJSON ['lastName'], dtNow)
                    }
                    else
                        ;
                }

                function getPulses (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getPulse () = ", responseText)

                    var measurement, measurementTotal = 0, measurementTotalValue = 0, i = countTraining - 1 //Здесь СНОВа м. посчитатЬ кол-во тренИроВОК
                    while (! (JSON.parse (responseText) ['rows'] [countTraining.toString ()] === undefined)) {
                        pulseJSON = JSON.parse (responseText) ['rows'] [i.toString ()] ['value']

                        measurement = 0
                        while (pulseJSON [measurement.toString ()] === undefined) {
                            if ((! (pulseJSON [measurement.toString ()] === undefined)) && (! (pulseJSON [measurement.toString ()] === NaN))) {
                                middlePulse += pulseJSON [measurement.toString ()]
                                measurementTotalValue ++
                            }
                            else
                                ;

                            measurement ++
                        }

                        measurementTotal += measurement

                        i --
                    }

                    if (measurementTotalValue)
                        middlePulse /= measurementTotalValue
                    else
                        ;

                    ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'reports', 'patient', getTemplate)
                }

                function getPatient (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getPatient () = ", responseText)

                    if (! (JSON.parse (responseText) ['rows'] === undefined)) {
                        patientJSON = JSON.parse (responseText) ['rows'] ['0'] ['value']
                    }
                    else
                        ;

//                    ВСе докУменты с показаниями ПУЛьСа для пациента, но можно И по ОДНой (с помощЬю 'arIdTrainings')
                    ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'pulses', 'pulse', getPulses, btnPatientTitle.patientJSON ['_id'])
                }

                function getTrainings (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTraining () = ", responseText)

                    while (! (JSON.parse (responseText) ['rows'] [countTraining.toString ()] === undefined)) {
                        trainingJSON = JSON.parse (responseText) ['rows'] [countTraining.toString ()] ['value']

                        var stage = trainingJSON ['countStage'] - 1
//                        Вариант №1 для вычисления времени
//                        dtStart = new Date (trainingJSON ['dttm'] ['start'] ['']; dtEnd = new Date (trainingJSON ['dttm'] ['end'] ['']
//                        totalTime = (new Date (trainingJSON ['dttm'] ['end'] ['']) - new Date (trainingJSON ['dttm'] ['start'] [''])) / 1000

                        console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTraining () = ", stage)
                        console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTraining () = ", JSON.stringify (trainingJSON))
                        while (stage > -1) {
                            middleSpeed += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['speed'])
                            middleTilt += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['incline'])
                            middleStepsLength += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['stepsLength'])
                            totalDistance += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['distance'])
//                        Вариант №2 для вычисления времени
                            totalTime += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['duration'])

                            stage --
                        }

                        middleSpeed /= trainingJSON ['countStage']
                        middleSpeed.toPrecision (4)
                        middleTilt /= trainingJSON ['countStage']
                        middleTilt.toPrecision (3)
                        middleStepsLength /= trainingJSON ['countStage']
                        middleTilt.toPrecision (3)

                        totalDistance = Math.round (totalDistance * Math.pow (10, 3)) / Math.pow (10, 3).toPrecision (4)
//                        totalTime.toString ().toPrecision (3)

                        middleStepsLength = Math.round (middleStepsLength * Math.pow (10, 2)) / Math.pow (10, 2).toPrecision (3)

                        countTraining ++
                        arIdTrainings.push (trainingJSON ['_id'])
                    }
//                    else
//                        ;

                    console.debug ('HColumnStatistic::rowButtonReportTraining::onClicked () countTraining =', countTraining)

                    ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'patients', 'patient', getPatient, btnPatientTitle.patientJSON ['_id'])
                }

                ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'trainings', 'trainingsPatient', getTrainings, btnPatientTitle.patientJSON ['_id'])
            }
        }
    }
    //Строка Кнопка отчЁты - по тренировке
    Row {
        id: rowButtonReportTraining

        width: parent.width
        height: heightControl

        visible: btnReport.checked

        HButton {
            id: btnReportTraining
            objectName: "btnReportTraining"
            parent: rowButtonReportTraining

            property string idTrainingResult: ""

            width: parent.width
            height: heightControl
            textUnchecked: "По тренировке"

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            enabled: idTrainingResult === "" ? false : true

            checked: false
            checkable: false

            onClicked: {
                var trainingJSON, patientJSON, pulseJSON, content,
                    middlePulse = 0, middleSpeed = 0, middleTilt = 0, middleStepsLength = 0, totalDistance = 0, totalTime = 0
                    , dtStart, dtEnd
                function getTemplate (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTemplate () = ", responseText)

                    if (! (JSON.parse (responseText) ['rows'] === undefined)) {
                        content = JSON.parse (responseText) ['rows'] ['0'] ['value'] ['content']

                        var dtNow = new Date ()
                        content = content.replace ('patientLastNameValue', patientJSON ['lastName'])
                        content = content.replace ('patientMiddleNameValue', patientJSON ['middleName'])
                        content = content.replace ('patientFirstNameValue', patientJSON ['firstName'])
                        content = content.replace ('trainingTimeValue', totalTime)
                        content = content.replace ('trainingDistanceValue', totalDistance)
                        content = content.replace ('trainingPulseValue', middlePulse)
                        content = content.replace ('trackSpeedValue', middleSpeed)
                        content = content.replace ('trackTiltValue', middleTilt)
                        content = content.replace ('stepsLengthValue', middleStepsLength)
                        content = content.replace ('reportDateTimeValue', dtNow)

                        console.debug (content)
                        sgnTrainingReport (content, patientJSON ['lastName'], dtNow)
                    }
                    else
                        ;
                }

                function getPulse (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getPulse () = ", responseText)

                    var measurement = 0, measurementTotal = 0, measurementTotalValue = 0
                    if (! (JSON.parse (responseText) ['rows'] === undefined)) {
                        pulseJSON = JSON.parse (responseText) ['rows'] ['0'] ['value']

                        while (pulseJSON [measurement.toString ()] === undefined) {
                            if ((! (pulseJSON [measurement.toString ()] === undefined)) && (! (pulseJSON [measurement.toString ()] === NaN))) {
                                middlePulse += pulseJSON [measurement.toString ()]
                                measurementTotalValue ++
                            }
                            else
                                ;
                            measurement ++
                        }

                        measurementTotal += measurement

                        if (measurementTotalValue)
                            middlePulse /= measurementTotalValue
                        else
                            ;

                        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'reports', 'training', getTemplate)
                    }
                    else
                        ;
                }

                function getPatient (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getPatient () = ", responseText)

                    if (! (JSON.parse (responseText) ['rows'] === undefined)) {
                        patientJSON = JSON.parse (responseText) ['rows'] ['0'] ['value']
                    }
                    else
                        ;

                    ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'pulses', 'pulse', getPulse, idTrainingResult)
                }

                function getTraining (responseText) {
                    console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTraining () = ", responseText)

                    if (! (JSON.parse (responseText) ['rows'] === undefined)) {
                        trainingJSON = JSON.parse (responseText) ['rows'] ['0'] ['value']

                        var stage = trainingJSON ['countStage']
                        if (trainingJSON ['type'].indexOf ('Custom') > -1)
                            ;
                        else
                            stage --
//                        Вариант №1 для вычисления времени
//                        dtStart = new Date (trainingJSON ['dttm'] ['start'] ['']; dtEnd = new Date (trainingJSON ['dttm'] ['end'] ['']
//                        totalTime = (new Date (trainingJSON ['dttm'] ['end'] ['']) - new Date (trainingJSON ['dttm'] ['start'] [''])) / 1000

                        console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTraining () = ", stage)
                        console.debug ("HColumnStatistic::rowButtonReportTraining::onClicked::getTraining () = ", JSON.stringify (trainingJSON ['speed']))
                        while (stage > -1) {
                            middleSpeed += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['speed'])
                            middleTilt += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['incline'])
                            middleStepsLength += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['stepsLength'])
                            totalDistance += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['distance'])
//                        Вариант №2 для вычисления времени
                            totalTime += parseFloat (trainingJSON ['phases'] [stage.toString ()] ['duration'])

                            stage --
                        }

                        middleSpeed /= trainingJSON ['countStage']
                        middleSpeed.toPrecision (4)
                        middleTilt /= trainingJSON ['countStage']
                        middleTilt.toPrecision (3)
                        middleStepsLength /= trainingJSON ['countStage']
                        middleTilt.toPrecision (3)

                        totalDistance = Math.round (totalDistance * Math.pow (10, 3)) / Math.pow (10, 3).toPrecision (4)
//                        totalTime.toString ().toPrecision (3)

                        middleStepsLength = Math.round (middleStepsLength * Math.pow (10, 2)) / Math.pow (10, 2).toPrecision (3)

                        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'patients', 'patient', getPatient, trainingJSON ['id_patient'])
                    }
                    else
                        ;
                }

                ScriptHCouchDB.viewCouchdb (nameDB, typeContent, 'trainings', 'training', getTraining, idTrainingResult)
            }
        }
    }
    //Строка ПУЛЬС
    Row {
        id: rowPulse

        width: parent.width
        height: heightControl

//        enabled: checkBoxCameraBase.checked || checkBoxCameraFace.checked
        enabled: true

        Text {
            parent: rowPulse
            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Пульс"
            font.pixelSize: Math.round (parent.width * 0.08)
        }

        Text {
            parent: rowPulse

            y: parent.height / 2 - height / 2
            width: parent.width * 2 * coeffWidthControl

            text: textPulseVal.toFixed (2)
            font.pixelSize: Math.round (parent.width * 0.08)

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

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Время"
            font.pixelSize: Math.round (parent.width * 0.08)
        }

        Text {
            parent: rowTraining

            y: parent.height / 2 - height / 2
            width: parent.width * 2 * coeffWidthControl

//            text: textTrainingTimeVal
            text: {
                var tm = new Date (), val
                val = sliderPreviousTime + sliderCurrentTime
                tm.setSeconds (val % 60)
                tm.setMinutes (val / 60)
                Qt.formatTime (tm, "mm:ss")
            }

            font.pixelSize: Math.round (parent.width * 0.08)
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

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Дистанция"
            font.pixelSize: Math.round (parent.width * 0.08)
        }

        Text {
            parent: rowDistance

            y: parent.height / 2 - height / 2
            width: parent.width * 2 * coeffWidthControl

            text: (sliderPreviousDistance + sliderCurrentDistance).toFixed (3)
            font.pixelSize: Math.round (parent.width * 0.08)

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    //Строка ВРЕМя РЕАЛьНОе чч:мм:сс
    Row {
        id: rowRealTime

        width: parent.width
        height: heightControl

//            enabled: checkBoxCameraBase.checked || checkBoxCameraFace.checked
        enabled: true

        Text {
            parent: rowRealTime

            y: parent.height / 2 - height / 2
            width: parent.width * 4 * coeffWidthControl

            text: "Реальн.вр."
            font.pixelSize: Math.round (parent.width * 0.08)
        }

        Text {
            parent: rowRealTime

            y: parent.height / 2 - height / 2
            width: parent.width * 2 * coeffWidthControl

//            text: textTrainingTimeVal
            text: {
                var tm = new Date ()
                tm.setHours (sliderRealTime / 60 / 24)
                tm.setMinutes (sliderRealTime / 60)
                tm.setSeconds (sliderRealTime % 60)

                Qt.formatTime(tm, "hh:mm:ss")
            }
            font.pixelSize: Math.round (parent.width * 0.08)

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }
}
