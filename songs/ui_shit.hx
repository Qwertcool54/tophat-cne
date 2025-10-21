doIconBop = false;

static var tophatHealthBG:FlxSprite;
static var tophatHealthBar:FlxSprite;


importScript('data/scripts/tophatPixel');
FlxG.camera.scroll.x = -175;
FlxG.camera.scroll.y = -125.5;

function postCreate() {
    for (spr in [healthBarBG, scoreTxt, missesTxt, healthBar, iconP1, iconP2]) {
        remove(spr); spr.visible = spr.active = spr.exists = false;
    }

}

