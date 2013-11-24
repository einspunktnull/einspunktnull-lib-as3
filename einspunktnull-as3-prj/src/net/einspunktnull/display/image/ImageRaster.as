package net.einspunktnull.display.image
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ImageRaster extends Sprite
	{
		private var _bmpData : BitmapData;
		private var _shape : Shape;
		private var _smoothing : Boolean;

		public function ImageRaster(bmpData : BitmapData, smoothing : Boolean = false)
		{
			super();
			_bmpData = bmpData;
			_smoothing = smoothing;
			_shape = new Shape();
			addChild(_shape);
		}

		public function redraw(rect:Rectangle) : void
		{
			_shape.graphics.clear();
			_shape.graphics.beginBitmapFill(_bmpData);
			_shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			_shape.graphics.endFill();
		}
	}
}
