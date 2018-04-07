//slidermanage.js - вспомогательные функции для управления элементами интерфейса 'slider'

function textFieldText (val) {
    var retVal
    if (val < Math.pow (10, -3))
        val = 0
    else
        ;

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
