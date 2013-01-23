package  
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class GAssetManager 
	{
		private static var _textureAssets:Dictionary = new Dictionary();
		private static var _movieClipAssets:Dictionary = new Dictionary();
		private static var _imagesAssets:Dictionary = new Dictionary();
		private static var _bitmapAssets:Dictionary = new Dictionary();
		private static var _xmlAssets:Dictionary = new Dictionary();
		private static var _byteAssets:Dictionary = new Dictionary();
		
		[Embed(source = "star.png")]
		private static var star:Class;
		[Embed(source = "planets.png")]
		private static var planets:Class;
		[Embed(source = "sky.png")]
		private static var sky:Class;


		public static function getBitmap(name:String):Bitmap
		{
			if (GAssetManager[name] != undefined)
			{
				//if (_bitmapAssets[name] == undefined)
				//{
				//	_bitmapAssets[name] = new GAssetManager[name]();
				//}
				//if (_bitmapAssets[name] == null) throw new Error("Resource type mismatch.");
				
				//return _bitmapAssets[name];
				return new GAssetManager[name]();
			} else throw new Error("Resource not defined.");
		}
		
		public static function getXML(name:String):XML
		{
			if (GAssetManager[name] != undefined)
			{
				if (_xmlAssets[name] == undefined)
				{
					_xmlAssets[name] = new XML(new GAssetManager[name]());
				}
				if (_xmlAssets[name] == null) throw new Error("Resource type mismatch.");
				
				return _xmlAssets[name];
			} else throw new Error("Resource not defined.");
		}
		
		public static function getBytes(name:String):ByteArray
		{
			if (GAssetManager[name] != undefined)
			{
				if (_byteAssets[name] == undefined)
				{
					_byteAssets[name] = new GAssetManager[name]();
				}
				if (_byteAssets[name] == null) throw new Error("Resource type mismatch.");
				
				return _byteAssets[name];
			} else throw new Error("Resource not defined.");
		}
		
		public static function getImage(name:String):Image
		{
			return new Image(getTexture(name));
		}

		public static function getTexture(name:String):Texture
		{
			if (GAssetManager[name] != undefined)
			{
				if (_textureAssets[name] == undefined)
				{
					var bitmap:Bitmap = getBitmap(name);
					_textureAssets[name] = Texture.fromBitmap(bitmap, false);
					bitmap.bitmapData.dispose();
					bitmap = null;
				}
				if (_textureAssets[name] == null) throw new Error("Resource type mismatch.");
				
				return _textureAssets[name];
			} else throw new Error("Resource not defined.");
		}
		
		public static function getMovieClip(name:String):MovieClip
		{
			if (GAssetManager[name] != undefined)
			{
				if (_movieClipAssets[name] == undefined)
				{
					var atlas:TextureAtlas = new TextureAtlas(getTexture(name), getXML(name + "_xml"));
					var frames:Vector.<Texture> = atlas.getTextures();
					_movieClipAssets[name] = frames;
				}
				if (_movieClipAssets[name] == null) throw new Error("Resource type mismatch.");
				
				return new MovieClip(_movieClipAssets[name], 22);
			} else throw new Error("Resource not defined.");
		}
	}

}
