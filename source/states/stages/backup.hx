package states.stages;

import states.stages.objects.*;
import objects.Character;

class StageWeek1 extends BaseStage {
	var walls:BGSprite;
	var balls:BGSprite;
	var bgpoka:BGSprite;
	var dark2:FlxSprite;
	var vinetka:BGSprite;
	var lampi:BGSprite;
	var lightening:FlxSprite;
	var offset:BGSprite;
	var linia:FlxSprite;
	var balls2:BGSprite;
	var walls2:BGSprite;
	var pool2:BGSprite;
	var light:FlxSprite;
	var dark:FlxSprite;
	var doIt:Bool = false;
	var idiotP:Int;
	var idiotO:Int;

	override function create() {
		walls = new BGSprite('bg/Walls_and_ground', -366, -133);
		add(walls);

		balls = new BGSprite('bg/Pool_lol', -125, 294);
		add(balls);

		bgpoka = new BGSprite('bg/Bg_itself', -496, -473);
		bgpoka.scale.set(1.3, 1.3);
		bgpoka.updateHitbox();

		dark2 = new FlxSprite().makeGraphic(FlxColor.BLACK, FlxG.width * 2, FlxG.height * 2);
		dark2.alpha = 0.4;
		dark2.scrollFactor.set(0, 0);

		vinetka = new BGSprite('bg/Vinetka', -496, -473);
		vinetka.scale.set(1.3, 1.3);
		vinetka.updateHitbox();
		vinetka.scrollFactor.set(0, 0);

		lampi = new BGSprite('bg/Lamps', -286, -138);
		lampi.scale.set(1.3, 1.3);
		lampi.updateHitbox();

		lightening = new FlxSprite(-300, -166);
		lightening.frames = Paths.getSparrowAtlas('bg/Biden_blasts');
		lightening.animation.addByPrefix('Biden blasts', "Biden blasts", 24, true);
		lightening.scale.set(1.3, 1.3);
		lightening.updateHitbox();

		offset = new BGSprite('bg/Pivo', -23, -200);

		linia = new FlxSprite(13, -200);
		linia.frames = Paths.getSparrowAtlas('bg/BASED_LINE');
		linia.animation.addByPrefix('line', "line", 24, true);

		balls2 = new BGSprite('bg/Background_second', -1333, -133);

		walls2 = new BGSprite('bg/Walls_ye', -200, -173);

		pool2 = new BGSprite('bg/Pool', -286, -86);

		light = new FlxSprite(-500, -333);
		light.frames = Paths.getSparrowAtlas('bg/Lamp');
		light.animation.addByPrefix('Lamp', "Lamp", 24, true);

		dark = new FlxSprite().makeGraphic(FlxColor.BLACK, FlxG.width * 2, FlxG.height * 2);
		dark.alpha = 0.26;
		dark2.scrollFactor.set(0, 0);
	}

	override function createPost() {
		PlayState.instance.remove(balls);
		PlayState.instance.remove(gfGroup);
		PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, balls);
		PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, gfGroup);

		game.skipCountdown = true;
		game.boyfriend.visible = false;
	}

	override function stepHit() {
		if (curStep == 1 && !doIt) {
			doIt = true;
			for (i in 0...4) {
				idiotP = game.playerStrums.members[i].x;
				idiotO = game.opponentStrums.members[i].x;
				game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)].x = idiotP;
				game.strumLineNotes.members[Std.int((i + 4) % game.strumLineNotes.length)].x = idiotO;
			}
		}

		if (curStep == 60) {
			game.boyfriend.visible = true;
			// game.boyfriend.playAnim(appear, true);
			// game.boyfriend.specialAnim = true;
		}

		if (curStep > 847) {
			PlayState.instance.remove(gfGroup);
			PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) - 1, gfGroup);
		}

		if (curStep == 848 && doIt) {
			doIt = false;

			for (i in 0...4) {
				idiotP = game.opponentStrums.members[i].x;
				idiotO = game.playerStrums.members[i].x;
				game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)].x = idiotO;
				game.strumLineNotes.members[Std.int((i + 4) % game.strumLineNotes.length)].x = idiotP;
			}
		}

		if (curStep == 2239 && !doIt) {
			doIt = false;

			for (i in 0...4) {
				idiotP = game.playerStrums.members[i].x;
				idiotO = game.opponentStrums.members[i].x;
				game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)].x = idiotP;
				game.strumLineNotes.members[Std.int((i + 4) % game.strumLineNotes.length)].x = idiotO;
			}
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch(eventName) {
			case "Change Room":
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val) {
					case 1, 2, 3, 4:
						if(val == 1) {
							walls.destroy();
							balls.destroy();
							add(balls2);
						}
						
						if (val == 2) {
							balls2.destroy();
							add(walls2);
							add(pool2);
							PlayState.instance.remove(light);
							PlayState.instance.insert(9, light);
							add(light);
							light.animation.play('Lamp');
							add(dark);
						}
						
						if (val == 3) {
							walls2.destroy();
							pool2.destroy();
							light.destroy();
							dark.destroy();

							PlayState.instance.remove(offset);
							PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, balls);
							add(offset);
							linia.animation.play('line');
							add(linia);
						}

						if (val == 4) {
							linia.destroy();
							offset.destroy();

							add(bgpoka);
							add(dark2);
							add(vinetka);
							add(lampi);
							lightening.animation.play('Biden blasts');
							add(lightening);
						}

					default:
				}
		}
	}
}