package  
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class GPlanet extends Sprite 
	{
		public static const ORBIT_THICKNESS:Number = 1.2;
		public static const SELECTED_THICKNESS:Number = 2.5;
		
		private static var m_ActivePlanet:GPlanet;
		private static var m_TextBox:GPopup;
		
		private var m_Star:DisplayObject;
		private var m_Planet:Image;
		private var m_Orbit:GCircle;
		private var m_OrbitRadius:Number;
		private var m_PlanetTime:Number;
		private var m_PlanetName:String;
		private var m_PlanetIndex:uint;
		private var m_Rotation:Number;
		private var m_Selector:GCircle;
		
		private var m_Angle:Number;
		private var m_Touched:Boolean = false;
		private var m_OrbitTouched:Boolean = false;
		private var m_PlanetTouched:Boolean = false;
		private var m_Mask:CircleMaskFilter;
		
		private static var m_TouchHelper:Boolean = false;
		private static var m_PointHelper:Point = new Point();
		private static var m_PointHelper2:Point = new Point();
		private static var m_MatrixHelper:Matrix = new Matrix();
		
		private static var m_cosa:Number;
		private static var m_sina:Number;
		
    	public function GPlanet(index:uint, orbitRadius:Number, time:Number, star:DisplayObject, planetTexture:Texture, planetName:String, orbitColor:uint = 0x00c0ff) 
		{
			super();
			
			m_Star = star;
			m_PlanetTime = time;
			m_OrbitRadius = orbitRadius;
			m_PlanetName = planetName;
			m_Rotation = GMath.DegreeToRadian(GMath.randomNumber(0.5, 2));
			
			m_Orbit = new GCircle(orbitRadius, ORBIT_THICKNESS, orbitColor);
			m_Orbit.x = m_Star.x;
			m_Orbit.y = m_Star.y;
			addChild(m_Orbit);
			
			m_Planet = new Image(planetTexture);
			m_Planet.pivotX = m_Planet.width / 2;
			m_Planet.pivotY = m_Planet.height / 2;
			
			m_Angle = GMath.cropRadians(GMath.DegreeToRadian(GMath.randomNumber(0, 360)));
			m_Planet.x = m_Star.x + orbitRadius * Math.cos(m_Angle);
			m_Planet.y = m_Star.y + orbitRadius * Math.sin(m_Angle);
			addChild(m_Planet);
			
			m_Selector = new GCircle(18, SELECTED_THICKNESS, orbitColor);
			m_Selector.x = m_Planet.x;
			m_Selector.y = m_Planet.y;
			m_Selector.visible = false;
			addChild(m_Selector);
			
			m_Mask = new CircleMaskFilter(16, m_OrbitRadius, 0);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (!m_TextBox)
			{
				m_TextBox = new GPopup(100, 20, "Planet", "Verdana", 12, 0xffffff, true);
				m_TextBox.pivotX -= 20;
				m_TextBox.pivotY += 9;
				m_TextBox.visible = false;
				stage.addChild(m_TextBox);
			}
			
		}
		
		public function advanceTime(time:Number):void
		{
			m_Angle = GMath.cropRadians(m_Angle + (GMath.DegreeToRadian(360) / m_PlanetTime) * time);
			m_cosa = Math.cos(m_Angle);
			m_sina = Math.sin(m_Angle);
			m_Planet.x = m_Star.x + m_OrbitRadius * m_cosa;
			m_Planet.y = m_Star.y + m_OrbitRadius * m_sina;
			
			m_Mask.centerX = m_OrbitRadius + m_OrbitRadius * m_cosa;
			m_Mask.centerY = m_OrbitRadius + m_OrbitRadius * m_sina;
			
			m_Selector.x = m_Planet.x;
			m_Selector.y = m_Planet.y;
			
			m_Planet.rotation = m_Angle;
			
			if (m_TextBox.Obj == this)
			{
				m_TextBox.x = m_Planet.x;
				m_TextBox.y = m_Planet.y;
			}
			
			if (Game.stageTouch)
			{
				m_PointHelper.x = Game.stageTouch.globalX;
				m_PointHelper.y = Game.stageTouch.globalY;
				
				m_MatrixHelper = stage.getTransformationMatrix(m_Orbit);
				m_PointHelper2 = m_MatrixHelper.transformPoint(m_PointHelper)
				
				m_TouchHelper = m_Orbit.hitTest(m_PointHelper2) == null ? false : true;
				
				m_MatrixHelper = stage.getTransformationMatrix(m_Planet);
				m_PointHelper2 = m_MatrixHelper.transformPoint(m_PointHelper)
				
				m_TouchHelper = m_TouchHelper || (m_Planet.hitTest(m_PointHelper2) == null ? false : true);
				
				if (m_ActivePlanet == null && m_TouchHelper && !m_Touched)
				{
					m_Touched = true;
					m_Orbit.Thickness = 3;
					m_Orbit.filter =  m_Mask;
					m_Selector.visible = true;
					
					m_TextBox.Text = m_PlanetName;
					
					m_TextBox.x = m_Planet.x;
					m_TextBox.y = m_Planet.y;
					m_TextBox.Obj = this;
					m_TextBox.visible = true;
					
					m_ActivePlanet = this;
				}
				else if (m_ActivePlanet == this && !m_TouchHelper && m_Touched)
				{
					m_Touched = false;
					m_Orbit.Thickness = ORBIT_THICKNESS;
					m_Orbit.filter = null;
					m_Selector.visible = false;
					
					m_ActivePlanet = null;
					m_TextBox.Obj = null;
					m_TextBox.visible = false;
				}
			}
			
		}
	}

}