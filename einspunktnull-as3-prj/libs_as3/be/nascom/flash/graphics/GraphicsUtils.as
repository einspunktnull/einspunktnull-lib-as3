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
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	
	/**
	 * The GraphicsUtilities class contains methods extending the flash.display.Graphics class functionality.
	 * 
	 * @see flash.display.Graphics
	 * 
	 * @author David Lenaerts
	 */
	public class GraphicsUtils
	{
		/**
		 * Draws a circular sector to a target Graphics object. Remember to call beginFill, beginGradientFill, beginBitmapFill and/or lineStyle prior to calling this method.
		 * 
		 * @param graphics The Graphics object to draw to.
		 * @param centerX The x location of the center of the circular sector relative to the registration point of the parent display object (in pixels) 
		 * @param centerY The y location of the center of the circular sector relative to the registration point of the parent display object (in pixels)
		 * @param radius The radius of the circular sector (in pixels).
		 * @param angle1 The angle of the first cutoff radius in degrees.
		 * @param angle2 The angle of the second cutoff radius in degrees.
		 * 
		 */
		public static function drawCircleSector(	graphics : Graphics, centerX : Number, centerY : Number,
													radius : Number, angle1 : Number, angle2 : Number) : void
		{
			var midAngle : Number, halfAngle : Number;
			var cos : Number, centerRadius : Number;
			var toRad : Number;
			var p1x : Number, p1y : Number,
				p2x : Number, p2y : Number,
				cx : Number, cy : Number;
			
			// the angle between the center of the two radii and the Y-axis
			midAngle = (angle1+angle2)*.5;
			
			// if the angle between the radii is >= 90 (any non-right corner in a right triangle can never be > 90), trig fails and we have to subdivide
			// taking half of that for smoother effect
			if (Math.abs(angle2-angle1) >= 45) {
				drawCircleSector(graphics, centerX, centerY, radius, angle1, midAngle);
				drawCircleSector(graphics, centerX, centerY, radius, midAngle, angle2);
				return;
			}
			
			// convert to radians
			toRad = Math.PI/180;
			angle1 *= toRad;
			angle2 *= toRad;
			midAngle *= toRad;
			
			// the half-angle between the two radii
			halfAngle = (angle2-angle1)*.5;
			
			// distance to control point = |hypotenuse| = |adjacent|/cos = |radius|/cos 
			cos = Math.cos(halfAngle);
			centerRadius = radius/cos;
			
			// control point position, based on its angle and distance from center
			cx = centerX+Math.cos(midAngle)*centerRadius;
			cy = centerY+Math.sin(midAngle)*centerRadius;
			
			// anchor points, based on angle and distance from center
			p1x = centerX+Math.cos(angle1)*radius;
			p1y = centerY+Math.sin(angle1)*radius;
			p2x = centerX+Math.cos(angle2)*radius;
			p2y = centerY+Math.sin(angle2)*radius;
			
			// draw the curve
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(p1x, p1y);
			graphics.curveTo(cx, cy, p2x, p2y);
			graphics.lineTo(centerX, centerY);
		}
		
		/**
		 * Returns any color from the range between your start & end color. Where t is a value from 0-1.
		 * 
		 * @param start Start color for your color range.
		 * @param end End color for your color range.
		 * @param t Parameter from 0 - 1 to get a specific color out of the color range.
		 * 
		 */
		public static function interpolateColor(start : uint ,end : uint, t : Number) : uint
		{
                var sr : int = (start >> 16) & 0xff;
                var sg : int = (start >> 8) & 0xff;
                var sb : int = start & 0xff;
                var er : int = (end >> 16) & 0xff;
                var eg : int = (end >> 8) & 0xff;
                var eb : int = end & 0xff;
                var tr : int = sr + t*(er-sr);
                var tg : int = sg + t*(eg-sg);
                var tb : int = sb + t*(eb-sb);

                return (tr << 16) | (tg << 8) | tb;
		}
		
		public static function tint (clip:DisplayObject, newColor:uint):void
		{
			var colorTransform:ColorTransform = clip.transform.colorTransform;
			colorTransform.color = newColor;
			clip.transform.colorTransform = colorTransform;
		}
	}
}