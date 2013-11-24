package net.einspunktnull.bitmap.util
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.images.JPGEncoder;
	import com.hurlant.util.Base64;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * @author Albrecht Nitsche
	 */
	public class BitmapUtil
	{
		public static function snapshot(displayObject : DisplayObject, width : int = 0, height : int = 0) : Bitmap
		{
			var w : int = width > 0 ? width : displayObject.width;
			var h : int = height > 0 ? height : displayObject.height;
			var snapshotBMD : BitmapData = new BitmapData(w, h, true, 0xffffff);
			var snapshot : Bitmap = new Bitmap(snapshotBMD, PixelSnapping.NEVER, true);
			snapshot.bitmapData.draw(displayObject);
			return snapshot;
		}

		public static function asJPGByteArray(displayObject : DisplayObject, quality : Number = 50, width : int = 0, height : int = 0) : ByteArray
		{
			var snapshot : Bitmap = snapshot(displayObject, width, height);
			var encoder : JPGEncoder = new JPGEncoder(quality);
			return encoder.encode(snapshot.bitmapData);
		}

		public static function asJPGByteArrayBase64(displayObject : DisplayObject, quality : Number = 50, width : Number = 0, height : Number = 0) : String
		{
			var jpgByteArray : ByteArray = asJPGByteArray(displayObject, quality, width, height);
			return Base64.encodeByteArray(jpgByteArray);
		}

		public static function asPNGByteArray(displayObject : DisplayObject, width : Number = 0, height : Number = 0) : ByteArray
		{
			var snapshot : Bitmap = snapshot(displayObject, width, height);
			return PNGEncoder.encode(snapshot.bitmapData);
		}

		public static function asPNGByteArrayBase64(displayObject : DisplayObject, width : Number = 0, height : Number = 0) : String
		{
			var pngByteArray : ByteArray = asJPGByteArray(displayObject, width, height);
			return Base64.encodeByteArray(pngByteArray);
		}

		public static function cloneBitmap(bmp : Bitmap) : Bitmap
		{
			return new Bitmap(bmp.bitmapData.clone(), "auto", true);
		}

		public static function grabPixels(source : DisplayObject, rect : Rectangle, smoothing : Boolean = true) : BitmapData
		{
			var draw : BitmapData = new BitmapData(source.width, source.height, true, 0);
			var copy : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			draw.draw(source, null, null, null, null, smoothing);
			copy.copyPixels(draw, rect, new Point(0, 0));
			draw.dispose();
			return copy;
		}

		public static function mergeHorizontal(left : Bitmap, right : Bitmap) : Bitmap
		{
			var merged : BitmapData = new BitmapData(left.width + right.width, (left.height >= right.height) ? left.height : right.height, true, 0);
			var rectLeft : Rectangle = new Rectangle(0, 0, left.width, left.height);
			merged.copyPixels(left.bitmapData, rectLeft, new Point(0, 0));
			var rectRight : Rectangle = new Rectangle(0, 0, right.width, right.height);
			merged.copyPixels(right.bitmapData, rectRight, new Point(left.width, 0));
			return new Bitmap(merged);
		}



	}
}
