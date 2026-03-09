import flixel.util.FlxAxes;
import flixel.math.FlxMath;
import funkin.menus.FreeplayState;
import funkin.menus.MainMenuState;
import funkin.backend.system.Controls;

var bg:FlxSprite;
var selector:FlxSprite;
var cards:Array<FlxSprite> = [];
var cardSongs:Array<String> = [];

var categories:Array<String> = ["ms", "ex", "tr"];
var curCategory:Int = 0;
var bottomY = curCategory == 1 ? 630 : 540;
var lerp:Float = 0.6;

var mainSongs:Array<Dynamic> = [
    {song: "tophat-guy", atlas: "menus/tpSongs/tophat"},
    {song: "shop-guy", atlas: "menus/tpSongs/shop"},
    {song: "business-guy", atlas: "menus/tpSongs/business"},
];

var extrasPositions:Array<Dynamic> = [
    {x: 575, y: 325},  
    {x: 810, y: 375},  
    {x: 320, y: 325},  
    {x: 150, y: 530}, 
];

var extrasSongs:Array<Dynamic> = [
    {song: "cool-kid", atlas: "menus/tpSongs/extras/ck"},
    {song: "hoodlum", atlas: "menus/tpSongs/extras/hl"},
    {song: "devil-guy", atlas: "menus/tpSongs/extras/oc"},
    {song: "abstract-guy", atlas: "menus/tpSongs/extras/ag"}
];

function create() {
    bg = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("menus/tpSongs/bg"));
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.antialiasing = false;

    add(bg);

    selector = new FlxSprite();
    selector.frames = Paths.getSparrowAtlas("menus/tpSongs/select");
    selector.animation.addByPrefix("ms", "ms", 24, true);
    selector.animation.addByPrefix("ex", "ex", 24, true);
    selector.animation.addByPrefix("tr", "tr", 24, true);
    selector.animation.play("ms");
    selector.antialiasing = false;
    selector.scale.set(2.5, 2.5);
    selector.updateHitbox();
    selector.screenCenter(FlxAxes.X);
    selector.y = 0;
    add(selector);

    buildCards();
    trace(curCategory);
}

function buildCards() {
    for (c in cards) remove(c);
    cards = [];
    cardSongs = [];

    if (curCategory == 1)
        bg.loadGraphic(Paths.image("menus/tpSongs/extras/bg"));
    else
        bg.loadGraphic(Paths.image("menus/tpSongs/bg"));
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    var songList = curCategory == 0 ? mainSongs : (curCategory == 1 ? extrasSongs : []);
    var shelfY = curCategory == 1 ? 470 : 430;
    var spacing = curCategory == 1 ? 70 : 250;
    var totalW = songList.length * spacing;
    var startX = curCategory == 1 ? 100 : (FlxG.width - totalW) / 2 + spacing / 2;
for (i => data in songList) {
    var posX = curCategory == 1 ? extrasPositions[i].x : startX + i * spacing;
    var card = new FlxSprite(posX, 0);
    card.frames = Paths.getSparrowAtlas(data.atlas);
    card.animation.addByPrefix("idle", "d", 24, true);
    card.animation.addByPrefix("select", "s", 12, true);
    card.animation.play("idle");
    card.antialiasing = false;
    card.scale.set(curCategory == 1 ? 2 : 2, curCategory == 1 ? 2 : 2);
    card.updateHitbox();
    card.y = curCategory == 1 ? extrasPositions[i].y - card.height : bottomY - card.height;
    cards.push(card);
    cardSongs.push(data.song);
    add(card);
}
}

function update(elapsed) {

    var camOffsetX:Float = (FlxG.mouse.x - FlxG.width / 2) * 0.05 * lerp;
    var camOffsetY:Float = (FlxG.mouse.y - FlxG.height / 2) * 0.05 * lerp;
    FlxG.camera.scroll.x = camOffsetX;
    FlxG.camera.scroll.y = camOffsetY;

    if (FlxG.keys.justPressed.ESCAPE) {
        FlxG.switchState(new MainMenuState());
        return;
    }
    
    if (FlxG.mouse.justPressed) {
        if (FlxG.mouse.overlaps(selector)) {
            var mouseX = FlxG.mouse.x;
            var centerX = selector.x + selector.width / 2;
            if (mouseX < centerX - selector.width / 4)
                curCategory = FlxMath.wrap(curCategory - 1, 0, categories.length - 1);
            else if (mouseX > centerX + selector.width / 4)
                curCategory = FlxMath.wrap(curCategory + 1, 0, categories.length - 1);
            selector.animation.play(categories[curCategory]);
            buildCards();
        }

        
        for (i => card in cards) {
            if (FlxG.mouse.overlaps(card)) {
                PlayState.loadSong(cardSongs[i]);
                FlxG.switchState(new PlayState());
                return;
            }
        }

        
        
    }

    
    for (card in cards) {
        if (FlxG.mouse.overlaps(card)) {
            if (card.animation.curAnim != null && card.animation.curAnim.name != "select")
                card.animation.play("select");
        } else {
            if (card.animation.curAnim != null && card.animation.curAnim.name == "select")
                card.animation.play("idle");
        }
    }
}