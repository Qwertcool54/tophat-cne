function onNoteCreation(event) {
    event.cancel();

    var note = event.note;
    var strumID = event.strumID;

    if (event.note.isSustainNote) {
    note.loadGraphic(Paths.image("game/notes/pixel/notesENDS"), true, 14, 14);
    var maxCol = 4;
        note.animation.add("hold", [strumID % maxCol]);
        note.animation.add("holdend", [maxCol + strumID % maxCol]);
    } else {
        note.loadGraphic(Paths.image("game/notes/pixel/notes"), true, 34, 34);
        var maxCol = Math.floor(note.graphic.width / 34);
        note.animation.add("scroll", [maxCol + strumID % maxCol]);
    }

    note.scale.set(3, 3);
    note.updateHitbox();
    note.antialiasing = false;
}

function onStrumCreation(event) {
    event.cancel();

    var strum = event.strum;
    strum.loadGraphic(Paths.image("game/notes/pixel/notes"), true, 34, 34);
    var maxCol = 4;
    var strumID = event.strumID % maxCol;

    strum.animation.add("static", [strumID]);
    strum.animation.add("pressed", [maxCol + strumID, (maxCol * 2) + strumID], 12, false);
    strum.animation.add("confirm", [(maxCol * 3) + strumID, (maxCol * 4) + strumID], 24, false);

    strum.scale.set(3, 3);
    strum.updateHitbox();
    strum.antialiasing = false;
}

