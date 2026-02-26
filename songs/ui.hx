import flixel.math.FlxRect;
import flixel.FlxSprite;

static var tophatHpBG:FlxSprite;
static var tophatHpBarOp:FlxSprite; 
static var tophatHpBarBF:FlxSprite; 
static var tophatIconP1:FlxSprite;
static var tophatIconP2:FlxSprite;
static var rankSprite:FlxSprite;

static var healthPercent:Float = 50;
static var lerpedHealth:Float = 1;
static var barW:Float = 319;
static var barH:Float = 57;
static var isDown:Bool = false;
static var barX:Float = 0;
static var barY:Float = 0;
var bL;
var bR;

FlxG.camera.pixelPerfectRender = true;



function onPlayerHit(e)
{
    e.note.splash = "TophatSplash";
}

function create() {
    bL = new FlxSprite().loadGraphic(Paths.image('game/hud/shadow'));
    bL.scale.set(3, 3);
    bL.updateHitbox();
    bL.cameras = [camHUD];

    bR = new FlxSprite().loadGraphic(Paths.image('game/hud/shadow'));
    bR.scale.set(3, 3);
    bR.updateHitbox();
    bR.cameras = [camHUD];
}

function postCreate() {
    for (spr in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, accuracyTxt, missesTxt]) {
        remove(spr);
        spr.visible = spr.active = spr.exists = false;
    }

    isDown = downscroll;
    barY = isDown ? 575 : 620;
    barX = 100;

   
    tophatHpBG = new FlxSprite(barX, barY);
    tophatHpBG.loadGraphic(Paths.image("game/hud/hpbar/bg"));
    tophatHpBG.setGraphicSize(Std.int(barW), Std.int(barH));
    tophatHpBG.updateHitbox();
    tophatHpBG.scrollFactor.set();
    tophatHpBG.cameras = [camHUD];
    tophatHpBG.scale.set(2.5, 2.5);
    tophatHpBG.updateHitbox();
    add(tophatHpBG);

    tophatHpBarOp = new FlxSprite(barX, barY);
    tophatHpBarOp.loadGraphic(Paths.image("game/hud/hpbar/opponent"));
    tophatHpBarOp.setGraphicSize(Std.int(barW), Std.int(barH));
    tophatHpBarOp.updateHitbox();
    tophatHpBarOp.scrollFactor.set();
    tophatHpBarOp.cameras = [camHUD];
    tophatHpBarOp.scale.set(2.5, 2.5);
    tophatHpBarOp.updateHitbox();
    add(tophatHpBarOp);

    tophatHpBarBF = new FlxSprite(barX, barY);
    tophatHpBarBF.loadGraphic(Paths.image("game/hud/hpbar/player"));
    tophatHpBarBF.setGraphicSize(Std.int(barW), Std.int(barH));
    tophatHpBarBF.updateHitbox();
    tophatHpBarBF.scrollFactor.set();
    tophatHpBarBF.cameras = [camHUD];
    tophatHpBarBF.scale.set(2.5, 2.5);
    tophatHpBarBF.updateHitbox();
    add(tophatHpBarBF);
    
    tophatIconP2 = new FlxSprite();
    tophatIconP2.frames = Paths.getSparrowAtlas("game/hud/tophatcon/tophatcon");
    tophatIconP2.animation.addByPrefix("idle", "i0", 6, true);
    tophatIconP2.animation.addByPrefix("losing", "l0", 6, true);
    tophatIconP2.animation.addByPrefix("itol", "itol", 6, false);
    tophatIconP2.animation.addByPrefix("outol", "outol", 6, false);
    tophatIconP2.animation.play("idle");
    tophatIconP2.scrollFactor.set();
    tophatIconP2.cameras = [camHUD];
    tophatIconP2.scale.set(2.5, 2.5);
    tophatIconP2.x = 150;
    tophatIconP2.y = 600;
    tophatIconP2.updateHitbox();
    add(tophatIconP2);

    
    tophatIconP1 = new FlxSprite();
    tophatIconP1.frames = Paths.getSparrowAtlas("game/hud/bfcon/bfcon");
    tophatIconP1.animation.addByPrefix("idle", "i0", 6, false);
    tophatIconP1.animation.addByPrefix("winning", "w", 6, true);
    tophatIconP1.animation.addByPrefix("losing", "l0", 6, true);
    tophatIconP1.animation.addByPrefix("itowin", "itowin", 6, false);
    tophatIconP1.animation.addByPrefix("outowin", "outowin", 6, false);
    tophatIconP1.animation.addByPrefix("itol", "itol0", 6, false);
    tophatIconP1.animation.addByPrefix("outol", "outol", 6, false);
    tophatIconP1.animation.addByPrefix("miss", "m", 6, false);
    tophatIconP1.animation.play("idle");
    tophatIconP1.scrollFactor.set();
    tophatIconP1.cameras = [camHUD];
    tophatIconP1.scale.set(2.5, 2.5);
    tophatIconP1.x = 730;
    tophatIconP1.y = 600;
    tophatIconP1.updateHitbox();
    add(tophatIconP1);

    bL.y = cpu.members[0].y + (14 * 2);
    bL.x = cpu.members[0].x + (3 * 3);
    bR.y = player.members[0].y + (14 * 2);
    bR.x = player.members[0].x + (3 * 3);
    insert(members.indexOf(strumLines), bL);
    insert(members.indexOf(strumLines), bR);
    
    rankSprite = new FlxSprite();
    rankSprite.frames = Paths.getSparrowAtlas("game/hud/rankbox");
    for (rank in ["s", "a", "b", "c", "d", "f", "p", "q"]) {
        rankSprite.animation.addByPrefix(rank + "i", rank + "i", 8, false);
        rankSprite.animation.addByPrefix(rank + "s", rank + "s", 8, false);
    }
rankSprite.animation.play("qi", false); 
    rankSprite.animation.play("qs", false);
    rankSprite.updateHitbox();
    rankSprite.scrollFactor.set();
    rankSprite.cameras = [camHUD];
    rankSprite.scale.set(2.5, 2.5);
    rankSprite.y = isDown ? 600 : 700;
    rankSprite.screenCenter(FlxAxes.X);
    add(rankSprite);


}

var curRankAnim:String = "q";

function update(elapsed:Float) {
    if (tophatHpBarBF == null) return;

    lerpedHealth = lerpedHealth + (Math.min(health, maxHealth) - lerpedHealth) * 0.25;
    healthPercent = (lerpedHealth / maxHealth) * 100;

    
    var hpPercent:Float = healthPercent / 100;
    tophatHpBarBF.clipRect = new FlxRect(barW * (1 - hpPercent), 0, barW * hpPercent, barH);
    tophatHpBarOp.clipRect = new FlxRect(0, 0, barW * (1 - hpPercent), barH);

    
    tophatHpBG.x = barX;
    tophatHpBG.y = barY;
    tophatHpBarOp.x = barX; tophatHpBarOp.y = barY;
    tophatHpBarBF.x = barX; tophatHpBarBF.y = barY;

    
    var acc:Float = accuracy;
    var newRank:String = "q";
    if (acc >= 1.0)       newRank = "p";
    else if (acc >= 0.95) newRank = "s";
    else if (acc >= 0.85) newRank = "a";
    else if (acc >= 0.70) newRank = "b";
    else if (acc >= 0.50) newRank = "c";
    else if (acc >= 0.30) newRank = "d";
    else                  newRank = "f";

    if (newRank != curRankAnim) {
        curRankAnim = newRank;
        rankSprite.animation.play(curRankAnim + "s", false);
    }
    if (rankSprite.animation.curAnim != null
        && rankSprite.animation.curAnim.name == curRankAnim + "s"
        && rankSprite.animation.curAnim.finished) {
        rankSprite.animation.play(curRankAnim + "i", false);
    }
    
    if (healthPercent < 35) {
        if (tophatIconP1.animation.curAnim.name == "idle" || tophatIconP1.animation.curAnim.name == "winning")
            tophatIconP1.animation.play("itol", true);
        else if (tophatIconP1.animation.curAnim.name == "itol" && tophatIconP1.animation.curAnim.finished)
            tophatIconP1.animation.play("losing");
    } else if (healthPercent > 65) {
        if (tophatIconP1.animation.curAnim.name == "idle" || tophatIconP1.animation.curAnim.name == "losing")
            tophatIconP1.animation.play("itowin", true);
        else if (tophatIconP1.animation.curAnim.name == "itowin" && tophatIconP1.animation.curAnim.finished)
            tophatIconP1.animation.play("winning");
    } else {
        if (tophatIconP1.animation.curAnim.name == "winning")
            tophatIconP1.animation.play("outowin", true);
        else if (tophatIconP1.animation.curAnim.name == "losing")
            tophatIconP1.animation.play("outol", true);
        else if (tophatIconP1.animation.curAnim.finished)
            tophatIconP1.animation.play("idle");
    }

    
    if (healthPercent > 65) {
        if (tophatIconP2.animation.curAnim.name == "idle")
            tophatIconP2.animation.play("itol", true);
        else if (tophatIconP2.animation.curAnim.name == "itol" && tophatIconP2.animation.curAnim.finished)
            tophatIconP2.animation.play("losing", false);
    } else if (healthPercent < 35) {
        if (tophatIconP2.animation.curAnim.name == "losing")
            tophatIconP2.animation.play("outol", false);
        else if (tophatIconP2.animation.curAnim.name == "outol" && tophatIconP2.animation.curAnim.finished)
            tophatIconP2.animation.play("idle", true);
    } else {
        if (tophatIconP2.animation.curAnim.name == "losing")
            tophatIconP2.animation.play("outol", false);
        else if (tophatIconP2.animation.curAnim.name == "outol" && tophatIconP2.animation.curAnim.finished)
            tophatIconP2.animation.play("idle", true);
    }
} 
