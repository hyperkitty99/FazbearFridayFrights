package states.editors;

import objects.Character;

import states.MainMenuState;

class MasterEditorMenu extends MusicBeatState {
	var options:Array<String> = [
		'Chart Editor',
		'Character Editor',
		'Week Editor',
		'Note Splash Debug'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var curSelected = 0;

	override function create() {
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Editors Main Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length) {
			var leText:Alphabet = new Alphabet(90, 320, options[i], true);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
			leText.snapToPosition();
		}

		changeSelection();

		FlxG.mouse.visible = false;
		super.create();
	}

	override function update(elapsed:Float) {
		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		if (controls.BACK) MusicBeatState.switchState(new MainMenuState());

		if (controls.ACCEPT) {
			switch(options[curSelected]) {
				case 'Chart Editor':
			    	MusicBeatState.switchState(new ChartingState());
				case 'Character Editor':
					MusicBeatState.switchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
				case 'Week Editor':
					MusicBeatState.switchState(new WeekEditorState());
				case 'Note Splash Debug':
					MusicBeatState.switchState(new NoteSplashDebugState());
			}
			FlxG.sound.music.volume = 0;
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.targetY == 0 ? item.alpha = 1 : item.alpha = 0.6;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0) {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		if (curSelected < 0) curSelected = options.length - 1;
		if (curSelected >= options.length) curSelected = 0;
	}
}