package options;

class Option {
	public var onChange:Void->Void = null;
	private var variable:String = null;
	public var name:String = 'Unknown';

	public function new(name:String, variable:String) {
		this.name = name;
		this.variable = variable;
	}

	public function change() if(onChange != null) onChange();
	public function getValue():Dynamic return Reflect.getProperty(ClientPrefs.data, variable);
	public function setValue(value:Dynamic) Reflect.setProperty(ClientPrefs.data, variable, value);
}