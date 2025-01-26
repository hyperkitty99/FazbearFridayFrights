package substates;

import flixel.ui.FlxButton;

class Prompt extends MusicBeatSubstate {
	var selected = 0;
	public var okc:Void->Void;
	public var cancelc:Void->Void;
	var theText:String = '';
	var goAnyway:Bool = false;
	var panel:FlxSprite;
	var buttonAccept:FlxButton;
	var buttonNo:FlxButton;

	public function new(promptText:String = '', defaultSelected:Int = 0, okCallback:Void->Void, cancelCallback:Void->Void, acceptOnDefault:Bool = false, option1:String = null, option2:String = null) {
		selected = defaultSelected;
		okc = okCallback;
		cancelc = cancelCallback;
		theText = promptText;
		goAnyway = acceptOnDefault;
		
		var op1 = 'OK';
		var op2 = 'CANCEL';
		
		if (option1 != null) op1 = option1;
		if (option2 != null) op2 = option2;
		buttonAccept = new FlxButton(475, 450, op1, function(){if(okc != null) okc(); close();});
		buttonNo = new FlxButton(635, 450, op2, function(){if(cancelc != null) cancelc(); close();});
		super();	
	}
	
	override public function create():Void {
		super.create();
		if (goAnyway) {
			if(okc != null) okc();
			close();
		} else {
		    panel = new FlxSprite(0, 0).makeGraphic(300, 150,0xff999999);
		    panel.scrollFactor.set();
	    	panel.screenCenter();
	    	add(panel);
		    add(buttonAccept);
		    add(buttonNo);

	    	var textshit:FlxText = new FlxText(buttonNo.width * 2, panel.y, 300, theText, 16);
		    textshit.alignment = 'center';
		    add(textshit);
		    textshit.screenCenter();
		    buttonAccept.screenCenter();
	    	buttonNo.screenCenter();
		    buttonAccept.x -= buttonNo.width / 1.5;
		    buttonAccept.y = panel.y + panel.height - 30;
	    	buttonNo.x += buttonNo.width / 1.5;
		    buttonNo.y = panel.y + panel.height - 30;
	    	textshit.scrollFactor.set();
		}
	}
}