package substates;

class BallsSubstate extends MusicBeatSubstate {
	var oswald:FlxSprite;
	var movingSprite:FlxSprite;

	override function create() {
		Conductor.songPosition = 0;

		FlxG.sound.play(Paths.sound('fellIntoHisLies'));

		var bg:FlxSprite = new FlxSprite(-640, -360).loadGraphic(Paths.image('ui/death/bg'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

        movingSprite = new FlxSprite(-640, -340).loadGraphic(Paths.image('ui/death/car'));
        movingSprite.antialiasing = ClientPrefs.data.antialiasing;
		movingSprite.scale.set(1.15, 1.15);

		oswald = new FlxSprite(-492, -210);
		oswald.frames = Paths.getSparrowAtlas('ui/death/oswald');
		oswald.animation.addByPrefix('oswald', "oswald", false);
		oswald.animation.play('oswald');
		oswald.antialiasing = ClientPrefs.data.antialiasing;
		add(oswald);

		new FlxTimer().start(2, function(tmr:FlxTimer) {
			bg.destroy();
		});

		new FlxTimer().start(2.8, function(tmr:FlxTimer) {
			add(movingSprite);
			FlxG.camera.shake(0.0075, 3, null, true, Y);
			new FlxTimer().start(1.8, function(tmr:FlxTimer) {
				FlxG.camera.fade(FlxColor.BLACK, 1.2, false, function() {
					MusicBeatState.resetState();
				});
			});
		});

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (oswald.animation.curAnim.finished) oswald.kill();
	}
}
