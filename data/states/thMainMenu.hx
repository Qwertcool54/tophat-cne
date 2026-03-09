import Sys;
import funkin.menus.FreeplayState;
import funkin.menus.credits.CreditsMain;
import funkin.backend.system.Controls;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.input.mouse.FlxMouseEvent;

var hour = Std.int(Sys.time() / 3600) % 24;
var timeOfDay = (hour >= 5 && hour < 12) ? "day" : (hour >= 12 && hour < 19) ? "afternoon" : "night";
var lerp:Float = 0.6;

var bg = new FlxSprite();
var table = new FlxSprite();
var guy = new FlxSprite();
var songBtn = new FlxSprite();
var optionsBtn = new FlxSprite();
var creditBtn = new FlxSprite();
var textbox = new FlxSprite();
var dialogueText = new FlxText();
var isDialogueOpen:Bool = false;
var fullText:String = "hello. welcome to my trailer.";
var currentText:String = "";
var textTimer:Float = 0;
var textSpeed:Float = 0.05;
var talkSounds:Array<String> = ["tophat/hat_talk1", "tophat/hat_talk2", "tophat/hat_talk3"];
var talkIndex:Int = 0;
var hoverText = new FlxText();
var closeTimer:Float = 0;
var closeDelay:Float = 1.5;

bg.loadGraphic(Paths.image('menus/tpMenu/bgmenu' + timeOfDay));
bg.setGraphicSize(Std.int(bg.width * 2));
bg.updateHitbox();
bg.scale.set(3, 3);
bg.screenCenter();

table.loadGraphic(Paths.image('menus/tpMenu/table'));
table.setGraphicSize(Std.int(table.width * 2));
table.y = 550;
table.x = 50;
table.scale.set(2.75, 2.75);
table.updateHitbox();

guy.frames = Paths.getSparrowAtlas('menus/tpMenu/guy');
for (i in 1...10) {
    guy.animation.addByPrefix(i + 'd', i + 'd', 8, false);
    guy.animation.addByPrefix(i + 't', i + 't', 8, false);
}
guy.animation.play('1d');
guy.setGraphicSize(Std.int(guy.width * 2));
guy.y = 200;
guy.x = 500;
guy.scale.set(2.5, 2.5);
guy.updateHitbox();

songBtn.frames = Paths.getSparrowAtlas('menus/tpMenu/songs');
songBtn.animation.addByPrefix('idle', 'd', 8, true);
songBtn.animation.addByPrefix('selected', 's', 8, false);
songBtn.animation.play('idle');
songBtn.setGraphicSize(Std.int(songBtn.width * 2));
songBtn.y = 200;
songBtn.x = 175;
songBtn.updateHitbox();

optionsBtn.frames = Paths.getSparrowAtlas('menus/tpMenu/options');
optionsBtn.animation.addByPrefix('idle', 'd', 8, true);
optionsBtn.animation.addByPrefix('selected', 's', 8, false);
optionsBtn.animation.play('idle');
optionsBtn.setGraphicSize(Std.int(optionsBtn.width * 2));
optionsBtn.y = 400;
optionsBtn.x = 175;
optionsBtn.updateHitbox();

creditBtn.frames = Paths.getSparrowAtlas('menus/tpMenu/credit');
creditBtn.animation.addByPrefix('idle', 'd', 8, true);
creditBtn.animation.addByPrefix('selected', 's', 8, false);
creditBtn.animation.play('idle');
creditBtn.setGraphicSize(Std.int(creditBtn.width * 2));
creditBtn.updateHitbox();
creditBtn.y = 50;
creditBtn.x = 175;

textbox.frames = Paths.getSparrowAtlas('menus/tpMenu/textbox');
textbox.animation.addByPrefix('hi', 'hi', 24, false);
textbox.animation.addByPrefix('idle', 'd', 8, false);
textbox.animation.addByPrefix('talk', 't', 8, true);
textbox.visible = false;
textbox.scale.set(3, 3);
textbox.updateHitbox();
textbox.screenCenter(FlxAxes.X);
textbox.y = FlxG.height - textbox.height - 10;

dialogueText.setFormat(null, 24, 0xFF000000);
dialogueText.font = "fonts/pixel.otf";
dialogueText.visible = false;
dialogueText.antialiasing = false;
hoverText.setFormat(null, 24, 0xFFFFFFFF);
hoverText.visible = false;

add(bg);
add(guy);
add(table);
add(creditBtn);
add(songBtn);
add(optionsBtn);
add(textbox);
add(dialogueText);
add(hoverText);


function update(elapsed) {
    if (FlxG.keys.justPressed.O) {
        PlayState.loadSong("tophat-old", "normal");
        FlxG.switchState(new PlayState());
    }

    var camOffsetX:Float = (FlxG.mouse.x - FlxG.width / 2) * 0.05 * lerp;
    var camOffsetY:Float = (FlxG.mouse.y - FlxG.height / 2) * 0.05 * lerp;
    FlxG.camera.scroll.x = camOffsetX;
    FlxG.camera.scroll.y = camOffsetY;

    if (FlxG.mouse.overlaps(creditBtn)) {
        creditBtn.animation.play('selected');
        hoverText.text = "credits";
        hoverText.visible = true;
        hoverText.x = creditBtn.x;
        hoverText.y = creditBtn.y - -90;
    } else
        creditBtn.animation.play('idle');
        
    if (FlxG.mouse.overlaps(songBtn)) {
        songBtn.animation.play('selected');
        hoverText.text = "songs";
        hoverText.visible = true;
        hoverText.x = songBtn.x + 20;
        hoverText.y = songBtn.y - -110;
    } else
        songBtn.animation.play('idle');
        
    if (FlxG.mouse.overlaps(optionsBtn)) {
        optionsBtn.animation.play('selected');
        hoverText.text = "options";
        hoverText.visible = true;
        hoverText.x = optionsBtn.x;
        hoverText.y = optionsBtn.y - -80;
    } else
        optionsBtn.animation.play('idle');

    if (!FlxG.mouse.overlaps(creditBtn) && !FlxG.mouse.overlaps(songBtn) && !FlxG.mouse.overlaps(optionsBtn))
        hoverText.visible = false;

    if (FlxG.mouse.justPressed) {
        if (!isDialogueOpen) {
            if (FlxG.mouse.overlaps(guy)) {
                isDialogueOpen = true;
                closeTimer = 0;
                textbox.visible = true;
                dialogueText.visible = true;
                currentText = "";
                talkIndex = 0;
                textTimer = 0;
                textbox.animation.play('hi');
                textbox.animation.finishCallback = function(_) {
                    textbox.animation.play('talk');
                };
                textbox.screenCenter(FlxAxes.X);
                textbox.y = FlxG.height - textbox.height - 10;
                dialogueText.x = textbox.x + 350;
                dialogueText.y = textbox.y + 100;
                dialogueText.fieldWidth = 700;
            } else if (FlxG.mouse.overlaps(creditBtn))
                FlxG.switchState(new CreditsMain());
            else if (FlxG.mouse.overlaps(songBtn))
                FlxG.switchState(new FreeplayState());
            else if (FlxG.mouse.overlaps(optionsBtn))
                FlxG.switchState(new OptionsMenu());
        }
    }

    if (FlxG.keys.justPressed.ESCAPE)
        FlxG.switchState(new TitleState());

    if (controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = false;
        persistentDraw = true;
    }

    if (controls.DEV_ACCESS && Options.devMode) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(new EditorPicker());
    }



    if (isDialogueOpen) {
        if (currentText.length < fullText.length) {
            textTimer += elapsed;
            if (textTimer >= textSpeed) {
                textTimer = 0;
                currentText += fullText.charAt(currentText.length);
                dialogueText.text = currentText;
                FlxG.sound.play(Paths.sound(talkSounds[talkIndex % 3]));
                talkIndex++;
                textbox.animation.play('talk');
                guy.animation.play('1t');
            }
        } else {
            textbox.animation.play('idle', false);
            guy.animation.play('1d');
            closeTimer += elapsed;
            if (closeTimer >= closeDelay) {
                closeTimer = 0;
                isDialogueOpen = false;
                textbox.visible = false;
                dialogueText.visible = false;
                currentText = "";
            }
        }
    }
}