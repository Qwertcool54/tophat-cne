import Sys;
import funkin.backend.system.Controls;
import funkin.menus.MainMenuState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var hour = Std.int(Sys.time() / 3600) % 24;
FlxG.camera.pixelPerfectRender = true;

var bg = new FlxSprite();
var clouds = new FlxSprite();
var door = new FlxSprite();
var grad = new FlxSprite();
var hills = new FlxSprite();
var canPress:Bool = false;

var timeOfDay = (hour >= 5 && hour < 12) ? "day" : (hour >= 12 && hour < 19) ? "afternoon" : "night";

bg.loadGraphic(Paths.image('menus/tpTitle/' + timeOfDay + '/bgstore'));
clouds.loadGraphic(Paths.image('menus/tpTitle/' + timeOfDay + '/clouds'));
grad.loadGraphic(Paths.image('menus/tpTitle/' + timeOfDay + '/GRADIENTFUCK'));
hills.loadGraphic(Paths.image('menus/tpTitle/' + timeOfDay + '/hills'));

door.frames = Paths.getSparrowAtlas('menus/tpTitle/' + timeOfDay + '/door');
door.animation.addByPrefix('open', 'open', 12, false);
door.animation.addByPrefix('close', 'close', 12, false);
door.animation.play('close');

add(grad);
add(clouds);
add(hills);
add(bg);
add(door);

canPress = true;

bg.y = 200;
bg.x = 350;
bg.scale.set(2, 2);
hills.y = 450;
hills.x = 350;
hills.scale.set(3, 3);
grad.y = 200;
grad.x = 350;
grad.scale.set(3, 3);
door.y = 539;
door.x = 460;
door.scale.set(2, 2);
clouds.scale.set(2, 2);

function update(elapsed) {
    if (canPress && controls.ACCEPT && door.animation.curAnim != null && door.animation.curAnim.name == "close") {
        FlxTween.tween(FlxG.camera, {zoom: 2}, 0.8, {ease:FlxEase.quadIn});
        FlxTween.tween(FlxG.camera.scroll, {y:230}, 0.8, {ease:FlxEase.quadIn});
        canPress = false;
        door.animation.play('open');
        FlxG.sound.play(Paths.sound('tophat/dooropen'));
        door.animation.finishCallback = function(_) {
            FlxG.switchState(new MainMenuState());
        };
    

    }
}

FlxG.sound.playMusic(Paths.music(timeOfDay), 1, true);

function create() {
    FlxG.camera.scroll.y = -500;
    FlxTween.tween(FlxG.camera.scroll, {y: 0}, 1.2, {ease: FlxEase.sineOut});
} 