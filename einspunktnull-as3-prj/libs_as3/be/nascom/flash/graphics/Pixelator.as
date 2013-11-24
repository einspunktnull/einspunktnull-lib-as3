/*
Copyright (c) 2008 NascomASLib Contributors.  See:
    http://code.google.com/p/nascomaslib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.nascom.flash.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	/** 
	 * 
	 * Pixelator creates a pixelated or mosaic image from a DisplayObject source. The amount of pixelation can be tweened to create mosaic fading effects. 
	 * 
	 * @example The following code takes a bitmap and places a pixelated version on the stage, assuming <code>bitmapData</code>
	 * 			is a loaded bitmap.
	 * 	<listing version="3.0">
	 * 		import be.nascom.flash.graphics.Pixelator;
	 * 		
	 * 		var pixelator : Pixelator = new Pixelator(bitmapData, 0.8);
	 * 		addChild(pixelator);
	 * </listing>
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
 	 */
	
	public class Pixelator extends Bitmap
	{
		private var _pixelation : Number = 0;
		private var _source : DisplayObject;
		
		/**
		 * Initializes a Pixelator object to refer to the specified BitmapData object.
		 * @param source The source DisplayObject to be pixelated.
		 * @param pixelation The amount of pixelation, a value between 0 and 1. 0 is not pixelated, 1 means the picture is reduced to 1 pixel.
		 */
		public function Pixelator(source : DisplayObject, pixelation : Number = 0)
		{
			_pixelation = pixelation;
			this.source = source;
			updateBitmap();
		}
		
		/**
		 * The amount of pixelation, a value between 0 and 1. 0 is not pixelated, 1 means the picture is reduced to 1 pixel.
		 */
		public function get pixelation() : Number
		{
			return _pixelation;
		}
		
		public function set pixelation(value : Number) : void
		{
			_pixelation = value;
			updateBitmap();
		}
		
		
		/**
		 * The source DisplayObject to be pixelated.
		 */
		public function get source() : DisplayObject
		{
			return _source;
		}
		
		public function set source(value : DisplayObject) : void
		{
			_source = value;
			if (bitmapData) bitmapData.dispose();
			bitmapData = new BitmapData(value.width, value.height);
			updateBitmap();
		}
		
		private function updateBitmap() : void
		{
			var scale : Number;
			var invScale : Number;
			var tempBmp : BitmapData;
			var matrix : Matrix;
			
			if (_pixelation == 1) {
				scale = 0.00001;
				tempBmp = new BitmapData(1, 1);
			}
			else {
				scale = 1-_pixelation;
				tempBmp = new BitmapData(Math.ceil(bitmapData.width*scale), Math.ceil(bitmapData.height*scale));
			}
			
			invScale = 1/scale
			
			matrix = new Matrix(scale, 0, 0, scale);
			tempBmp.draw(_source, matrix);
			matrix.a = matrix.d = invScale;
			bitmapData.draw(tempBmp, matrix);
			tempBmp.dispose();
		}
	}
}