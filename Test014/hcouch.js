function postCouchdb (nameDB, content, postJSON, callBack) {
    var doc = new XMLHttpRequest ();

    console.debug ("::postCouchdb:JSON.stringify (postJSON) =", JSON.stringify (postJSON))

    doc.open ("POST", "http://" + ipDB + ":" + portDB + "/" + nameDB, true);
    doc.setRequestHeader ('Content-Type', 'application/' + content)

    doc.onreadystatechange = function () {
        console.debug ("XMLHttpRequest::postCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")
        switch (doc.status) {
            case 201: //Для GET === 200
                switch (doc.readyState) {
                    case doc.DONE:
//                        console.debug ("::postCouchdb =", JSON.parse (doc.responseText) ["id"], "; _rev =", JSON.parse (doc.responseText) ["rev"])
//                        idTraining = JSON.parse (doc.responseText) ["id"]
//                        revTraining = JSON.parse (doc.responseText) ["rev"];

                        if (! (callBack === undefined)) {
//                            console.debug ("::postCouchdb () doc.responseText =", doc.responseText)
                            console.debug ("::postCouchdb () callBack (", JSON.parse (doc.responseText) ["id"], " )")
                            callBack (JSON.parse (doc.responseText) ["id"])
                        }
                        else
                            ;
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
//                        console.debug ("::privatePutCouchdb", doc.readyState)
                        break;
                    default:
                        ;
                }
                break;
            default:
                ;
        }
    }

    doc.send (JSON.stringify (postJSON))
}

function coutJSON (obj) {
    //ПРоход JSON
    for (var key in obj ) {
        if (obj.hasOwnProperty (key)) {
            console.debug (key, obj [key])
        }
        else
            ;
    }
}

function privatePutCouchdb (nameDB, content, postJSON) {
    var doc = new XMLHttpRequest ();

//    console.debug (JSON.stringify (postJSON ["type"]))

//    var aggregateValue = '[{'
//    //ПРоход JSON
//    for (var key in postJSON ["type"]) {
//        if (postJSON ["type"].hasOwnProperty (key)) {
//            console.debug (key, postJSON ["type"] [key])
//            aggregateValue += '"' + key + '"' + ':' + '"' + postJSON ["type"] [key] + '"'
//            aggregateValue += ','
//        }
//        else
//            ;
//    }
//    aggregateValue = aggregateValue.substr (0, aggregateValue.length - 1) + '}]'
//    console.debug ("aggregateValue =", aggregateValue)

//    var postData = '{' +
//                    '"_id":"' + postJSON ["_id"] + '",' +
//                    '"_rev":"' + postJSON ["_rev"] + '",' +
//                    '"type":"' + aggregateValue + '",' +
//                    '"type":"' + JSON.stringify (postJSON ["type"]) + '",' +
//                    '"type":"' + postJSON ["type"]["p1"] + '",' +
//                    '"type":"' + 'EASY' + '",' +
//                    '"type":"' + postJSON ["type"] + '",' +
//                    '"forename":"' + postJSON ["forename"] + '",' +
//                    '"surname":"' + postJSON ["surname"] + '"' +
//                    '}';

    doc.open ("PUT", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/" + postJSON ["_id"], true);
    doc.setRequestHeader ('Content-Type', 'application/' + content)

    doc.onreadystatechange = function () {
        var responseJSON

//        console.debug ("XMLHttpRequest::privatePutCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")
        switch (doc.status) {
            case 200:
                switch (doc.readyState) {
                    case doc.DONE:
                        responseJSON = JSON.parse (doc.responseText)
//                        if (responseJSON ["ok"] && (responseJSON ["id"] === idTraining))
//                            revTraining = responseJSON ["rev"]
//                        else
//                            ;
                        console.debug ("::privatePutCouchdb result = ", responseJSON ["ok"], responseJSON ["id"], responseJSON ["rev"])
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
//                        console.debug ("::privatePutCouchdb", doc.readyState)
                        break;
                    default:
                        ;
                }
                break;
            case 201:
                switch (doc.readyState) {
                    case doc.DONE:
                        responseJSON = JSON.parse (doc.responseText)
                        console.debug ("::privatePutCouchdb result = ", responseJSON ["ok"], responseJSON ["id"], responseJSON ["rev"])
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
//                        console.debug ("::privatePutCouchdb", doc.readyState)
                        break;
                    default:
                        ;
                }
                break;
            default:
                console.debug ("::privatePutCouchdb OTHER STATUS  =", doc.status, ", readyState = ", doc.readyState, ", responceText = ", doc.responseText)
        }
    }

     //Если простые обЪектЫ
    console.debug ("Перед оТПРАВлением (postData):", JSON.stringify (postJSON))
    doc.send (JSON.stringify (postJSON))

    //Если СЛОжНЫе обЪектЫ
//    console.debug ("Перед оТПРАВлением (postData):", JSON.stringify (postData))
//    doc.send (JSON.stringify (postData))

//    console.debug ("Перед оТПРАВлением (postData):", JSON.stringify (postJSON))
//    doc.send (JSON.stringify (postJSON))
}

function joinJSON (dest, src) {
    for (var key in src) {
        if (dest.hasOwnProperty (key)) {
            if (JSON.stringify (src [key]).indexOf ('{') > -1)
                joinJSON (dest [key], src [key])
            else {
//                console.debug ("joinJSON::JSON.stringify (obj [key]).indexOf ('{') > -1::else", key, dest [key], src [key])
                dest [key] = src [key]
            }
        }
        else {
//            console.debug ("joinJSON::dest.hasOwnProperty (key)::else", key, dest [key], src [key])
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

function putCouchdb (nameDB, content, idDoc, dataJSON) {
    var doc = new XMLHttpRequest ();

    doc.open ("GET", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/" + idDoc, true);
    doc.setRequestHeader ('Content-Type', 'application/' + content)

    doc.onreadystatechange = function () {
        console.debug ("XMLHttpRequest::putCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")
        switch (doc.status) {
            case 200:
                switch (doc.readyState) {
                    case doc.DONE:
                        var key, keyIn, responseJSON = JSON.parse (doc.responseText), postJSON = responseJSON
                        console.debug ("::putCouchdb DONE _id =", idDoc, "; _rev =", responseJSON ["_rev"])

                        joinJSON (postJSON, dataJSON)
//                        consoleJSON (postJSON, 0)

//                        //ПРоход JSON
//                        for (key in dataJSON) {
//                            if (dataJSON.hasOwnProperty (key)) {
//                                console.debug ("::putCouchdb::key in dataJSON", key, JSON.stringify (dataJSON [key]))

//                                if (postJSON.hasOwnProperty (key) && (! (postJSON [key] === null)) && (! (postJSON [key] === undefined))) {
//                                    if (postJSON [key].length === 0) {
//        //                                console.debug ("Create's:", JSON.stringify (dataJSON), "ИЛИ ТаК (д.б. ===):", dataJSON.toLocaleString ())
//                                        console.debug ("::putCouchdb::Create's:", JSON.stringify (dataJSON [key]))
//                                        postJSON [key] = dataJSON [key]
//                                    }
//                                    else {
////                                        if ((JSON.stringify (postJSON [key]).indexOf ('[') > -1) || (JSON.stringify (postJSON [key]).indexOf (']') > -1)) {
//                                        if (JSON.stringify (dataJSON [key]).indexOf ('{') > -1) {
////                                            var countKeyIn = 0
//                                            for (keyIn in dataJSON [key]) {
//                                                postJSON [key] [keyIn] = dataJSON [key] [keyIn]
////                                                console.debug (keyIn, postJSON [key] [keyIn], dataJSON [key] [keyIn])
////                                                countKeyIn ++
//                                            }
////                                            Не работает ??? даже с простыми обЪектами
////                                            if (countKeyIn > 0)
////                                                ;
////                                            else
////                                                postJSON [key] = dataJSON [key]
//                                        }
//                                        else
//                                            postJSON [key] = dataJSON [key]

////                                        console.debug ("::putCouchdb::Changed:", countKeyIn, key, JSON.stringify (dataJSON [key]))
//                                    }
//                                }
//                                else {
//                                    console.debug ("::putCouchdb::Create's:", JSON.stringify (dataJSON [key]))
//                                    postJSON [key] = dataJSON
//                                }
//                            }
//                            else
//                                ;
//                        }

//                        console.debug ("::putCouchdb, postJSON =", JSON.stringify (postJSON))
//                        postJSON ["_rev"] = ""
                        privatePutCouchdb (nameDB, content, postJSON)
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
                        break;
                    default:
                        ;
                }
                break;
            default:
                ;
        }
    }

    doc.send (null)
}

function updateCouchdb (nameDB, content, idDoc, dataJSON) {
    var doc = new XMLHttpRequest ();

    doc.open ("GET", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/" + idDoc, true);
    doc.setRequestHeader ('Content-Type', 'application/' + content)

    doc.onreadystatechange = function () {
        console.debug ("XMLHttpRequest::putCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")
        switch (doc.status) {
            case 200:
                switch (doc.readyState) {
                    case doc.DONE:
                        var key, responseJSON = JSON.parse (doc.responseText), postJSON = responseJSON
                        console.debug ("::putCouchdb DONE _id =", idDoc, "; _rev =", responseJSON ["_rev"])

                        //ПРоход JSON
                        for (key in dataJSON) {
                            if (dataJSON.hasOwnProperty (key)) {
//                                console.debug ("ПРоход JSON = ", key, dataJSON [key])

                                if (postJSON.hasOwnProperty (key) && (! (postJSON [key] === null)) && (! (postJSON [key] === undefined))) {
                                    console.debug ("postJSON.hasOwnProperty (key) =", postJSON.hasOwnProperty (key))

                                    if (postJSON [key].length === 0) {
                                        console.debug ("Create's:", JSON.stringify (dataJSON [key]))
                                        postJSON [key] = dataJSON [key]
                                    }
                                    else {
                                        postJSON [key] = JSON.stringify (dataJSON [key])

                                        if (postJSON [key].indexOf ("\\") > -1) {
                                            postJSON [key] = postJSON [key].replace (/\\/g, "")
                                        }
                                        else
                                            ;

                                        postJSON [key] = JSON.parse (postJSON [key]) //Здесь ОТЛИЧие от 'putCouchdb' !!!
                                    }
                                }
                                else {
                                    console.debug ("Create's:", key, JSON.stringify (dataJSON [key]))
                                    postJSON [key] = dataJSON [key]//Здесь ОТЛИЧие от 'putCouchdb' !!! НЕ РАБотаеТ ???
                                }
                            }
                            else
                                ;
                        }

//                        console.debug ("::putCouchdb, postJSON =", JSON.stringify (postJSON))
//                        postJSON ["_rev"] = ""
                        privatePutCouchdb (nameDB, content, postJSON)
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
                        break;
                    default:
                        ;
                }
                break;
            default:
                ;
        }
    }

    doc.send (null)
}

function putPulseCouchdb (nameDB, content, idDoc, dataJSON) {
    var doc = new XMLHttpRequest ();

    doc.open ("GET", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/" + idDoc, true);
    doc.setRequestHeader ('Content-Type', 'application/' + content)

    doc.onreadystatechange = function () {
        console.debug ("XMLHttpRequest::putCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")
        switch (doc.status) {
            case 200:
                switch (doc.readyState) {
                    case doc.DONE:
                        var key, responseJSON = JSON.parse (doc.responseText), postJSON = responseJSON
                        console.debug ("::putCouchdb for docId =", idDoc, "; _rev =", responseJSON ["_rev"])
//                        var dataJSON = JSON.parse (postData) //??? УЖЕ обЪект

                        //ПРоход postJSON (responseJSON (doc.responseText))
//                        for (key in postJSON) {
//                            if (postJSON.hasOwnProperty (key))
//                                console.debug (key, postJSON [key])
//                            else
//                                ;
//                        }

                        //ПРоход dataJSON
//                        for (key in dataJSON) {
//                            if (dataJSON.hasOwnProperty (key))
//                                console.debug (key, dataJSON [key])
//                            else
//                                ;
//                        }

                        //ВариАнт №1
//                        postJSON ["type"] += dataJSON ["type"]

                        //ВариАнт №2
//                        var dt = new Date
//                        postJSON ["type"] = '[{"stamp":"' + dt.toString () + '","value":"' + dataJSON ["type"] + '"}]'

                        //ВариАнт №3
                        if (postJSON.hasOwnProperty ("pulseDateTimeLine") && (! (postJSON ["pulseDateTimeLine"] === null)) && (! (postJSON ["pulseDateTimeLine"] === undefined))) {
                            if (postJSON ["pulseDateTimeLine"].length === 0) {
//                                console.debug ("Create's:", JSON.stringify (dataJSON), "ИЛИ ТаК (д.б. ===):", dataJSON.toLocaleString ())
                                console.debug ("Create's:", JSON.stringify (dataJSON))
                                postJSON ["pulseDateTimeLine"] = dataJSON
                            }
                            else {
//                                console.debug ("Have's:", JSON.stringify (postJSON), "ИЛИ ТаК (д.б. ===):", postJSON.toString ())
//                                console.debug ("Have's:", JSON.stringify (postJSON))
//                                console.debug ("Adding's:", JSON.stringify (dataJSON), "ИЛИ ТаК (д.б. ===):", dataJSON.toString ())
//                                console.debug ("Adding's:", JSON.stringify (dataJSON))
                                if ((JSON.stringify (postJSON ["pulseDateTimeLine"]).indexOf ('[') > -1) || (JSON.stringify (postJSON ["pulseDateTimeLine"]).indexOf (']') > -1)) {
                                    postJSON ["pulseDateTimeLine"] = (JSON.stringify (postJSON ["pulseDateTimeLine"])).substring (1, (JSON.stringify (postJSON ["pulseDateTimeLine"])).length - 1) + "," + JSON.stringify (dataJSON)
                                    if (postJSON ["pulseDateTimeLine"].indexOf ("\\") > -1) {
//                                        console.debug ("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
                                        postJSON ["pulseDateTimeLine"] = postJSON ["pulseDateTimeLine"].replace (/\\/g, "")
                                    }
                                    else
                                        ; //console.debug ("--------------------------------------------------------------------------------------")
                                }
                                else
                                    postJSON ["pulseDateTimeLine"] = "[" + JSON.stringify (postJSON ["pulseDateTimeLine"]) + "," + JSON.stringify (dataJSON)

                                postJSON ["pulseDateTimeLine"] += "]"

//                                postJSON ["pulseDateTimeLine"] = JSON.parse (JSON.stringify (postJSON ["pulseDateTimeLine"]))
//                                console.debug ("Were's:", JSON.stringify (postJSON), "ИЛИ ТаК (д.б. ===):", postJSON.toString ())
//                                console.debug ("Were's:", JSON.stringify (postJSON))
                            }
                        }
                        else {
//                            console.debug ("Create's:", JSON.stringify (dataJSON), "ИЛИ ТаК (д.б. ===):", dataJSON.toString ())
                            console.debug ("Create's:", JSON.stringify (dataJSON))
                            postJSON ["pulseDateTimeLine"] = dataJSON
                        }


                        //ДРУГоЕ поле
//                        var assessment = '{DateTime:"' + dt.toLocaleString () + '",rate:"value2"}'
//                        console.debug (JSON.stringify (postJSON ["assessment"]))
//                        if (postJSON ["assessment"].length === 0) {
//                            console.debug ("Create's:", JSON.stringify (postJSON ["assessment"]))
//                            postJSON ["assessment"] = assessment
//                        }
//                        else {
//                            console.debug ("Adding's:", JSON.stringify (postJSON ["assessment"]))
//                            postJSON ["assessment"] = JSON.stringify (postJSON ["assessment"]) + "," + assessment
//                            postJSON ["assessment"].replace ("\\", "")
//                        }

//                        console.debug ("Перед оТПРАВлением (postJSON):", JSON.stringify (postJSON))

                        privatePutCouchdb (nameDB, content, postJSON)
//                        privatePutCouchdb (nameDB, content, JSON.stringify (postJSON))
//                        privatePutCouchdb (nameDB, content, JSON.parse (postDataTemp))
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
                        break;
                    default:
                        ;
                }
                break;
            default:
                ;
        }
    }

    doc.send (null)
}

//ТестоваЯ ???
//function queryCouchdb (nameDB, content, idDoc) {
//    var doc = new XMLHttpRequest ();
//    var respJSON, postData, placements

//    doc.open ("GET", "http://" + ipDB + ":" + portDB + "/" + nameDB + "/" + idDoc, true);
//    doc.setRequestHeader ('Content-Type', 'application/' + content)

//    doc.onreadystatechange = function () {
//        console.debug ("XMLHttpRequest::queryCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")

//        switch (doc.status) {
//            case 200: //OK
//                switch (doc.readyState) {
//                    case doc.DONE:
////                        console.debug("Your data has been sent AND XMLHttpRequest is ready", doc.readyState, doc.status, doc.responseText)
//                        console.debug ("::queryCouchdb =", idDoc, JSON.stringify (doc.responseText))
//                        respJSON = JSON.parse (doc.responseText)
//                        console.debug (JSON.stringify (respJSON ["rows"] ["0"] ["value"]))
//                        placements = respJSON ["rows"] ["0"] ["value"].replace (/\\/g, "")
//                        console.debug (JSON.stringify (placements))
//                        console.debug (JSON.parse (placements) ["size"])
//                        break;
//                    case doc.LOADING:
//                    case doc.OPENED:
//                    case doc.UNSENT:
//                    case doc.HEADERS_RECEIVED:
//                        break
//                    default:
//                        ;
//                }
//                break
//            case 400: //Bad request
//                break
//            default:
//                console.debug ("::queryCouchdb =", idDoc, JSON.stringify (doc.responseText))
//        }
//    }

//    doc.send (null)
//}

function viewCouchdb (nameDB, content, nameDesign, nameView, callBack, key) {
    var doc = new XMLHttpRequest ();
    var respJSON
    var postData
    var getContent

    getContent = 'http://' + ipDB + ':' + portDB + '/' + nameDB + '/_design/' + nameDesign + '/_view/' + nameView
    if (! (key === undefined))
        getContent += '?key="' + key + '"'
    else
        ;

    console.debug ("::viewCouchdb::getContent =", getContent)

    doc.open ("GET", getContent, true);
    doc.setRequestHeader ('Content-Type', 'application/' + content)

    doc.onreadystatechange = function () {
//        console.debug ("XMLHttpRequest::viewCouchdb::onreadystatechange: {readyState =", doc.readyState, "Status =", doc.status, "}")

        switch (doc.status) {
            case 200: //OK
                switch (doc.readyState) {
                    case doc.DONE:
//                        respJSON = JSON.parse (doc.responseText) Лишняя операция, если просто ТЕКСТ отправЛЯем
//                        console.debug("Your data has been sent AND XMLHttpRequest is ready", doc.readyState, doc.status, doc.responseText)
//                        console.debug ("::viewCouchdb", "idDoc =", respJSON ["rows"] [respJSON ["offset"]] ["id"], "key =", respJSON ["rows"] [respJSON ["offset"]] ["key"])
                        callBack (doc.responseText)
                        break;
                    case doc.LOADING:
                    case doc.OPENED:
                    case doc.UNSENT:
                    case doc.HEADERS_RECEIVED:
                        break
                    default:
                        ;
                }
                break
            case 400: //Bad request
                break
            default:
                ; //console.debug ("::viewCouchdb = {readyState =", doc.readyState, "Status =", doc.status, "}")
        }
    }

    doc.send (null)
}

function ageOfBirstDay (strBirstDay) {
    var dtCurrent = new Date (), dtBirstDay = new Date (strBirstDay),
        retAge = dtCurrent.getFullYear () - dtBirstDay.getFullYear ()
    if (dtCurrent.getMonth () < dtBirstDay.getMonth ())
        retAge --
    else
        ;

    return retAge
}
