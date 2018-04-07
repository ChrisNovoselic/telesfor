// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.
//import "objectReality.js" as ScriptObjectReality
//import "cvcapture.js" as ScriptCvCapture
import "slidermanage.js" as ScriptSliderManage
//import "timerspeed.js" as ScriptTimerSpeed

import "."

//    Столбец - управление ОбЪектАМи расширенной реальности
Column {
//    id: columnManagementObjectReality

//    x: ScriptCvCapture.posXItem (2, 0)
    spacing: 6
    width: widthManagmentArea

    anchors.right: parent.right
    anchors.rightMargin: global_offset
    anchors.bottom: parent.bottom
    anchors.bottomMargin: global_offset

    function enabledFixedPSC () {
        var bRes, obj = undefined

        if (cameraBase.visible) {
            obj = cameraBase
        }
        else {
            if (cameraFace.visible) {
                obj = cameraFace
            }
            else {
                bRes = false
            }
        }

        if (obj === undefined)
            ;
        else
            bRes  = obj.fixedPSC

        console.debug ("Поиск ЦФСК = ", obj, bRes)

        return bRes
    }

    function getButton (prefix) {
        var i, obj
        for (i = 0; i < children.length; i ++) {
            if (children [i].children [0].objectName.indexOf (prefix) > -1)
                break
        }

        if (i < children.length)
            obj = children [i].children [0]
        else
            obj = null

        return obj
    }

    function getButtonChecked (prefix) {
        var retChecked = false, obj = getButton (prefix)

        if (! (obj === null)) {
            //Кнопка НАЙДЕНа
            retChecked = obj.checked
        }
        else
            ;

        return retChecked
    }

    function setButtonChecked (prefix, val) {
        var i
        for (i = 0; i < children.length; i ++) {
            console.debug (children [i].children [0].objectName)
            if (children [i].children [0].objectName.indexOf (prefix) > -1)
                break
        }

        console.debug (children.length, i)

        if (i < children.length) {
            //Кнопка НАЙДЕНа
            children [i].children [0].checked = val
        }
        else
            ;
    }

    function enabledRowReplacement () {
        return btnCenterPSC.edited || btnLine1.edited || btnLine2.edited || btnTrace1.edited || btnTrace2.edited || btnGamma.edited || btnLattice.edited
    }

    function enableRowObjectReality () {
//        return cameraBase.visible || cameraFace.visible

        return btnFixedPSC.checked
    }

    //Возвращает ИМя обЪекта управления
    function getNameActiveObject () {
        var nameActiveObject = "", btnActive = undefined //columnManagementObjectReality.getButton ("Trace1")

    //        console.log (btnCenterPSC.checked, btnLine1.checked, btnLine2.checked, btnTrace1.checked, btnTrace2.checked)

        if (btnCenterPSC.edited)
            btnActive = btnCenterPSC
        else
            if (btnLine1.edited)
                btnActive = btnLine1
            else
                if (btnLine2.edited)
                    btnActive = btnLine2
                else
                    if (btnTrace1.edited)
                        btnActive = btnTrace1
                    else
                        if (btnTrace2.edited)
                            btnActive = btnTrace2
                        else
                            if (btnGamma.edited)
                                btnActive = btnGamma
                            else
                                if (btnLattice.edited) {
                                    btnActive = btnLattice
                                }
                                else
                                    ;


    //        console.debug (btnActive)
        if (! (btnActive === undefined)) {
            nameActiveObject = btnActive.objectName.substring (3, btnActive.objectName.length)
    //        console.debug (nameActiveObject)

            if (btnActive === btnLattice) {
                if (cameraBase.visible)
                    nameActiveObject += "Front"
                else
                    if (cameraFace.visible)
                        nameActiveObject += "Rear"
                    else
                        nameActiveObject = "";
            }
            else {
            }
        }
        else
            ;

//        console.debug (nameActiveObject)
        return nameActiveObject
    }

    //Возвращает тип управления элементом при размещении его в пространстве
    function getNameActiveItemManagement () {
        var nameActiveItemManagement = ""

        if (btnPosition.checked)
            nameActiveItemManagement = "position"
        else
            if (btnRotation.checked)
                nameActiveItemManagement = "rotation"
            else
                if (btnSize.checked)
                    nameActiveItemManagement = "size"
                else
                    ;

        return nameActiveItemManagement;
    }

    function createPseudoLattice () {
//            createPseudoLattice ()
        console.debug ("createPseudoLattice ()")

        var i, enumTypeLatticeLine = new Array ("vertical", "horizontal"), j
        for (i in enumTypeLatticeLine) {
            for (j = 0; j < m_synchCoordinates.count_lattice_line - 2; j ++) {
                var src = "HLatticeLine.qml"
                var obj = Qt.createComponent (src)

                if (obj.status === Component.Ready) {
                    obj = obj.createObject (rectanglePseudoLattice, {})
                    if (obj === null)
                        // Error Handling
                        console.debug ("Ошибка создания", src)
                    else {
                        obj.type = enumTypeLatticeLine [i]
                        obj.objectName = enumTypeLatticeLine [i] + (j + 1)
                        obj.number = j + 1
//                            obj.totalLine = m_synchCoordinates.count_lattice_line
                        obj.width = width
//                            obj.color = "yellow"


//                            obj.parent = rectanglePseudoLattice

                        switch (enumTypeLatticeLine [i]) {
                        case "vertical":
                            break
                        case "horizontal":
                            break
                        default:
                        }

//                        console.debug ("createPseudoLattice ()", obj.objectName)
                    }
                }
                else {
                    console.log ("Ошибка загрузки", src, obj.errorString ())
                }
            }
        }
    }

    //Строка - Фиксация центра фиизмческих координат
    Row {
        id: rowFixedPSC

        width: parent.width

        enabled: cameraBase.visible || cameraFace.visible

        HButton {
            id: btnFixedPSC
            objectName: "btnFixedPSC"
            parent: rowFixedPSC
            width: parent.width
            height: heightControl
            textUnchecked: "Поиск ЦФСК"
            textChecked: "Поиск ЦФСК"

//            checked: cameraBase.visible ? cameraBase.fixedPSC : cameraFace.visible ? cameraFace.fixedPSC : false
            checked: false
            checkable: true

            onClicked: {
                sgnResetPSC ()

                checked = enabledFixedPSC ()
            }

            onCheckedChanged: {
                //                    m_synchCoordinates.fixedPSC (checked)
            }

            onDoubleClicked: {
            }
        }
    }

    //Строка - слайдер для управления 1-ой координатой ПАРАМЕТРа обЪекта
    Row {
        id: rowSliderLineX
        enabled: btnPosition.checked || btnRotation.checked || btnSize.checked
        visible: enabled

        width: parent.width

        TextField {
            id: textFieldSliderLineX
            parent: rowSliderLineX
            width: 0.2 * parent.width

//            text: ScriptSliderManage.textFieldText (sliderObjectX.value)
            text: Math.round (sliderObjectX.value * Math.pow (10, 1)) / Math.pow (10, 1).toPrecision (3)
            font {
                pixelSize: Math.round (width * ratioWidthSliderTextField)
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
//                ScriptObjectReality.replacementObjectReality ()
//                sgnReplacmentObjectReality (getNameActiveObject (), getNameActiveItemManagement ())
                sgnReplacmentObject (getNameActiveObject (), getNameActiveItemManagement ())
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
        visible: enabled

        width: parent.width

        TextField {
            id: textFieldSliderLineY
            parent: rowSliderLineY
            width: 0.2 * parent.width

//            text: ScriptSliderManage.textFieldText (sliderObjectY.value)
            text: Math.round (sliderObjectY.value * Math.pow (10, 1)) / Math.pow (10, 1).toPrecision (3)
            font {
                pixelSize: Math.round (width * ratioWidthSliderTextField)
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
//                ScriptObjectReality.replacementObjectReality ()
//                sgnReplacmentObjectReality (getNameActiveObject (), getNameActiveItemManagement ())
                sgnReplacmentObject (getNameActiveObject (), getNameActiveItemManagement ())
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
        visible: enabled

        width: parent.width

        TextField {
            id: textFieldSliderLineZ
            parent: rowSliderLineZ
            width: 0.2 * parent.width

            text: Math.round (sliderObjectZ.value * Math.pow (10, 1)) / Math.pow (10, 1).toPrecision (3)
            font {
                pixelSize: Math.round (width * ratioWidthSliderTextField)
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
//                ScriptObjectReality.replacementObjectReality ()
//                sgnReplacmentObjectReality (getNameActiveObject (), getNameActiveItemManagement ())
                sgnReplacmentObject (getNameActiveObject (), getNameActiveItemManagement ())
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

        enabled: columnManagementObjectReality.enabledRowReplacement ()
        visible: enabled

        HButton {
            id: btnPosition
            objectName: "btnPosition"
            width: parent.width
            height: heightControl
            textUnchecked: "Позиция"
//            textChecked: "..."

            colorChecked: '#2f96b4'
            colorUncheked: '#5bc0de'

            checkable: true

            onClicked: {
            }

            onDoubleClicked: {
            }

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

//        enabled: columnManagementObjectReality.enabledRowReplacement ()
        enabled: false
        visible: enabled

        HButton {
            id: btnRotation
            objectName: "btnRotation"
            width: parent.width
            height: heightControl
            textUnchecked: "Вращение"
//            textChecked: "..."

            colorChecked: '#2f96b4'
            colorUncheked: '#5bc0de'

            checkable: true

            onClicked: {
            }

            onDoubleClicked: {
            }

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

        enabled: columnManagementObjectReality.enabledRowReplacement ()
        visible: enabled

        HButton {
            id: btnSize
            objectName: "btnSize"
            width: parent.width
            height: heightControl
            textUnchecked: "Размер"
//            textChecked: "..."

            colorChecked: '#2f96b4'
            colorUncheked: '#5bc0de'

            checkable: true

            onClicked: {
            }

            onDoubleClicked: {
            }

            onCheckedChanged: {
                if (checked) {
                    //Остальные 'ПОДНИМаем'
                    btnPosition.checked = false
//                    btnRotation.checked = false

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
//        enabled: cameraBase.visible || cameraFace.visible

        width: parent.width

        visible: false

        HButton {
            id: btnCenterPSC
            objectName: "btnCenterPSC"
            width: parent.width
            height: heightControl
            textUnchecked: "Центр ФСК"
//            textChecked: "..."

            checkable: true
            editable: false

            onCheckedChanged: {
                centerPSC.visible = checked
            }

            onEditedChanged: {
                if (edited) {
                    //Остальные 'ПОДНИМаем'
                    sgnEditedButtonGroupObjectReality (btnCenterPSC)

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
        enabled: enableRowObjectReality ()
//        enabled: false

        width: parent.width

        HButton {
            id: btnLine1
            objectName: "btnLine1"
            width: parent.width
            height: heightControl
            textUnchecked: "Линия 1"
//            textChecked: "..."

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checkable: true
            editable: true

            onCheckedChanged: {
//                ScriptObjectReality.getObjectReality ("Line", 1).visible = checked
//                descObjectsReality.setVisible ("Line", 1, checked)
                sgnSetVisibleObjectReality ("Line", 1, checked)
            }

            onEditedChanged: {
                if (edited) {
                    //Остальные 'ПОДНИМаем'
                    sgnEditedButtonGroupObjectReality (btnLine1)

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
//        enabled: false
//        enabled: cameraBase.visible || cameraFace.visible
        enabled: enableRowObjectReality ()

        width: parent.width

        HButton {
            id: btnLine2
            objectName: "btnLine2"
            width: parent.width
            height: heightControl
            textUnchecked: "Линия 2"
//            textChecked: "..."

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checkable: true
            editable: true

            onClicked: {
            }

            onDoubleClicked: {
            }

            onCheckedChanged: {
//                ScriptObjectReality.getObjectReality ("Line", 2).visible = checked
//                descObjectsReality.setVisible ("Line", 2, checked)
                sgnSetVisibleObjectReality ("Line", 2, checked)
            }

            onEditedChanged: {
                if (edited) {
                    //Остальные 'ПОДНИМаем'
                    sgnEditedButtonGroupObjectReality (btnLine2)

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

        enabled: enableRowObjectReality ()

        HButton {
            id: btnTrace1
            objectName: "btnTrace1"
            width: parent.width
            height: heightControl
            textUnchecked: "След 1"
//            textChecked: "..."

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checkable: true
            editable: true

            onCheckedChanged: {
//                var i, trace
//                for (i = 1; i < m_synchCoordinates.count_of_trace; i += 2) {
//                    ScriptTimerSpeed.visibleTrace (i, checked)
//                }
                sgnSetVisibleObjectReality ("Trace", 1, checked)
            }

            onEditedChanged: {
                if (edited) {
                    //Остальные 'ПОДНИМаем'
                    sgnEditedButtonGroupObjectReality (btnTrace1)

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

        enabled: enableRowObjectReality ()

        HButton {
            id: btnTrace2
            objectName: "btnTrace2"
            width: parent.width
            height: heightControl
            textUnchecked: "След 2"
//            textChecked: "..."

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checkable: true
            editable: true

            onCheckedChanged: {
//                var i, trace
//                for (i = 2; i < count_of_trace; i += 2) {
//                    ScriptTimerSpeed.visibleTrace (i, checked)
//                }
                sgnSetVisibleObjectReality ("Trace", 2, checked)
            }

            onEditedChanged: {
                if (edited) {
                    //Остальные 'ПОДНИМаем'
                    sgnEditedButtonGroupObjectReality (btnTrace2)

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
        enabled: enableRowObjectReality ()

        width: parent.width

        HButton {
            id: btnGamma
            objectName: "btnGamma"
            width: parent.width
            height: heightControl
            textUnchecked: "Гамма"
//            textChecked: "..."

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checkable: true
            editable: true

            onClicked: {
            }

            onDoubleClicked: {
            }

            onCheckedChanged: {
//                ScriptObjectReality.getObjectReality ("Gamma", 1).visible = checked
//                descObjectsReality.setVisible ("Gamma", 1, checked)
                sgnSetVisibleObjectReality ("Gamma", 1, checked)

//                ScriptObjectReality.getObjectReality ("Gamma", 2).visible = checked
//                descObjectsReality.setVisible ("Gamma", 2, checked)
                sgnSetVisibleObjectReality ("Gamma", 2, checked)
            }

            onEditedChanged: {
                if (edited) {
                    //Остальные 'ПОДНИМаем'
                    sgnEditedButtonGroupObjectReality (btnGamma)

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
        enabled: enableRowObjectReality ()

        width: parent.width
        visible: true

        HButton {
            id: btnLattice
            objectName: "btnLattice" //"btn" + latticeFront.objectName
            parent: rowLattice
            width: parent.width
            height: heightControl
            textUnchecked: "Решётка"

            colorUncheked: "black"
            colorChecked: "#ffffff"

            colorTextUnchecked: "white"
            colorTextChecked: "black"

            checkable: true
            editable: true

            onCheckedChanged: {
                if (checked) {
                }
                else {
                }

//                if (cameraBase.visible)
//                    latticeFront.visible = checked
//                else
//                    latticeFront.visible = false

//                if (cameraFace.visible)
//                    latticeRear.visible = checked
//                else
//                    latticeRear.visible = false
            }

            onEditedChanged: {
                if (edited) {
//                    Остальные 'ПОДНИМаем'
//                    unCheckableButton (btnGamma)
                    sgnEditedButtonGroupObjectReality (btnLattice)

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
    //ПсевдоРешЁткА для УПРАВЛения решЁткоЙ
    Rectangle {
        id: rectanglePseudoLattice

        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

//        anchors.top: rowCenterPSC.bottom
//        anchors.topMargin: spacing

//        width: parent.width
        height: width

        color: rectangleForm.color

        visible: btnLattice.checked && ! (btnCenterPSC.edited || btnLine1.edited || btnLine2.edited || btnTrace1.edited || btnTrace2.edited || btnGamma.edited || btnLattice.edited)
//        visible: true

        Component.onCompleted: {
//            createPseudoLattice ()
        }

        onWidthChanged: {
            console.debug ("rectanglePseudoLattice.children.length =", children.length)
            var i
            for (i = 0; i < children.length; i ++) {
//                console.debug (children [i].objectName)
                children [i].width = width
//                switch (children [i].type) {
//                case "vertical":
//                    children [i].width = width
//                    break
//                case "horizontal":
//                    children [i].width = width
//                    break
//                default:
//                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var lineArea = height / ((parent.children.length - 1) / 2)
                    , number = Math.ceil (mouseY / lineArea) //+ ((parent.children.length - 1) / 2)
                console.debug ("rectanglePseudoLattice::MouseArea::onClicked =", mouseY, height, lineArea, number)
                console.debug ("rectanglePseudoLattice::MouseArea::onClicked =", parent.children.length, parent.children [number].objectName )
                if (parent.children [number + ((parent.children.length - 1) / 2)].checked) {
                    sgnCheckedLatticeLine (number, false, "blue")
                    parent.children [number + ((parent.children.length - 1) / 2)].checked = false
                }
                else {
                    sgnCheckedLatticeLine (number, true, "blue")
                    parent.children [number + ((parent.children.length - 1) / 2)].checked = true
                }

            }
        }

//        HLatticeLine {
//            type: "vertical"
//            number: 1

//            width: parent.width
//        }

//        HLatticeLine {
//            type: "vertical"
//            number: 2

//            width: parent.width
//        }

//        HLatticeLine {
//            type: "vertical"
//            number: 4

//            width: parent.width
//        }

//        HLatticeLine {
//            type: "vertical"
//            number: 6

//            width: parent.width
//        }

//        HLatticeLine {
//            type: "horizontal"
//            number: 3

//            width: parent.width
//        }
    }

    //_Отладка
    HButton {
        id: btnDebug
        width: parent.width
        height: heightControl
        textUnchecked: "Отладка"
        //            textChecked: "..."

        checkable: false
        visible: true //false

        onClicked: {
//            ScriptHCouchDB.queryCouchdb (nameDB, typeContent, "1234")
//            Добавление сложного обЪекта в документ
//            ScriptHCouchDB.putCouchdb (nameDB, typeContent, "1234", JSON.parse ('{"DateTime":"' + (new Date).toLocaleString () + '","pulse":"value2"}'))

//            var dtBegin = new Date () //Qt.formatTime(tm, "hh:mm:ss")
//            var postData = '{"id_patient":"' + btnPatientTitle.patientJSON ["_id"] + '",' +
//                            '"dttm":"' + dtBegin.toDateString () + ' ' + dtBegin.toTimeString () + '",' +
//                            '"type":"' + 'training' + '",' +
//                            '"speed":{"timeStamp":"' + dtBegin.toTimeString () + '","value":"' + paramTrackSpeed.val + '"},' +
//                            '"tilt":"' + paramTrackTilt.val + '",' +
//                            '"time":"' + paramTrainingTime.val + '",' +
//                            '"distance":"' + paramTrainingDistance.val + '",' +
//                            '"pulse":"' + textPulseVal.toFixed (2) + '",' +
//                            '"stepsLength":"' + paramStepsLength.val +
//                            '"}'

//            console.debug (postData)

//            console.debug (JSON.parse (postData) ["speed"] ["timeStamp"], JSON.parse (postData) ["dttm"], JSON.parse (postData) ["stepsLength"])

//            Запись в БД пациента с ФАМИЛИЕй ГОСТь
//            var dtBirstDay = new Date,
//                baseName = 'Эраст' //Иван, Пётр, Семён, Гаврил, Андре, Серге, Гевор, Глеб, Ефрем, Захар, Исак, Марк, Степан, Федот, Харитон, Яромир, Эраст
//            dtBirstDay.setDate (21); dtBirstDay.setMonth (6); dtBirstDay.setFullYear (1968); //dtBirstDay.setHours (19); dtBirstDay.setMinutes (25); dtBirstDay.setSeconds (49)
//            sgnPostCouchDB (nameDB, typeContent, JSON.parse ('{"lastName":"' + baseName +  'ов' + '",' +
//                                                        '"firstName":"' + baseName + '",' +
//                                                        '"middleName":"' + baseName +  'ович' + '",' +
//                                                        '"type":"' + 'patient' + '",' +
//                                                        '"birstDay":"' + dtBirstDay.toDateString () + '",' +
//                                                        '"diagnose":"' + 'Диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе...диагнозе' + '",' +
//                                                        '"height":"' + 124 + '",' +
//                                                        '"weight":"' + 77 +
//                                                        '"}'))

            function joinJSON (dest, src) {
                for (var key in src) {
                    if (dest.hasOwnProperty (key)) {
                        if (JSON.stringify (src [key]).indexOf ('{') > -1)
                            joinJSON (dest [key], src [key])
                        else {
                            console.debug ("joinJSON::JSON.stringify (obj [key]).indexOf ('{') > -1::else", key, dest [key], src [key])
                            dest [key] = src [key]
                        }
                    }
                    else {
                        console.debug ("joinJSON::dest.hasOwnProperty (key)::else", key, dest [key], src [key])
                        dest [key] = src [key]
                    }
                }
            }

            function consoleJSON (obj, level) {
                var tab = ""
                for (var i = 0; i < level; i ++)
                    tab += "    "
                for (var key in obj) {
                    if (obj.hasOwnProperty (key)) {
                        if (JSON.stringify (obj [key]).indexOf ('{') > -1) {
                            console.debug (tab, key, ":")
                            consoleJSON (obj [key], level + 1)
                        }
                        else
                            console.debug (tab, key, obj [key])
                    }
                    else
                        ;
                }
            }

            var dtNow = new Date, postData1 = '{' +
                        '"id_patient":"' + '11111111111111111111111' + '",' +
                        '"' + 'id_pulse' + '":"' + '' + '",' +
                        '"' + 'countStage' + '":"' + parseInt (sliderCurrentTrainingStage + 1) + '"' + ',' +
                    '"' + 'id_task' + '":"' + '1-1-1-1-1-1-1-1-1-1-1' + '",' +
                        '"dttm":{"start":{"":"' + dtNow.toDateString () + ' ' +  dtNow.toTimeString () + '"}},' +
                        '"type":"' + 'training' + '",' +
                        '"phases":{' +
                            '"0":{' +
                                '"type":"idle"' + ',' +
                                '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
                                '"speed":"0"' + ',' +
                                '"tilt":"0"' + ',' +
//                                '"time":"0"' + ',' +
//                                '"distance":"0"' + ',' +
                                '"stepsLength":"0"' +
                                '}' +
                            '}' +
                        '}',
            postData2 = '{' +
                    '"id_patient":"' + '22222222222222222222' + '",' +
                                '"' + 'id_pulse' + '":"' + 'NEW_PULSE' + '",' +
                                '"' + 'countStage' + '":"' + parseInt (sliderCurrentTrainingStage + 1) + '"' + ',' +
                    '"' + 'id_task' + '":"' + '2-2-2-2-2-2-2-2-2-2-2-2-2-' + '",' +
                                '"dttm":{"end":{"":"' + dtNow.toDateString () + ' ' +  dtNow.toTimeString () + '"}},' +
                                '"type":"' + 'training' + '",' +
                                '"phases":{' +
                                    '"1":{' +
                                        '"type":"idle"' + ',' +
                                        '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
                                        '"speed":"0"' + ',' +
                                        '"tilt":"0"' + ',' +
                                        '"time":"0"' + ',' +
                                        '"distance":"0"' + ',' +
                                        '"stepsLength":"0"' +
                                        '}' + ',' +
                                    '"0":{' +
//                                        '"type":"idle"' + ',' +
//                                        '"timeStamp":"' + dtNow.toTimeString () + '"' + ',' +
//                                        '"speed":"0"' + ',' +
//                                        '"tilt":"0"' + ',' +
                                        '"time":"666"' + ',' +
                                        '"distance":"666"' + //',' +
//                                        '"stepsLength":"0"' +
                                        '}' +
                                    '}' +
                                '}'

            var jsonPostData1 = JSON.parse (postData1), jsonPostData2 = JSON.parse (postData2)
            joinJSON (jsonPostData1, jsonPostData2)
//            console.debug (JSON.stringify (jsonPostData1))
            consoleJSON (jsonPostData1, 0)


//            var db = ScriptJQueryCouch.couchDB (nameDB)

//            var couchDB = new ScriptACouch.CouchDB (nameDB, "application/xml")
//            couchDB.allDocs (callBackXMLHttpRequestStateChange)

//            var couchDB = new ScriptCouch.CouchDB.$ ("http://" + ipDB + ":" + portDB + "/" + nameDB, "couchDB")

//            var couch = ScriptJQueryCouch.$
//            console.debug (JSON.stringify (couch))

//            var sys = ScriptModuleRequire.require ('sys');
//            var nodeCouch = ScriptModuleRequire.require ('node-couch')

//            couchDB = ScriptNodeCouch.CouchDB
//            couchDB = ScriptModuleRequire.require ('./node-couch.js')

//            db = couchDB.db ('test001', 5984, '127.0.0.1');

//            couchDB.open ("http://" + ipDB + ":" + portDB + "/" + nameDB)
//            console.debug (JSON.stringify (couchDB))

//            console.debug (JSON.stringify (columnTreadmill))

//            var doc = new XMLHttpRequest ();

//            doc.onreadystatechange = function () {
//                        function showRequestInfo (text) {
//                            text = gText + "\n" + text
//                            console.log (text)
//                        }

//                        function showRequestInfoXMLHttpRequest (obj) {
//                            showRequestInfo ("Headers -->");
//                            showRequestInfo (doc.getAllResponseHeaders ());
//                            showRequestInfo ("Last modified -->");
//                            showRequestInfo (doc.getResponseHeader ("Last-Modified"));
//                        }

//                        switch (doc.readyState) {
//                        case XMLHttpRequest.HEADERS_RECEIVED:
//                            //                            showRequestInfoXMLHttpRequest (doc)
//                            break;
//                        case XMLHttpRequest.DONE:
//                            var a = doc.responseText;
//                            console.debug (a)
//                            //                            showRequestInfoXMLHttpRequest (doc)
//                            break;
//                        default:
//                            ;
//                        }
//                    }

//            doc.open ("GET", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/_all_docs");
//            doc.send (null);

//            var db = new ScriptCouch.CouchDB ("http://" + ipDB + ":" + portDB + "/" + nameDB, "application/xml")
//            console.log (JSON.stringify (db));

//            postData = '{"_id":"1234","_rev":"' + respJSON._rev + '","forename":"666","surname":"777","type":"-666"}';
//            console.debug (postData)
//            doc.open("PUT", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/1234", true);
//            doc.setRequestHeader ('Content-Type', 'application/json')
//            doc.send (postData);
        }
    }
}
