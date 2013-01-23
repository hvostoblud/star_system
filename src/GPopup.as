package  
{
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class GPopup extends Sprite 
	{
		private var m_Background:Quad;
		private var m_TextBox:TextField;
		
		public var Obj:DisplayObject;
		
		public function set Text(value:String):void
		{
			m_TextBox.text = value;
		}
		
		public function GPopup(width:int, height:int, text:String, fontName:String="Verdana",
                                  fontSize:Number=12, color:uint=0x0, bold:Boolean=false) 
		{
			super();
			
			m_Background = new Quad (100, 20, 0x111111);
			addChild(m_Background);
			
			m_TextBox = new TextField(100, 20, "Planet", "Verdana", 12, 0xffffff, true);
			addChild(m_TextBox);
		}
		
	}

}