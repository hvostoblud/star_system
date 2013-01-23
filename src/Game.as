package {
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;

	public class Game extends Sprite
	{
		private var planets:Vector.<GPlanet>;
		private var m_TextBox:TextField;
		
		public static var stageTouch:Touch;
		
		public function Game()
		{
			planets = new Vector.<GPlanet>();
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var background:Image = new Image(GAssetManager.getTexture("sky"));
			background.blendMode = BlendMode.NONE;
			addChild(background);
			
			var atlas:GAtlas = new GAtlas(GAssetManager.getTexture("planets"), 26, 26);
			var names:Array = ["Selene", "Mimas", "Ares", "Enceladus", "Tethys", "Dione", "Zeus", "Rhea", "Titan", "Janus", "Hyperion", "Iapetus"];
			
			var sun:Image = GAssetManager.getImage("star");
			sun.pivotX = sun.width / 2;
			sun.pivotY = sun.height / 2;
			sun.x = stage.stageWidth / 2;
			sun.y = stage.stageHeight / 2;
			
			addChild(sun);
			
			for (var i:int = 0; i < 12; i++ )
			{
				var planetside:GPlanet = new GPlanet(i, 90 + i * 26, 40 + i * 20, sun, atlas.getTextureByIndex(i), names[i]);
				addChild(planetside);
				planets.push(planetside);
			}
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onFrame(e:EnterFrameEvent):void
		{
			for each(var planet:GPlanet in planets)
			{
				planet.advanceTime(e.passedTime);
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			stageTouch = e.getTouch(stage);
		}
	}
}