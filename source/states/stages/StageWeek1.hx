package states.stages;

import states.stages.objects.*;
import objects.Character;
import objects.StrumNote;
import sys.thread.Thread;
import backend.VideoSprite;

class StageWeek1 extends BaseStage {
	var walls:BGSprite;
	var balls:BGSprite;
	var bgpoka:BGSprite;
	var dark2:FlxSprite;
	var lightening:FlxSprite;
	var offset:BGSprite;
	var linia:FlxSprite;
	var balls2:BGSprite;
	var walls2:BGSprite;
	var light:FlxSprite;
	var dark:FlxSprite;
	var doIt:Bool = false;
	var idiotP:Int;
	var idiotO:Int;

	var dont:FlxSprite;
	var miss:FlxSprite;
	var bonnybonbaw:FlxSprite;
	var comic2:FlxSprite;

	var spacee:FlxSprite;
	var strangling:Bool = false;
	var video:VideoSprite;
	var pitiful:FlxSprite;

	override function create() {
		walls = new BGSprite('bg/Walls_and_ground', -366, -133);
		add(walls);

		balls = new BGSprite('bg/Pool_lol', -125, 294);
		add(balls);

		bgpoka = new BGSprite('bg/Bg_itself', -496, -473);
		bgpoka.scale.set(1.3, 1.3);
		bgpoka.updateHitbox();

		lightening = new FlxSprite(-300, -166);
		lightening.frames = Paths.getSparrowAtlas('bg/Biden_blasts');
		lightening.antialiasing = ClientPrefs.data.antialiasing;
		lightening.animation.addByPrefix('Biden blasts', "Biden blasts", 24, true);
		lightening.scale.set(1.3, 1.3);
		lightening.updateHitbox();

		offset = new BGSprite('bg/Pivo', -23, -200);

		linia = new FlxSprite(13, -200);
		linia.frames = Paths.getSparrowAtlas('bg/BASED_LINE');
		linia.antialiasing = ClientPrefs.data.antialiasing;
		linia.animation.addByPrefix('line', "line", 24, true);

		balls2 = new BGSprite('bg/Background_second', -468, -133);

		walls2 = new BGSprite('bg/Walls_ye', -200, -173);

		light = new FlxSprite(-500, -333);
		light.frames = Paths.getSparrowAtlas('bg/Lamp');
		light.antialiasing = ClientPrefs.data.antialiasing;
		light.animation.addByPrefix('Lamp', "Lamp", 24, true);

		dark = new FlxSprite().makeGraphic(FlxColor.BLACK, FlxG.width * 2, FlxG.height * 2);
		dark.alpha = 0.26;
		dark.scrollFactor.set(0, 0);
		dark.screenCenter();
		dark.updateHitbox();
		dark.cameras = [game.camOther];
		
		dont = new FlxSprite(715, 100);
		dont.frames = Paths.getSparrowAtlas('ui/dont/dont');
		dont.antialiasing = ClientPrefs.data.antialiasing;
		dont.animation.addByPrefix('dont', "dont", 24, true);
		dont.updateHitbox();
		dont.cameras = [game.camOther];
		dont.alpha = 0;

		miss = new FlxSprite(750, 420);
		miss.frames = Paths.getSparrowAtlas('ui/dont/miss');
		miss.antialiasing = ClientPrefs.data.antialiasing;
		miss.animation.addByPrefix('dont', "dont", 24, true);
		miss.updateHitbox();
		miss.cameras = [game.camOther];
		miss.alpha = 0;

		bonnybonbaw = new FlxSprite(-10);
		bonnybonbaw.frames = Paths.getSparrowAtlas('ui/dont/bon');
		bonnybonbaw.antialiasing = ClientPrefs.data.antialiasing;
		bonnybonbaw.animation.addByPrefix('bon', "bon", 24, false);
		bonnybonbaw.updateHitbox();
		bonnybonbaw.cameras = [game.camOther];
		bonnybonbaw.alpha = 0;

		spacee = new FlxSprite(400, 450);
		spacee.frames = Paths.getSparrowAtlas('ui/dont/space');
		spacee.antialiasing = ClientPrefs.data.antialiasing;
		spacee.animation.addByPrefix('space', "space", 24, true);
		spacee.updateHitbox();
		spacee.cameras = [game.camOther];
		spacee.alpha = 0;

		pitiful = new FlxSprite(440, 720).loadGraphic(Paths.image('ui/dont/pitiful'));
		pitiful.cameras = [game.camOther];
		pitiful.antialiasing = ClientPrefs.data.antialiasing;

		dark2 = new FlxSprite().makeGraphic(FlxColor.BLACK, FlxG.width * 2, FlxG.height * 2);
		dark2.alpha = 0.4;
		dark2.scrollFactor.set(0, 0);
		dark2.screenCenter();
		dark2.updateHitbox();
		dark2.cameras = [game.camOther];

		comic2 = new FlxSprite().loadGraphic(Paths.image('ui/comics/intoTheBalls2'));
		comic2.antialiasing = ClientPrefs.data.antialiasing;
		comic2.cameras = [game.camOther];
		comic2.alpha = 0;
	}

	override function createPost() {
		PlayState.instance.remove(balls);
		PlayState.instance.remove(gfGroup);
		PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, balls);
		PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, gfGroup);

		game.boyfriend.visible = false;
		game.camHUD.visible = false;
		game.camGame.visible = false;
		game.fliptheI = true;

		Thread.create(()->
		{
			video = new VideoSprite();
			video.autoScale = false;
			video.load(Paths.video('Cutscene_ayo'));
			video.cameras = [game.camOther];
		});
	}

	override function stepHit() {
		if (curStep == 1 && !doIt) {
			game.iconP1.flipX = true;
			game.iconP2.flipX = true;
			game.camGame.visible = true;
			doIt = true;
	
			for (i in 0...4) {
				idiotP = game.playerStrums.members[i].x;
				idiotO = game.opponentStrums.members[i].x;
				game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)].x = idiotP;
				game.strumLineNotes.members[Std.int((i + 4) % game.strumLineNotes.length)].x = idiotO;
			}
		}

		if (curStep == 60) game.boyfriend.visible = true;

		if (curStep == 64) {
			game.camHUD.alpha = 0;
			FlxTween.tween(game.camHUD, {alpha: 1}, 0.3, {ease: FlxEase.linear});
			game.camHUD.visible = true;
		}


		if (curStep > 847) {
			PlayState.instance.remove(gfGroup);
			PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) - 1, gfGroup);
		}

		if (curStep == 848 && doIt) {
			doIt = false;
			game.fliptheI = false;
			game.iconP1.flipX = false;
			game.iconP2.flipX = false;

			for (i in 0...4) {
				idiotP = game.opponentStrums.members[i].x;
				idiotO = game.playerStrums.members[i].x;
				FlxTween.tween(game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)], {x: idiotO}, 1, {ease: FlxEase.linear});
				FlxTween.tween(game.strumLineNotes.members[Std.int((i + 4) % game.strumLineNotes.length)], {x: idiotP}, 1, {ease: FlxEase.linear});
			}
		}

		if (curStep == 1264) FlxTween.tween(game.camHUD, {alpha: 0.5}, 0.5, {ease: FlxEase.linear});

		if (curStep == 1288) game.gf.visible = false;

		if (curStep == 1296)  FlxTween.tween(game.camHUD, {alpha: 1}, 0.1, {ease: FlxEase.linear});

		if (curStep == 1360) FlxTween.tween(game.camHUD, {alpha: 0}, 1, {ease: FlxEase.linear});

		if (curStep == 1381) game.dad.visible = false;

		if (curStep == 1408) {
			states.PlayState.secondPhase = true;
			game.gf.visible = true;
			if (!ClientPrefs.data.hideHud) {
				game.healthBar.visible = false;
				game.iconP1.visible = false;
				game.iconP2.visible = false;
				game.scoreTxt.visible = false;
			}
			FlxTween.tween(game.camHUD, {alpha: 1}, 10, {ease: FlxEase.linear});
			for (i in 0...4) game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)].alpha = 0;
		}

		if (curStep == 2071) {
			states.PlayState.secondPhase = false;
			states.PlayState.thirdPhase = true;
			FlxTween.tween(game.camHUD, {alpha: 0}, 0.1, {ease: FlxEase.linear});
			FlxTween.tween(game.camGame, {alpha: 0}, 0.1, {ease: FlxEase.linear});
		}

		if (curStep == 2075) FlxTween.tween(game.boyfriend, {alpha: 0}, 0.0001, {ease: FlxEase.linear});

		if (curStep == 2111) game.cameraSpeed = 700;

		if (curStep == 2112) {
			game.iconP2.y -= 30;
			game.drainnnnn = true;
			game.cameraSpeed = 1;
			game.gf.visible = false;
			game.dad.visible = false;
			game.camHUD.alpha = 0;
			FlxTween.tween(game.camGame, {alpha: 1}, 0.1, {ease: FlxEase.linear});
		}

		if (curStep == 2198) FlxTween.tween(game.boyfriend, {alpha: 1}, 0.0001, {ease: FlxEase.linear});

		if (curStep == 2224) game.dad.visible = true;

		if (curStep == 2240) {
			game.dad.visible = true;
			game.dad.alpha = 1;
			FlxTween.tween(game.camHUD, {alpha: 1}, 0.1, {ease: FlxEase.linear});
			if (!ClientPrefs.data.hideHud) {
				game.healthBar.visible = true;
				game.iconP1.visible = true;
				game.iconP2.visible = true;
				game.scoreTxt.visible = true;
			}
		}

		if (curStep == 2071) {
			add(comic2);
			FlxTween.tween(comic2, {alpha: 1}, 0.5, {ease: FlxEase.linear});
		}

		if (curStep == 2519) FlxTween.tween(pitiful, {y: -pitiful.height}, 1.5, {ease: FlxEase.expoIn, onComplete: function(twn:FlxTween) {
			pitiful.destroy();
		}});

		if (curStep == 2110) FlxTween.tween(comic2, {alpha: 0}, 0.2, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {comic2.destroy();}});

		if (curStep == 2495) {
			add(pitiful);
			FlxTween.tween(pitiful, {y: 256}, 1, {ease: FlxEase.expoOut});
		}

		if (curStep == 2879) FlxTween.tween(dark, {alpha: 0.7}, 2, {ease: FlxEase.linear});

		if (curStep == 2895) {
			add(dont);
			add(miss);
			add(bonnybonbaw);
			dont.animation.play('dont');
			miss.animation.play('miss');
			bonnybonbaw.animation.play('bon');
			FlxTween.tween(dont, {alpha: 1}, 0.5, {ease: FlxEase.linear});
			FlxTween.tween(miss, {alpha: 1}, 0.5, {ease: FlxEase.linear});
			FlxTween.tween(bonnybonbaw, {alpha: 1}, 0.1, {ease: FlxEase.linear});
		}

		if (curStep == 2911) {
			FlxTween.tween(dark, {alpha: 0.26}, 0.5, {ease: FlxEase.linear});
			FlxTween.tween(dont, {alpha: 0}, 0.2, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {
				dont.destroy();
				miss.destroy();
				bonnybonbaw.destroy();
			}});
			FlxTween.tween(miss, {alpha: 0}, 0.2, {ease: FlxEase.linear});
			FlxTween.tween(bonnybonbaw, {alpha: 0}, 0.2, {ease: FlxEase.linear});
		}

		if (curStep == 3183) {
			game.cameraSpeed = 700;
			game.drainnnnn = false;
		}

		if (curStep == 3184) {
			game.cameraSpeed = 1;
			camHUD.alpha = 1;
			camGame.alpha = 1;
		}

		if (curStep == 3568) {
			FlxTween.tween(game.dad, {alpha: 0}, 12, {ease: FlxEase.linear});
			FlxTween.tween(game.iconP2, {alpha: 0}, 12, {ease: FlxEase.linear});
		}

		if (curStep == 3696) {
			FlxTween.tween(game.boyfriend, {alpha: 0}, 2, {ease: FlxEase.linear});
			FlxTween.tween(game.camHUD, {alpha: 0}, 2, {ease: FlxEase.linear});
			FlxTween.tween(game.camGame, {alpha: 0}, 1, {ease: FlxEase.linear});
		}

		if (curStep == 3736) {
			FlxTween.tween(game.iconP2, {alpha: 1}, 0.0001, {ease: FlxEase.linear});
			FlxTween.tween(game.dad, {alpha: 1}, 0.0001, {ease: FlxEase.linear});
			FlxTween.tween(game.boyfriend, {alpha: 1}, 0.0001, {ease: FlxEase.linear});
			FlxTween.tween(game.camHUD, {alpha: 1}, 0.0001, {ease: FlxEase.linear});
			FlxTween.tween(game.camGame, {alpha: 1}, 0.0001, {ease: FlxEase.linear});
		}

		if (curStep == 3984) {
			strangling = true;
			add(spacee);
			spacee.animation.play('space', true);
			FlxTween.tween(spacee, {alpha: 1}, 0.5, {ease: FlxEase.linear});
		}

		if (curStep == 4232) {
			strangling = false;
			FlxTween.tween(spacee, {alpha: 0}, 0.2, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {
				spacee.destroy();
			}});
		}

		if (curStep == 4240) {
			FlxTween.tween(game.camHUD, {alpha: 0}, 0.1, {ease: FlxEase.linear});
			FlxTween.tween(game.camGame, {alpha: 0}, 0.1, {ease: FlxEase.linear});
		}

		if (curStep == 4260)
		{
			Thread.create(()->
			{
				inCutscene = true;

				video.bitmap.onEndReached.add(Thread.create.bind(() ->
				{
					video.visible = false;
					game.startAndEnd();
					return;
				}));
				video.play();
				add(video);
			});
		}
	}

	override function update(elapsed:Float) {
		if (strangling) {
			if (FlxG.keys.justPressed.SPACE) game.health += 0.08;
			game.health -= 0.01 * elapsed * 60;
		}
		super.update(elapsed);
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch(eventName) {
			case "Change Room":
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val) {
					case 1, 2, 3, 4, 5:
						if(val == 1) {
							walls.destroy();
							balls.destroy();
							add(balls2);
						}
						
						if (val == 2) {
							balls2.destroy();
							add(walls2);
							PlayState.instance.remove(light);
							PlayState.instance.insert(Std.int(members.indexOf(game.boyfriendGroup)) + 1, light);
							add(light);
							if (ClientPrefs.data.flashing) light.animation.play('Lamp');
							add(dark);
						}
						
						if (val == 3) {
							walls2.destroy();
							light.destroy();
							dark.destroy();

							PlayState.instance.remove(offset);
							PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, offset);
							add(offset);
							PlayState.instance.remove(linia);
							PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 2, linia);
							linia.animation.play('line');
							add(linia);
						}

						if (val == 4) {
							linia.destroy();
							offset.destroy();

							add(bgpoka);
							add(dark2);
							if (ClientPrefs.data.flashing) lightening.animation.play('Biden blasts');
							add(lightening);
						}

						if (val == 5) {
							bgpoka.destroy();
							dark2.destroy();
							lightening.destroy();
						}
					default:
				}
			case "Smooth cam zoom":
				if(flValue1 == null) flValue1 = 0;
				if(flValue2 == null) flValue2 = 0;

				FlxTween.tween(game.camGame, {zoom: flValue1}, flValue2, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween) {
					game.defaultCamZoom = game.camGame.zoom;
				}});
			case "CameraZoom":
				if(flValue1 == null) flValue1 = 0;
				if(flValue2 == null) flValue2 = 0;

				FlxTween.tween(game.camGame, {zoom: flValue1 + 0.1}, flValue2, {ease: FlxEase.circOut});
			case "Camera Flash":
				if(flValue1 == null) flValue1 = 0;

				if (ClientPrefs.data.flashing) game.camOther.flash(FlxColor.WHITE, flValue1, null, true);
			case "Change Icon":
				if(flValue1 == 1) {
					game.iconP2.changeIcon(game.gf.healthIcon);
					game.healthBar.setColors(FlxColor.fromRGB(game.gf.healthColorArray[0], game.gf.healthColorArray[1], game.gf.healthColorArray[2]), FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
					game.checkIcon();
				} else {
					game.iconP2.changeIcon(game.dad.healthIcon);
					game.reloadHealthBarColors();
					game.checkIcon();
				}
		}
	}
}