package substates;

import flixel.addons.transition.FlxTransitionableState;

typedef PauseButton = {
	var x:Int;
	var y:Int;
	var name:String;
}

class PauseSubState extends MusicBeatSubstate {
	var optionShit:Array<PauseButton> = [
		{x: 125,  y: 285, name: 'resume'},
		{x: 125,  y: 385, name: 'restart'},
		{x: 125,  y: 485, name: 'exit'}
	];	
	var menuItems:FlxTypedGroup<FlxSprite>;
	var selector:FlxSprite;
	var oswald:FlxSprite;

	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	override function create() {
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		FlxSprite.defaultAntialiasing = ClientPrefs.data.antialiasing;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);

		pauseMusic = new FlxSound();
		if(!states.PlayState.secondPhase && !states.PlayState.thirdPhase) pauseMusic.loadEmbedded(Paths.music('Pause 1'), true, true);
		if(states.PlayState.secondPhase) pauseMusic.loadEmbedded(Paths.music('Pause 2'), true, true);
		if(states.PlayState.thirdPhase) pauseMusic.loadEmbedded(Paths.music('Pause 3'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		FlxG.sound.list.add(pauseMusic);

		add(new FlxSprite(85, 85, Paths.image("ui/shitballs/paper")));

		add(selector = new FlxSprite(125, -500, Paths.image("ui/mainmenu/selector")));

		add(menuItems = new FlxTypedGroup<FlxSprite>());

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(optionShit[i].x, optionShit[i].y);
			menuItem.ID = i;
			menuItem.frames = Paths.getSparrowAtlas('ui/shitballs/pauseStuff');
			menuItem.animation.addByPrefix(optionShit[i].name, optionShit[i].name, 0, false);
			menuItem.animation.play(optionShit[i].name);
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		oswald = new FlxSprite();
		oswald.frames = Paths.getSparrowAtlas('ui/shitballs/oswald');
		oswald.animation.addByPrefix('happy', 'happy', 0, false);
		oswald.animation.addByPrefix('concerned', 'concerned', 0, false);
		oswald.animation.addByPrefix('shitballs', 'shitballs', 0, false);
		if(!states.PlayState.secondPhase && !states.PlayState.thirdPhase) oswald.animation.play('happy');
		if(states.PlayState.secondPhase) oswald.animation.play('concerned');
		if(states.PlayState.thirdPhase) oswald.animation.play('shitballs');
		oswald.updateHitbox();
		add(oswald);


		changeSelection();

		states.PlayState.blurFilter.blurX = 10;
		states.PlayState.blurFilter.blurY = 10;
		super.create();
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

		if(controls.BACK) {
			close();
			return;
		}

		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode)) {
			switch (optionShit[curSelected].name) {
				case "resume":
					close();
					states.PlayState.blurFilter.blurX = 0;
					states.PlayState.blurFilter.blurY = 0;
				case "restart":
					states.PlayState.blurFilter.blurX = 0;
					states.PlayState.blurFilter.blurY = 0;
					states.PlayState.instance.paused = true;
					FlxG.sound.music.volume = 0;
					states.PlayState.instance.vocals.volume = 0;

					states.PlayState.secondPhase = false;
					states.PlayState.thirdPhase = false;

					FlxG.resetState();
				case "exit":
					states.PlayState.blurFilter.blurX = 0;
					states.PlayState.blurFilter.blurY = 0;
					states.PlayState.deathCounter = 0;
					states.PlayState.seenCutscene = false;
					states.PlayState.secondPhase = false;
					states.PlayState.thirdPhase = false;

					FlxG.switchState(new states.MainMenuState());

					states.PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
			}
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;
	
		if (curSelected < 0) curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length) curSelected = 0;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.offset.x = 0;

			if (spr.ID == curSelected) {
				spr.offset.x = -25;
				selector.y = spr.y;
			}
		});
	}

	override function destroy() {
		pauseMusic.destroy();
		super.destroy();
	}
}