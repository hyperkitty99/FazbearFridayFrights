/* 
if i ever release the source code
TRIGGER WARNING: SHITTY CODE INCOMING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

package states;

import flixel.addons.transition.FlxTransitionableState;
import openfl.filters.BlurFilter;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.input.keyboard.FlxKey;

#if VIDEOS_ALLOWED
import sys.thread.Thread;
import backend.VideoSprite;
#end

typedef MainMenuButton = {
	var x:Int;
	var y:Int;
	var name:String;
	var hovered:Bool;
}

class MainMenuState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var curSelected:Int = 0;

	var optionShit:Array<MainMenuButton> = [
		{x: 265,  y: 250, name: 'freeplay', hovered: false},
		{x: 265,  y: 340, name: 'credits', hovered: false},
		{x: 265,  y: 435, name: 'options', hovered: false}
	];	

	public static var menuItems:FlxTypedGroup<FlxSprite>;
	public static var selector:FlxSprite;
	var book:FlxSprite;

	static final defaultZoom:Float = 1;

	var openedBook:Bool = false;
	var opening:Bool = true;

	var blurFilter:BlurFilter;
	var black:FlxSprite;

	var vingette:FlxSprite;
	var video:VideoSprite;

	var msucic:FlxSound;
	var emitter:FlxEmitter;

	override function create() {
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxG.mouse.visible = true;
		FlxSprite.defaultAntialiasing = ClientPrefs.data.antialiasing;

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		add(new FlxSprite(-320, -180, Paths.image("ui/mainmenu/bg")));

		book = new FlxSprite();
		book.frames = Paths.getSparrowAtlas('ui/mainmenu/book');
		book.animation.addByPrefix('open', 'Book cover flip', 24, false);
		book.animation.addByPrefix('opened', 'Book opened', 0, false);
		book.animation.addByPrefix('empty', 'empty', 0, false);
		book.screenCenter();
		book.updateHitbox();
		add(book);

		add(selector = new FlxSprite(265, -500, Paths.image("ui/mainmenu/selector")));

		add(menuItems = new FlxTypedGroup<FlxSprite>());

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(optionShit[i].x, optionShit[i].y);
			menuItem.ID = i;
			menuItem.frames = Paths.getSparrowAtlas('ui/mainmenu/menuThings');
			menuItem.animation.addByPrefix('idle', optionShit[i].name, 0, false);
			menuItem.animation.play('idle');
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		menuItems.visible = false;

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0;
		add(black);

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();

		if(FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;
		persistentUpdate = true;
		persistentDraw = true;

		FlxG.camera.zoom = 0.55;
		FlxG.camera.alpha = 0;

		FlxTween.tween(FlxG.camera, {alpha: 1}, 2, {ease: FlxEase.circOut});

		FlxTween.tween(FlxG.camera, {zoom: defaultZoom}, 2, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween) {
			FlxG.camera.zoom = defaultZoom;
			opening = false;
		}});

		blurFilter = new BlurFilter(20, 20);
		FlxG.camera.filters = [blurFilter];

		FlxTween.tween(blurFilter, {blurX: 0, blurY: 0}, 2.2, {ease: FlxEase.circOut});

		msucic = new FlxSound();
		msucic.loadEmbedded(Paths.music('Menu'), true);
		msucic.volume = 0.7;
		msucic.play();
		FlxG.sound.list.add(msucic);

		if(FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

		add(vingette = new FlxSprite(0, 0, Paths.image("ui/mainmenu/vingette")));
		vingette.scrollFactor.set(0, 0);

		emitter = new FlxEmitter(0, 60, 100);
		for (i in 0...100)
		{
			var p = new FlxParticle();
			var p2 = new FlxParticle();	

			p.loadGraphic(Paths.image('particler'));
			p.scale.set(0.5, 0.5);

			p2.loadGraphic(Paths.image('particler'));
			p.scrollFactor.set(1.2, 1.2);
			p2.scrollFactor.set(1.4, 1.4);
			
			emitter.add(p);
			emitter.add(p2);
		}
		emitter.width = FlxG.width * 2;
		emitter.height = FlxG.height * 2;
		emitter.launchMode = CIRCLE;
		emitter.lifespan.set(0);
		emitter.alpha.set(0, 1, 0, 0);
        add(emitter);

		emitter.start(false, 0.02);

		Paths.clearUnusedMemory();
		WinAPI.setDarkMode(true);

		#if VIDEOS_ALLOWED
		if(!openfl.utils.Assets.exists(Paths.video('dust'))) FlxG.log.warn('Couldnt find video file:');

		Thread.create(()->
		{
			video = new VideoSprite();
			video.autoScale = false;
			video.load(Paths.video('dust'), ['input-repeat=65545']);
			video.blend = openfl.display.BlendMode.ADD;
			video.alpha = 0.2;
			video.play();
			add(video);
		});
		#else
		FlxG.log.warn('Platform not supported!');
		#end
	}

	var selectedSomethin:Bool = false;
	var thing:Bool = false;
	override function update(elapsed:Float) {
		if(FlxG.keys.justPressed.P) {
			states.PlayState.practiceMode = !states.PlayState.practiceMode;
			states.PlayState.practiceMode ? FlxG.sound.play(Paths.sound("zovActive")) : FlxG.sound.play(Paths.sound("zovDeavtiv"));
		}

		if (!selectedSomethin && openedBook && !opening) {
			menuItems.forEach(function(spr:FlxSprite) {
				if (FlxG.mouse.overlaps(spr)) {
					curSelected = spr.ID;

					spr.offset.x = -25;
					selector.y = spr.y;

					if (!optionShit[curSelected].hovered) optionShit[curSelected].hovered = true;

					if (FlxG.mouse.justPressed) {
						selectedSomethin = true;
						book.animation.play('empty');
				
						switch (optionShit[curSelected].name) {
							case 'freeplay':
								msucic.volume = 0;
								black.alpha = 0.5;
								openSubState(new substates.ComicSubstate());
								persistentUpdate = false;
								video.pause();
								subStateClosed.add((substateThing) -> if (substateThing is substates.ComicSubstate) {
									video.resume();
									persistentUpdate = true;
									msucic.volume = 0.7;
									selectedSomethin = false;
									book.animation.play('opened');
									black.alpha = 0;
								});
							case 'credits':
								new FlxTimer().start(0.3, function(tmr:FlxTimer) {
									menuItems.visible = false;
									selector.y = -500;
								});
								FlxG.sound.play(Paths.sound('paper/paper' + FlxG.random.int(1, 4)));
								openSubState(new substates.CreditsSubstate());

								subStateClosed.add((substateThing) -> if (substateThing is substates.CreditsSubstate) {
									book.animation.play('opened');
									selectedSomethin = false;
								});
							case 'options':
								new FlxTimer().start(0.3, function(tmr:FlxTimer) {
									menuItems.visible = false;
									selector.y = -500;
								});
								FlxG.sound.play(Paths.sound('paper/paper' + FlxG.random.int(1, 4)));
								openSubState(new options.ControlsSubState());

								subStateClosed.add((substateThing) -> if (substateThing is options.ControlsSubState) {
									book.animation.play('opened');
									selectedSomethin = false;
								});
						}
					}
				} else {
					if (!optionShit[curSelected].hovered) selector.y = -500;
					optionShit[spr.ID].hovered = false;
					spr.offset.x = 0;
				}
			});
		}

		if (!openedBook && !opening) {
            if (FlxG.camera.target == null && !menuItems.visible) {
                final pointX = FlxMath.bound(FlxG.mouse.screenX, 0, FlxG.width);
                final pointY = FlxMath.bound(FlxG.mouse.screenY, 0, FlxG.height);
                final lerpFactor = Math.exp(-elapsed * 5);
                FlxG.camera.scroll.set(
                    FlxMath.lerp((pointX * FlxG.camera.zoom) * 0.035, FlxG.camera.scroll.x, lerpFactor),
                    FlxMath.lerp((pointY * FlxG.camera.zoom) * 0.035, FlxG.camera.scroll.y, lerpFactor)
                );
                FlxG.camera.zoom = defaultZoom - (Math.pow(Math.abs(FlxMath.remapToRange(pointX - book.x, 0, book.width, -0.25, 0.25)), 2) + Math.pow(Math.abs(FlxMath.remapToRange(pointY - book.y, 0, book.height, -0.2, 0.2)), 2));
            }

			if (FlxG.mouse.overlaps(book) && !thing) {
				if (FlxG.mouse.justPressed) {
					FlxG.sound.play(Paths.sound('bookOpeni'), 3);
				    book.animation.play('open');
				    thing = true;
			    }
		    }

			if (book.animation.curAnim != null) {
				if (book.animation.curAnim.name == 'open' && book.animation.curAnim.finished) {
					book.animation.play('opened');

					menuItems.visible = true;

					FlxTween.tween(FlxG.camera, {zoom: defaultZoom}, 0.5, {ease: FlxEase.circOut});
					FlxTween.tween(FlxG.camera.scroll, {x: 0}, 0.5, {ease: FlxEase.circOut});
					FlxTween.tween(FlxG.camera.scroll, {y: 0}, 0.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween) {
						openedBook = true;
						vingette.scale.set(1, 1);
						if (video != null) video.scale.set(1, 1);
					}});
				}
			}

			vingette.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
			if (video != null) video.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
		}

		if (opening) {
			vingette.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
			if (video != null) video.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
		}
		super.update(elapsed);
	}

	override public function draw():Void {
        super.draw();

		if (!menuItems.visible) {
			if (video != null) video.draw();
			if (emitter != null) emitter.draw();
		}
    }
}