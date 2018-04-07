function resizeQmlCVCapture () {
    console.debug ("cameraBase.visible=", cameraBase.visible, "cameraFace.visible=", cameraFace.visible)
    var title_height = btnPatientTitle.height + 1 * global_offset
    var heightQmlCvCapture = rectangleForm.height - 3 * global_offset - title_height

    if (cameraBase.visible && cameraFace.visible)
//        if (cameraBase.visible)
    {
        cameraBase.x = posXItem (1, 0)
        cameraBase.move (cameraBase.x + global_offset, cameraBase.y + global_offset + title_height);
        cameraBase.size (widthQmlCvCapture - 2 * global_offset, heightQmlCvCapture);
        cameraFace.x = posXItem (1, 1)
        cameraFace.move (cameraFace.x + global_offset, cameraFace.y + global_offset + title_height);
        cameraFace.size (widthQmlCvCapture - 2 * global_offset, heightQmlCvCapture);
        console.log ("cameraBase.visible && cameraFace.visible");
    }
    else
    {
        var camera
        if (cameraBase.visible) {
            camera = cameraBase
            console.log ("cameraBase.visible");
        }
        else {
            camera = cameraFace
            console.log ("cameraFace.visible");
        }
        camera.x = posXItem (1, 0)
        camera.move (camera.x + global_offset, camera.y + global_offset + title_height);
        camera.size (widthCvCaptureArea - 2 * global_offset, heightQmlCvCapture);
    }
}

function posXItem (numArea, numSubArea) {
    var retX = global_offset;
    //var varTmp = cameraBase_Coordinates.getNullPSCX ();
    switch (numArea) {
        case 0:
            break;
        case 1:
            switch (numSubArea) {
                case 0:
                    retX = widthManagmentArea + 2 * global_offset;
                    break;
                case 1:
                    retX = widthManagmentArea + 2 * global_offset + widthQmlCvCapture + global_offset;
                    break;
                default:
            }
            break;
        case 2:
            retX = widthManagmentArea + 2 * global_offset + widthCvCaptureArea + global_offset;
            break;
        default:
    }

    return retX;
}
