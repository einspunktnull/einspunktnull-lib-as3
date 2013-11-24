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

package be.nascom.flash.math
{
	import flash.geom.Point;
	
	/**
	 * The LineSegment Class represents a 2D line segment from one point to another, or an infinite line through two points.
	 * This class makes use of the standard AS3 Point rather than NascomASLib's Point2D/Vector2D, to ensure compatability when these classes are not used.
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
	 */
	public class LineSegment
	{
		/**
		 * The x-coordinate of the starting point
		 */
		public var x0 : Number;
		
		/**
		 * The y-coordinate of the starting point
		 */
		public var y0 : Number;
		
		/**
		 * The x-coordinate of the end point
		 */
		public var x1 : Number;
		
		/**
		 * The y-coordinate of the end point
		 */
		public var y1 : Number;
		
		/**
		 * Creates an instance of LineSegment
		 * 
		 * @param x0 The x-coordinate of the starting point
		 * @param y0 The y-coordinate of the starting point
		 * @param x1 The x-coordinate of the end point
		 * @param y1 The y-coordinate of the end point
		 */
		public function LineSegment(x0 : Number, y0 : Number, x1 : Number, y1 : Number)
		{
			this.x0 = x0;
			this.y0 = y0;
			this.x1 = x1;
			this.y1 = y1;
		}
		
		/**
		 * Calculates the distance from a point to the infinite line (not the segment!). Ie, the begin and end points are ignored, and the line is treated as an infinite algebraic line.
		 */
		public function distanceToPoint(x : Number, y : Number) : Number
		{
			var deltaX : Number, deltaY : Number;
			
			// faster methods given prerequisites
			if (x0 == x1) return Math.abs(x-x0);
			if (y0 == y1) return Math.abs(y-y0);
			
			deltaX = x1-x0;
			deltaY = y1-y0;
			return Math.abs(deltaX*(y0-y)-deltaY*(x0-x))/Math.sqrt(deltaX*deltaX+deltaY*deltaY);
		}
		
		/**
		 * Returns the normalized vector pointing in the direction of the line
		 * 
		 * @see flash.geom.Point
		 */
		public function getOrientationVector() : Point
		{
			var p : Point = new Point(x1-x0, y1-y0);
			p.normalize(1);
			return p;
		}
		
		/**
		 * Formats the line parameters as a string.
		 */
		public function toString() : String
		{
			return "( "+x0+" , "+y0+" ) - ( "+x1+" , "+y1+" )";
		}
		
		/**
		 * The slope of a line. if x1==x0, slope would be +/-Infinity, and therefore it returns the maximum/minimum Number value. However, it is recommended to use a valid work-around for strictly horizontal lines.
		 */
		public function get slope() : Number
		{
			// fix this
			if (x1 == x0 && y0 < y1) return Number.MIN_VALUE;
			if (x1 == x0 && y0 > y1) return Number.MAX_VALUE;
			return (y1-y0)/(x1-x0);
		}
		
		/**
		 * Returns the intersection point of this line with another.
		 * 
		 * @param line A line segment for which the intersection point is needed.
		 * @param infinite Defines whether the LineSegment is treated as an infinite line or a segment. If true, the start and end points of the line segment are ignored, and it is handled as an infinite algebraic line. Default value is false, so the line will be treated as a segment. Ie, the intersection point is not returned unless it falls within the bounds of both segments.
		 */
		public function getIntersection(line : LineSegment, infinite : Boolean = false) : Point
		{
			var check : Boolean;
			var slope1 : Number;
			var slope2 : Number;
			var intersectionX : Number;
			var intersectionY : Number;
			
			if (y0 == y1 && line.y0 == line.y1) return null;
				// parallel horizontal lines
			
			if (x0 == x1) {
				// this slope infinity, need workaround
				if (line.x0 == line.x1) {
					// parallel verical lines
					return null;
				}
				else {
					intersectionX = x0;
					intersectionY = line.slope*(x0-line.x0)+line.y0; 
				}
			}
			else if (line.x0 == line.x1) {
				// line slope infinity, parallel case already handled in previous if
				intersectionX = line.x0;
				intersectionY = slope*(line.x0-x0)+y0; 
			}
			else {
				// case if line slopes are both valid (not +/-infinity)
				slope1 = this.slope;
				slope2 = line.slope;
				
				// parallel lines
				if (slope1 == slope2) return null;
				
				// nonparallel lines
				intersectionX = (line.x0-x0)/(slope1-slope2);
				intersectionY = slope1*intersectionX;			
			}
			
			// do not take segment end and start into account
			if (infinite) {
				return new Point(intersectionX, intersectionY);
			}
			
			// check if intersection is part of both segments, if so, return intersection point 
			if (isMemberPointOnSegment(intersectionX, intersectionY) &&
				line.isMemberPointOnSegment(intersectionX, intersectionY))
				return new Point(intersectionX, intersectionY);
			
			// default case
			return null;
		}
		
		/**
		 * Checks if a point is on the line or line segment.
		 * 
		 * @param pointX The horizontal coordinate of the point
		 * @param pointY The vertical coordinate of the point
		 * @param infinite Defines whether the LineSegment is treated as an infinite line or a segment. If true, the start and end points of the line segment are ignored, and it is handled as an infinite algebraic line. Default value is false, so the line will be treated as a segment. Ie, the function returns false unless it falls within the bounds of both segments.
		 */
		public function containsPoint(pointX : Number, pointY : Number, infinite : Boolean = false) : Boolean
		{
			if (pointY != pointX*slope)
				return false;
			
			if (infinite) return true;
			
			return isMemberPointOnSegment(pointX, pointY);
		}
		
		/**
		 * Checks if a point with coordinates (pointX, pointY) that is on the line, falls within the boundaries of the line
		 * Assertion: pointY = pointX*slope (ie: point € line);
		 */
		private function isMemberPointOnSegment(pointX : Number, pointY : Number) : Boolean
		{
			if (x0 < x1 && pointX >= x0 && pointX <= x1) {
				return true;
			} 
			else if (x0 > x1 && pointX >= x1 && pointX <= x0) {
				return true;
			}
			else if (y0 <= y1 && pointY >= y0 && pointY <= y1) {
				return true;
			}
			else if (y0 > y1 && pointY <= y0 && pointY >= y1) {
				return true;
			}
			
			return false;
		}
	}
	
}