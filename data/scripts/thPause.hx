import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import funkin.options.OptionsMenu;
import funkin.menus.FreeplayState;

var openTimer:Float = 0;
var openDuration:Float = 0.5;
var curSelected:Int = 0;
var bfOutline = new CustomShader("outline");
var bwShader = new CustomShader("bw");
bfOutline.thickness = 2.0;
bfOutline.outlineColor = [1.0, 1.0, 1.0, 1.0];

var pauseCam:FlxCamera;
var panel:FlxSprite;
var cursor:FlxSprite;
var photoMode:FlxSprite;

var menuItems:Array<String> = ["unpause", "retry", "opt", "exit"];
var btnPrefixes:Array<String> = ["un", "re", "op", "ex"];

var canDoShit:Bool = false;

function create(event) {
    event.cancel();

    camera = pauseCam = new FlxCamera();
    pauseCam.bgColor = 0x88000000;
    FlxG.cameras.add(pauseCam, false);

    if (game.boyfriend != null) game.boyfriend.shader = bfOutline;
    if (game.dad != null) game.dad.shader = bfOutline;
    if (game.gf != null) game.gf.shader = bfOutline;
    game.camGame.addShader(bwShader);
    game.camHUD.addShader(bwShader); 

    panel = new FlxSprite();
    panel.frames = Paths.getSparrowAtlas("game/hud/tpPause/pause");
    panel.animation.addByPrefix("idle", "open0002", 24, false);
    panel.animation.play("idle");
    panel.antialiasing = false;
    panel.scale.set(2.5, 2.5);
    panel.updateHitbox();
    panel.screenCenter();
    add(panel);

    cursor = new FlxSprite();
    cursor.frames = Paths.getSparrowAtlas("game/hud/tpPause/pause");
    cursor.animation.addByPrefix("un", "un0", 24, true);
    cursor.animation.addByPrefix("re", "re0", 24, true);
    cursor.animation.addByPrefix("op", "op0", 24, true);
    cursor.animation.addByPrefix("ex", "ex0", 24, true);
    cursor.animation.play("un");
    cursor.antialiasing = false;
    cursor.scale.set(2.5, 2.5);
    cursor.updateHitbox();
    cursor.screenCenter();
    add(cursor);

    photoMode = new FlxSprite();
    photoMode.frames = Paths.getSparrowAtlas("game/hud/tpPause/pm");
    photoMode.animation.addByPrefix("idle", "d", 24, true);
    photoMode.animation.addByPrefix("hi", "hi", 24, false);
    photoMode.animation.play("idle");
    photoMode.antialiasing = false;
    photoMode.scale.set(3, 3);
    photoMode.updateHitbox();
    photoMode.screenCenter(FlxAxes.X);
    photoMode.y = panel.y + panel.height + -25;
    add(photoMode);

    var pmKey = new FlxText(0, 0, 0, "1", 24);
    pmKey.screenCenter(FlxAxes.X);
    pmKey.x += 60; 
    pmKey.y = photoMode.y + photoMode.height - 75;
    add(pmKey);
}

function destroy() {
    if (game.boyfriend != null) game.boyfriend.shader = null;
    if (game.dad != null) game.dad.shader = null;
    if (game.gf != null) game.gf.shader = null;
    if (FlxG.cameras.list.contains(pauseCam))
        FlxG.cameras.remove(pauseCam);
    game.camGame.removeShader(bwShader);
    game.camHUD.removeShader(bwShader);
}
function update(elapsed) {
    pauseCam.alpha = lerp(pauseCam.alpha, 1, 0.25);

    if (!canDoShit) {
        openTimer += elapsed;
        if (openTimer >= openDuration) {
            canDoShit = true;
            changeSelection(0);
        }
        return;
    }

    changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));
    if (controls.ACCEPT) enterOption();

    if (FlxG.keys.justPressed.ONE && canDoShit) {
        var photoModeActive = photoMode.animation.curAnim.name == "hi";
        photoModeActive = !photoModeActive;
        photoMode.animation.play(photoModeActive ? "hi" : "idle");
        panel.visible = !photoModeActive;
        cursor.visible = !photoModeActive;
        game.camHUD.visible = !photoModeActive;
        photoMode.visible = !photoModeActive;
}
}

function changeSelection(change) {
    if (cursor == null) return;
    curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);
    cursor.animation.play(btnPrefixes[curSelected]);
}

function enterOption() {
    canDoShit = false;
    switch(menuItems[curSelected]) {
        case "unpause": close();
        case "retry": FlxG.switchState(new PlayState());
        case "opt": FlxG.switchState(new OptionsMenu());
        case "exit": FlxG.switchState(new FreeplayState());
    }
}