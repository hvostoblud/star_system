package  
{
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author 
	 */
	public class GAtlas
	{
		private var _textureAtlas:Texture;
		private var _frames:Vector.<Texture> = new Vector.<Texture>();
		
		public function GAtlas(texture:Texture, width:int, height:int) 
		{
			_textureAtlas = texture;
			getFramesFromTexture(_textureAtlas, width, height);
		}
		
		private function getFramesFromTexture(texture:Texture, width:int, height:int):void
		{
			if (!(texture && texture.width >= width && texture.height >= height)) return;
			
			for (var i:int = 0; i < texture.height; i = i + height)
			{
				for (var j:int = 0; j < texture.width; j = j + width)
				{
					_frames.push(Texture.fromTexture(texture, new Rectangle(j, i, width, height)));
				}
			}
		}
		public function getTextureByIndex(index:int):Texture
		{
			return _frames[index];
		}
	}

}