package substates;

import backend.Song;

class ComicSubstate extends MusicBeatSubstate {
    var text:FlxText;
    var backgrounds:Array<FlxSprite>;
    var currentBgIndex:Int = 0;
    var allBackgroundsVisible:Bool = false;
	var blackScreen:FlxSprite;
    var msucic:FlxSound;

    override function create() {
        backgrounds = [];

        msucic = new FlxSound();
        msucic.loadEmbedded(Paths.music('Comic music'), true, true);
        msucic.play(true);
        FlxG.sound.list.add(msucic);

        for (i in 0...6) {
            var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/comics/comic cutouts/intoTheBalls${i}'));
            bg.antialiasing = ClientPrefs.data.antialiasing;
            bg.alpha = 0;
            bg.scale.set(0.85, 0.85);
            bg.updateHitbox();
            bg.screenCenter();
            add(bg);
            backgrounds.push(bg);
        }

        FlxTween.tween(backgrounds[0], {alpha: 1}, 1.2, {ease: FlxEase.expoOut});

        text = new FlxText(0, 625, 505, "Press Space to continue", 30);
        text.setFormat(Paths.font("FallingSkyBlk.otf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.borderSize = 1.25;
        text.screenCenter(X);
        text.alpha = 0;
        add(text);

        FlxTween.tween(text, {alpha: 1}, 1.2, {ease: FlxEase.expoOut});

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackScreen.alpha = 0;
		add(blackScreen);

        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.ACCEPT) {
            if (!allBackgroundsVisible) {
                if (currentBgIndex < backgrounds.length - 1) {
                    currentBgIndex++;
                    FlxTween.tween(backgrounds[currentBgIndex], {alpha: 1}, 1.2, {ease: FlxEase.expoOut});
                } 
                if (currentBgIndex == backgrounds.length - 1) {
					allBackgroundsVisible = true;
					text.text = 'Press Enter to start!';
				}
            } else {
				FlxTween.tween(blackScreen, {alpha: 1}, 0.2, {ease: FlxEase.circIn, onComplete: function(twn:FlxTween) {
					states.PlayState.SONG = Song.loadFromJson('balls', 'balls');
					FlxG.switchState(new states.PlayState());
				}});
            }
        }

        if (controls.BACK) {
            msucic.destroy();
            close();
            return;
        }
    }
}
