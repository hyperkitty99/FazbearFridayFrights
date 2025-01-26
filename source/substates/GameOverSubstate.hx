package substates;

import objects.Character;
import flixel.FlxObject;

class GameOverSubstate extends MusicBeatSubstate {
	public var boyfriend:Character;
	var playingDeathSound:Bool = false;

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;
	var timer:FlxTimer;
	var deathtimer:FlxTimer;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = states.PlayState.SONG;
		if(_song != null) {
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	override function create() {
		FlxG.camera.zoom = 0.9;
		instance = this;

		Conductor.songPosition = 0;

		boyfriend = new Character(-610, -570, characterName, true);
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));

		boyfriend.playAnim('firstDeath');
		super.create();
	}

	public var startedDeath:Bool = false;
	var isEnding:Bool = false;
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.ACCEPT) {
			if (!isEnding) {
				isEnding = true;
				boyfriend.playAnim('deathConfirm', true);
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music(endSoundName));
				deathtimer = new FlxTimer().start(0.7, function(tmr:FlxTimer) {FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {FlxG.resetState();});});
			}
		}

		if (controls.BACK) {
			if (!isEnding) {
				isEnding = true;
				FlxG.sound.music.stop();
				if (timer != null) timer.cancel();
				if (deathtimer != null) deathtimer.cancel();
				states.PlayState.deathCounter = 0;
				states.PlayState.seenCutscene = false;
				states.PlayState.chartingMode = false;
	
				FlxG.switchState(new states.MainMenuState());
			}
		}
		
		if (boyfriend.animation.curAnim != null) {
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath){
				new FlxTimer().start(0.8, function(tmr:FlxTimer) {
					boyfriend.playAnim('deathLoop');
				});
			}

			if(boyfriend.animation.curAnim.name == 'firstDeath') {
				if (boyfriend.animation.curAnim.finished && !playingDeathSound) {
					timer = new FlxTimer().start(0.8, function(tmr:FlxTimer) {
						startedDeath = true;
						FlxG.sound.playMusic(Paths.music(loopSoundName), 1);
					});
				}
			}
		}
		
		if (FlxG.sound.music.playing) Conductor.songPosition = FlxG.sound.music.time;
	}

	override function destroy() {
		instance = null;
		super.destroy();
	}
}
