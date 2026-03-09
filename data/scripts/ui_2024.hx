import flixel.math.FlxRect;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

var tophatRank:FlxSprite;
var tophatIconP1:FlxSprite;
var tophatIconP2:FlxSprite;
var tophatHealthBG:FlxSprite;
var tophatHealthColor:FlxSprite;
var cahceRect:FlxRect = new FlxRect();

var songName:String = PlayState.SONG.meta.name.toLowerCase();
var isBusiness:Bool = songName == "business-guy";
var isDevil:Bool = songName == "devil-guy";
var isCoolKid:Bool = songName == "cool-kid";
var isHood:Bool = songName == "hoodlum";
var isShop:Bool = songName == "shop-guy";
var hideHUD:Bool = isDevil || isCoolKid || isHood;

static var healthPercent:Float = 50;
public var lerpedHealth:Float = 1;
static var barW:Float = 648;
static var barH:Float = 93;
static var barX:Float = 150;
static var barY:Float = 650;
static var healthBarColors:Array<Int> = [0xFF000000, 0xFF000000];

FlxG.camera.pixelPerfectRender = true;

function postCreate() {
    for (spr in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, accuracyTxt, missesTxt, comboGroup]) {
        remove(spr);
        spr.visible = spr.active = spr.exists = false;
    }

    cpu.visible = false;
    for (i in playerStrums.members) i.x -= 310;

    var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
    var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
    healthBarColors = [leftColor, rightColor];

    tophatHealthBG = new FlxSprite(barX, barY);
    tophatHealthBG.loadGraphic(Paths.image(isBusiness ? "game/hud/2024/tophpbarsbusiness" : isShop ? "game/hud/2024/tophpbarshop" : "game/hud/2024/tophpbar"));
    tophatHealthBG.updateHitbox();
    tophatHealthBG.scrollFactor.set();
    tophatHealthBG.cameras = [camHUD];
    tophatHealthBG.visible = !hideHUD;
    add(tophatHealthBG);

    tophatHealthColor = new FlxSprite(barX, barY);
    tophatHealthColor.loadGraphic(Paths.image("game/hud/2024/tophpbarcolor"));
    tophatHealthColor.updateHitbox();
    tophatHealthColor.scrollFactor.set();
    tophatHealthColor.cameras = [camHUD];
    tophatHealthColor.visible = !hideHUD;
    tophatHealthColor.onDraw = () -> {
        for (i => color in healthBarColors) {
            var pw:Float = tophatHealthColor.width * Math.abs(1 - (healthPercent / 100));
            if (i == 0) cahceRect.set(0, 2, pw, tophatHealthColor.height - 2);
            else cahceRect.set(pw, 2, tophatHealthColor.width - pw, tophatHealthColor.height - 2);
            tophatHealthColor.colorTransform.color = color;
            tophatHealthColor.clipRect = cahceRect;
            if (color == 0x00000000) continue;
            tophatHealthColor.draw();
        }
    };
    add(tophatHealthColor);

    tophatIconP1 = new FlxSprite(barX + barW - 20, barY - 5);
    tophatIconP1.frames = Paths.getSparrowAtlas(isBusiness ? "game/hud/2024/icons/penis" : isShop ? "game/hud/2024/icons/gf" : "game/hud/2024/icons/bf");
    tophatIconP1.animation.addByPrefix("normal", "d", 24, true);
    tophatIconP1.animation.addByPrefix("losing", "l", 24, false);
    tophatIconP1.animation.play("normal");
    tophatIconP1.scrollFactor.set();
    tophatIconP1.scale.set(3, 3);
    tophatIconP1.cameras = [camHUD];
    tophatIconP1.visible = !hideHUD;
    add(tophatIconP1);

    tophatIconP2 = new FlxSprite(barX - 45, barY - 5);
    tophatIconP2.frames = Paths.getSparrowAtlas(isBusiness ? "game/hud/2024/icons/bg" : isShop ? "game/hud/2024/icons/sg" : "game/hud/2024/icons/thg");
    tophatIconP2.animation.addByPrefix("normal", "d", 24, true);
    tophatIconP2.animation.addByPrefix("losing", isBusiness ? "l" : "l0", 24, false);
    tophatIconP2.animation.play("normal");
    tophatIconP2.scrollFactor.set();
    tophatIconP2.scale.set(3, 3);
    tophatIconP2.cameras = [camHUD];
    tophatIconP2.visible = !hideHUD;
    add(tophatIconP2);

    tophatRank = new FlxSprite(0, barY - 5);
    tophatRank.frames = Paths.getSparrowAtlas("game/hud/2024/rating");
    tophatRank.animation.addByPrefix("P", "p", 24, true);
    tophatRank.animation.addByPrefix("A", "a", 24, true);
    tophatRank.animation.addByPrefix("B", "b", 24, true);
    tophatRank.animation.addByPrefix("C", "c", 24, true);
    tophatRank.animation.addByPrefix("D", "d", 24, true);
    tophatRank.animation.addByPrefix("F", "f", 24, true);
    tophatRank.animation.play("P");
    tophatRank.scrollFactor.set();
    tophatRank.scale.set(3, 3);
    tophatRank.updateHitbox();
    tophatRank.screenCenter(FlxAxes.X);
    tophatRank.cameras = [camHUD];
    tophatRank.visible = !hideHUD;
    add(tophatRank);
    if (isDevil) {
        dsBase = new FlxSprite(barX, barY);
        dsBase.loadGraphic(Paths.image("game/hud/2024/devil/dsBase"));
        dsBase.scrollFactor.set();
        dsBase.scale.set(3, 3);
        dsBase.cameras = [camHUD];
        dsBase.visible = !hideHUD;
        add(dsBase);
    }
}

function update(elapsed:Float) {
    lerpedHealth = CoolUtil.fpsLerp(lerpedHealth, Math.min(health, maxHealth), 1/4);
    healthPercent = (lerpedHealth / maxHealth) * 100;

    var acc = accuracy * 100;
    var rankName = acc >= 100 ? "P" : acc >= 90 ? "A" : acc >= 80 ? "B" : acc >= 70 ? "C" : acc >= 60 ? "D" : "F";

    if (tophatRank != null && tophatRank.animation.curAnim != null && tophatRank.animation.curAnim.name != rankName)
        tophatRank.animation.play(rankName);

    if (tophatIconP1 == null || tophatIconP2 == null) return;

    var p1Losing = healthPercent < 35;
    var p2Losing = healthPercent > 65;

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
        note.loadGraphic(Paths.image(isBusiness ? "game/hud/2024/NOTE_assetsENDS-business" : isShop ? "game/hud/2024/arrows/NOTE_assetsENDS-shop" : "game/hud/2024/NOTE_assetsENDS"), true, 7, 7);
        var maxCol = 4;
        note.animation.add("hold", [strumID % maxCol]);
        note.animation.add("holdend", [maxCol + strumID % maxCol]);
    } else {
        note.loadGraphic(Paths.image(isBusiness ? "game/hud/2024/NOTE_assets-business" : isShop ? "game/hud/2024/NOTE_assets-shop" : "game/hud/2024/NOTE_assets"), true, 34, 34);
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
    strum.loadGraphic(Paths.image(isBusiness ? "game/hud/2024/NOTE_assets-business" : isShop ? "game/hud/2024/NOTE_assets-shop" : "game/hud/2024/NOTE_assets"), true, 34, 34);
    var maxCol = 4;
    var strumID = event.strumID % maxCol;
    strum.animation.add("static", [strumID]);
    strum.animation.add("pressed", [maxCol + strumID, (maxCol * 2) + strumID], 12, false);
    strum.animation.add("confirm", [(maxCol * 3) + strumID, (maxCol * 4) + strumID], 24, false);
    strum.scale.set(3, 3);
    strum.updateHitbox();
    strum.antialiasing = false;
}