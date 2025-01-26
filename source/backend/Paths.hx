package backend;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;

import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.system.System;

import lime.utils.Assets;
import flash.media.Sound;

class Paths {
	public static var dumpExclusions:Array<String> = ['assets/music/freakyMenu.ogg'];
	public static function clearUnusedMemory() {
		for (key in currentTrackedAssets.keys()) {
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key)) {
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) {
					FlxG.bitmap._cache.remove(key);
					openfl.Assets.cache.removeBitmapData(key);
					currentTrackedAssets.remove(key);

					obj.persist = false;
					obj.destroyOnNoUse = true;
					obj.destroy();
				}
			}
		}

		System.gc();
	}

	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory() {
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys()) {
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) {
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		for (key => asset in currentTrackedSounds) {
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && asset != null) {
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}

		localTrackedAssets = [];
		openfl.Assets.cache.clear("songs");
	}

	// private static function gnerateUUID() { // https://gist.github.com/ciscoheat/4b1797fa56648adac163f44186f1823a
	// 	var uid = new StringBuf(); 
	// 	var a = 8;
	// 	uid.add(StringTools.hex(Std.int(Date.now().getTime()), 8));
	// 	while((a++) < 36) {
	// 		uid.add(a * 51 & 52 != 0
	// 			? StringTools.hex(a ^ 15 != 0 ? 8 ^ Std.int(Math.random() * (a ^ 20 != 0 ? 16 : 4)) : 4)
	// 			: '-'
	// 		);
	// 	}
	// 	return uid.toString().toLowerCase();
	// }

	// public static function embeddedVideo(file:String) {
	// 	var filename:String = lime.system.System.applicationStorageDirectory + gnerateUUID() + '.mp4';
	// 	var output = sys.io.File.write(filename);
	// 	var oflBytes:haxe.io.BytesData = openfl.Assets.getBytes(file);
	// 	for (byteIndex in 0...oflBytes.length) output.writeByte(oflBytes[byteIndex]);
	// 	output.close();
	// 	return filename;
	// }

	public static function getPath(file:String, ?type:AssetType = TEXT):String return getPreloadPath(file);
	inline public static function getPreloadPath(file:String = '') return 'assets/$file';

	inline static public function txt(key:String) return getPath('data/$key.txt', TEXT);
	inline static public function xml(key:String) return getPath('data/$key.xml', TEXT);
	inline static public function json(key:String) return getPath('data/$key.json', TEXT);
	static public function video(key:String) return 'assets/videos/$key.mp4';
	inline static public function font(key:String) return 'assets/fonts/$key';

	static public function sound(key:String):Sound {
		var sound:Sound = returnSound('sounds', key);
		return sound;
	}

	inline static public function soundRandom(key:String, min:Int, max:Int) return sound(key + FlxG.random.int(min, max));

	inline static public function music(key:String):Sound {
		var file:Sound = returnSound('music', key);
		return file;
	}

	inline static public function voices(song:String, postfix:String = null):Sound {
		var songKey:String = '${formatToSongPath(song)}/Voices';
		if(postfix != null) songKey += '-' + postfix;

		var voices = returnSound('songs', songKey);
		return voices;
	}

	inline static public function inst(song:String):Sound {
		var songKey:String = '${formatToSongPath(song)}/Inst';
		var inst = returnSound('songs', songKey);
		return inst;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	static public function image(key:String, ?allowGPU:Bool = true, ?posInfos:haxe.PosInfos):FlxGraphic {
		var bitmap:BitmapData = null;
		var file:String = null;

		file = getPath('images/$key.png', IMAGE);
		if (currentTrackedAssets.exists(file)) {
			localTrackedAssets.push(file);
			return currentTrackedAssets.get(file);
		} else if (OpenFlAssets.exists(file, IMAGE)) bitmap = OpenFlAssets.getBitmapData(file);

		if (bitmap != null) {
			var retVal = cacheBitmap(file, bitmap, allowGPU);
			if(retVal != null) return retVal;
		}

		trace('Image with key "$key" could not be found' + '(${posInfos.fileName}, ${posInfos.lineNumber})');
		return null;
	}

	static public function cacheBitmap(file:String, ?bitmap:BitmapData = null, ?allowGPU:Bool = true) {
		if(bitmap == null) {
			if (OpenFlAssets.exists(file, IMAGE)) bitmap = OpenFlAssets.getBitmapData(file);

			if(bitmap == null) return null;
		}

		localTrackedAssets.push(file);
		if (allowGPU) {
			var texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
			texture.uploadFromBitmapData(bitmap);
			bitmap.image.data = null;
			bitmap.dispose();
			bitmap.disposeImage();
			bitmap = BitmapData.fromTexture(texture);
		}
		var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, file);
		newGraphic.persist = true;
		newGraphic.destroyOnNoUse = false;
		currentTrackedAssets.set(file, newGraphic);
		return newGraphic;
	}

	static public function getTextFromFile(key:String):String {
		var path:String = getPath(key, TEXT);
		if(OpenFlAssets.exists(path, TEXT)) return Assets.getText(path);
		return null;
	}

	public static function fileExists(key:String, type:AssetType) {
		if(OpenFlAssets.exists(getPath(key, type))) return true;
		return false;
	}

	static public function getAtlas(key:String, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, allowGPU);
		var myXml:Dynamic = getPath('images/$key.xml', TEXT);

		if(OpenFlAssets.exists(myXml))
			return FlxAtlasFrames.fromSparrow(imageLoaded, myXml);
		else {
			var myJson:Dynamic = getPath('images/$key.json', TEXT);
			if(OpenFlAssets.exists(myJson)) return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, myJson);
		}
		return getPackerAtlas(key);
	}

	inline static public function getSparrowAtlas(key:String, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, allowGPU);
		return FlxAtlasFrames.fromSparrow(imageLoaded, getPath('images/$key.xml'));
	}

	inline static public function getPackerAtlas(key:String, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, allowGPU);
		return FlxAtlasFrames.fromSpriteSheetPacker(imageLoaded, getPath('images/$key.txt'));
	}

	inline static public function getAsepriteAtlas(key:String, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, allowGPU);
		return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, getPath('images/$key.json'));
	}

	inline static public function formatToSongPath(path:String) {
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join("").toLowerCase();
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static function returnSound(path:Null<String>, key:String) {
		var gottenPath:String = '$key.ogg';
		if(path != null) gottenPath = '$path/$gottenPath';
		gottenPath = getPath(gottenPath, SOUND);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);

		if(!currentTrackedSounds.exists(gottenPath)) {
			var retKey:String = (path != null) ? '$path/$key' : key;
			retKey = ((path == 'songs') ? 'songs:' : '') + getPath('$retKey.ogg', SOUND);
			if(OpenFlAssets.exists(retKey, SOUND)) currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(retKey));
		}
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}
}