package 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import starling.textures.Texture;
	import starling.filters.FragmentFilter;
 
    public class CircleMaskFilter extends FragmentFilter
    {
 
        private var mShaderProgram:Program3D;
		private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
 
		private var mCenterX:Number;
		private var mCenterY:Number;
		private var mRadius:Number;
 
        public function CircleMaskFilter(radius:Number = 100.0, cx:Number = 0.0, cy:Number = 0.0)
        {
			mCenterX = cx;
			mCenterY = cy;
			mRadius = radius;
        }
 
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
 
        protected override function createPrograms():void
        {
            var fragmentProgramCode:String =
				"sub ft0.x, v0.x, 	fc0.x							\n" +
				"mul ft0.x, ft0.x, 	ft0.x							\n" +
				"sub ft0.y, v0.y, 	fc0.y							\n" +
				"mul ft0.y, ft0.y, 	ft0.y							\n" +
				"add ft0.z, ft0.x, 	ft0.y							\n" +
				"sqt ft0.x, ft0.z									\n" +
				"tex ft1, 	v0, 	fs0<2d, clamp, linear, mipnone>	\n" +
				"sge ft0.w, ft0.x, 	fc0.z							\n" +
				"mul ft1.w, ft1.w, 	ft0.w							\n" +
				"mov oc, 	ft1"
 
 
            mShaderProgram = assembleAgal(fragmentProgramCode);
        }
 
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {		
			mVars[0] = mCenterX / texture.width;
			mVars[1] = mCenterY / texture.height;
			mVars[2] = mRadius	/ ((texture.width + texture.height) * .5);
			
			context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
            context.setProgram(mShaderProgram);
        }
 
		public function set centerX(value:Number):void { mCenterX = value; }
		public function get centerX():Number { return mCenterX; }
 
		public function set centerY(value:Number):void { mCenterY = value; }
		public function get centerY():Number { return mCenterY; }
 
		public function set radius(value:Number):void { mRadius = value; }
		public function get radius():Number { return mRadius; }
    }
}