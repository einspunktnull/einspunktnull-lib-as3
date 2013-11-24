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
package be.nascom.flash.util
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class DisplayUtil
	{
		/**
		 *  The <code>removeAllChildren()</code> method returns an Boolean whether or not all the children of a DisplayObjectContainer have been removed
		 *	
		 *  @param doc	DisplayObjectContainer
		 *	
		 *	@return	Boolean whether or not all the children of a DisplayObjectContainer have been removed
		 *
		*/
		public static function removeAllChildren(doc:DisplayObjectContainer):Boolean
		{
			while(doc.numChildren) doc.removeChildAt(0);
			if(doc.numChildren == 0) return true;
			return false;
		}
		
		/**
		 *  The <code>stopAllChildren()</code> method stops the passed Movieclip and all it's children-Movieclips.
		 *
		 *  @param	mc	Movieclip 
		 *
		*/
		public static function stopAllChildren(mc:MovieClip):void
		{
			//trace('STOP called for: '+mc);
			mc.stop();
			for(var i:int = 0; i < mc.numChildren; i++){
				if(mc.getChildAt(i)){
					if(mc.getChildAt(i).hasOwnProperty('currentFrame')){
						stopAllChildren(MovieClip(mc.getChildAt(i)));
					}
				}
			}   
		}
	}
}