package shaders;

import flixel.system.FlxAssets.FlxShader;

class MatrixShader extends FlxShader {
	@:glVertexBody("
	openfl_Alphav = openfl_Alpha;
	openfl_TextureCoordv = openfl_TextureCoord;
	openfl_ColorMultiplierv = openfl_ColorMultiplier;
	openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
	
    gl_Position = openfl_Matrix * openfl_Position * matrix;
	")
	@:glVertexSource("
	#pragma header

	attribute float alpha;
	attribute vec4 colorMultiplier;
	attribute vec4 colorOffset;
    uniform mat4 matrix;

	void main(void) {
		#pragma body
		
		openfl_Alphav = openfl_Alpha * alpha;
		openfl_ColorOffsetv = colorOffset / 255.0;
		openfl_ColorMultiplierv = colorMultiplier;
	}")
	public function new() {
		super();
        matrix.value = [1.0, 0.0, 0.0, 0.0,  //width [0], skewX [1],  ?,  xPos [3]
                        0.0, 1.0, 0.0, 0.0,  //skewY [4], height [5], ? , yPos [7]
                        0.0, 0.0, 1.0, 0.0,  //?,         ?,          ?,  ?
                        0.0, 0.0, 0.0, 1.0]; //yRot [12], xRot [13],  ?,  scale [15]
        alpha.value = [0.0];
	}
}