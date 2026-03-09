import Sys;
var hour = Std.int(Sys.time() / 3600) % 24;
var timeOfDay = (hour >= 5 && hour < 12) ? "day" : (hour >= 12 && hour < 19) ? "afternoon" : "night";


var bg = new FlxSprite();
var sky = new FlxSprite();
var floor = new FlxSprite();
var light = new FlxSprite();
var layer19 = new FlxSprite();
bg.loadGraphic(Paths.image('stages/bg/hood/' + timeOfDay + '/bg'));
floor.loadGraphic(Paths.image('stages/bg/hood/' + timeOfDay + '/floor'));
light.loadGraphic(Paths.image('stages/bg/hood/' + timeOfDay + '/light'));
sky.loadGraphic(Paths.image('stages/bg/hood/' + timeOfDay + '/sky'));
layer19.loadGraphic(Paths.image('stages/bg/hood/Layer 19'));

add(sky);
add(bg);
add(floor);
insert(10, layer19);
add(light);

floor.y = 500;
light.y = 250;
light.x = 750;

camGame.width = camHUD.width = 1500;
camGame.height = camHUD.height = 1200;
importScript("data/scripts/ui_2024");

function postCreate() {
    gf.visible = false;
}

