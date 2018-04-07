// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import lib002 1.0 //QmlCVCapture, HObjectReality

import "objectReality.js" as ScriptObjectReality //Только для СТАТических функций
import "hcouch.js" as ScriptHCouchDB

//ОбЪектЫ расширенной реальности
Item {
//    id: descObjectsReality

//    У ЭТОГо 'Item' НЕТ НИ ОДНогО ПОТОМкА !!!
//    function getObjectReality (prefix, num) {
//        console.debug ("descObjectsReality::getObjectReality (): children.length = ", children.length)
//        var i
//        for (i = 0; i < children.length; i ++) {
//            console.debug ("descObjectsReality::getObjectReality ()", prefix, num, children [i].objectName)
//            if (children [i].objectName.indexOf (prefix) > -1) {
//                var obj = children [i]
//                if (num === undefined) {
//                    if (obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length).length === 0) {
//                        console.debug ("getObjectReality obj=", obj)
//                        break
//                    }
//                    else
//                        ;
//                }
//                else {
//                    if (obj.objectName.substr (prefix.length, obj.objectName.length - prefix.length) === num.toString ()) {
//                        console.debug ("getObjectReality obj=", obj)
//                        break
//                    }
//                    else
//                        ;
//                }
//            }
//            else
//                ;
//        }

//        if (i < children.length)
//            return children [i] //ИЛИ 'obj'
//        else {
//            console.debug ("descObjectsReality::getObjectReality ('", prefix, "') = null")
//            return null
//        }
//    }

//    function setVisible (prefix, num, val) {
//        getObjectReality (prefix, num).visible = val
//    }

    function savePlacementsObjectReality (obj) {
        ScriptHCouchDB.updateCouchdb (nameDB, typeContent, "placementsObjectReality", JSON.parse (ScriptObjectReality.makeUpdatePlacementsData (obj)))
    }

    function setPlacementsObjectReality (obj) {
        ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "placements", obj.objectName,
            function (responseText) {
                var responseJSON = JSON.parse (responseText), offset = eval (responseJSON ['offset'])
                responseJSON = responseJSON ["rows"] [offset] ["value"]

//                console.debug ("responseJSON ['position'] ['axisY'] ['sliderValue'] =", responseJSON ["position"] ["axisY"] ["sliderValue"])

                ScriptObjectReality.setPlacementsData (obj, responseJSON)

                if ((obj.objectName.indexOf ("Trace") > -1) || (obj.objectName.indexOf ("Pole") > -1))
                    sgnSetPlacementsMovable (obj.objectName)
                else
                    ;

//                console.debug ("placements [0].sliders [1].sliderValue =", obj.placements [0].sliders [1].sliderValue)
            })
    }

    //Центр ФСК
    HObjectReality {
        id: centerPSC
        objectName: "CenterPSC"
        opacity: 0.8
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {

            setPlacementsObjectReality (centerPSC)

//            savePlacementsObjectReality (centerPSC)

//            sgnAddStaticObjectReality (centerPSC)
        }
    }

    //РешЁтка - ФРОНт
    HObjectReality {
        id: latticeFront
        objectName: "LatticeFront" //НЕ ЗАБЫВАть ИЗМЕНить 'id' соответствуюЩЕй КНОПКи
        opacity: 0.8
        visible: cameraBase.visible && columnManagementObjectReality.getButtonChecked ("Lattice")
//        sourceEntity: "Plane.mesh"
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            placements [0].sliders [0].sliderValue = -0.05
//            placements [0].sliders [1].sliderValue = 0.22
//            placements [0].sliders [2].sliderValue = -0.05

//            placements [2].sliders [0].sliderValue = 12.0
//            placements [2].sliders [1].sliderValue = 8.0
//            placements [2].sliders [2].sliderValue = 6.0

            setPlacementsObjectReality (latticeFront)

//            savePlacementsObjectReality (latticeFront)

//            sgnAddStaticObjectReality (latticeFront)
        }
    }
    //РешЁтка - вид СЗАДи
    HObjectReality {
        id: latticeRear
        objectName: "LatticeRear" //НЕ ЗАБЫВАть ИЗМЕНить 'id' соответствуюЩЕй КНОПКи
        opacity: 0.6
        visible: cameraFace.visible && columnManagementObjectReality.getButtonChecked ("Lattice")
//        sourceEntity: "Plane.mesh"
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0 //для 'Plane' 90.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: 0.1
                        maxValue: 20.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            placements [0].sliders [0].sliderValue = -0.0
//            placements [0].sliders [1].sliderValue = -0.2
//            placements [0].sliders [2].sliderValue = -0.4

//            placements [2].sliders [0].sliderValue = 14.0
//            placements [2].sliders [1].sliderValue = 10.0
//            placements [2].sliders [2].sliderValue = 14.0

            setPlacementsObjectReality (latticeRear)

//            savePlacementsObjectReality (latticeRear)

//            sgnAddStaticObjectReality (latticeRear)
        }
    }

    //Линия №1
    HObjectReality {
        id: line1
        objectName: "Line1"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 8.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 8.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 8.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            placements [0].sliders [0].sliderValue = 0.1 //0.1
//            placements [0].sliders [1].sliderValue = 0.2
//            placements [0].sliders [2].sliderValue = -0.1

//            placements [2].sliders [0].sliderValue = 0.1
//            placements [2].sliders [1].sliderValue = 0.1
//            placements [2].sliders [2].sliderValue = 8.0

            setPlacementsObjectReality (line1)

//            savePlacementsObjectReality (line1)

//            sgnAddStaticObjectReality (line1)
        }
    }
    //Линия №2
    HObjectReality {
        id: line2
        objectName: "Line2"
        opacity: 0.6
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 8.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 8.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 8.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            placements [0].sliders [0].sliderValue = -0.3
//            placements [0].sliders [1].sliderValue = 0.3
//            placements [0].sliders [2].sliderValue = -0.1

//            placements [2].sliders [0].sliderValue = 0.1
//            placements [2].sliders [1].sliderValue = 0.1
//            placements [2].sliders [2].sliderValue = 8.0

            descObjectsReality.setPlacementsObjectReality (line2)

//            ScriptHCouchDB.queryCouchdb (nameDB, typeContent, "_design/placements/_view/" + objectName)
//            ScriptHCouchDB.viewCouchdb (nameDB, typeContent, "placements", objectName,
//                function (responseText) {
//                    var responseJSON = JSON.parse (responseText), offset = eval (responseJSON ['offset'])
//                    responseJSON = responseJSON ["rows"] [offset] ["value"]

//                    console.debug ("responseJSON ['position'] ['axisY'] ['sliderValue'] =", responseJSON ["position"] ["axisY"] ["sliderValue"])

////                    placements [0].sliders [0].sliderValue = responseJSON ["position"] ["axisX"] ["sliderValue"]
////                    placements [0].sliders [1].sliderValue = responseJSON ["position"] ["axisY"] ["sliderValue"]
////                    placements [0].sliders [2].sliderValue = responseJSON ["position"] ["axisZ"] ["sliderValue"]

////                    placements [2].sliders [0].sliderValue = responseJSON ["size"] ["axisX"] ["sliderValue"]
////                    placements [2].sliders [1].sliderValue = responseJSON ["size"] ["axisY"] ["sliderValue"]
////                    placements [2].sliders [2].sliderValue = responseJSON ["size"] ["axisZ"] ["sliderValue"]

//                    ScriptHCouchDB.setPlacementsData (line2, responseJSON)

//                    console.debug ("placements [0].sliders [1].sliderValue =", placements [0].sliders [1].sliderValue)
//                })

//            Здесь б. полУчен и СОХРАНёН 1-ый JSON 'HObjectReality'
//            var placementsJSON = JSON.parse (ScriptObjectReality.makeUpdatePlacementsData (line2))

//            console.debug (placementsJSON [nameObjectReality] [arNameItemManagement [2]] ["axis" + arNameAxis [1]] [arNameParametr [2] + 'Value'])

//            var tempData = '{"line2":' +
//                                '{"position":' +
//                                    '{"axisX":' +
//                                        '{"sliderValue":"VALUE",' +
//                                        '"minValue":"VALUE",' +
//                                        '"maxValue":"VALUE",' +
//                                        '"stepValue":"VALUE"},' +
//                                    '"axisY":' +
//                                        '{"sliderValue":"VALUE",' +
//                                        '"minValue":"VALUE",' +
//                                        '"maxValue":"VALUE",' +
//                                        '"stepValue":"VALUE"},' +
//                                    '"axisZ":' +
//                                        '{"sliderValue":"VALUE",' +
//                                        '"minValue":"VALUE",' +
//                                        '"maxValue":"VALUE",' +
//                                        '"stepValue":"VALUE"}' +
//                                '},' +
//                                '"rotation":' +
//                                    '{"":"",' +
//                                    '"":"",' +
//                                    '"":""},' +
//                                '"size":' +
//                                    '{"":"",' +
//                                    '"":"",' +
//                                    '"axisZ":' +
//                                        '{"":"",' +
//                                        '"":"",' +
//                                        '"":"",' +
//                                        '"":""}}}}'
//            placementsJSON = JSON.parse (tempData)

//            ScriptHCouchDB.updateCouchdb (nameDB, typeContent, "placementsObjectReality", placementsJSON)

//            sgnAddStaticObjectReality (line2)
        }
    }

    //Составной обЪект ГАММА
    //Гамма №1
    HObjectReality {
        id: gamma1
        objectName: "Gamma1"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            var vec3D = ScriptObjectReality.getPositionTrace (3, 0)
//            placements [0].sliders [0].sliderValue = vec3D.x
//            placements [0].sliders [1].sliderValue = vec3D.y
//            placements [0].sliders [2].sliderValue = vec3D.z
////            ШиринА следа
//            placements [0].sliders [2].sliderValue -= 0.02754

//            placements [2].sliders [0].sliderValue = 1.0
//            placements [2].sliders [1].sliderValue = 1.0
//            placements [2].sliders [2].sliderValue = 0.1

            setPlacementsObjectReality (gamma1)

//            savePlacementsObjectReality (gamma1)

//            sgnAddStaticObjectReality (gamma1)
        }
    }
    //Гамма №2
    HObjectReality {
        id: gamma2
        objectName: "Gamma2"
        opacity: 0.6
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            var vec3D = ScriptObjectReality.getPositionTrace (3, 0)
//            placements [0].sliders [0].sliderValue = vec3D.x
//            placements [0].sliders [1].sliderValue = vec3D.y
////            ВысотА 1-ой части
//            placements [0].sliders [1].sliderValue += 2 * 0.02754
//            placements [0].sliders [2].sliderValue = vec3D.z
////            ШиринА следа
//            placements [0].sliders [2].sliderValue -= 0.02754

//            placements [2].sliders [0].sliderValue = 1.0
//            placements [2].sliders [1].sliderValue = 0.1
//            placements [2].sliders [2].sliderValue = 1.0

            setPlacementsObjectReality (gamma2)

//            savePlacementsObjectReality (gamma2)

//            sgnAddStaticObjectReality (gamma2)
        }
    }

    //След №1
    HObjectReality {
        id: trace1
        objectName: "Trace1"
        opacity: 0.9
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            ScriptObjectReality.traceOnCompleted (trace1, 1, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE);

//            console.debug ("Trace1::onCompleted", placements [1].sliders [2].sliderValue)

            setPlacementsObjectReality (trace1)

//            console.debug ("Trace1::onCompleted", placements [1].sliders [2].sliderValue)

//            savePlacementsObjectReality (trace1)

//            sgnAddStaticObjectReality (trace1)

        }
    }
    //След №2
    HObjectReality {
        id: trace2
        objectName: "Trace2"
        opacity: 0.6
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            ScriptObjectReality.traceOnCompleted (trace2, 2, ScriptObjectReality.TYPE_OBJECTREALITY.TRACE);

            setPlacementsObjectReality (trace2)

//            savePlacementsObjectReality (trace2)

//            sgnAddStaticObjectReality (trace2)
        }
    }

    //Кол №1 (для следа №1)
    HObjectReality {
        id: pole1
        objectName: "Pole1"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            var vec3DPos = ScriptObjectReality.getPositionPole (1, 0)
//            placements [0].sliders [0].sliderValue = vec3DPos.x
//            placements [0].sliders [1].sliderValue = vec3DPos.y
//            placements [0].sliders [2].sliderValue = vec3DPos.z

//            vec3DPos = ScriptObjectReality.getSizePole ()
//            placements [2].sliders [0].sliderValue = vec3DPos.x
//            placements [2].sliders [1].sliderValue = vec3DPos.y
//            placements [2].sliders [2].sliderValue = vec3DPos.z

            setPlacementsObjectReality (pole1)

//            savePlacementsObjectReality (pole1)

//            sgnAddStaticObjectReality (pole1)
        }
    }
    //Кол №2 (для следа №2)
    HObjectReality {
        id: pole2
        objectName: "Pole2"
        opacity: 0.7
        visible: false
        sourceEntity: "Cube.mesh"
        placements: [
            HManagementItem { //position
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -2.0
                        maxValue: 2.0
                        stepValue: 0.01
                    }
                ]
            },
            HManagementItem { //rotation
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 0.0
                        minValue: -180.0
                        maxValue: 180.0
                        stepValue: 5.0
                    }
                ]
            },
            HManagementItem { //size (scale)
                sliders: [
                    HManagementSlider { //Ось X
                        sliderValue:  1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Y
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    },
                    HManagementSlider { //Ось Z
                        sliderValue: 1.0
                        minValue: 0.1
                        maxValue: 6.0
                        stepValue: 0.1
                    }
                ]
            }
        ]

        Component.onCompleted: {
//            var vec3DPos = ScriptObjectReality.getPositionPole (2, 0)
//            placements [0].sliders [0].sliderValue = vec3DPos.x
//            placements [0].sliders [1].sliderValue = vec3DPos.y
//            placements [0].sliders [2].sliderValue = vec3DPos.z

//            vec3DPos = ScriptObjectReality.getSizePole ()
//            placements [2].sliders [0].sliderValue = vec3DPos.x
//            placements [2].sliders [1].sliderValue = vec3DPos.y
//            placements [2].sliders [2].sliderValue = vec3DPos.z

            setPlacementsObjectReality (pole2)

//            savePlacementsObjectReality (pole2)

//            sgnAddStaticObjectReality (pole2)
        }
    }

}
