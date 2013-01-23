package
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.VertexData;
	
	public class GCircle extends Quad
	{
		private var m_Program:Program3D;
		private var m_VertexData:VertexData;
		private var m_VertexBuffer:VertexBuffer3D;
		private var m_Indices:Vector.<uint>;
		private var m_IndexBuffer:IndexBuffer3D;
		
		private var m_Radius:Number;
		private var m_Thickness:Number;
		private var m_Alpha:uint;
		
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperPoint:Point = new Point();		
		
		private var fragmet0:Vector.<Number>;
		private var fragmet1:Vector.<Number>;
		private var fragmet2:Vector.<Number>;
		private var aalpha:Vector.<Number>;
		private var ccontext:Context3D;
		private var dx:Number;
		private var dy:Number;
		private var dd:Number;
		
		public function get Thickness():Number
		{
			return m_Thickness;
		}
		
		public function set Thickness(value:Number):void
		{
			m_Thickness = value;
		}
		
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			super.width = value;
			adjustSize();
		}
		
		override public function get height():Number 
		{
			return super.height;
		}
		
		override public function set height(value:Number):void 
		{
			super.height = value;
			adjustSize();
		}
		
		override public function get color():uint 
		{
			return super.color;
		}
		
		override public function set color(value:uint):void 
		{
			super.color = value;
			adjustColor();
		}
		
		private function adjustSize():void
		{
			m_VertexData.setPosition(0, 0.0, 0.0);
			m_VertexData.setPosition(1, width, 0.0);
			m_VertexData.setPosition(2, 0.0, height);
			m_VertexData.setPosition(3, width, height); 
		}
		
		private function adjustColor():void
		{
			m_VertexData.setColor(0, color);
			m_VertexData.setColor(1, color);
			m_VertexData.setColor(2, color);
			m_VertexData.setColor(3, color);
		}
		
		public function GCircle(radius:Number, thickness:Number, color:uint = 0xffffff, alpha:Number = 1)
		{
			super(radius * 2, radius * 2, color);
			pivotX = pivotY = radius;
			m_Radius = radius;
			m_Thickness = thickness;
			m_Alpha = alpha;
			
			m_Indices = Vector.<uint>([0,1,2,1,3,2]);
			m_VertexData = new VertexData(4);
			m_VertexData.setTexCoords(0, 0.0, 0.0);
			m_VertexData.setTexCoords(1, 1.0, 0.0);
			m_VertexData.setTexCoords(2, 0.0, 1.0);
			m_VertexData.setTexCoords(3, 1.0, 1.0);	
			
			aalpha = Vector.<Number>([1, 1, 1, m_Alpha]);
			fragmet0 = Vector.<Number>([0.0, 0.5, 1, 2]);
			fragmet1 = Vector.<Number>([0.5,0.5,0.5,-1.0]);
			fragmet2 = Vector.<Number>([(width*scaleX) * 1.2,3.1415926,-3.1415927,3]);
			
			createProgram();
			adjustSize();
			adjustColor();
			
			Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 0, true);
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			support.finishQuadBatch();
			
			ccontext.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);      
			
			ccontext.setProgram(m_Program);
			ccontext.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);
			ccontext.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, aalpha, 1);
			
			ccontext.setVertexBufferAt(0, m_VertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			ccontext.setVertexBufferAt(1, m_VertexBuffer, VertexData.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
			ccontext.setVertexBufferAt(2, m_VertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			
			fragmet1[2] = 0.5 - m_Thickness / width;
			fragmet2[0] = (width * scaleX * 1.2) / m_Thickness;
			
			ccontext.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmet0);
			ccontext.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fragmet1);
			ccontext.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, fragmet2);
			
			ccontext.drawTriangles(m_IndexBuffer);
			
			ccontext.setVertexBufferAt(0, null);
			ccontext.setVertexBufferAt(1, null);
			ccontext.setVertexBufferAt(2, null);
			
		}
		
		private function onContextCreated(event:Object):void
		{
			createProgram();
		}
		
		private function createProgram():void
		{
			ccontext = Starling.context;
			
			m_VertexBuffer = ccontext.createVertexBuffer(m_VertexData.numVertices, m_VertexData.rawData.length / m_VertexData.numVertices);
			m_VertexBuffer.uploadFromVector(m_VertexData.rawData, 0, m_VertexData.numVertices);
			
			m_IndexBuffer = ccontext.createIndexBuffer(6);
			m_IndexBuffer.uploadFromVector(m_Indices, 0, 6);
			
			if (ccontext == null) throw new Error();
			
			var vertexProgramCode:String = "";
			vertexProgramCode += "m44 op, va0, vc0\n";
			vertexProgramCode += "mov v0, va2\n";
			vertexProgramCode += "mul v1, va1, vc4 \n";
			
			var fragmentProgramCode:String = "";
			 //xx = uv.x - center.x
			fragmentProgramCode += "sub ft0.x, v0.x, fc1.x\n";
			 //xx^2
			fragmentProgramCode += "mul ft0.x, ft0.x, ft0.x\n";
			
			 //yy = uv.y - center.y
			fragmentProgramCode += "sub ft0.y, v0.y, fc1.y\n";
			 //yy^2
			fragmentProgramCode += "mul ft0.y, ft0.y, ft0.y\n";
			
			//radius^2
			fragmentProgramCode += "mov ft2.x, fc1.z\n";
			fragmentProgramCode += "mul ft2.x, ft2.x, ft2.x\n";
			
			//s=(xx*xx+yy*yy-radius*radius)/2/radius
			fragmentProgramCode += "add ft2.y, ft0.x, ft0.y\n";
			fragmentProgramCode += "sub ft2.y, ft2.y, ft2.x\n";
			fragmentProgramCode += "div ft2.y, ft2.y, fc0.w\n";
			fragmentProgramCode += "div ft2.y, ft2.y, fc1.z\n";
			
			//f = s*Pi*0.8
			fragmentProgramCode += "mul ft2.y, ft2.y, fc2.y\n";
			fragmentProgramCode += "mul ft2.y, ft2.y, fc2.x\n";
			
			//ft2.z = sin(f)/f
			fragmentProgramCode += "sin ft2.z, ft2.y\n";
			fragmentProgramCode += "div ft2.z, ft2.z, ft2.y\n";
			
			fragmentProgramCode += "sge ft1.x, ft2.y, fc2.z\n";
			fragmentProgramCode += "slt ft1.y, ft2.y, fc2.y\n";
			fragmentProgramCode += "mul ft1.z, ft1.x, ft1.y\n";
			
			fragmentProgramCode += "mul ft2.z, ft2.z, ft1.z\n";

			//fragmentProgramCode += "mov ft4, fc3\n";
			fragmentProgramCode += "mov ft4, v1\n";
			fragmentProgramCode += "mov ft4.w, ft2.z\n";
			fragmentProgramCode += "mov oc, ft4\n";
			
			var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var vs:ByteArray = vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
			
			var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var fs:ByteArray = fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
			
			m_Program = ccontext.createProgram();
			m_Program.upload(vs, fs);
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject 
		{
	        dx = this.width / 2 - localPoint.x;
			dy = this.height / 2 - localPoint.y;
			dd = Math.sqrt(dx * dx + dy * dy);
			if (Math.abs(m_Radius - dd) < 13) return this;
			return null;
		}
	}
}