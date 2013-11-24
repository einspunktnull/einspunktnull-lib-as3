package net.einspunktnull.bitmap.algorithm.unshredd
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import net.einspunktnull.data.util.ConvertUtil;


	/**
	 * @author Albrecht Nitsche
	 */
	public class UnshreddAlgorithm
	{
		private var _bitmap : Bitmap;
		private var _width : Number;
		private var _height : Number;
		private var _stripWidth : int = 2;
		private var _totalStrips : int;

		public function UnshreddAlgorithm(bitmapIn : Bitmap)
		{
			_bitmap = bitmapIn;
			_width = _bitmap.width;
			_height = _bitmap.height;
		}


		public function getStripWidth() : int
		{
			_stripWidth = computeStripWidth();
			return _stripWidth;
		}

		public function unshredd() : Bitmap
		{
			if (_stripWidth < 2) return null;

			_totalStrips = _width / _stripWidth;

			var score : int = 1 << 29;
			var finalStrip : int = -1;
			var stripMap : Dictionary = new Dictionary();
			// Upto 8 works good! stepping in eights saves some time
			var colorRange : int = 8;

			for (var strip : int = 0; strip < _totalStrips; strip++)
			{
				var neighbour : Array = findBestNeightbour(strip, colorRange);

				stripMap[neighbour[0]] = strip;
				if (neighbour[1] < score)
				{
					score = neighbour[1];
					finalStrip = strip;
				}
			}

			var nextStrip : int = finalStrip;
			var unshreddedImage : Bitmap = new Bitmap();
			var bmd : BitmapData = new BitmapData(_bitmap.width, _bitmap.height);

			for (var stripi : int = _totalStrips - 1; stripi > -1; stripi--)
			{
				var rect : Rectangle = new Rectangle(_stripWidth * nextStrip, 0, _stripWidth, _height);
				var destPoint : Point = new Point(stripi * _stripWidth, 0);
				bmd.copyPixels(_bitmap.bitmapData, rect, destPoint);
				if (stripMap[nextStrip]!=null)
				{
					nextStrip = stripMap[nextStrip];
				}
			}

			unshreddedImage.bitmapData = bmd;

			return unshreddedImage;
		}

		private function findBestNeightbour(strip : int, colorRange : int) : Array
		{
			var bestScore : int = -1;
			// var bestNeighbour : int = -1;
			var bestStrip : int;
			for (var curStrip : int = 0; curStrip < _totalStrips; curStrip++)
			{
				if (curStrip != strip)
				{
					var curScore : int = computeScore(strip, curStrip, _stripWidth, colorRange);
					if (curScore > bestScore)
					{
						bestScore = curScore;
						bestStrip = curStrip;
					}
				}
			}
			return [bestStrip, bestScore];
		}

		private function computeStripWidth() : Number
		{

			var minStripWidth : uint = 2;
			var maxStripWidth : uint = _width / 2;
			// Random negative value
			var stripWidth : int = -1 << 29;
			var stripDifference : Number = -1;
			// This value worked out to be the best!
			var threshold : uint = 2;

			for (var curStripWidth : int = minStripWidth; curStripWidth < maxStripWidth + 1; curStripWidth++)
			{
				if (_width % curStripWidth != 0) continue;

				var total : Number = 0;

				var avgStripDiff : Number;
				for (var i : int = 0; i < _width / curStripWidth; i++)
				{
					if ((i + 1) < (_width / curStripWidth))
					{
						var score : Number = computeScore(i, i + 1, curStripWidth, 8);
						var result : Number = computeStripDifference(8, _height, score);
						total += result;
					}
					avgStripDiff = total / (_width / curStripWidth);
				}
				if (avgStripDiff > stripDifference)
				{
					if (curStripWidth % stripWidth == 0)
					{
						if (Math.abs(avgStripDiff - stripDifference) <= threshold) continue;
					}
					stripWidth = curStripWidth;
					stripDifference = avgStripDiff;
				}
			}
			return stripWidth;
		}

		private function computeScore(strip1 : int, strip2 : int, stripWidth : int, colourRangeSize : int) : Number
		{
			var score : int = 0;
			// Based on some heuristics
			var threshold : Number = 30;
			for (var i : int = 0; i < _height; i += colourRangeSize)
			{
				var avgPx1 : Array = [0, 0, 0, 0];
				var avgPx2 : Array = [0, 0, 0, 0];
				for (var colourRange : int = 0; colourRange < colourRangeSize; colourRange++)
				{
					if (i + colourRange < _height)
					{
						var px1 : Array = getPixelValue((stripWidth * strip1) + (stripWidth - 1), (i + colourRange));
						var px2 : Array = getPixelValue((stripWidth * strip2), (i + colourRange));
						for (var j : int = 1; j < 4; j++)
						{
							avgPx1[j] += px1[j];
							avgPx2[j] += px2[j];
						}
						var distance : Number = computeDistance(avgPx1, avgPx2);
						if (distance < threshold) score++;
					}
				}
			}
			return score;
		}

		private function computeDistance(p : Array, q : Array) : Number
		{
			var r : int = p[1] - q[1];
			var g : int = p[2] - q[2];
			var b : int = p[3] - q[3];
			return Math.sqrt(( r * r + g * g + b * b ));
		}

		private function getPixelValue(x : uint, y : uint) : Array
		{
			var pxValDec : uint = _bitmap.bitmapData.getPixel32(x, y);
			return ConvertUtil.argb2uintArray(pxValDec);

		}

		private function computeStripDifference(colourRange : int, height : Number, score : Number) : int
		{
			return int(Math.round(height / colourRange) - score);
		}

	}
}
