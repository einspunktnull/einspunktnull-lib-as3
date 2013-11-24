package net.einspunktnull.display.image
{
	import net.einspunktnull.bitmap.util.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Albrecht Nitsche
	 */
	public class Scale9Image extends Sprite
	{
		private var _bmp : Bitmap;
		private var _x1 : Number;
		private var _x2 : Number;
		private var _y1 : Number;
		private var _y2 : Number;
		private var _bmpTL : Bitmap;
		private var _bmpTM : Bitmap;
		private var _bmpTR : Bitmap;
		private var _bmpCL : Bitmap;
		private var _bmpCM : Bitmap;
		private var _bmpCR : Bitmap;
		private var _bmpBL : Bitmap;
		private var _bmpBM : Bitmap;
		private var _bmpBR : Bitmap;

		public function Scale9Image(bmp : Bitmap, x1 : Number, x2 : Number, y1 : Number, y2 : Number)
		{
			_bmp = bmp;
			_x1 = x1;
			_x2 = x2;
			_y1 = y1;
			_y2 = y2;

			cut();

			width = _bmp.width;
			height = _bmp.height;
		}

		private function cut() : void
		{
			_bmpTL = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(0, 0, _x1, _y1)));
			_bmpTM = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(_x1, 0, _x2 - _x1, _y1)));
			_bmpTR = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(_x2, 0, _bmp.width - _x2, _y1)));
			addChild(_bmpTL);
			addChild(_bmpTM);
			addChild(_bmpTR);

			_bmpCL = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(0, _y1, _x1, _y2 - _y1)));
			_bmpCM = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(_x1, _y1, _x2 - _x1, _y2 - _y1)));
			_bmpCR = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(_x2, _y1, _bmp.width - _x2, _y2 - _y1)));
			addChild(_bmpCL);
			addChild(_bmpCM);
			addChild(_bmpCR);

			_bmpBL = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(0, _y2, _x1, _bmp.height - _y2)));
			_bmpBM = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(_x1, _y2, _x2 - _x1, _bmp.height - _y2)));
			_bmpBR = new Bitmap(BitmapUtil.grabPixels(_bmp, new Rectangle(_x2, _y2, _bmp.width - _x2, _bmp.height - _y2)));
			addChild(_bmpBL);
			addChild(_bmpBM);
			addChild(_bmpBR);
		}

		override public function set width(width : Number) : void
		{
			_bmpTR.x = _bmpCR.x = _bmpBR.x = width - _bmpTR.width;
			_bmpTM.x = _bmpCM.x = _bmpBM.x = _bmpTL.width;
			_bmpTM.width = _bmpCM.width = _bmpBM.width = _bmpTR.x - _bmpTM.x;
		}

		override public function set height(height : Number) : void
		{
			_bmpBL.y = _bmpBM.y = _bmpBR.y = height - _bmpBL.height;
			_bmpCL.y = _bmpCM.y = _bmpCR.y = _bmpTL.height;
			_bmpCL.height = _bmpCM.height = _bmpCR.height = _bmpBL.y - _bmpCL.y;
		}
	}
}
