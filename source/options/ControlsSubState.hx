package options;

import backend.InputFormatter;
import objects.AttachedSprite;
import options.Option;

import flixel.input.keyboard.FlxKey;

class ControlsSubState extends MusicBeatSubstate {
	var curSelected:Int = 0;
	var curAlt:Bool = false;

	var options:Array<Dynamic> = [
		[true, 'Notes'],
		[true, 'Left', 'note_left', 'Note Left'],
		[true, 'Down', 'note_down', 'Note Down'],
		[true, 'Up', 'note_up', 'Note Up'],
		[true, 'Right', 'note_right', 'Note Right'],
		[true, ''],
		[true, 'UI'],
		[true, 'Left', 'ui_left', 'UI Left'],
		[true, 'Down', 'ui_down', 'UI Down'],
		[true, 'Up', 'ui_up', 'UI Up'],
		[true, 'Right', 'ui_right', 'UI Right']
	];

	var labels:Array<Dynamic> = [
		'Visuals and UI',
		'Graphics',
		'Gameplay'
	];
	var curOptions:Array<Int>;
	var curOptionsValid:Array<Int>;

	var grpDisplay:FlxTypedGroup<Alphabet>;
	var grpBlacks:FlxTypedGroup<AttachedSprite>;
	var grpOptions:FlxTypedGroup<Alphabet>;
	var grpBinds:FlxTypedGroup<Alphabet>;
	var selectSpr:AttachedSprite;

	private var grpOptions2:FlxTypedGroup<Alphabet>;
	private var grpLabels:FlxTypedGroup<Alphabet>;
	private var grpChecks:FlxTypedGroup<AttachedSprite>;
	private var grpBlacks2:FlxTypedGroup<AttachedSprite>;

	private var curSelected2:Int = 0;

	private var curOption:Option = null;
	private var optionThingies:Array<Option> = [
		new Option('Hide HUD', 'hideHud'),
		new Option('Flashing Lights', 'flashing'),
		new Option('Camera Zooms', 'camZooms'),
		new Option('FPS Counter', 'showFPS'),

		new Option('Anti-Aliasing', 'antialiasing'),
		new Option('Shaders', 'shaders'),
		new Option('GPU Caching', 'cacheOnGPU'),

		new Option('Guitar Hero Sustains', 'guitarHeroSustains'),
		new Option('Downscroll', 'downScroll'),
		new Option('Ghost Tapping', 'ghostTapping')
	];

	var pages:FlxSprite;
	var doEverything:Bool = false;
	
	public function new() {
		super();

		options.push([true]);
		options.push([true]);

		grpDisplay = new FlxTypedGroup<Alphabet>();
		add(grpDisplay);
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);
		grpBlacks = new FlxTypedGroup<AttachedSprite>();
		add(grpBlacks);
		selectSpr = new AttachedSprite();
		selectSpr.loadGraphic(Paths.image('ui/options/button'));
		selectSpr.scale.set(1.05, 1.1);
		add(selectSpr);
		grpBinds = new FlxTypedGroup<Alphabet>();
		add(grpBinds);

		createTexts();

		grpBlacks2 = new FlxTypedGroup<AttachedSprite>();
		add(grpBlacks2);
		grpOptions2 = new FlxTypedGroup<Alphabet>();
		add(grpOptions2);
		grpLabels = new FlxTypedGroup<Alphabet>();
		add(grpLabels);
		grpChecks = new FlxTypedGroup<AttachedSprite>();
		add(grpChecks);

        optionThingies[3].onChange = onChangeFPSCounter;

		for (i in 0...optionThingies.length) {
			var optionText:Alphabet = new Alphabet(730, 110, optionThingies[i].name, false);
			optionText.y = optionText.y + i * 38;
			optionText.setScale(0.4, 0.4);
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			grpOptions2.add(optionText);

			if (i >= 4) grpOptions2.members[i].y += 60;
			if (i >= 7) grpOptions2.members[i].y += 60;

			var black:AttachedSprite = new AttachedSprite();
			black.loadGraphic(Paths.image('ui/options/box'));
			black.sprTracker = optionText;
			black.yAdd = 17;
			black.xAdd = 280;
			black.antialiasing = ClientPrefs.data.antialiasing;
			grpBlacks2.add(black);

			var check:AttachedSprite = new AttachedSprite();
			check.loadGraphic(Paths.image('ui/options/check'));
			check.sprTracker = optionText;
			check.yAdd = 20;
			check.xAdd = 285;
			check.antialiasing = ClientPrefs.data.antialiasing;
			check.visible = (optionThingies[i].getValue() ? true : false);
			grpChecks.add(check);
		}

		for (i in 0...labels.length) {
			var optionText:Alphabet = new Alphabet(700, 50, labels[i], false);
			optionText.y = optionText.y + i * 160;
			optionText.setScale(0.6, 0.6);
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			grpLabels.add(optionText);

			if (i >= 1) grpLabels.members[i].y += 55;
		}

		reloadCheckboxes();

		pages = new FlxSprite(201, -95);
		pages.frames = Paths.getSparrowAtlas('ui/mainmenu/option');
		pages.animation.addByPrefix('options', 'options0', 24, false);
		pages.animation.addByPrefix('optionsReverse', 'optionsReverse', 24, false);
		pages.updateHitbox();
		add(pages);

		pages.animation.play('options');

		grpDisplay.visible = false;
		grpOptions.visible = false;
		grpBlacks.visible = false;
		selectSpr.visible = false;
		grpBinds.visible = false;
			
		pages.animation.finishCallback = function(s:String) {
			pages.visible = false;
			doEverything = true;
			grpDisplay.visible = true;
			grpOptions.visible = true;
			grpBlacks.visible = true;
			selectSpr.visible = true;
			grpBinds.visible = true;
		}
	}

	function reloadCheckboxes() for (i in 0...optionThingies.length) grpChecks.members[i].visible = (optionThingies[i].getValue() ? true : false);

	function createTexts() {
		curOptions = [];
		curOptionsValid = [];
		grpDisplay.forEachAlive(function(text:Alphabet) text.destroy());
		grpBlacks.forEachAlive(function(black:AttachedSprite) black.destroy());
		grpOptions.forEachAlive(function(text:Alphabet) text.destroy());
		grpBinds.forEachAlive(function(text:Alphabet) text.destroy());
		grpDisplay.clear();
		grpBlacks.clear();
		grpOptions.clear();
		grpBinds.clear();

		var myID:Int = 0;
		for (i in 0...options.length) {
			var option:Array<Dynamic> = options[i];
			if(option[0]) {
				if(option.length > 1) {
					var text:Alphabet = new Alphabet(255, 83, option[1], false);
					text.isMenuItem = true;
					text.changeX = false;
					text.distancePerItem.y = 34;
					text.targetY = myID;
					text.setScale(0.4, 0.4);
					if(option.length < 3)
						grpDisplay.add(text);
					else {
						grpOptions.add(text);
						curOptions.push(i);
						curOptionsValid.push(myID);
					}
					text.ID = myID;

					if(option.length < 3) addCenteredText(text, option, myID);
					else addKeyText(text, option, myID);

					text.snapToPosition();
				}
				myID++;
			}
		}
		updateText();
	}

	function addCenteredText(text:Alphabet, option:Array<Dynamic>, id:Int) {
		text.screenCenter(X);
		text.setScale(0.6, 0.6);
		text.y -= 50;
		text.x -= 225;
		text.startPosition.y -= 30;
	}

	function addKeyText(text:Alphabet, option:Array<Dynamic>, id:Int) {
		for (n in 0...2) {
			var key:String = null;
			var savKey:Array<Null<FlxKey>> = ClientPrefs.keyBinds.get(option[2]);
			key = InputFormatter.getKeyName((savKey[n] != null) ? savKey[n] : NONE);

			var attach:Alphabet = new Alphabet(400 + n * 120, 86, key, false);
			attach.isMenuItem = true;
			attach.changeX = false;
			attach.distancePerItem.y = 34;
			attach.targetY = text.targetY;
			attach.setScale(0.3, 0.3);
			attach.ID = Math.floor(grpBinds.length / 2);
			attach.snapToPosition();
			grpBinds.add(attach);

			attach.scaleX = Math.min(0.3, 100 / attach.width);

			var black:AttachedSprite = new AttachedSprite();
			black.loadGraphic(Paths.image('ui/options/button'));
			black.sprTracker = text;
			black.yAdd = 14;
			black.xAdd = 139 + n * 120;
			grpBlacks.add(black);
		}
	}

	function updateBind(num:Int, text:String) {
		var bind:Alphabet = grpBinds.members[num];
		var attach:Alphabet = new Alphabet(400 + (num % 2) * 110, 86, text, false);
		attach.isMenuItem = true;
		attach.changeX = false;
		attach.distancePerItem.y = 34;
		attach.targetY = bind.targetY;
		attach.setScale(0.3, 0.3);
		attach.ID = bind.ID;
		attach.x = bind.x;
		attach.y = bind.y;

		attach.scaleX = Math.min(0.3, 100 / attach.width);

		bind.kill();
		grpBinds.remove(bind);
		grpBinds.insert(num, attach);
		bind.destroy();
	}

	function onChangeFPSCounter() if (Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;

	var binding:Bool = false;
	var holdingEsc:Float = 0;
	var timeForMoving:Float = 0.1;
	override function update(elapsed:Float) {
		if (doEverything) {
			if(timeForMoving > 0) {
				timeForMoving = Math.max(0, timeForMoving - elapsed);
				super.update(elapsed);
				return;
			}	

			for (i in 0...optionThingies.length) {
				if (FlxG.mouse.overlaps(grpBlacks2.members[i])) {
					curSelected2 = i;
					curOption = optionThingies[curSelected2];
		
					if (FlxG.mouse.justPressed) {
						FlxG.sound.play(Paths.sound('checkmarki'), 1);
						curOption.setValue((curOption.getValue()) ? false : true);
						curOption.change();
						reloadCheckboxes();
					}
				}
			}
	
			if(!binding) {
				if(FlxG.keys.justPressed.ESCAPE) {
					FlxG.sound.play(Paths.sound('paper/paper' + FlxG.random.int(1, 4)));
					pages.visible = true;
					pages.animation.play('optionsReverse');
					grpDisplay.visible = false;
					grpOptions.visible = false;
					grpBlacks.visible = false;
					selectSpr.visible = false;
					grpBinds.visible = false;
					states.MainMenuState.menuItems.visible = true;
					states.MainMenuState.selector.y = 435;
			
					pages.animation.finishCallback = function(s:String) {
						ClientPrefs.saveSettings();
						ClientPrefs.loadPrefs();
						close();
						return;
					}
					doEverything = false;
				}
	
				if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT) updateAlt(true);
				if(FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN) updateText(FlxG.keys.justPressed.UP ? -1 : 1);
	
				if(FlxG.keys.justPressed.ENTER) {
					binding = true;
					holdingEsc = 0;
					ClientPrefs.toggleVolumeKeys(false);
				}
			} else {
				var altNum:Int = curAlt ? 1 : 0;
				var curOption:Array<Dynamic> = options[curOptions[curSelected]];
				if(FlxG.keys.pressed.ESCAPE || FlxG.keys.pressed.BACKSPACE) {
					holdingEsc += elapsed;
					if(holdingEsc > 0.5) {
						binding = false;
						ClientPrefs.reloadVolumeKeys();
					}
				} else {
					holdingEsc = 0;
					var changed:Bool = false;
					var curKeys:Array<FlxKey> = ClientPrefs.keyBinds.get(curOption[2]);
	
					if(FlxG.keys.justPressed.ANY || FlxG.keys.justReleased.ANY) {
						var keyPressed:Int = FlxG.keys.firstJustPressed();
						var keyReleased:Int = FlxG.keys.firstJustReleased();
						if (keyPressed > -1 && keyPressed != FlxKey.ESCAPE && keyPressed != FlxKey.BACKSPACE) {
							curKeys[altNum] = keyPressed;
							changed = true;
						} else if (keyReleased > -1 && (keyReleased == FlxKey.ESCAPE || keyReleased == FlxKey.BACKSPACE)) {
							curKeys[altNum] = keyReleased;
							changed = true;
						}
					}
	
					if(changed) {
						if(curKeys[altNum] == curKeys[1 - altNum]) curKeys[1 - altNum] = FlxKey.NONE;
	
						var option:String = options[curOptions[curSelected]][2];
						ClientPrefs.clearInvalidKeys(option);
						for (n in 0...2) {
							var key:String = null;
							var savKey:Array<Null<FlxKey>> = ClientPrefs.keyBinds.get(option);
							key = InputFormatter.getKeyName(savKey[n] != null ? savKey[n] : NONE);
							updateBind(Math.floor(curSelected * 2) + n, key);
						}
						FlxG.sound.play(Paths.sound('checkmarki'), 1);
						binding = false;
						ClientPrefs.reloadVolumeKeys();
					}
				}
			}
		}
		super.update(elapsed);
	}

	function updateText(?move:Int = 0) {
		if(move != 0) {
			curSelected += move;

			if(curSelected < 0) curSelected = curOptions.length - 1;
			else if (curSelected >= curOptions.length) curSelected = 0;
		}

		updateAlt();
	}

	function updateAlt(?doSwap:Bool = false) {
		if(doSwap) curAlt = !curAlt;

		selectSpr.sprTracker = grpBlacks.members[Math.floor(curSelected * 2) + (curAlt ? 1 : 0)];
		selectSpr.visible = (selectSpr.sprTracker != null);

	}
}