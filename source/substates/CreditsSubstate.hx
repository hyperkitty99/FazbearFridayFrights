package substates;

typedef StupidDevs = {
	var x:Int;
	var y:Int;
	var name:String;
	var desc:String;
	var hovered:Bool;
}

class CreditsSubstate extends MusicBeatSubstate {
	var curSelected:Int = 0;

	var optionShit:Array<StupidDevs> = [
		{x: 285,  y: 80,  name: 'hordy17', desc: '"actually the mod idea was developed by FFB, but somehow i became a director(?) have you ever heard about five nights in yama? ogurci...................."', hovered: false},
		{x: 450,  y: 80,  name: 'Flying Felt Boot', desc: '"Never heard about grass or sun. I spent my whole life making sprites for the mod. Imagine losing sanity just because you wanted to make funny bunny mod"', hovered: false},
		{x: 285,  y: 275, name: 'NickNGC', desc: '"Hi! Im the one who pretty much coded this entire thing. I enjoyed working on this project, Im glad I got the chance to participate in it."', hovered: false},
		{x: 450,  y: 275, name: 'Iccer', desc: '"Im sorry, guys, but I cant draw for yama right now, otherwise my mom will beat me up on the keybprapvovalmotsivolyvdkgkgtsuttsybvzh-09338"', hovered: false},
		{x: 365,  y: 470, name: 'deasodiakk', desc: '"did u nose?.. did u know, if u sniff pizza too much, you nose might think it, its pizza? this, this is because pizza smells trick your nose into pizza thinking."', hovered: false}
	];

	var menuItems:FlxTypedGroup<FlxSprite>;

	var descText:FlxText;
	var nameText:FlxText;
	var imageThing:FlxSprite;

	var nameBG:FlxSprite;
	var descBG:FlxSprite;
	var descBGNick:FlxSprite;
	var pages:FlxSprite;
	var doEverything:Bool = false;

	override function create() {
		FlxG.mouse.visible = true;

		FlxSprite.defaultAntialiasing = ClientPrefs.data.antialiasing;

		add(menuItems = new FlxTypedGroup<FlxSprite>());

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(optionShit[i].x, optionShit[i].y);
			menuItem.ID = i;
			menuItem.frames = Paths.getSparrowAtlas('ui/credits/peeps');
			menuItem.animation.addByPrefix('idle', optionShit[i].name, 0, false);
			menuItem.animation.play('idle');
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		menuItems.visible = false;

		add(nameBG = new FlxSprite(685, 80, Paths.image("ui/credits/name")));
		add(descBG = new FlxSprite(685, 180, Paths.image("ui/credits/box")));
		add(descBGNick = new FlxSprite(685, 180, Paths.image("ui/credits/nickBox")));

		descText = new FlxText(700, 195, 338, '"Hi! Im the one who pretty much coded this entire thing. I enjoyed working on this project, Im glad I got the chance to participate in it."', 21);
		descText.setFormat(Paths.font("alphabet.ttf"), 21, FlxColor.BLACK, LEFT);
		descText.active = false;
		add(descText);
		descText.autoSize = true;

		nameText = new FlxText(615, 90, 505, "NickNGC", 30);
		nameText.setFormat(Paths.font("alphabet.ttf"), 30, FlxColor.BLACK, CENTER);
		nameText.active = false;
		add(nameText);

		imageThing = new FlxSprite(690, 470);
		imageThing.frames = Paths.getSparrowAtlas('ui/credits/peeps');
		imageThing.animation.addByPrefix('NickNGCM', 'NickNGCM', 0, false);
		imageThing.animation.play('NickNGCM');
		imageThing.antialiasing = ClientPrefs.data.antialiasing;
		imageThing.updateHitbox();
		add(imageThing);
		imageThing.y = FlxG.height - imageThing.height - 75;

		descBG.visible = false;

		pages = new FlxSprite(201, -95);
		pages.frames = Paths.getSparrowAtlas('ui/mainmenu/credit');
		pages.animation.addByPrefix('credits', 'credits0', 24, false);
		pages.animation.addByPrefix('creditsReverse', 'creditsReverse', 24, false);
		pages.updateHitbox();
		add(pages);

		pages.animation.play('credits');
			
		pages.animation.finishCallback = function(s:String) {
			pages.visible = false;
			doEverything = true;
			menuItems.visible = true;
		}

		super.create();
	}

	var lastSelected:Int = -1;
	override function update(elapsed:Float) {
		if (doEverything) {
			menuItems.forEach(function(spr:FlxSprite) {
				if (FlxG.mouse.overlaps(spr)) {
					curSelected = spr.ID;
	
					if (!optionShit[curSelected].hovered) optionShit[curSelected].hovered = true;
	
					if (FlxG.mouse.justPressed) {
						nameText.text = optionShit[curSelected].name;
						descText.text = optionShit[curSelected].desc;
					
						imageThing.animation.addByPrefix(optionShit[curSelected].name + 'M', optionShit[curSelected].name + 'M', 0, false);
						imageThing.animation.play(optionShit[curSelected].name + 'M');
						imageThing.updateHitbox();
						imageThing.y = FlxG.height - imageThing.height - 75;
	
						if (optionShit[curSelected].name == "NickNGC") {
							descBG.visible = false;
							descBGNick.visible = true;
						} else {
							descBG.visible = true;
							descBGNick.visible = false;
						}
					}
				} else optionShit[spr.ID].hovered = false;
			});
	
			if(controls.BACK) {
				FlxG.sound.play(Paths.sound('paper/paper' + FlxG.random.int(1, 4)));
				pages.visible = true;
				pages.animation.play('creditsReverse');
				menuItems.visible = false;
				states.MainMenuState.menuItems.visible = true;
				states.MainMenuState.selector.y = 340;
		
				pages.animation.finishCallback = function(s:String) {
					close();
					return;
				}
				doEverything = false;
			}
		}

		super.update(elapsed);
	}
}