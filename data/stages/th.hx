

function postCreate(){
    gf.visible = false;
    shop.frames = Paths.getFrames("stages/bg/shop");
    shop.animation.addByPrefix("i", "shop", 3, true);
    shop.animation.play("i");
    sun.frames = Paths.getFrames("stages/bg/sun");
    sun.animation.addByPrefix("sun", "sun", 12, true);
    sun.animation.play("sun");
    // game.dad.setColorTransform(255,255,0);
    var width = 1050;
    var newWidth = 350;
    var height = 789;
    var newHeight = 263;

    // FlxG.camera.zoom = 1;
    FlxG.camera.zoom = width / newWidth;
    FlxG.camera.scroll.x = (newWidth - width) / 2;
    FlxG.camera.scroll.y = (newHeight - height) / 2;

    defaultCamZoom = FlxG.camera.zoom;

    isCameraOnForcedPos = true;
    // FlxG.camera.scroll.x = 0;
    // FlxG.camera.scroll.y = 0;
    // FlxG.camera.target = null;
    
}

function onDadHit(NoteHitEvent){
    if(health > 0.4)
    {
        health = health -= 0.007;
    }
}
