// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.
import "objectReality.js" as ScriptObjectReality
//import "cvcapture.js" as ScriptCvCapture
import "slidermanage.js" as ScriptSliderManage
import "timerspeed.js" as ScriptTimerSpeed

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
                for (i = 1; i < ScriptTimerSpeed.countOfTrace (); i += 2) {
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

