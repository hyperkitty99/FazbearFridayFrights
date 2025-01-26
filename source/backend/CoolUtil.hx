package backend;

import sys.io.File;
import openfl.utils.Assets;

class CoolUtil {
	inline public static function quantize(f:Float, snap:Float) {
		var m:Float = Math.fround(f * snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String) return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String> {
		var daList:String = null;
		var formatted:Array<String> = path.split(':');
		path = formatted[formatted.length-1];
		if(Assets.exists(path)) daList = Assets.getText(path);
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor {
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String> {
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length) daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float {
		if(decimals < 1) return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals) tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function dominantColor(sprite:flixel.FlxSprite):Int {
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth) {
			for (row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0) {
					if (countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0;
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if(countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int> {
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) FlxG.openURL(site);

	inline public static function openFolder(folder:String, absolute:Bool = false) {
		if(!absolute) folder =  Sys.getCwd() + '$folder';

		folder = folder.replace('/', '\\');
		if(folder.endsWith('/')) folder.substr(0, folder.length - 1);

		var command:String = 'explorer.exe';
		Sys.command(command, [folder]);
		trace('$command $folder');
	}

	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		final company:String = FlxG.stage.application.meta.get('company');
		return '${company}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
	}

	public static function setTextBorderFromString(text:FlxText, border:String) {
		switch(border.toLowerCase().trim()) {
			case 'shadow':
				text.borderStyle = SHADOW;
			case 'outline':
				text.borderStyle = OUTLINE;
			case 'outline_fast', 'outlinefast':
				text.borderStyle = OUTLINE_FAST;
			default:
				text.borderStyle = NONE;
		}
	}
}
