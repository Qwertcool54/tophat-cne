import funkin.backend.utils.FlxInterpolateColor;
import flixel.ui.FlxBarFillDirection;
import flixel.math.FlxRect;
import flixel.ui.FlxBar;
import flixel.math.FlxRect;
import flixel.FlxSprite;

var tophatIconP1:FlxSprite;
var tophatIconP2:FlxSprite;
var tophatHealthBG:FlxSprite;
var tophatHealthColor:FlxSprite;
var cahceRect:FlxRect = new FlxRect();

static var healthPercent:Float = 50;
public var lerpedHealth:Float = 1;
static var barW:Float = 648;
static var barH:Float = 93;
static var isDown:Bool = false;
static var barX:Float = 0;
static var barY:Float = 0;

static var ogHealthColors:Array<Int> = [0xFF000000, 0xFF000000];
static var healthBarColors:Array<Int> = [0xFF000000, 0xFF000000];
var __lerpColor:FlxInterpolateColor;

FlxG.camera.pixelPerfectRender = true;

function postCreate() {
    for (spr in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, accuracyTxt, missesTxt]) {
        remove(spr);
        spr.visible = spr.active = spr.exists = false;
    }
    cpu.visible = false;
	for (i in playerStrums.members) {
        i.x -= 310;
    }
    var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
    var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
    healthBarColors = [leftColor, rightColor];
    ogHealthColors = [leftColor, rightColor];

    isDown = downscroll;
    barY = isDown ? 650 : 650;
    barX = 150;

    tophatHealthBG = new FlxSprite(barX, barY);
    tophatHealthBG.loadGraphic(Paths.image("game/hud/2024/tophpbar"));
    tophatHealthBG.scale.set(1, 1);
    tophatHealthBG.updateHitbox();
    tophatHealthBG.scrollFactor.set();
    tophatHealthBG.cameras = [camHUD];
    add(tophatHealthBG);

    var tpfillPath = Paths.image("game/hud/2024/tophpbarcolor");
    tophatHealthColor = new FlxSprite(barX, barY);
    if(Assets.exists(tpfillPath)) tophatHealthColor.loadGraphic(tpfillPath);
    tophatHealthColor.scale.set(1, 1);
    tophatHealthColor.updateHitbox();
    tophatHealthColor.scrollFactor.set();
    tophatHealthColor.cameras = [camHUD];
    add(tophatHealthColor);

    tophatIconP1 = new FlxSprite(barX + barW - 20, barY - 5);
    tophatIconP1.frames = Paths.getSparrowAtlas("game/hud/2024/icons/bf");
    tophatIconP1.animation.addByPrefix("normal", "d", 24, true);
    tophatIconP1.animation.addByPrefix("losing", "l", 24, false);
    tophatIconP1.animation.play("normal");
    tophatIconP1.scrollFactor.set();
    tophatIconP1.scale.set(1.5, 1.5);
    tophatIconP1.cameras = [camHUD];
    add(tophatIconP1);

    tophatIconP2 = new FlxSprite(barX - 45, barY - 5);
    tophatIconP2.frames = Paths.getSparrowAtlas("game/hud/2024/icons/thg");
    tophatIconP2.animation.addByPrefix("normal", "d", 24, true);
    tophatIconP2.animation.addByPrefix("losing", "l0", 24, false);
    tophatIconP2.animation.play("normal");
    tophatIconP2.scrollFactor.set();
    tophatIconP2.scale.set(1.5, 1.5);
    tophatIconP2.cameras = [camHUD];
    add(tophatIconP2);

    tophatHealthColor.onDraw = () -> {
        for (i => color in healthBarColors) {
            var precentWidth:Float = tophatHealthColor.width * Math.abs(1-(healthPercent/100));
            switch (i) {
                case 0: cahceRect.set(0, 2, precentWidth, tophatHealthColor.height-2);
                case 1: cahceRect.set(precentWidth, 2, tophatHealthColor.width-precentWidth, tophatHealthColor.height - 2);
            }

            tophatHealthColor.colorTransform.color = color;
            tophatHealthColor.clipRect = cahceRect;
            if (color == 0x00000000) continue;
            tophatHealthColor.draw();
        }
    };
}

function update(elapsed:Float) {
    lerpedHealth = CoolUtil.fpsLerp(lerpedHealth, Math.min(health, maxHealth), 1/4);
    healthPercent = (lerpedHealth / maxHealth) * 100;

    var p1Losing = healthPercent < 35;
    var p2Losing = healthPercent > 65;

    if (tophatIconP1 == null || tophatIconP2 == null) return;
    if (tophatIconP1.animation.curAnim != null) {
        if (p1Losing && tophatIconP1.animation.curAnim.name != "losing")
            tophatIconP1.animation.play("losing");
        else if (!p1Losing && tophatIconP1.animation.curAnim.name != "normal")
            tophatIconP1.animation.play("normal");
    }

    if (tophatIconP2.animation.curAnim != null) {
        if (p2Losing && tophatIconP2.animation.curAnim.name != "losing")
            tophatIconP2.animation.play("losing");
        else if (!p2Losing && tophatIconP2.animation.curAnim.name != "normal")
            tophatIconP2.animation.play("normal");
    }
}

function onCountdown(event) {
    event.antialiasing = false;
    event.scale = 2.5;
    
    event.soundPath = switch(event.swagCounter) {
        case 0: 'tophat/three';
        case 1: 'tophat/two';
        case 2: 'tophat/one';
        case 3: 'tophat/go';
        default: null;
    };
    
    event.spritePath = switch(event.swagCounter) {
        case 0: null;
        case 1: 'game/hud/two';
        case 2: 'game/hud/one';
        case 3: 'game/hud/go';
        default: null;
    };
}

function onNoteCreation(event) {
    event.cancel();

    var note = event.note;
    var strumID = event.strumID;

    if (event.note.isSustainNote) {
    note.loadGraphic(Paths.image("game/hud/2024/arrows/NOTE_assetsENDS"), true, 7, 7);
    var maxCol = 4;
        note.animation.add("hold", [strumID % maxCol]);
        note.animation.add("holdend", [maxCol + strumID % maxCol]);
    } else {
        note.loadGraphic(Paths.image("game/hud/2024/arrows/NOTE_assets"), true, 17, 17);
        var maxCol = Math.floor(note.graphic.width / 17);
        note.animation.add("scroll", [maxCol + strumID % maxCol]);
    }

    note.scale.set(4, 4);
    note.updateHitbox();
    note.antialiasing = false;
}

function onStrumCreation(event) {
    event.cancel();

    var strum = event.strum;
    strum.loadGraphic(Paths.image("game/hud/2024/NOTE_assets"), true, 34, 34);
    var maxCol = 4;
    var strumID = event.strumID % maxCol;

    strum.animation.add("static", [strumID]);
    strum.animation.add("pressed", [maxCol + strumID, (maxCol * 2) + strumID], 12, false);
    strum.animation.add("confirm", [(maxCol * 3) + strumID, (maxCol * 4) + strumID], 24, false);

    strum.scale.set(3, 3);
    strum.updateHitbox();
    strum.antialiasing = false;
}