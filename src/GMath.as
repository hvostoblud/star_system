//
//File:        GMath.as
//Copyright:   Copyright (C) 2012 suomy.nona.gd@gmail.com. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software, to deal in the Software without restriction, including without 
//limitation the rights to use, copy, modify, merge, publish, distribute, and/or sell 
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.  
//
package  
{
	public class GMath 
	{
		public static const D0:Number = DegreeToRadian(0);
		public static const D22_5:Number = DegreeToRadian(22.5);
		public static const D45:Number = DegreeToRadian(45);
		public static const D67_5:Number = DegreeToRadian(67.5);
		public static const D90:Number = DegreeToRadian(90);
		public static const D112_5:Number = DegreeToRadian(112.5);
		public static const D135:Number = DegreeToRadian(135);
		public static const D157_5:Number = DegreeToRadian(157.5);
		public static const D180:Number = DegreeToRadian(180);
		public static const D_180:Number = DegreeToRadian(-180);
		public static const D_157_5:Number = DegreeToRadian(-157.5);
		public static const D_135:Number = DegreeToRadian(-135);
		public static const D_112_5:Number = DegreeToRadian(-112.5);
		public static const D_90:Number = DegreeToRadian(-90);
		public static const D_67_5:Number = DegreeToRadian(-67.5);
		public static const D_45:Number = DegreeToRadian(-45);
		public static const D_22_5:Number = DegreeToRadian(-22.5);
		
		public static function RoundTo(value:Number, n:uint = 0):Number
		{
			var t:uint = Math.pow(10, GMath.abs(n));
			return Math.round(value * t) /t;
		}
		
		public static function DegreeToRadian(value:Number):Number
		{
			return value * Math.PI / 180;
		}
		
		public static function RadianToDegree(value:Number):Number
		{
			return value * 180 / Math.PI;
		}
		
		public static function deltaAngleRadian(a1:Number, a2:Number):Number
		{
			var da:Number = a1 - a2;
			if (da > Math.PI) {
				da = -Math.PI * 2 + da;
			} else if (da < -Math.PI) {
				da = Math.PI * 2 + da;
			}
			return da;
		}
		
		public static function deltaAngleDegree(a1:Number, a2:Number):Number
		{
			var da:Number = a1 - a2;
			if (da > 180) {
				da = -360 + da;
			} else if (da < -180) {
				da = 360 + da;
			}
			return da;
		}
		
		public static function randomNumber(low:Number=0, high:Number=1):Number
		{
			return (Math.random() * (high - low)) + low;
		}
		
		public static function abs(n:Number):Number
		{
			if (n < 0)  n = -n;
			return n;
		}
		
		public static function cropRadians(angle:Number):Number
		{
			if (angle > Math.PI) {
				angle = -Math.PI * 2 + angle;
			} else if (angle < -Math.PI) {
				angle = Math.PI * 2 + angle;
			}
			return angle;
		}
	}

}
