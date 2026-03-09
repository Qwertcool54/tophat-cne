var neo:FlxSprite;

var cam:FlxCamera;

function postCreate() {
    gf.visible = false;
    cam = new FlxCamera();
	cam.bgColor = 0x0;
    var bar1 = new FlxSprite().makeGraphic(FlxG.width,85,0xFF000000);
	add(bar1);
	bar1.cameras = [cam];
	var bar2 = new FlxSprite(0,FlxG.height-85).makeGraphic(FlxG.width,85,0xFF000000);
	add(bar2);
	bar2.cameras = [cam];
    var people = new FlxSprite();
	people.frames = Paths.getSparrowAtlas('stages/bg/cool/people');
	people.animation.addByPrefix('i','people',8);
	people.animation.play('i');
    insert(2, people);
	neo = new FlxSprite(0,110);
	neo.frames = Paths.getSparrowAtlas('stages/bg/cool/neo');
	neo.animation.addByPrefix('i','neo',8);
	neo.animation.play('i');
    camFollow.x = bg.getMidpoint().x + 10;
    insert(3, neo);
}

var time:Float = 0;
var neoGoingLeft:Bool = true;
var neoSpeed:Int = 5;
var allowedToMove:Float = 0;

function snapCam(x, y)
{
	game.camFollow.x = x;
	game.camFollow.y = y;
	game.camGame.snapToTarget();
}



function update(elapsed:Float) {

	time+= elapsed;
	allowedToMove-=elapsed;
	while (time >= 1/8) {
		time-=1/8;

		if (allowedToMove >= 0) return;
		if (neo.x < bg.x || neo.x >bg.x + bg.width) {
			neoSpeed = 5 * FlxG.random.int(1,5);
			neoGoingLeft = !neoGoingLeft;
			allowedToMove = FlxG.random.float(5,10);
			
		}
		if (neoGoingLeft) 
			neo.x += neoSpeed;
		else 
			neo.x -= neoSpeed;
		
		neo.flipX = !neoGoingLeft;
	}

}

importScript("data/scripts/ui_2024");