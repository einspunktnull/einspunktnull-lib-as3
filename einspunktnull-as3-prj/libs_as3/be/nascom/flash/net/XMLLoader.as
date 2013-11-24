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
package be.nascom.flash.net
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XMLLoader extends EventDispatcher
	{		
		public static const COMPLETE:String = "complete loading xml";	
			
		private var _source:String;
		private var _xml_doc:XML;
		
		public function XMLLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function set source(s:String):void
		{
			_source=s;
			loadSource();
		}
		
		public function get source():String
		{
			return _source;
		}
		
		public function get xml_doc():XML
		{
			if(_xml_doc==null)return new XML();
			return new XML(_xml_doc.toString());
		}
		
		public function set xml_doc(x:XML):void{
			/*error?*/
		}

		private function loadSource():void
		{
			var loader:URLLoader=new URLLoader();
			loader.addEventListener(Event.COMPLETE,handleXMLLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR,handleXMLLoadError);
            var url_request:URLRequest=new URLRequest(_source);
            try
            {
				loader.load(url_request);
            }catch(error:Error)
            {
            	dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            }
		}
		
		public function handleXMLLoaded(e:Event):void
		{
			_xml_doc=new XML(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function handleXMLLoadError(e:Event=null,stri:String=""):void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}		
	}
}