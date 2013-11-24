package net.einspunktnull.display.image
{
	import net.einspunktnull.bitmap.util.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author Albrecht Nitsche
	 */
	public class AutoScale9Image extends Scale9Image
	{
		public function AutoScale9Image(bmp : Bitmap)
		{
			var x1 : int = -1;
			var x2 : int = -1;
			var y1 : int = -1;
			var y2 : int = -1;

			var bmd : BitmapData = bmp.bitmapData;

			for (var i : int = 0; i < bmp.width; i++)
			{
				if (bmd.getPixel32(i, 0) == 0xff000000)
				{
					x1 = i;
					break;
				}
			}
			if (x1 != -1)
			{
				for (var j : int = x1; j < bmp.width; j++)
				{
					if (bmd.getPixel32(j, 0) != 0xff000000)
					{
						x2 = j - 1;
						break;
					}
				}
			}

			for (var k : int = 0; k < bmp.height; k++)
			{
				if (bmd.getPixel32(0, k) == 0xff000000)
				{
					y1 = k;
					break;
				}
			}

			if (y1 != -1)
			{
				for (var l : int = y1; l < bmp.height; l++)
				{
					if (bmd.getPixel32(0, l) != 0xff000000)
					{
						y2 = l - 1;
						break;
					}
				}
			}

			bmp = new Bitmap(BitmapUtil.grabPixels(bmp, new Rectangle(2, 2, bmp.width - 2, bmp.height - 2)));
			super(bmp, x1, x2, y1, y2);
		}
	}
}
