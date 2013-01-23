package {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import starling.core.Starling;
    
	[SWF(width = "840", height = "840", frameRate = "30", backgroundColor = "#000000")]
	public class Main extends flash.display.Sprite {
        
        private var m_starling:Starling;
		
		public function Main()
        {
			Starling.handleLostContext = false;
            m_starling = new Starling(Game, stage, new Rectangle(0, 0, 840, 840));
            m_starling.start();
        }
    }
}
