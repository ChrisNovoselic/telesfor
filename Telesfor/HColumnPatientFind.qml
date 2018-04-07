// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1 //Slider, Button e.t.c.

Rectangle {
//    id:columnColumnPatientFind
    property int spacing: 6

    width: widthManagmentArea

    visible: btnPatientArea.checked
//    enabled: (! columnTraining.getButtonTrainingRun ().checked) && (! columnTreadmill.getButtonTrackRun ().checked)
    enabled: false

    anchors.left: columnTreadmill.right
    anchors.leftMargin: global_offset
//    anchors.right: columnPatientList.left
//    anchors.rightMargin: global_offset


    anchors.top: btnPatientTitle.bottom
    anchors.topMargin: global_offset

//    anchors.bottom: parent.bottom
////    anchors.bottom: collumnPatientRoutine.top
//    anchors.bottomMargin: 1 * global_offset

    height: rectanglePopupPatientFind.visible ? heightWithPopupPatientFind () : heightWithoutPopupPatientFind ()
    function heightWithPopupPatientFind () {
        return 10 * heightControl + (10 + 0) * spacing + rectanglePopupPatientFind.height + spacing / 2
    }

    function heightWithoutPopupPatientFind () {
        return 10 * heightControl + (10 - 1) * spacing + spacing / 2
    }

    color: "darkgray"

//    anchors.bottom: rectangleForm.bottom
//    anchors.bottomMargin: 1 * global_offset

    function magnifier (objParam, objTop, objBottom) {
        rectanglePopupPatientFind.object = objParam

        rectanglePopupPatientFind.visible = true

        rectanglePopupPatientFind.objectRowTop = objTop
        rectanglePopupPatientFind.objectRowBottom = objBottom
    }

    //Строка - описание
    Row {
        id: rowColumnPatientFindDesc
//        parent: rowPatient
        width: parent.width
        height: heightControl
        Text {
            y: parent.height / 2 - height / 2
            text: "Поиск"
            font {
                pixelSize: Math.round (widthManagmentArea * 0.1)
            }
        }
    }

    //Строка - Фамилия
    Row {
         id: rowColumnPatientFindLastName
//         parent: rowPatient
         width: parent.width
         height: heightControl

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindLastName, rowColumnPatientFindLastName, rowColumnPatientFindFirstName)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindLastName)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindLastName, rowColumnPatientFindLastName, rowColumnPatientFindFirstName)
                 }
             }
         }

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindDesc.bottom
             anchors.topMargin = parent.spacing
         }

         Text {
             id: textRowPatientFindLastNameDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Фамилия"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     rowColumnPatientFindLastName.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindLastName
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
                 var num = paramPatientFindLastName.val
                 var alfaBeta = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
                 if (num)
                     return alfaBeta [num - 1]
                 else
                     return "Все"
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                    rowColumnPatientFindLastName.magnifier ()
                 }
             }

             Component.onCompleted: {
                 paramPatientFindLastName.objectTextField = textFieldSliderPatientFindLastName
             }
         }
     }
    //Строка - Имя
    Row {
         id: rowColumnPatientFindFirstName
//         parent: rowPatient
         width: parent.width
         height: heightControl

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindFirstName, rowColumnPatientFindFirstName, rowColumnPatientFindMiddleName)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindFirstName)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindFirstName, rowColumnPatientFindFirstName, rowColumnPatientFindMiddleName)
                 }
             }
         }

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindLastName.bottom
             anchors.topMargin = parent.spacing
         }

         Text {
             id: textRowPatientFindFirstNameDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Имя"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     rowColumnPatientFindFirstName.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindFirstName
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
                 var num = paramPatientFindFirstName.val
                 var alfaBeta = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
                 if (num)
                     return alfaBeta [num - 1]
                 else
                     return "Все"
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     rowColumnPatientFindFirstName.magnifier ()
                 }
             }

             Component.onCompleted: {
                paramPatientFindFirstName.objectTextField = textFieldSliderPatientFindFirstName
             }
         }
     }
    //Строка - Отчество
    Row {
         id: rowColumnPatientFindMiddleName
//         parent: rowPatient
         width: parent.width
         height: heightControl

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindMiddleName, rowColumnPatientFindMiddleName, rowColumnPatientFindAgeMin)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindMiddleName)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindMiddleName, rowColumnPatientFindMiddleName, rowColumnPatientFindAgeMin)
                 }
             }
         }

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindFirstName.bottom
             anchors.topMargin = parent.spacing
         }

         Text {
             id: textRowPatientFindMiddleNameDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Отчество"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     rowColumnPatientFindMiddleName.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindMiddleName
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
                 var num = paramPatientFindMiddleName.val
                 var alfaBeta = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
                 if (num)
                     return alfaBeta [num - 1]
                 else
                     return "Все"
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                    rowColumnPatientFindMiddleName.magnifier ()
                 }
             }

             Component.onCompleted: {
                paramPatientFindMiddleName.objectTextField = textFieldSliderPatientFindMiddleName
             }
         }
     }

    //Строка - Возраст МИН
    Row {
         id: rowColumnPatientFindAgeMin
//         parent: rowPatient
         width: parent.width
         height: heightControl

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindMiddleName.bottom
             anchors.topMargin = parent.spacing
         }

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindAgeMin, rowColumnPatientFindAgeMin, rowColumnPatientFindAgeMax)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindAgeMin)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindAgeMin, rowColumnPatientFindAgeMin, rowColumnPatientFindAgeMax)
                 }
             }
         }

         Text {
             id: textRowPatientFindAgeMinDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Возраст мин."
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     rowColumnPatientFindAgeMin.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindAgeMin
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
//                 var min = 19, max = 99
//                 return min.toString () + "-" + max.toString ()
                 return paramPatientFindAgeMin.val
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                    rowColumnPatientFindAgeMin.magnifier ()
                 }
             }

             Component.onCompleted: {
             }
         }
     }
    //Строка - Возраст МАКС
    Row {
         id: rowColumnPatientFindAgeMax
//         parent: rowPatient
         width: parent.width
         height: heightControl

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindAgeMin.bottom
             anchors.topMargin = parent.spacing
         }

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindAgeMax, rowColumnPatientFindAgeMax, rowColumnPatientFindHeightMin)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindAgeMax)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindAgeMax, rowColumnPatientFindAgeMax, rowColumnPatientFindHeightMin)
                 }
             }
         }

         Text {
             id: textRowPatientFindAgeMaxDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Возраст макс."
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     rowColumnPatientFindAgeMax.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindAgeMax
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
//                 var min = 19, max = 99
//                 return min.toString () + "-" + max.toString ()
                 return paramPatientFindAgeMax.val
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                    rowColumnPatientFindAgeMax.magnifier ()
                 }
             }

             Component.onCompleted: {
             }
         }
     }

    //Строка - Рост МИН
    Row {
         id: rowColumnPatientFindHeightMin
//         parent: rowPatient
         width: parent.width
         height: heightControl

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindAgeMax.bottom
             anchors.topMargin = parent.spacing
         }

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindHeightMin, rowColumnPatientFindHeightMin, rowColumnPatientFindHeightMax)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindHeightMin)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindHeightMin, rowColumnPatientFindHeightMin, rowColumnPatientFindHeightMax)
                 }
             }
         }

         Text {
             id: textRowPatientFindHeightMinDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Рост минимум"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindHeightMin
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
//                 var min = 99, max = 199
//                 return min + "-" + max
                 return paramPatientFindHeightMin.val
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }

             Component.onCompleted: {
             }
         }
     }
    //Строка - Рост МАКС
    Row {
         id: rowColumnPatientFindHeightMax
//         parent: rowPatient
         width: parent.width
         height: heightControl

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindHeightMin.bottom
             anchors.topMargin = parent.spacing
         }

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindHeightMax, rowColumnPatientFindHeightMax, rowColumnPatientFindWeightMin)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindHeightMax)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindHeightMax, rowColumnPatientFindHeightMax, rowColumnPatientFindWeightMin)
                 }
             }
         }

         Text {
             id: textRowPatientFindHeightMaxDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Рост максимум"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindHeightMax
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: paramPatientFindHeightMax.val
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }

             Component.onCompleted: {
             }
         }
     }

    //Строка - Вес МИН
    Row {
         id: rowColumnPatientFindWeightMin
//         parent: rowPatient
         width: parent.width
         height: heightControl

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindHeightMax.bottom
             anchors.topMargin = parent.spacing
         }

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindWeightMin, rowColumnPatientFindWeightMin, rowColumnPatientFindWeightMax)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindWeightMin)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindWeightMin, rowColumnPatientFindWeightMin, rowColumnPatientFindWeightMax)
                 }
             }
         }

         Text {
             id: textRowPatientFindWeightMinDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Вес минимум"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindWeightMin
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
//                 var min = 39, max = 139
//                 return min + "-" + max
                 return paramPatientFindWeightMin.val
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }

             Component.onCompleted: {
             }
         }
     }
    //Строка - Вес МАКС
    Row {
         id: rowColumnPatientFindWeightMax
//         parent: rowPatient
         width: parent.width
         height: heightControl

         Component.onCompleted: {
             anchors.top = rowColumnPatientFindWeightMin.bottom
             anchors.topMargin = parent.spacing
         }

         function magnifier () {
             if (rectanglePopupPatientFind.object === undefined)
                 parent.magnifier (paramPatientFindWeightMax, rowColumnPatientFindWeightMax, undefined)
             else {
                 if (rectanglePopupPatientFind.object === paramPatientFindWeightMax)
                     rectanglePopupPatientFind.visible = false
                 else{
                     rectanglePopupPatientFind.visible = false
                     parent.magnifier (paramPatientFindWeightMax, rowColumnPatientFindWeightMax, undefined)
                 }
             }
         }

         Text {
             id: textRowPatientFindWeightMaxDescription

             y: parent.height / 2 - height / 2
             width: parent.width * 4 * coeffWidthControl

             text: " Вес максиимум"
             font {
                 pixelSize: Math.round (widthManagmentArea * 0.08)
             }
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: "AlignLeft"

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }
         }

         TextField {
             id: textFieldSliderPatientFindWeightMax
             width: parent.width * 2 * coeffWidthControl
             height: heightControl
             readOnly: true

             text: {
//                 var min = 39, max = 139
//                 return min + "-" + max
                 return paramPatientFindWeightMax.val
             }
             font {
                 pixelSize: Math.round (height * ratioHeightTextField)
             }
             horizontalalignment: TextInput.AlignHCenter

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     parent.parent.magnifier ()
                 }
             }

             Component.onCompleted: {
             }
         }
     }

    HPopupWindow {
        id: rectanglePopupPatientFind
        visible: false
    }
}

