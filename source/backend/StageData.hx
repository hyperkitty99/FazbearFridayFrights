package backend;

import openfl.utils.Assets;
import backend.Song;

typedef StageFile = {
	var defaultZoom:Float;
	var stageUI:String;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;
}

class StageData {
	public static function dummy():StageFile {
		return {
			defaultZoom: 0.9,
			stageUI: "normal",

			boyfriend: [770, 100],
			girlfriend: [400, 130],
			opponent: [100, 100],
			hide_girlfriend: false,

			camera_boyfriend: [0, 0],
			camera_opponent: [0, 0],
			camera_girlfriend: [0, 0],
			camera_speed: 1
		};
	}

	public static var forceNextDirectory:String = null;
	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		SONG.stage != null ? stage = SONG.stage : stage = 'stage';

		var stageFile:StageFile = getStageFile(stage);
		forceNextDirectory = '';

	}

	public static function getStageFile(stage:String):StageFile {
		var rawJson:String = null;
		var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

		Assets.exists(path) ? rawJson = Assets.getText(path) : return null;

		return cast tjson.TJSON.parse(rawJson);
	}
}
