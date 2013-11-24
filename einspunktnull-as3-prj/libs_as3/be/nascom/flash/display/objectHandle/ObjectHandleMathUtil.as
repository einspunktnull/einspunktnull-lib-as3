package be.nascom.flash.display.objectHandle{
	
	public class ObjectHandleMathUtil{
		
		public static const PI_180:Number=Math.PI/180;//wtf is this for?!
		public static const ONE80_PI:Number=180/Math.PI;
		public static const PI2:Number=Math.PI*2;

		//keep degrees between 0 and 360
		public static function constrainDegreeTo360(degree:Number):Number{
			return (360+degree%360)%360;
		}
		public static function constrainRadianTo2PI(rad:Number):Number{
			return (PI2+rad%PI2)%PI2;
		}

		public static function radiansToDegrees(rad:Number):Number{
			return rad*ONE80_PI;
		}
		public static function degreesToRadians(degree:Number):Number{
			return degree*PI_180;
		}


	}
}