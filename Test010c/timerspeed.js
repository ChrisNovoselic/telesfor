function countOfTrace () {
    var i, cnt, cntRequired = Math.round((length_track + 2 * sliderStepsLength + Math.abs (begin_position_trace - begin_position_track)) / sliderStepsLength)
    if (cntRequired % 2 === 1)
        cntRequired ++

    console.debug ("Количество следов (НАДО): ", cntRequired)

    return cntRequired
}

function visibleTrace (num, val) {
    var prefixObectName = "Trace", itemManagement = "position", axisDirection = "X", visible,
        posAxisDirection = m_synchCoordinates.getValue (prefixObectName + num, itemManagement, axisDirection),
        lim1 = begin_position_track + direction_track * length_track,
        lim2 = begin_position_track

    console.debug ("pos = ", posAxisDirection, "; lim1 = ", lim1, "; lim2 = ", lim2)

    if ((posAxisDirection < lim1) ||
            (posAxisDirection > lim2)) {
        visible = false

//        console.debug (obj, visible)
//        m_synchCoordinates.setVisible (obj, visible)

//        return
    }
    else {
//        if (parseInt(obj.substr (5, obj.length - 5)) % 2 === 1) {
        if (num % 2 === 1) {
            if (val)
                visible = true
            else
                visible = false
        }
        else {
            if (val)
                visible = true
            else
                visible = false
        }
    }

    m_synchCoordinates.setVisible (prefixObectName + num, visible)
    m_synchCoordinates.setVisible ("Pole" + num, visible)
    console.debug (prefixObectName + num, visible)
}

function motionTrace() {
    var objTrace, objPole, itemManagement = "position", axisDirection = "X"
    var indxPrevTrace, indxNexrTrace
//    console.log (timerTrackSpeed.interval)
    console.log (count_of_trace)

    var i, ar = Array.constructor
    for (i = 1; i <= count_of_trace; i ++) {
//                ar [i - 1] = "Trace" + i.toString ()
        objTrace = "Trace" + i.toString ()
//        console.debug (obj, m_synchCoordinates.getValue (obj, itemManagement, axisDirection), "virtualLengthTrack=", virtualLengthTrack ())
        m_synchCoordinates.changeValue (objTrace, itemManagement, axisDirection, direction_track * sliderTrackSpeed * 0.03)
//        m_synchCoordinates.changeValue (objTrace, itemManagement, axisDirection, direction_track * 0.02)

        objPole = "Pole" + i
        m_synchCoordinates.changeValue (objPole, itemManagement, axisDirection, direction_track * sliderTrackSpeed * 0.03)
//        m_synchCoordinates.changeValue (objPole, itemManagement, axisDirection, direction_track * 0.02)

//        if (Math.abs () === sliderTrackSpeed.value)
//            console.debug ("ОШИБКА КООРДИНАТ!")


        if (m_synchCoordinates.getValue (objTrace, itemManagement, axisDirection) < direction_track * count_of_trace * sliderStepsLength + begin_position_trace) {
            console.log ("Cлед №", i, "из", m_synchCoordinates.getValue (objTrace, itemManagement, axisDirection), "в", begin_position_trace)
            m_synchCoordinates.initValue (objTrace, itemManagement, axisDirection, begin_position_trace)
            m_synchCoordinates.initValue (objPole, itemManagement, axisDirection, begin_position_trace)

            indxPrevTrace = i

            indxNexrTrace = i + 1
            if (indxNexrTrace > count_of_trace)
                indxNexrTrace = 1

//            console.debug ("Между следами", indxPrevTrace, indxNexrTrace, m_synchCoordinates.getValue ("Trace" + indxNexrTrace, itemManagement, axisDirection) - m_synchCoordinates.getValue ("Trace" + indxPrevTrace, itemManagement, axisDirection))
        }
        else {

        }

        console.debug ("checkBoxTrace2.cheked = ", checkBoxTrace2.checked)
        if (i % 2 === 1)
            visibleTrace (i, ScriptObjectReality.getCheckBoxTrace1Value ())
//            visibleTrace (i, checkBoxTrace1.checked)
        else
            if (i % 2 === 0)
                visibleTrace (i, checkBoxTrace2.checked)
            else
                ;

//        if (m_synchCoordinates.getValue (obj, itemManagement, axisDirection) < direction_track * length_track + begin_position_track) {
//            console.log (obj, "Выход за границу! ", m_synchCoordinates.getValue (obj, itemManagement, axisDirection))
//            if (m_synchCoordinates.visible (obj))
//                m_synchCoordinates.setVisible (obj, false)
//            else
//                ; //Пусть остаётСя НЕВИДИМЫм, потому что ОН за границей 'ДОРОЖКи'

//            if (m_synchCoordinates.getValue (obj, itemManagement, axisDirection) < direction_track * (length_track + sliderStepsLength) + begin_position_track) {
////                    if (m_synchCoordinates.getValue (obj, itemManagement, axisDirection) > direction_track * length_track + begin_position_track) {
//                m_synchCoordinates.initValue (obj, itemManagement, axisDirection, begin_position_trace)
//                console.log (obj, "В ИСХОДНое пололжение!")
////                Для 2-х рядов
//                if (i % 2)
//                    if (checkBoxTrace1.checked)
//                        m_synchCoordinates.setVisible (obj, true)
//                    else
//                        ;
//                else
//                    if (checkBoxTrace2.checked)
//                        m_synchCoordinates.setVisible (obj, true)
//                    else
//                        ;
////                Любой 'след' ТЕПЕРь (при ОДНом ряде) - ВИДИМЫЙ
////                m_synchCoordinates.setVisible (obj, true)
//            }
//            else
//                ; //'След' продолжает движение НЕВИДИМым
//        }
//        else
//            ; //
    }

//            cylinderTrace1.position.x = m_synchCoordinates.IteratorTrace ("Trace1", cylinderTrace1.position.x, sliderTrackSpeed.stepSize)
//            cylinderTrace2.position.x = m_synchCoordinates.IteratorTrace ("Trace2", cylinderTrace2.position.x, sliderTrackSpeed.stepSize)
}
