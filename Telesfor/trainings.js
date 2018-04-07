function trainingItem () {
    this.stepsLength = min_steps_length
    this.trackSpeed = min_track_speed
    this.trackTilt = min_track_tilt
    this.duration = 0
}

function training () {
    this.items = new Arary ();
    this.addItem = function (item) {
        items [items.length - 1] = item
    }
}
