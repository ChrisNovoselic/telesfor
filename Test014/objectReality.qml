// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import lib002 1.0

HObjectReality {
//    id: trace2
//    objectName: "TraceX"
    objectName: ""
//    opacity: 0.8
    opacity: 1.0
//    visible: checkBoxTrace2.checked
    visible: false
//    sourceEntity: "Cube.mesh"
    sourceEntity: ""
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
                    sliderValue: 90.0
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
                    sliderValue: 0.1
                    minValue: 0.1
                    maxValue: 6.0
                    stepValue: 0.1
                },
                HManagementSlider { //Ось Z
                    sliderValue: 3.0
                    minValue: 0.1
                    maxValue: 6.0
                    stepValue: 0.1
                }
            ]
        }
    ]

    Component.onCompleted: {
//        ScriptTrace.traceOnCompleted (trace2, 2)
        console.debug ("DYNAMIC EMPTY OBJECT REALITY!")
    }

//    onSgnObjectRealityDestroy:

//    Connections {
//        target: rectangleForm
//        onSgnSetViewportPosition: {
//        }
}
