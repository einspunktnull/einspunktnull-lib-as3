package net.einspunktnull.net.loading
{
	import flash.net.URLVariables;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;


	[Event(name="COMPLETE", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	[Event(name="PROGRESS", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	[Event(name="IO_ERROR", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	[Event(name="SECURITY_ERROR", type="net.einspunktnull.net.loading.EPNLoaderEvent")]

	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNLoader extends EventDispatcher
	{
		protected var _url : String;
		private var _loader : EventDispatcher;
		public var proxy : Object;
		public var vars : URLVariables = new URLVariables();
		protected var _bytesLoaded : Number = 0;
		protected var _bytesTotal : Number = -1;

		public function EPNLoader(loader : EventDispatcher, url : String = null)
		{
			_loader = loader;
			_url = url;
		}

		protected function addListeners() : void
		{
			_loader.addEventListener(Event.COMPLETE, eventHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			_loader.addEventListener(ProgressEvent.PROGRESS, eventHandler);
		}

		protected function removeListeners() : void
		{
			_loader.removeEventListener(Event.COMPLETE, eventHandler);
			_loader.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
		}

		protected function eventHandler(event : Event) : void
		{
			var eventType : String;
			switch(event.type)
			{
				case ProgressEvent.PROGRESS:
					eventType = EPNLoaderEvent.PROGRESS;
					_bytesLoaded = ProgressEvent(event).bytesLoaded;
					_bytesTotal = ProgressEvent(event).bytesTotal;
					break;
				case Event.COMPLETE:
					eventType = EPNLoaderEvent.COMPLETE;
					removeListeners();
					break;
				case IOErrorEvent.IO_ERROR:
					eventType = EPNLoaderEvent.IO_ERROR;
					removeListeners();
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					eventType = EPNLoaderEvent.SECURITY_ERROR;
					removeListeners();
					break;
			}
			dispatchEvent(new EPNLoaderEvent(eventType, event));
		}

		public function get url() : String
		{
			return _url;
		}

		public function get bytesLoaded() : Number
		{
			return _bytesLoaded;
		}

		public function get bytesTotal() : Number
		{
			return _bytesTotal;
		}
	}
}
