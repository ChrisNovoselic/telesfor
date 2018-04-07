//slidermanage.js - вспомогательные функции для управления элементами интерфейса 'slider'

function textFieldText (val) {
    var retVal
    if (val < Math.pow (10, -3))
        val = 0;

//    console.debug (val)
    if (val.toString ().length > 3) {
//            console.log (val.toFixed (2))
        retVal = parseFloat(val).toFixed (2)
    }
    else
        retVal = val

//    console.debug (retVal)
    return retVal
}

//ВозвраТ НЕ АВТОматизиРОВАНных СЛАЙДЕРов
//Скорость дорожки (HColumnTreadmill.qml)
//function sliderTrackSpeed () {

//}

////Длина шага (HColumnTraining.qml)
//function sliderStepsLength () {

//}

//Возвращает ИМя обЪекта управления
function getNameActiveObject () {
    var nameActiveObject = "", btnActive = btnTrace1

//        console.log (btnCenterPSC.checked, btnLine1.checked, btnLine2.checked, btnTrace1.checked, btnTrace2.checked)

    if (btnCenterPSC.checked)
        btnActive = btnCenterPSC
    else
        if (btnLine1.checked)
            btnActive = btnLine1
        else
            if (btnLine2.checked)
                btnActive = btnLine2
            else
                if (btnTrace1.checked)
                    btnActive = btnTrace1
                else
                    if (btnTrace2.checked)
                        btnActive = btnTrace2
                    else
                        if (btnGamma.checked)
                            btnActive = btnGamma
                        else
                            if (btnLattice.checked) {
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

//    console.debug (nameActiveObject)
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

//Отсылает СИГНАЛ на сторону 'C++' чтобы получить в ОТВЕТ инициализирующие данные
function recoverySliderValueObject () {
    var nameActiveObject = getNameActiveObject (), nameItemManagement = getNameActiveItemManagement ()
//        console.log (nameActiveObject, nameItemManagement)
    if ((! (nameActiveObject === "")) && (! (nameItemManagement === "")))
        sgnRecoverySliderValueObject (nameActiveObject, nameItemManagement)
}

//Вызывается при ДЕактивации 'slider' - инициализируется значением по умолчанию
function sliderNonValue (sliderX, sliderY, sliderZ) {
    sliderX.minimumValue = -1
    sliderX.maximumValue = 1
    sliderX.stepSize = 0.5
    sliderX.value = 0

    sliderY.minimumValue = -1
    sliderY.maximumValue = 1
    sliderY.stepSize = 0.5
    sliderY.value = 0

    sliderZ.minimumValue = -1
    sliderZ.maximumValue = 1
    sliderZ.stepSize = 0.5
    sliderZ.value = 0

//        console.log ("sliderNonValue...")
}
