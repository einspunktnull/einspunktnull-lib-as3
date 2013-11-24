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
package be.nascom.flash.display.objectHandle{
	
	public class ObjectHandleProperties{
		
		public var x:Number = 100;
		public var y:Number = 100;
		public var width:Number = 100;
		public var height:Number = 200;
		public var rotation:Number=0;
		
		public function ObjectHandleProperties(){
		}
		
		public function equals(properties:ObjectHandleProperties):Boolean{
			var p:ObjectHandleProperties=properties;
			return (p.x==x && p.y==y && p.width==width && p.height==height && p.rotation==rotation);
		}

		public function toString():String{
			return "ObjectHandleProperties{x:"+x+" , y:"+y+" , width:"+width+" , height:"+height+" , rotation:"+rotation+" }";
		}

	}
}