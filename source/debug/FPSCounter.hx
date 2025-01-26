package debug;

import flixel.FlxG;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.Lib;

import openfl.utils.Assets;

class FPSCounter extends TextField {
	public var currentFPS(default, null):Int;
	public var memoryMegas(get, never):Float;
	public var tColor:Int;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFFFF) {
		super();

		this.x = x;
		this.y = y;

		tColor = color;
		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FallingSkyBlk.otf").fontName, 14, tColor, null, null, null, null, null, RIGHT);
		width = Lib.application.window.width - x * 2;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;
	private override function __enterFrame(deltaTime:Float):Void {
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		times.push(haxe.Timer.stamp());
		while (times[0] < haxe.Timer.stamp() - 1000) times.shift();

		currentFPS = currentFPS < FlxG.drawFramerate ? times.length : FlxG.drawFramerate;
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void {
		text = 'FPS: ${currentFPS}'+ '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';
		width = Lib.application.window.width - x * 2;

		textColor = tColor;
		if (currentFPS < FlxG.drawFramerate * 0.5) textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float return cast(System.totalMemory, UInt);
}