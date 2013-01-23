package  
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krasnopolsky
	 */
	public class GTiledImage extends Image
	{
		protected var _scale_factor:Point;
		
		public function GTiledImage(texture:Texture) 
		{
			super(texture);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			updateSize();
		}
		
		private function updateSize():void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
			
			scaleX =  width / texture.width;
			scaleY = height / texture.height ;
		}
	}

}