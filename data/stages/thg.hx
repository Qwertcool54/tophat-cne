function onDadHit(NoteHitEvent){
    if(health > 0.4)
    {
        health = health -= 0.007;
    }
}


function postCreate() {
    gf.visible = false;
}