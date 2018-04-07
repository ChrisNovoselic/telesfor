import QtQuick 1.0

import "hcouch.js" as ScriptHCouchDB

BorderImage {
    id: button

    property bool isTitle: false
    property variant patientJSON: undefined
    onPatientJSONChanged: {
        if (! (patientJSON === undefined)) {
            textUnchecked = patientJSON ['lastName'].concat (' ',
                            patientJSON ['firstName'], ' ',
                            patientJSON ['patronymic'])
            if (isTitle) {
                textUnchecked = textUnchecked.concat (', ',
                                                      'Рост: ', patientJSON ['height'], ', ',
                                                      'Вес: ', patientJSON ['weight'], ', ',
                                                      ScriptHCouchDB.ageOfBirthDay (patientJSON ['birthDate']), ' полных лет', ', ',
                                                      'Пол: ', patientJSON ['sex'])

                sgnGetPatientRoutine (patientJSON ['_id'])
                sgnResetStatistic ()
            }
            else
                ; //textUnchecked = ""

            textChecked = textUnchecked

            checkedButtonPatient ()
        }
        else
            ;
    }

    function checkedButtonPatient () {
        if ((! (btnPatientTitle.patientJSON === undefined)) && (! (patientJSON === undefined))) {
            if (! isTitle) {
                if (btnPatientTitle.patientJSON ["_id"] === patientJSON ["_id"])
                    checked = true
                else
                    checked = false
            }
            else
                ;

//            console.debug (objectName, btnPatientTitle.patientJSON ["_id"], patientJSON ["_id"], checked)
        }
        else
            ;
    }

    function enabledButtonPatient () {
        if (patientJSON === undefined)
            return false
        else
            return true
    }

    function uncheckedButtonPatient (btn) {
//        console.debug ("HButtonPatient::uncheckedButtonPatient", parent.children.length)
        for (var i = 1; i < parent.children.length; i ++) {
            if ((parent.children [i].objectName.indexOf ("btnPatient") > -1) && (parent.children [i].enabled) && (! (parent.children [i] === btn)))
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
            btnPatientTitle.patientJSON = patientJSON

            uncheckedButtonPatient (button)
        }
        else
            ;

        console.debug ("HButtonPatient::onCheckedChanged ()", objectName)
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

    enabled: enabledButtonPatient ()

//    source: "images/button-" + color + ".gif"; clip: true
    border { left: 10; top: 10; right: 10; bottom: 10 }

//    Для состояния 'edited'
//    Rectangle {
//        id: rectEdited
//        anchors.fill: button;
//        radius: radius;
//        color: "blue";
//        opacity: 0;
//        gradient: Gradient {
//            GradientStop { position: 0.0; color: "lightsteelblue" }
//            GradientStop { position: 1.0; color: "yellow" }
//        }
//        border.color: borderColor
//        border.width: borderWidth
//    }
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
            GradientStop { position: 0.0; color: Qt.darker (colorChecked) }
//            GradientStop { position: 1.0; color: { console.debug (colorChecked); return colorChecked } }
            GradientStop { position: 1.0; color: colorChecked }
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
        style: Text.Sunken; color: colorText; styleColor: Qt.darker (colorText); smooth: true
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
//        State {
//            name: "pressed"; when: mouseArea.pressed == true
//            PropertyChanges { target: shade; opacity: .4 }
//        },
//        State {
//            name: "edited"; when: edited === true
//            PropertyChanges { target: rectEdited; opacity: .6; }
//            PropertyChanges { target: buttonText; text: button.textChecked; }
//        },
        State {
            name: "disabled"; when: button.enabled === false
            PropertyChanges { target: rectDisabled; opacity: .9; }
            PropertyChanges { target: buttonText; text: button.textUnchecked; color: colorUnchecked} //"white"
        },
        State {
            name: "checked"; when: (checked === true) || (mouseArea.pressed === true)
            PropertyChanges { target: rectChecked; opacity: .2; }
            PropertyChanges { target: buttonText; text: button.textChecked; }
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
