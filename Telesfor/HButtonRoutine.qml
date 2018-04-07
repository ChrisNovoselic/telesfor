import QtQuick 1.0

import "hcouch.js" as ScriptHCouchDB
import "."

BorderImage {
    id: button
//    objectName: "btnPatientRoutine"

    property variant routineJSON: undefined
    onRoutineJSONChanged: {
        if (! (routineJSON === undefined)) {
//            console.debug ("HButtonRoutine::onRoutineJSONChanged = ", routineJSON ['name'])

//            if ((objectName.indexOf ("Default") < 0) && (objectName.indexOf ("Custom") < 0))
                textUnchecked = routineJSON ['name']
//            else
//                ;

            textChecked = textUnchecked

            if (checked)
                sgnSetPatientRoutine (JSON.stringify (routineJSON))
            else
                ;

//            checkedButtonRoutine ()
        }
        else { //НИКОГДа НЕ ВЫПОЛНЯЕТся, т.к. у 2-х кнопок всегда ЕСТь 'routineJSON'
//            if ((objectName.indexOf ("Default") < 0) || (objectName.indexOf ("Custom") < 0)) {
                textUnchecked = "Задание №" + objectName.substring (objectName.length - 1, objectName.length)
                checked = false
//            }
//            else
//                ;
        }

        textChecked = textUnchecked
    }

//    function checkedButtonRoutine () {
//        if (objectName.indexOf ("Default") > -1) {
//            checked = true
//            //Вызов происходИТ в 'Change' свойствА 'checked'
////            if (! (routineJSON === undefined))
////                sgnSetPatientRoutine (JSON.stringify (routineJSON))
////            else
////                ;
//        }
//        else
//            checked = false

//        console.debug ("HButtonRoutine::checkedButtonRoutine ()", objectName, checked)
//    }

    function enabledButtonRoutine () {
        var bEnabled = false

        if (objectName.length) {
            if (routineJSON === undefined)
                ; //return false
            else
                bEnabled = true

//            console.debug ("HButtonRoutine::enabledButtonRoutine ()", objectName, bEnabled)
        }
        else
            ;

        return bEnabled
    }

    function uncheckedButtonRoutine (btn) {
//        console.debug ("HButtonRoutine::uncheckedButtonRoutine", parent.children.length)
        for (var i = 1; i < parent.children.length; i ++) {
            if ((parent.children [i].objectName.indexOf ("btnPatientRoutine") > -1) && (parent.children [i].enabled) && (! (parent.children [i] === btn)))
                parent.children [i].checked = false
            else
                ;
        }
    }

    property string textUnchecked: ""
    property string textChecked: ""
    property real textRatio: 0.7
    property string colorUnchecked: "white" //'#ee5f5b' //"lightgreen"
    property string colorChecked: "black" //'#bd362f' //"red"
    property string colorText: 'white'
    property bool checked: false
    onCheckedChanged: {
        if (checked) {
            if (! (routineJSON === undefined)) {
                uncheckedButtonRoutine (button)
                console.debug ("HButtonRoutine::onCheckedChanged::sgnSetPatientRoutine = ", objectName, JSON.stringify (routineJSON))
                if (sliderCurrentTrainingStage > 0)
                    ; //Сигнал б. послан в 'onSliderCurrentTrainingStageChanged'
                else
                    sgnSetPatientRoutine (JSON.stringify (routineJSON))

//                if (idTraining.length > 0) {
//                    sgnResetStatistic ()
//                }
//                else
//                    ;
            }
            else
                ;
        }
        else
            ;

        console.debug ("HButtonRoutine::onCheckedChanged ()", objectName, checked)
    }

    property bool checkable: true
    property bool edited: false
    property bool editable: false

    property string borderColor: "blue"
    property int borderWidth: 0

    signal clicked
    onClicked: {
    }

    signal doubleClicked

    enabled: enabledButtonRoutine ()

//    source: "images/button-" + color + ".gif"; clip: true
    border { left: 10; top: 10; right: 10; bottom: 10 }

//    Для состояния 'unchecked'
    Rectangle {
        id: rectUnchecked
        anchors.fill: button
        radius: radius
        color: colorUnchecked
        opacity: 0
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker (colorUnchecked) }
            GradientStop { position: 1.0; color: colorUnchecked }
        }
        border.color: borderColor
        border.width: borderWidth
    }
//    Для состояния 'checked'
    Rectangle {
        id: rectChecked
        anchors.fill: button
        radius: radius
        color: colorChecked
        opacity: 0
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorChecked }
//            GradientStop { position: 1.0; color: { console.debug (colorChecked); return colorChecked } }
            GradientStop { position: 1.0; color: Qt.darker (colorChecked) }
        }
        border.color: borderColor
        border.width: borderWidth
    }
//    Для состояния 'disabled'
    Rectangle {
        id: rectDisabled
        anchors.fill: button;
        radius: radius;
        color: "lightgray";
        opacity: 0;
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker ("lightgray") }
            GradientStop { position: 1.0; color: "lightgray" }
        }
        border.color: borderColor
        border.width: borderWidth
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        anchors.verticalCenterOffset: +1
        anchors.horizontalCenterOffset: - (parent.width - width) / 2 + global_offset

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: parent.width > parent.height ? parent.height * textRatio : parent.width * textRatio
//        style: Text.Sunken; color: "red"; styleColor: "yellow"; smooth: true
        style: Text.Normal; color: colorText; /*styleColor: Qt.darker (colorText);*/ smooth: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (! checked) {
                checked = ! checked
                button.clicked ()
//            if (! checkable) {
//                checked = ! checked
//            }
//            else
//                ;
            }
            else
                ;
        }

        onDoubleClicked: {
            if (editable) {
                edited = ! edited

                checked = true
            }
            else
                ;

            button.doubleClicked ()
        }
    }

    states: [
        State {
            name: "checked"; when: (checked === true) || (mouseArea.pressed === true)
            PropertyChanges { target: rectChecked; opacity: .2; }
            PropertyChanges { target: buttonText; text: button.textChecked; styleColor: colorChecked}
        },
        State {
            name: "disabled"; when: button.enabled === false
            PropertyChanges { target: rectDisabled; opacity: .9; }
            PropertyChanges { target: buttonText; text: button.textUnchecked; color: colorUnchecked}
        },
        State {
            name: "unchecked"; when: checked === false
            PropertyChanges { target: rectUnchecked; opacity: .5; }
            PropertyChanges { target: buttonText; text: button.textUnchecked; }
        }
    ]

    Component.onCompleted: {
        if (textChecked === "")
            textChecked = textUnchecked

//        console.debug ("HButton::onCompleted (): parent.objectName =", parent.objectName)
    }
}
