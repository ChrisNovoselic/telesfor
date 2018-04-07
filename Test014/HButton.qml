/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.0

BorderImage {
    id: button

    property string textUnchecked: ""
    property string textChecked: ""
    property real textRatio: 0.7
    property string colorUncheked: "green"
    property string colorChecked: "#f00"

    property string colorTextUnchecked: "white"
    property string colorTextChecked: "black"

    property bool checkable: false
    property bool checked: false
    onCheckedChanged: {
        console.debug ("HButton::onClicked (); checked =", checkable, checked)
        if ((! checkable) && checked) //???
            checked = false //???
    }

    property bool editable: false
    property bool edited: false

    property string borderColor: "black"
    property int borderWidth: 0

    property int radius: 3

    signal clicked
    signal doubleClicked

//    source: "images/button-" + color + ".gif"; clip: true
    border { left: 10; top: 10; right: 10; bottom: 10 }

//    Для состояния 'edited'
    Rectangle {
        id: rectEdited
        anchors.fill: button;
        radius: radius
        color: "blue";
        opacity: 0;
        gradient: Gradient {
//            GradientStop { position: 0.0; color: "lightsteelblue" }
            GradientStop { position: 0.0; color: "yellow" }
            GradientStop { position: 0.5; color: Qt.darker ("yellow") }
        }
        border.color: borderColor
        border.width: borderWidth
    }
//    Для состояния 'unchecked'
    Rectangle {
        id: rectUnchecked
        anchors.fill: button;
        radius: radius;
        color: colorUncheked
        opacity: 0;
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker (colorUncheked) }
            GradientStop { position: 1.0; color: colorUncheked }
        }
        border.color: borderColor
        border.width: borderWidth
    }
//    Для состояния 'checked'
    Rectangle {
        id: rectChecked
        anchors.fill: button;
        radius: radius;
        color: colorChecked
        opacity: 0;
        gradient: Gradient {
            GradientStop { position: 1.0; color: colorChecked }
            GradientStop { position: 0.0; color: Qt.lighter (colorChecked) }
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
        anchors.centerIn: parent;
        anchors.verticalCenterOffset: +1
        anchors.horizontalCenterOffset: +3
        font.pixelSize: parent.width > parent.height ? parent.height * textRatio : parent.width * textRatio
//        style: Text.Sunken; color: "red"; styleColor: "yellow"; smooth: true
        style: Text.Sunken; color: colorTextUnchecked; styleColor: Qt.darker (colorTextUnchecked); smooth: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (! edited) {
                checked = ! checked
                button.clicked ()
                if (! checkable)
                    checked = ! checked

                console.debug ("HButton::onClicked (); checked =", checkable, checked)
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
        State {
            name: "edited"; when: edited === true
            PropertyChanges { target: rectEdited; opacity: .6; }
            PropertyChanges { target: buttonText; text: button.textChecked; }
        },
        State {
            name: "disabled"; when: button.enabled === false
            PropertyChanges { target: rectDisabled; opacity: .9; }
            PropertyChanges { target: buttonText; text: button.textUnchecked; }
        },
        State {
            name: "checked"; when: (checked === true) || (mouseArea.pressed === true)
            PropertyChanges { target: rectChecked; opacity: .8; }
            PropertyChanges { target: buttonText; text: button.textChecked; color: colorTextChecked; }
        },
        State {
            name: "unchecked"; when: checked === false
            PropertyChanges { target: rectUnchecked; opacity: .5; }
            PropertyChanges { target: buttonText; text: button.textUnchecked; color: colorTextUnchecked; }
        }
    ]

    Component.onCompleted: {
        if (textChecked === "")
            textChecked = textUnchecked

//        console.debug ("HButton::onCompleted (): parent.objectName =", parent.objectName)
    }
}
