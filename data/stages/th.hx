

function postCreate(){
    gf.visible = false;
    shop.frames = Paths.getFrames("stages/bg/shop");
    shop.animation.addByPrefix("i", "shop", 3, true);
    shop.animation.play("i");
    sun.frames = Paths.getFrames("stages/bg/sun");
    sun.animation.addByPrefix("sun", "sun", 12, true);
    sun.animation.play("sun");
}
