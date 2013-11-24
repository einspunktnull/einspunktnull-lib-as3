package net.einspunktnull.display.fx
{
	import be.nascom.flash.graphics.Rippler;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class RippleImage extends Sprite
	{
		private var _bmp : Bitmap;
		private var _rippler : Rippler;

		public function RippleImage(bmp : Bitmap)
		{
			_bmp = bmp;
			addChild(_bmp);
			_rippler = new Rippler(_bmp, 100, 6,6);
			_rippler.drawRipple(_bmp.width / 2, _bmp.height / 2,30, 1);
		}
	}
}
