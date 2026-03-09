import backend.utils.CoolUtil;

var bg:FlxSprite;


var cutscene:FlxSprite;
var crowd:FlxSprite;

var crowdAppear:Bool = false;

function create() {
	var s = new FlxSprite().loadGraphic(Paths.image('stages/bg/tp-old/screenthing'));
	s.scale.set(3,3);
	s.updateHitbox();
	s.cameras = [camHUD];
	add(s);

	cutscene = new FlxSprite();
	cutscene.frames = Paths.getSparrowAtlas('stages/bg/tp-old/cutscene');
	cutscene.animation.addByPrefix('i','cutscene',18.5,false);

	cutscene.animation.finishCallback = (s)->{cutscene.visible = false;}
	cutscene.setGraphicSize(FlxG.width);
	cutscene.updateHitbox();
	insert(1, cutscene);
	cutscene.cameras = [camHUD];


}

function onDestroy() {
}

function onSongStart() {
	//video.play();
	cutscene.animation.play('i');
}
function postCreate()
{

	bg = new FlxSprite().loadGraphic(Paths.image('stages/bg/tp-old/bgth'));
	insert(2, bg);

	var gradient = new FlxSprite().loadGraphic(Paths.image('stages/bg/tp-old/grad'));
	add(gradient);
	

	snapCam(bg.getMidpoint().x, bg.getMidpoint().y);
    camFollow.x = bg.getMidpoint().x + 10;


	uiGroup.alpha = 0;
	for (i in game.opponentStrums) i.x = -1000;

	for (i in game.playerStrums) {
		i.visible = false;
	}


	crowd = new FlxSprite();
	crowd.frames = Paths.getSparrowAtlas('stages/bg/tp/hi_data');
	crowd.animation.addByPrefix('i','crowd',8);
	crowd.animation.play('i');
	crowd.y = bg.height;
	crowd.x = (bg.width - crowd.width)/2;
	crowd.alpha = 0.75;
	add(crowd);
	


}
var crowdTween:FlxTween;
function onBeatHit() {

	// if (crowdTween != null)crowdTween.cancel();
	// crowd.y = bg.height - crowd.height;
	// crowdTween = FpsTween.m8.tween(crowd, {y:bg.height - crowd.height + 3},0.2);
	
}

function snapCam(x, y)
{
	game.camFollow.x = x;
	game.camFollow.y = y;
	game.camGame.snapToTarget();
}

function onDadHit(NoteHitEvent){
    if(health > 0.4)
    {
        health = health -= 0.007;
    }
}

importScript("data/scripts/ui_2024");
