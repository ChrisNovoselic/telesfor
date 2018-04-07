//var arTraceObjectReality = Array.constructor
//var arObjectReality = new Array ()

//var TYPE_OBJECTREALITY = { "TRACE": 0,
//                           "LINE": 1,
//                           "POLE": 2
//}

//var TYPE_ITEMMANAGEMENT = { "position": 0,
//                           "rotation": 1,
//                           "size": 2
//}

//function getCheckBoxTrace1Value () {
//    return checkBoxTrace1.checked
//}

//function getCountObjectReality (name) {
//    var i, cnt = 0, obj
//    if (! (name === undefined)) {
//        for (i = 0; i < arObjectReality.length; i ++) {
//            obj = arObjectReality [i]
//            if (obj.objectName.indexOf (name) > -1) {
//                cnt ++
////                Отладка
////                console.debug (cnt, " - ", obj.objectName)
//            }
//        }
//    }
//    else
//        if (arObjectReality.length === 0)
//            cnt = -1
//        else
//            cnt = arObjectReality.length

//    return cnt
//}

//function getObjectReality (prefix, num) {
//    console.debug ("::getObjectReality (): arObjectReality.length =", arObjectReality.length)
//    console.debug ("::getObjectReality", prefix, num)
//    var i, obj
//    for (i = 0; i < arObjectReality.length; i ++) {
//        obj = arObjectReality [i]
//        console.debug ("::getObjectReality (): objectName [", i, "] =", obj.objectName)
//        if (obj.objectName.indexOf (prefix) > -1) {
//            console.debug ("getObjectReality num=", obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length))
//            if (num === undefined) {
//                if (obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length).length === 0) {
//                    console.debug ("getObjectReality obj=", obj)
//                    return obj
//                }
//                else
//                    ;
//            }
//            else {
//                if (obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length) === num.toString ()) {
//                    console.debug ("getObjectReality obj=", obj)
//                    return obj
//                }
//                else
//                    ;
//            }
//        }
//        else
//            ;
//    }

//    console.debug ("objectReality.js::getObjectReality = null")

//    return null
//}

//function getNumTraceOfMinPosition () {
//    var axisDirection = "X", itemManagement = "position", prefixName = "Trace", obj
//    , i, minValue, iRes = 1, countTrace = getCountObjectReality (prefixName)
//    for (i = 1; i <= countTrace; i ++) {
//        obj = prefixName + i

//        if (i > 1)
//            if (minValue > m_synchCoordinates.getValue (obj, itemManagement, axisDirection)) {
//                minValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
//                iRes = i
//            }
//            else
//                ;
//        else
//            minValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
//    }

//    return iRes
//}

//function getNumTraceOfMaxPosition () {
//    var axisDirection = "X", itemManagement = "position", prefixName = "Trace", obj
//    , i, maxValue, iRes = 1, countTrace = getCountObjectReality (prefixName)
//    for (i = 1; i <= countTrace; i ++) {
//        obj = prefixName + i

//        if (i > 1)
//            if (maxValue < m_synchCoordinates.getValue (obj, itemManagement, axisDirection)) {
//                maxValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
//                iRes = i
//            }
//            else
//                ;
//        else
//            maxValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
//    }

//    return iRes
//}

//function setTracesPlacement () {
//    var axisDirection = "X", itemManagement = "position", objTrace, objPole
//    var i
////        , indexMinValue = 1, posMinValue
//        , indexMaxValue = 1, posMaxValue
//        , countOfTrace = ScriptTimerSpeed.countOfTrace ()
////                    , ar = Array.constructor
//    console.debug ("::setTracesPlacement: count_of_trace =", countOfTrace)

////    indexMinValue = getNumTraceOfMinPosition ()
////    posMinValue = getObjectReality ("Trace", indexMinValue).placements [0].sliders [0].sliderValue

//    indexMaxValue = getNumTraceOfMaxPosition ()
////    posMaxValue = descObjectsReality.getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue
//    posMaxValue = getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue

////    console.log ("Мин. знач.=", posMinValue, " следа с номером=", indexMinValue)
//    console.log ("Макс. знач.=", posMaxValue, " следа с номером=", indexMaxValue)

////    obj = "Trace" + (indexMinValue).toString ()
////    console.log (obj, axisDirection, "=", posMinValue)
////    console.log (obj, axisDirection, "=", m_synchCoordinates.getValue (obj, itemManagement, axisDirection))

//    for (i = 1; i < countOfTrace; i ++) {
//        indexMaxValue ++
//        if (indexMaxValue > countOfTrace)
//            indexMaxValue = 1

//        objTrace = "Trace" + (indexMaxValue).toString ()
//        objPole = "Pole" + indexMaxValue

////        if (posMinValue + i * sliderStepsLength < direction_track * count_of_trace * sliderStepsLength + begin_position_trace) {
////            console.debug ("objectReality::setTracesPlacement-Выход за пределы!")

//        m_synchCoordinates.initValue (objTrace, itemManagement, axisDirection, posMaxValue + i * direction_track * paramStepsLength.val)
//        console.log (objTrace, axisDirection, "=", m_synchCoordinates.getValue (objTrace, itemManagement, axisDirection))

//        m_synchCoordinates.initValue (objPole, itemManagement, axisDirection, posMaxValue + i * direction_track * paramStepsLength.val)
////        console.log (objPole, axisDirection, "=", m_synchCoordinates.getValue (objPole, itemManagement, axisDirection))
////        }
////        else
////            ;
//    }
//}

function createObjectsReality () {
    var i, trace, pole
//    , ar = new Array ()
    console.debug ("Количество следов", m_synchCoordinates.count_of_trace)
    for (i = 3; i <= m_synchCoordinates.count_of_trace; i ++) {
        trace = createObjectReality (i, TYPE_OBJECTREALITY.TRACE)
//        sgnSetPlacementsMovable (trace.objectName) Нет смысла СВЯЗывания СИГналов ещЁ не произошЛо
        pole = createObjectReality (i, TYPE_OBJECTREALITY.POLE)
//        sgnSetPlacementsMovable (pole.objectName)  Нет смысла СВЯЗывания СИГналов ещЁ не произошЛо
    }
}

function createObjectReality (num, type) {
    var src = "objectReality.qml"
    var obj = Qt.createComponent (src)

    if (obj.status === Component.Ready) {
//        obj = obj.createObject (rectangleForm, {})
        obj = obj.createObject (descObjectsReality, {})
        if (obj === null)
            // Error Handling
            console.debug ("Ошибка создания 'objectReality'")
        else {
//            traceOnCompleted (obj, num, type)

            var prefixName
            switch (type) {
                case TYPE_OBJECTREALITY.TRACE:
                    prefixName = "Trace"
                    break
//                case TYPE_OBJECTREALITY.LINE:
//                    prefixName = "Line"
//                    break
                case TYPE_OBJECTREALITY.POLE:
                    prefixName = "Pole"
                    break
                default:
            }

            obj.objectName = prefixName + num
            console.debug  (obj.objectName)

//            if (num % 2 === 1)
//                obj.opacity = trace1.opacity
//            else
//                obj.opacity = trace2.opacity

            switch (num) {
               case 2:
                   obj.sourceEntity = "VertexItemBlue.mesh"
                   break
               default:
                   obj.sourceEntity = "Cube.mesh"
            }
        }
    }
    else {
        console.log ("Ошибка загрузки 'objectReality':", obj.errorString ())
    }

    return obj
 }

//function getObjectRealityPlacement (num, itemManagement, type) {
//function getObjectRealityPlacement (num, itemManagement, type) {
//    var vec3DRes = Qt.vector3d.constructor

//    console.log ("::getObjectRealityPlacement ", num, ":", itemManagement, ":", type)

//    switch (itemManagement) {
//        case TYPE_ITEMMANAGEMENT.position: //position
//            switch (type) {
//                case TYPE_OBJECTREALITY.TRACE:
////                    vec3DRes = getPositionTrace (num, num % 2)
//                    vec3DRes = getPositionTrace (num, 0)
//                    break
//                case TYPE_OBJECTREALITY.POLE:
////                    vec3DRes = getPositionPole (num, num % 2)
//                    vec3DRes = getPositionPole (num, 0)
//                    break
//                default:
//                    ;
//            }
//            break
//        case TYPE_ITEMMANAGEMENT.rotation: //rotation
//            vec3DRes = getRotation ()
//            break
//        case TYPE_ITEMMANAGEMENT.size: //size
//            switch (type) {
//                case TYPE_OBJECTREALITY.TRACE:
//                    vec3DRes = getSizeTrace ()
//                    break
//                case TYPE_OBJECTREALITY.POLE:
//                    vec3DRes = getSizePole ()
//                    break
//                default:
//                    ;
//            }
//            break
//        default:
//    }

////    console.debug ("::getObjectRealityPlacement RETURN=", vec3DRes)

//    return vec3DRes
//}

//function getPositionTrace (num, numRow) {
//    var vec3DRes = Qt.vector3d.constructor

//    vec3DRes.x = begin_position_trace + direction_track * (num - 1) * paramStepsLength.val
////    vec3DRes.x = begin_position_trace + getObjectReality ("Trace", num - 1).placements [0].sliders [0].sliderValue + direction_track * sliderStepsLength

////    vec3DRes.y = m_synchCoordinates.szMarkerPSC / 2
//    vec3DRes.y = 0
////    vec3DRes.y = -m_synchCoordinates.szMarkerPSC / 2

//    vec3DRes.z = numRow * sliderStepsWidth + m_synchCoordinates.szMarkerPSC / 2

//    console.debug ("::getPositionTrace (", num, ") RETURN = {", vec3DRes.x, vec3DRes.y, vec3DRes.z, "}")

//    return vec3DRes
//}

//function getPositionLine () {
//    return Qt.vector3d (0.0, 0.0, 0.0)
//}

//function getPositionPole (num, numRow) {
//    var vec3D = getPositionTrace (num, numRow)
////    Половина ширинЫ следа
//    vec3D.z -= 0.02754 / 2

////    Четверть ШИРИНы следА ???
//    vec3D.z -= 0.02754 / 4

//    return vec3D
//}

//function getRotation () {
//    return Qt.vector3d (0.0, 0.0, 0.0)
//}

//function getSizeTrace () {
//    return Qt.vector3d (3.0, 0.1, 1.0)
//}

//function getSizePole () {
//    return Qt.vector3d (0.2, 2.0, 0.2)
//}



//function traceOnCompleted (obj, num, type) {
//function traceOnCompleted (obj, num, type) {
//        console.debug (JSON.stringify (obj))

//    var i, vec3D = Qt.vector3d.constructor

////        var arPlacement = Array.constructor
////        for (i = 0; i < 3; i ++) {
////            arPlacement [i] = Qt.vector3d.constructor
////            arPlacement [i] = getObjectRealityPlacement (num, i)
////        }

//    for (i = 0; i < 3; i ++) {
////        vec3D = getObjectRealityPlacement (num, i, type)
//        vec3D = getObjectRealityPlacement (num, i, type)
////            console.log (JSON.stringify (arPlacement [i]))
////            console.log (vec3D)

//        obj.placements [i].sliders [0].sliderValue = vec3D.x
//        obj.placements [i].sliders [1].sliderValue = vec3D.y
//        obj.placements [i].sliders [2].sliderValue = vec3D.z
//    }

////        console.debug (num, trace1, trace2)
////        console.debug ("trace1", trace1.placements [0].sliders [0].minValue, trace1.placements [0].sliders [0].maxValue)
////        console.debug ("trace2", trace2.placements [0].sliders [0].minValue, trace2.placements [0].sliders [0].maxValue)

////        console.debug (num, obj.objectName)
//    switch (obj.objectName) {
//        case "Trace1":
//            //Ось "X"
////                console.debug ("sliderStepsWidth=", sliderStepsWidth.minimumValue, sliderStepsWidth.maximumValue)

////                obj.placements [0].sliders [0].minValue = trace2.placements [0].sliders [0].sliderValue + sliderStepsWidth.maximumValue
////                obj.placements [0].sliders [0].maxValue = trace2.placements [0].sliders [0].sliderValue + sliderStepsWidth.minimumValue

////            console.debug ("Trace2=", trace2.placements [0].sliders [0].sliderValue, trace2.placements [0].sliders [0].minValue, trace2.placements [0].sliders [0].maxValue)
////            console.debug ("Trace1=", obj.placements [0].sliders [0].sliderValue, obj.placements [0].sliders [0].minValue, obj.placements [0].sliders [0].maxValue)

//            //Ось "Z"
////                obj.placements [0].sliders [2].minValue = -1.0
////                obj.placements [0].sliders [2].maxValue = 1.0
//            break
//        case "Trace2":
//            //Ось "X"
////                obj.placements [0].sliders [0].minValue = trace1.placements [0].sliders [0].sliderValue + sliderStepsWidth.maximumValue
////                obj.placements [0].sliders [0].maxValue = trace1.placements [0].sliders [0].sliderValue + sliderStepsWidth.minimumValue

//            //Ось "Z"
////                obj.placements [0].sliders [2].minValue = -1.0
////                obj.placements [0].sliders [2].maxValue = 1.0
//            break
//        default:
//    }

////    arTraceObjectReality.push (obj)
//}


//function translateObjectReality (obj, vec3DCoordinates) {

//}

//function rotateObjectReality (obj, vec3DAngle) {
//        console.log (obj.transform, vec3DAngle.x, vec3DAngle.y, vec3DAngle.z)

//        if (! (obj.transform [0] === undefined))
//            obj.transform [0].angle = vec3DAngle.x
//        if (! (obj.transform [1] === undefined))
//            obj.transform [1].angle = vec3DAngle.y
//        if (! (obj.transform [2] === undefined))
//            obj.transform [2].angle = vec3DAngle.z
//}

//function scaleObjectReality (obj, vec3DCoeff) {

//}

//function replacementObjectReality () {
//    console.debug ("Qml::replacementObjectReality")
//    var nameActiveObject = columnManagementObjectReality.getNameActiveObject (), nameActiveItemManagement = columnManagementObjectReality.getNameActiveItemManagement ()
//    console.debug ("nameActiveObject=", nameActiveObject, ", nameActiveItemManagement=", nameActiveItemManagement)
//    if ((! (nameActiveObject === "")) && (! (nameActiveItemManagement === ""))) {
//        sgnReplacmentObject (nameActiveObject, nameActiveItemManagement)

////        var objTo, objOf, multCoeff

//        if (! (nameActiveObject.indexOf ("Trace") === -1)) { //только для 'Trace'
//            switch (nameActiveItemManagement) {
//                case "position":
//                    break;
//                case "rotation":
//                    break;
//                case "size":
//                    break;
//                default:
//                    ;
//            }
//        }
//        else
//            ; //Не 'Trace' ...
//    }
//    else
//        ; //Не известнЫЙ обЪект ИЛИ элемент управления обЪектОМ
//}

//function refit () {
//    if (m_synchCoordinates) {
//        //ОТЛАДКа
//        console.debug ("Количество objectReality (В НАЛИЧИИ) Qml: ", getCountObjectReality (), " ; C++:", m_synchCoordinates.getCountObjectReality ())

//        m_synchCoordinates.count_of_trace = ScriptTimerSpeed.countOfTrace ()

//        //Удалить ЛИШНие (создать необходимые)
//        var i, obj, name, prefixName = "Trace",
//                countOfTrace = m_synchCoordinates.getCountObjectReality (prefixName),
//                propertyCountOfTrace = ScriptTimerSpeed.countOfTrace ()
////        countOfTrace = getCountObjectReality (prefixName)
//        console.debug ("propertyCountOfTrace = ", propertyCountOfTrace,
//                       "; Количество следов (В НАЛИЧИИ) Qml: ", getCountObjectReality (prefixName),
//                       " ; C++:", countOfTrace)

//        var indexMaxValue, posMaxValue, numLeadingTrace

////        indexMinValue = getNumTraceOfMinPosition ()
////        console.debug ("indexMinValue=", indexMinValue)
////        posMinValue = getObjectReality ("Trace", indexMinValue).placements [0].sliders [0].sliderValue
////        console.debug ("posMinValue=", posMinValue)

//        indexMaxValue = getNumTraceOfMaxPosition ()
//        console.debug ("indexMaxValue=", indexMaxValue)

////        if (descObjectsReality.getObjectReality ("Trace", indexMaxValue)) {
//        if (getObjectReality ("Trace", indexMaxValue)) {
////            posMaxValue = descObjectsReality.getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue
//            posMaxValue = getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue
//            console.debug ("posMaxValue=", posMaxValue)
//        }
//        else
//            ;

//        console.debug ("Количество следов: ", propertyCountOfTrace)

//        numLeadingTrace = indexMaxValue

//        if (countOfTrace > -1) {
//            if (! (propertyCountOfTrace === countOfTrace)) {
//                m_synchCoordinates.initValue (prefixName + indexMaxValue, "position", "X", begin_position_trace)
//                m_synchCoordinates.initValue ("Pole" + indexMaxValue, "position", "X", begin_position_trace)

//                if (propertyCountOfTrace > countOfTrace) {
//                    //Создать необходимые
//                    console.debug ("Создать необходимые: ", propertyCountOfTrace - getCountObjectReality (prefixName))
//                    for (i = countOfTrace; i < propertyCountOfTrace; i ++) {
//                        obj = createObjectReality (i + 1, TYPE_OBJECTREALITY.TRACE)
//                        console.debug ("objectReality.create with №", i + 1)
//                        arObjectReality.push (obj)

//                        console.debug ("m_synchCoordinates.insertObjectReality", obj.objectName, arObjectReality [arObjectReality.length - 1])
//                        m_synchCoordinates.insertObjectReality (obj.objectName, arObjectReality [arObjectReality.length - 1]);
////                        m_synchCoordinates.insertObjectReality (obj.objectName, obj);

////                        Добавляем КОЛы
//                        obj = createObjectReality (i + 1, TYPE_OBJECTREALITY.POLE)
//                        arObjectReality.push (obj)
//                        m_synchCoordinates.insertObjectReality (obj.objectName, arObjectReality [arObjectReality.length - 1]);

////                        console.debug (obj.placements [0].sliders [0].sliderValue)
////                        console.debug (getObjectReality (prefixName, i))
////                        obj.placements [0].sliders [0].sliderValue = getObjectReality (prefixName, i).placements [0].sliders [0].sliderValue - direction_track * sliderStepsLength.value
//                    }

//                    console.debug ("Количество следов (В НАЛИЧИИ) Qml: ", getCountObjectReality (prefixName), "; C++: ", m_synchCoordinates.getCountObjectReality (prefixName))
//                }
//                else {
//                    //Удалить ЛИШНие
//                    console.debug ("Удалить ЛИШНие: ", getCountObjectReality (prefixName) - propertyCountOfTrace)
//                    //Перед удалениеим ПРОВЕРить - не потеряем ли позицию следа
//                    if (indexMaxValue > propertyCountOfTrace) {
//                        //С удаление следа - ПОТЕРяем ЕГо ПОЗицию
//                        if (indexMaxValue % 2 === 1) {
//                            console.debug ("Потеря позиции: ", indexMaxValue, "НЕ чЁтный")
//                            numLeadingTrace = 1
//                        }
//                        else {
//                            console.debug ("Потеря позиции: ", indexMaxValue, "чЁтный")
//                            numLeadingTrace = propertyCountOfTrace
//                        }

//                        console.debug ("Назначили numLeadingTrace=", numLeadingTrace)
//                    }
//                    else
//                        ; //НиЧЕГо не делаем - ПОТЕРь позиции СЛЕДа НЕТ

//                    for (i = 0; i < arObjectReality.length; i ++) {
//                        name = arObjectReality [i].objectName
//                        prefixName = "Trace"
//                        if (name.indexOf (prefixName) > -1) {
//                            console.debug (name.substr (prefixName.length, name.length - prefixName.length))
//                            if (name.substr (prefixName.length, name.length - prefixName.length) > propertyCountOfTrace) {
//                                console.debug ("Удаляем: ", arObjectReality [i].objectName)
//                                m_synchCoordinates.deleteObjectReality (arObjectReality [i].objectName, arObjectReality [i]);
//                                obj = arObjectReality.splice (i, 1)
//                                console.debug ("УдалЁН: ", obj)

//                                i --
//                            }
//                            else
//                                ;
//                        }
//                        else
//                            ;

//                        prefixName = "Pole"
//                        if (name.indexOf (prefixName) > -1) {
//                            console.debug (name.substr (prefixName.length, name.length - prefixName.length))
//                            if (name.substr (prefixName.length, name.length - prefixName.length) > propertyCountOfTrace) {
//                                console.debug ("Удаляем: ", arObjectReality [i].objectName)
//                                m_synchCoordinates.deleteObjectReality (arObjectReality [i].objectName, arObjectReality [i]);
//                                obj = arObjectReality.splice (i, 1)
//                                console.debug ("УдалЁН: ", obj)

//                                i --
//                            }
//                            else
//                                ;
//                        }
//                        else
//                            ;
//                    }
//                    console.debug ("Количество следов (В НАЛИЧИИ) Qml: ", getCountObjectReality ("Trace"), "; C++: ", m_synchCoordinates.getCountObjectReality (prefixName))
//                }
//            }
//            else {
//            }

////            m_synchCoordinates.initValue (prefixName + 1, "position", "X", posMinValue)
//            m_synchCoordinates.initValue (prefixName + numLeadingTrace, "position", "X", begin_position_trace)
////            m_synchCoordinates.initValue ("Pole" + 1, "position", "X", posMinValue)
//            m_synchCoordinates.initValue ("Pole" + numLeadingTrace, "position", "X", begin_position_trace)

//            console.debug ("Переместили след в НАЧАЛо с ном.=", numLeadingTrace)

//            setTracesPlacement ()
//        }
//        else {

//        }
//    }
//    else {
//        console.debug ("sliderStepsLength::onValueChanged", "m_synchCoordinates not initialized")
//    }
//}

function setPlacementsData (obj, placementsJSON) {
    var i, j, k,
        arNameItemManagement = ["position", "rotation", "size"],
        arNameAxis = ["X", "Y", "Z"],
        arNameParametr = ["slider", "min", "max", "step"],
        val

    for (i = 0; i < arNameItemManagement.length; i ++) {
        for (j = 0; j < arNameAxis.length; j ++) {
            for (k = 0; k < arNameParametr.length; k ++) {
                val = placementsJSON [arNameItemManagement [i]] ['axis' + arNameAxis [j]] [arNameParametr [k] + 'Value']

                switch (k) {
                    case 0:
                        obj.placements [i].sliders [j].sliderValue = val
                        break
                    case 1:
                        obj.placements [i].sliders [j].minValue = val
                        break
                    case 2:
                        obj.placements [i].sliders [j].maxValue = val
                        break
                    case 3:
                        obj.placements [i].sliders [j].stepValue = val
                        break
                    default:
                        ;
                }
            }
        }
    }
}

function makeUpdatePlacementsData (obj) {
    var placementsData, i, j, k,
        arNameItemManagement = ["position", "rotation", "size"],
        arNameAxis = ["X", "Y", "Z"],
        arNameParametr = ["slider", "min", "max", "step"]

    placementsData = '{"' + obj.objectName + '":{'
    for (i = 0; i < arNameItemManagement.length; i ++) {
        placementsData += '"'

        placementsData += arNameItemManagement [i] + '":{"'

        for (j = 0; j < arNameAxis.length; j ++) {
            placementsData += 'axis' + arNameAxis [j]

            placementsData += '":{"'

            for (k = 0; k < arNameParametr.length; k ++) {
                placementsData += arNameParametr [k] + 'Value' + '":"'

                switch (k) {
                    case 0:
                        placementsData += obj.placements [i].sliders [j].sliderValue
                        break
                    case 1:
                        placementsData += obj.placements [i].sliders [j].minValue
                        break
                    case 2:
                        placementsData += obj.placements [i].sliders [j].maxValue
                        break
                    case 3:
                        placementsData += obj.placements [i].sliders [j].stepValue
                        break
                    default:
                        ;
                }

                placementsData += '"'

                if (k + 1 < arNameParametr.length)
                    placementsData += ',"'
                else
                    ;
            }

            placementsData += '}'

            if (j + 1 < arNameAxis.length)
                placementsData += ',"'
            else
                ;
        }

        placementsData += '}'

        if (i + 1 < 3)
            placementsData += ','
        else
            ;
    }

    placementsData += '}}'

    console.debug (obj.objectName, ".onCompleted =", placementsData)

    return placementsData
}
