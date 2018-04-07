//var arTraceObjectReality = Array.constructor
var arObjectReality = new Array ()

var TYPE_OBJECTREALITY = { "TRACE": 0,
                           "LINE": 1,
                           "POLE": 2
}

var TYPE_ITEMMANAGEMENT = { "position": 0,
                           "rotation": 1,
                           "size": 2
}

function getCheckBoxTrace1Value () {
    return checkBoxTrace1.checked
}

function enabledRowReplacement () {
    return btnCenterPSC.checked || btnLine1.checked || btnLine2.checked || btnTrace1.checked || btnTrace2.checked || btnGamma.checked || btnLattice.checked
}

function getCountObjectReality (name) {
    var i, cnt = 0, obj
    if (! (name === undefined)) {
        for (i = 0; i < arObjectReality.length; i ++) {
            obj = arObjectReality [i]
            if (obj.objectName.indexOf (name) > -1) {
                cnt ++
//                Отладка
//                console.debug (cnt, " - ", obj.objectName)
            }
        }
    }
    else
        if (arObjectReality.length === 0)
            cnt = -1
        else
            cnt = arObjectReality.length

    return cnt
}

function getObjectReality (prefix, num) {
    console.debug ("getObjectReality", prefix, num)
    var i, obj
    for (i = 0; i < arObjectReality.length; i ++) {
        obj = arObjectReality [i]
        if (obj.objectName.indexOf (prefix) > -1) {
//            console.debug ("getObjectReality num=", obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length))
            if (obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length) === num.toString ()) {
//                console.debug ("getObjectReality obj=", obj)
                return obj
            }
            else
                ;
        }
        else
            ;
    }

    console.debug ("objectReality.js::getObjectReality = null")
    return null
}

function getNumTraceOfMinPosition () {
    var axisDirection = "X", itemManagement = "position", prefixName = "Trace", obj
    , i, minValue, iRes = 1, countTrace = getCountObjectReality (prefixName)
    for (i = 1; i <= countTrace; i ++) {
        obj = prefixName + i

        if (i > 1)
            if (minValue > m_synchCoordinates.getValue (obj, itemManagement, axisDirection)) {
                minValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
                iRes = i
            }
            else
                ;
        else
            minValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
    }

    return iRes
}

function getNumTraceOfMaxPosition () {
    var axisDirection = "X", itemManagement = "position", prefixName = "Trace", obj
    , i, maxValue, iRes = 1, countTrace = getCountObjectReality (prefixName)
    for (i = 1; i <= countTrace; i ++) {
        obj = prefixName + i

        if (i > 1)
            if (maxValue < m_synchCoordinates.getValue (obj, itemManagement, axisDirection)) {
                maxValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
                iRes = i
            }
            else
                ;
        else
            maxValue = m_synchCoordinates.getValue (obj, itemManagement, axisDirection)
    }

    return iRes
}

function setTracesPlacement () {
    var axisDirection = "X", itemManagement = "position", objTrace, objPole
    var i
//        , indexMinValue = 1, posMinValue
        , indexMaxValue = 1, posMaxValue
        , countOfTrace = ScriptTimerSpeed.countOfTrace ()
//                    , ar = Array.constructor
    console.debug ("::setTracesPlacement: count_of_trace=", countOfTrace)

//    indexMinValue = getNumTraceOfMinPosition ()
//    posMinValue = getObjectReality ("Trace", indexMinValue).placements [0].sliders [0].sliderValue

    indexMaxValue = getNumTraceOfMaxPosition ()
    posMaxValue = getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue

//    console.log ("Мин. знач.=", posMinValue, " следа с номером=", indexMinValue)
    console.log ("Макс. знач.=", posMaxValue, " следа с номером=", indexMaxValue)

//    obj = "Trace" + (indexMinValue).toString ()
//    console.log (obj, axisDirection, "=", posMinValue)
//    console.log (obj, axisDirection, "=", m_synchCoordinates.getValue (obj, itemManagement, axisDirection))

    for (i = 1; i < countOfTrace; i ++) {
        indexMaxValue ++
        if (indexMaxValue > countOfTrace)
            indexMaxValue = 1

        objTrace = "Trace" + (indexMaxValue).toString ()
        objPole = "Pole" + indexMaxValue

//        if (posMinValue + i * sliderStepsLength < direction_track * count_of_trace * sliderStepsLength + begin_position_trace) {
//            console.debug ("objectReality::setTracesPlacement-Выход за пределы!")

        m_synchCoordinates.initValue (objTrace, itemManagement, axisDirection, posMaxValue + i * direction_track * sliderStepsLength)
        console.log (objTrace, axisDirection, "=", m_synchCoordinates.getValue (objTrace, itemManagement, axisDirection))

        m_synchCoordinates.initValue (objPole, itemManagement, axisDirection, posMaxValue + i * direction_track * sliderStepsLength)
//        console.log (objPole, axisDirection, "=", m_synchCoordinates.getValue (objPole, itemManagement, axisDirection))
//        }
//        else
//            ;
    }
}

function createObjectReality (num, type) {
    var src = "objectReality.qml"
    var obj = Qt.createComponent (src)

    if (obj.status === Component.Ready) {
        obj = obj.createObject (rectangleForm, {})
        if (obj === null)
            // Error Handling
            console.debug ("Ошибка создания 'objectReality'")
        else {
            traceOnCompleted (obj, num, type)

            var prefixName
            switch (type) {
                case TYPE_OBJECTREALITY.TRACE:
                    prefixName = "Trace"
                    break
                case TYPE_OBJECTREALITY.LINE:
                    prefixName = "Line"
                    break
                case TYPE_OBJECTREALITY.POLE:
                    prefixName = "Pole"
                    break
                default:
            }

            obj.objectName = prefixName + num
            console.debug  (obj.objectName)

            obj.opacity = 0.8

//            if (num % 2 === 1)
//               obj.visible = checkBoxTrace1.checked
//            else
//                obj.visible = checkBoxTrace2.checked

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

    return obj;
 }

//function getObjectRealityPlacement (num, itemManagement, type) {
function getObjectRealityPlacement (num, itemManagement, type) {
    var vec3DRes = Qt.vector3d.constructor

    console.log ("::getObjectRealityPlacement ", num, ":", itemManagement, ":", type)

    switch (itemManagement) {
        case TYPE_ITEMMANAGEMENT.position: //position
            switch (type) {
                case TYPE_OBJECTREALITY.TRACE:
//                    vec3DRes = getPositionTrace (num, num % 2)
                    vec3DRes = getPositionTrace (num, 0)
                    break
                case TYPE_OBJECTREALITY.POLE:
//                    vec3DRes = getPositionPole (num, num % 2)
                    vec3DRes = getPositionPole (num, 0)
                    break
                default:
                    ;
            }
            break
        case TYPE_ITEMMANAGEMENT.rotation: //rotation
            vec3DRes = getRotation ()
            break
        case TYPE_ITEMMANAGEMENT.size: //size
            switch (type) {
                case TYPE_OBJECTREALITY.TRACE:
                    vec3DRes = getSizeTrace ()
                    break
                case TYPE_OBJECTREALITY.POLE:
                    vec3DRes = getSizePole ()
                    break
                default:
                    ;
            }
            break
        default:
    }

//    console.debug ("::getObjectRealityPlacement RETURN=", vec3DRes)

    return vec3DRes
}

function getPositionTrace (num, numRow) {
    var vec3DRes = Qt.vector3d.constructor

    vec3DRes.x = begin_position_trace + direction_track * (num - 1) * sliderStepsLength
//    vec3DRes.x = begin_position_trace + getObjectReality ("Trace", num - 1).placements [0].sliders [0].sliderValue + direction_track * sliderStepsLength

    vec3DRes.y = m_synchCoordinates.szMarkerPSC / 2
//    vec3DRes.y = 0
//    vec3DRes.y = -m_synchCoordinates.getMarkerSize () / 2

    vec3DRes.z = -offset_of_edge - numRow * sliderStepsWidth

    console.debug ("::getPositionTrace (", num, ") RETURN = {", vec3DRes.x, vec3DRes.y, vec3DRes.z, "}")

    return vec3DRes
}

function getPositionLine () {
    return Qt.vector3d (0.0, 0.0, 0.0)
}

function getPositionPole (num, numRow) {
    var vec3D = getPositionTrace (num, numRow)
//    Половина ширинЫ следа
      vec3D.z -= 0.02754 / 2
    return vec3D
}

function getRotation () {
    return Qt.vector3d (0.0, 0.0, 0.0)
}

function getSizeTrace () {
    return Qt.vector3d (3.0, 0.1, 1.0)
}

function getSizePole () {
    return Qt.vector3d (0.2, 2.0, 0.2)
}



//function traceOnCompleted (obj, num, type) {
function traceOnCompleted (obj, num, type) {
        console.debug (JSON.stringify (obj))

    var i, vec3D = Qt.vector3d.constructor

//        var arPlacement = Array.constructor
//        for (i = 0; i < 3; i ++) {
//            arPlacement [i] = Qt.vector3d.constructor
//            arPlacement [i] = getObjectRealityPlacement (num, i)
//        }

    for (i = 0; i < 3; i ++) {
//        vec3D = getObjectRealityPlacement (num, i, type)
        vec3D = getObjectRealityPlacement (num, i, type)
//            console.log (JSON.stringify (arPlacement [i]))
//            console.log (vec3D)

        obj.placements [i].sliders [0].sliderValue = vec3D.x
        obj.placements [i].sliders [1].sliderValue = vec3D.y
        obj.placements [i].sliders [2].sliderValue = vec3D.z
    }

//        console.debug (num, trace1, trace2)
//        console.debug ("trace1", trace1.placements [0].sliders [0].minValue, trace1.placements [0].sliders [0].maxValue)
//        console.debug ("trace2", trace2.placements [0].sliders [0].minValue, trace2.placements [0].sliders [0].maxValue)

//        console.debug (num, obj.objectName)
    switch (obj.objectName) {
        case "Trace1":
            //Ось "X"
//                console.debug ("sliderStepsWidth=", sliderStepsWidth.minimumValue, sliderStepsWidth.maximumValue)

//                obj.placements [0].sliders [0].minValue = trace2.placements [0].sliders [0].sliderValue + sliderStepsWidth.maximumValue
//                obj.placements [0].sliders [0].maxValue = trace2.placements [0].sliders [0].sliderValue + sliderStepsWidth.minimumValue

//            console.debug ("Trace2=", trace2.placements [0].sliders [0].sliderValue, trace2.placements [0].sliders [0].minValue, trace2.placements [0].sliders [0].maxValue)
//            console.debug ("Trace1=", obj.placements [0].sliders [0].sliderValue, obj.placements [0].sliders [0].minValue, obj.placements [0].sliders [0].maxValue)

            //Ось "Z"
//                obj.placements [0].sliders [2].minValue = -1.0
//                obj.placements [0].sliders [2].maxValue = 1.0
            break
        case "Trace2":
            //Ось "X"
//                obj.placements [0].sliders [0].minValue = trace1.placements [0].sliders [0].sliderValue + sliderStepsWidth.maximumValue
//                obj.placements [0].sliders [0].maxValue = trace1.placements [0].sliders [0].sliderValue + sliderStepsWidth.minimumValue

            //Ось "Z"
//                obj.placements [0].sliders [2].minValue = -1.0
//                obj.placements [0].sliders [2].maxValue = 1.0
            break
        default:
    }

//    arTraceObjectReality.push (obj)
}


function translateObjectReality (obj, vec3DCoordinates) {

}

function rotateObjectReality (obj, vec3DAngle) {
//        console.log (obj.transform, vec3DAngle.x, vec3DAngle.y, vec3DAngle.z)

//        if (! (obj.transform [0] === undefined))
//            obj.transform [0].angle = vec3DAngle.x
//        if (! (obj.transform [1] === undefined))
//            obj.transform [1].angle = vec3DAngle.y
//        if (! (obj.transform [2] === undefined))
//            obj.transform [2].angle = vec3DAngle.z
}

function scaleObjectReality (obj, vec3DCoeff) {

}

function replacementObjectReality () {
    console.debug ("Qml::replacementObjectReality")
    var nameActiveObject = ScriptSliderManage.getNameActiveObject (), nameActiveItemManagement = ScriptSliderManage.getNameActiveItemManagement ()
    console.debug ("nameActiveObject=", nameActiveObject, ", nameActiveItemManagement=", nameActiveItemManagement)
    if ((! (nameActiveObject === "")) && (! (nameActiveItemManagement === ""))) {
//            var vecValue = m_synchCoordinates.getValues (nameActiveObject, nameActiveItemManagement)
//            console.debug ("Qml::signal - sgnReplacmentObject")
        sgnReplacmentObject (nameActiveObject, nameActiveItemManagement)

//        var objTo, objOf, multCoeff

        if (! (nameActiveObject.indexOf ("Trace") === -1)) { //только для 'Trace'
            switch (nameActiveItemManagement) {
                case "position":
//                    switch (nameActiveObject) {
//                        case "Trace1":
//                            objOf = trace1
//                            objTo = trace2
//                            break
//                        case "Trace2":
//                            objOf = trace2
//                            objTo = trace1
//                            break
//                        default:
//                    }

//                    sliderStepsLength = Math.abs (objTo.placements [0].sliders [0].sliderValue - objOf.placements [0].sliders [0].sliderValue)
//                    sliderStepsWidth.value = Math.abs (objTo.placements [0].sliders [2].sliderValue - objOf.placements [0].sliders [2].sliderValue)

//                    objTo.placements [0].sliders [0].sliderValue = objOf.placements [0].sliders [0].sliderValue
//                    objTo.placements [0].sliders [1].sliderValue = objOf.placements [0].sliders [1].sliderValue
//                    objTo.placements [0].sliders [2].sliderValue = objOf.placements [0].sliders [2].sliderValue

//                    offset_of_edge = -trace1.placements [0].sliders [2].sliderValue
//                    begin_position_trace = trace1.placements [0].sliders [0].sliderValue

//                    switch (nameActiveObject) {
//                        case "Trace1":
//                            objTo.placements [0].sliders [0].sliderValue = objOf.placements [0].sliders [0].sliderValue + sliderStepsLength
//                            objTo.placements [0].sliders [2].sliderValue = objOf.placements [0].sliders [2].sliderValue - sliderStepsWidth.value
//                            break
//                        case "Trace2":
//                            objTo.placements [0].sliders [0].sliderValue = objOf.placements [0].sliders [0].sliderValue - sliderStepsLength
//                            objTo.placements [0].sliders [2].sliderValue = objOf.placements [0].sliders [2].sliderValue + sliderStepsWidth.value
//                            break
//                        default:
//                    }

//                    var i, nameObject
//                    for (i = 3; i <= count_of_trace; i ++) {
//                        nameObject = "Trace" + i.toString ()
//                        m_synchCoordinates.initValue (nameObject, nameActiveItemManagement, "X", trace1.placements [0].sliders [0].sliderValue + (i - 1) * sliderStepsLength)
//                        m_synchCoordinates.initValue (nameObject, nameActiveItemManagement, "Y", trace1.placements [0].sliders [1].sliderValue)
//                        m_synchCoordinates.initValue (nameObject, nameActiveItemManagement, "Z", trace1.placements [0].sliders [2].sliderValue)
//                        if (i % 2 === 0)
//                            m_synchCoordinates.changeValue (nameObject, nameActiveItemManagement, "Z", -sliderStepsWidth.value)
//                    }

    //                    translateObjectReality (nameActiveObject, vecValue)
                    break;
                case "rotation":
    //                    rotateObjectReality (nameActiveObject, vecValue)
                    break;
                case "size":
    //                    scaleObjectReality (nameActiveObject, vecValue) //y, z
                    break;
                default:
                    ;
            }
        }
        else
            ; //Не 'Trace' ...
    }
}


