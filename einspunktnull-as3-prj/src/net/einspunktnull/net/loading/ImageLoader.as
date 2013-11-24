package net.einspunktnull.net.loading
{
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * @author Albrecht Nitsche
	 */
	public class ImageLoader extends EPNLoader implements IEPNLoader
	{
		private var _loader : URLLoader;
		private var _bitmap : Bitmap;
		private var _onCompleteEvent : Event;

		public function ImageLoader(url : String = null)
		{
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			super(_loader, url);
		}

		public function load(url : String = null) : void
		{
			if (url) _url = url;
			addListeners();
			_loader.load(new URLRequest(_url));
		}

		override protected function eventHandler(event : Event) : void
		{
			var eventType : String;
			switch(event.type)
			{
				case ProgressEvent.PROGRESS:
					eventType = EPNLoaderEvent.PROGRESS;
					_bytesLoaded = ProgressEvent(event).bytesLoaded;
					_bytesTotal = ProgressEvent(event).bytesTotal;
					dispatchEvent(new EPNLoaderEvent(eventType, event));
					break;
				case IOErrorEvent.IO_ERROR:
					eventType = EPNLoaderEvent.IO_ERROR;
					removeListeners();
					dispatchEvent(new EPNLoaderEvent(eventType, event));
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					eventType = EPNLoaderEvent.SECURITY_ERROR;
					removeListeners();
					dispatchEvent(new EPNLoaderEvent(eventType, event));
					break;
				case Event.COMPLETE:
					eventType = EPNLoaderEvent.COMPLETE;
					_onCompleteEvent = new EPNLoaderEvent(eventType, event);
					onComplete();
					break;
			}
			
		}

		private function onComplete() : void
		{
			var loader : Loader = new Loader();
			loader.loadBytes(_loader.data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onReady);
		}

		private function onReady(event : Event) : void
		{
			var loaderInfo : LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onReady);
			_bitmap = loaderInfo.content as Bitmap;
			removeListeners();
			dispatchEvent(_onCompleteEvent);
		}


		public function getBitmap() : Bitmap
		{
			return _bitmap;
		}

		public function get content() : *
		{
			return getBitmap();
		}
	}
}
