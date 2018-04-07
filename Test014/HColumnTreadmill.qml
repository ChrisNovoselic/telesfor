// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.

//import "slidermanage.js" as ScriptSliderManage
import "cvcapture.js" as ScriptCvCapture

import "."

Column {
//    id: columnTrack
    spacing: 6

//    x: ScriptCvCapture.posXItem (0, 0)
    width: widthManagmentArea

    anchors.left: parent.left
    anchors.leftMargin: global_offset
    anchors.top: parent.top
    anchors.topMargin: global_offset

    function getButtonTrackRun () { return btnTrackRun }

    //Строка - описание
    Row {
        parent: columnTreadmill
        width: parent.width
        height: heightControl
        Text {
            y: parent.height / 2 - height / 2
            text: "Дорожка"
            font {
                pixelSize: Math.round (parent.width * 0.1)
            }
        }
    }
    //Строка старт/останов/обдув дорожки
    Row {
        width: parent.width
        spacing: 6

//        Кнопка Старт/Стоп
        HButton {
            id: btnTrackRun
            width: parent.width / 2 - parent.spacing / 2
            height: heightControl * 2
            textUnchecked: "Запуск"
            textChecked: "Останов"
            textRatio: 0.3

            checked: false
            checkable: true

            onClicked: {
                console.debug ("btnTrackRun::onClicked", "checked=", checked)
            }

            onCheckedChanged: {
//                Функция выбора РЕЖИМа работЫ
                function runTrainingTreadmill () {
                    if (btnCameraBase.checked || btnCameraFace.checked)
                        ;
                    else {
                        if (btnCameraBase.enabled)
                            btnCameraBase.checked = true
                        else {
                            if (btnCameraFace.enabled)
                                btnCameraFace.checked = true
                            else
                                ;
                        }
                    }
                }

                if (sliderCurrentTrainingStage) {//Стоп
                    sliderTrainingStage += sliderCurrentTrainingStage

                    if (isLimit ())
                        ;
                    else
                        if (sliderCurrentTrainingStage)
                            sliderTrainingStage ++
                        else
                            ;
                }
                else
                    sliderTrainingStage ++ //Старт/Стоп

                sliderCurrentTrainingStage = 0

                if (checked) {
//                    Выбор РЕЖИМа работЫ
                    runTrainingTreadmill ()

                    sgnTreadmillStart ()

                    sgnManagementTreadmill ("*600*")

                    sgnManagementTreadmill ("*604#" + (paramTrackSpeed.val * 5).toFixed (2) + "*")
                    sgnManagementTreadmill ("*605#" + (500 + (4000 - 500) / 12 * paramTrackTilt.val).toFixed (2) + "*")

                    sliderTrainingTask ++
                }
                else {
                    sgnTreadmillStop ()

                    sgnManagementTreadmill ("*601*")
                }

                sliderPreviousTime += sliderCurrentTime
                sliderCurrentTime = 0
                sliderPreviousDistance += sliderCurrentDistance
                sliderCurrentDistance = 0
            }

            onDoubleClicked: {
            }

            Connections {
                target: rectangleForm
                onSgnTrainingStart: {
                    console.debug ("HColumnTreadmill::onSgnStartTraining (target = rectangleForm)")
//                    btnTrackRun.checked = true
                }

                onSgnTrainingStop: {
                    console.debug ("HColumnTreadmill::onSgnStopTraining (target = rectangleForm)")
                    if (btnTrackRun.checked)
                        btnTrackRun.checked = false
                }
            }
        }

//        Кнопка Обдув
        //Строка - Управление ОБДУВом доржкИ (вклю/выкл.)
        HButton {
            id: btnObduvTrack
            width: parent.width / 2 - parent.spacing / 2
            height: heightControl * 2
            textUnchecked: "<center>Обдув<br\>старт</center>"
            textChecked: "<center>Обдув<br\>стоп</center>"
            textRatio: 0.3

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

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
}
