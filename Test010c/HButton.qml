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
    property string colorUncheked: "lightgreen"
    property string colorCheked: "red"
    property bool checked: false
    property bool checkable: true

    signal clicked
    signal doubleClicked

//    source: "images/button-" + color + ".gif"; clip: true
    border { left: 10; top: 10; right: 10; bottom: 10 }

    Rectangle {
        id: rectUnchecked
        anchors.fill: button;
        radius: 15;
        color: "blue";
        opacity: 0;
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightsteelblue" }
            GradientStop { position: 1.0; color: colorUncheked }
        }
    }

    Rectangle {
        id: rectChecked
        anchors.fill: button;
        radius: 15;
        color: "blue";
        opacity: 0;
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightsteelblue" }
            GradientStop { position: 1.0; color: colorCheked }
        }
    }

    Rectangle {
        id: rectDisabled
        anchors.fill: button;
        radius: 15;
        color: "gray";
        opacity: 0;
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgray" }
            GradientStop { position: 1.0; color: "gray" }
        }
    }

    Text {
        id: buttonText
        anchors.centerIn: parent; anchors.verticalCenterOffset: +1
        font.pixelSize: parent.width > parent.height ? parent.height * .7 : parent.width * .7
        style: Text.Sunken; color: "red"; styleColor: "yellow"; smooth: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            checked = ! checked
            button.clicked ()
            if (! checkable)
                checked = ! checked
        }

        onDoubleClicked: {
            button.doubleClicked ()
        }
    }

    states: [
//        State {
//            name: "pressed"; when: mouseArea.pressed == true
//            PropertyChanges { target: shade; opacity: .4 }
//        },
        State {
            name: "disabled"; when: button.enabled === false
            PropertyChanges { target: rectDisabled; opacity: .9; }
            PropertyChanges { target: buttonText; text: button.textUnchecked; }
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
    }
}
