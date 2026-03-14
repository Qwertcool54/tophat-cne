/// this code took from vs hyp remastered by VS HYP REMASTERED DEMO by hypsk8r


import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.FramerateCounter;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.system.System;

public static var fpsText:TextField;
public static var solidSprite:Sprite;
public static var fpsY:Float = 0;
public static var fpsVisible:Bool = true;

var fpsFrameCount:Int = 0;
var fpsSmoothed:Float = 0;
var fpsDisplay:Int = 0;
var lastTimer:Float = Lib.getTimer();
var updateInterval:Float = 1 / 15;
var lastUpdateTime:Float = 0;

function preStateSwitch() Framerate.instance.visible = false;

function new() {
    solidSprite = new Sprite();
    solidSprite.graphics.beginFill(0xFF000000);
    solidSprite.graphics.drawRect(0, 0, 100, 100);
    solidSprite.graphics.endFill();
    solidSprite.alpha = 0.5;
    solidSprite.x = 10;
    solidSprite.y = 5 + fpsY;
    Main.instance.addChild(solidSprite);

    fpsText = new TextField();
    fpsText.defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFFFF);
    fpsText.height = 26;
    fpsText.selectable = false;
    fpsText.x = 10;
    fpsText.y = 5 + fpsY;
    Main.instance.addChild(fpsText);
}

function update(elapsed:Float) {
    fpsFrameCount++;
    lastUpdateTime += elapsed;

    if (lastUpdateTime >= updateInterval) {
        var timerNow:Float = Lib.getTimer();
        var timeElapsed:Float = timerNow - lastTimer;
        lastTimer = timerNow;

        var instantFPS:Float = timeElapsed <= 0 ? 0 : (fpsFrameCount * 1000 / timeElapsed);

        var smoothing:Float = 1.0 - Math.pow(0.75, timeElapsed * 0.06);

        fpsSmoothed = fpsSmoothed + (instantFPS - fpsSmoothed) * smoothing;
        fpsDisplay = Std.int(Math.round(fpsSmoothed));

        fpsFrameCount = 0;
        lastUpdateTime = 0;
    }

    var memMB:Float = System.totalMemory / 1024 / 1024;
    var memStr:String = Std.string(Math.round(memMB * 100) / 100);

    solidSprite.y = 5 + fpsY;
    fpsText.y = 5 + fpsY;

    if (FlxG.keys.justPressed.F3) {
        fpsVisible = !fpsVisible;
        solidSprite.visible = fpsVisible;
        fpsText.visible = fpsVisible;
    }

    fpsText.text = "FPS: " + fpsDisplay + " • Memory: " + memStr + "MB";
    fpsText.setTextFormat(fpsText.defaultTextFormat);
    fpsText.width = fpsText.textWidth + 10;
    setSize(fpsText.width - 3, fpsText.height - 6);
}

function setSize(width, height) {
    solidSprite.graphics.clear();
    solidSprite.graphics.beginFill(0xFF000000);
    solidSprite.graphics.drawRect(0, 0, width, height);
    solidSprite.graphics.endFill();
}

function destroy() {
    Main.instance.removeChild(solidSprite);
    Main.instance.removeChild(fpsText);
    Framerate.instance.visible = true;
}