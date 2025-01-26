package backend;

import lime.utils.Assets;

class Mods {
	inline public static function mergeAllTextsNamed(path:String, defaultDirectory:String = null, allowDuplicates:Bool = false) {
		if(defaultDirectory == null) defaultDirectory = Paths.getPreloadPath();
		defaultDirectory = defaultDirectory.trim();
		if(!defaultDirectory.endsWith('/')) defaultDirectory += '/';
		if(!defaultDirectory.startsWith('assets/')) defaultDirectory = 'assets/$defaultDirectory';

		var mergedList:Array<String> = [];
		var paths:Array<String> = directoriesWithFile(defaultDirectory, path);

		var defaultPath:String = defaultDirectory + path;
		if(paths.contains(defaultPath)) {
			paths.remove(defaultPath);
			paths.insert(0, defaultPath);
		}

		for (file in paths) {
			var list:Array<String> = CoolUtil.coolTextFile(file);
			for (value in list)
				if((allowDuplicates || !mergedList.contains(value)) && value.length > 0) mergedList.push(value);
		}
		return mergedList;
	}

	inline public static function directoriesWithFile(path:String, fileToFind:String) {
		var foldersToCheck:Array<String> = [];
		#if sys
		if(Assets.exists(path + fileToFind))
		#end
			foldersToCheck.push(path + fileToFind);

		return foldersToCheck;
	}
}