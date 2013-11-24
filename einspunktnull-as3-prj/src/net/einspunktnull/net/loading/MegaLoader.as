package net.einspunktnull.net.loading
{
	import net.einspunktnull.data.util.StringUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	[Event(name="COMPLETE", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	[Event(name="PROGRESS", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	[Event(name="IO_ERROR", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	[Event(name="SECURITY_ERROR", type="net.einspunktnull.net.loading.EPNLoaderEvent")]
	/**
	 * @author Albrecht Nitsche
	 */
	public class MegaLoader extends EventDispatcher
	{
		private var _loaderTypes : Dictionary = new Dictionary();
		private var _loaders : Vector.<IEPNLoader>;
		private var _bytesTotal : Number;
		private var _bytesLoaded : Number;
		private var _sizeDetectionType : String = MegaLoaderSizeDetectionType.NONE;
		private var _useFixBytesLoaded : Boolean = false;
		public var sizeDetectionUrl : String;
		private var _loadersComplete : uint;

		public function MegaLoader()
		{
			createLoaderTypes();
			_loaders = new Vector.<IEPNLoader>();
		}

		private function createLoaderTypes() : void
		{
			_loaderTypes["png"] = ImageLoader;
			_loaderTypes["gif"] = ImageLoader;
			_loaderTypes["jpg"] = ImageLoader;
			_loaderTypes["jpeg"] = ImageLoader;

			_loaderTypes["zip"] = ZIPLoader;
			_loaderTypes["swc"] = ZIPLoader;

			_loaderTypes["xml"] = XMLLoader;

			_loaderTypes["swf"] = SWFLoader;
		}

		public function set sizeDetectionType(sizeDetectionType : String) : void
		{
			_sizeDetectionType = sizeDetectionType;
		}

		private function getLoaderClass(fileExtension : String) : Class
		{
			var ext : String = fileExtension.toLowerCase();
			return _loaderTypes[ext];
		}

		public function load() : void
		{
			if (_sizeDetectionType == MegaLoaderSizeDetectionType.NONE)
			{
				startLoading();
			}
			else if (_sizeDetectionType == MegaLoaderSizeDetectionType.URL)
			{
				if (sizeDetectionUrl)
				{
					var urlVars : URLVariables = new URLVariables();
					urlVars["baseDir"] = "../";
					urlVars["pwd"] = "net.einspunktnull.net.loading.MegaLoader";
					var fileVars : URLVariables = new URLVariables();
					for (var i : int = 0; i < _loaders.length; i++)
					{
						var loader : EPNLoader = (_loaders[i] as EPNLoader);
						fileVars["f" + i] = loader.url;
					}
					urlVars["files"] = fileVars;
					var txtLoader : TextLoader = new TextLoader(sizeDetectionUrl);
					txtLoader.vars = urlVars;
					txtLoader.addEventListener(EPNLoaderEvent.COMPLETE, onDetectFileSizeComplete);
					txtLoader.load();
				}
				else
				{
					warnch(this, "no sizeDetectionUrl defined - use No SizeDetection");
					startLoading();
				}
			}
		}

		private function onDetectFileSizeComplete(event : EPNLoaderEvent) : void
		{
			var tl : TextLoader = event.target as TextLoader;
			_bytesTotal = Number(tl.getText());
			if (!isNaN(_bytesTotal)) _useFixBytesLoaded = true;
			else warnch(this, "sizeDetectionfailed - use No SizeDetection");
			startLoading();
		}

		private function startLoading() : void
		{
			_loadersComplete = 0;
			for each (var loader : IEPNLoader in _loaders)
			{
				setListeners(true, loader, evtHandler);
				loader.load();
			}
		}

		private function setListeners(add : Boolean, loader : IEPNLoader, evtHandler : Function) : void
		{
			if (add)
			{
				loader.addEventListener(EPNLoaderEvent.COMPLETE, evtHandler);
				loader.addEventListener(EPNLoaderEvent.IO_ERROR, evtHandler);
				loader.addEventListener(EPNLoaderEvent.SECURITY_ERROR, evtHandler);
				loader.addEventListener(EPNLoaderEvent.PROGRESS, evtHandler);
			}
			else
			{
				loader.removeEventListener(EPNLoaderEvent.COMPLETE, evtHandler);
				loader.removeEventListener(EPNLoaderEvent.IO_ERROR, evtHandler);
				loader.removeEventListener(EPNLoaderEvent.SECURITY_ERROR, evtHandler);
				loader.removeEventListener(EPNLoaderEvent.PROGRESS, evtHandler);
			}
		}

		private function evtHandler(event : EPNLoaderEvent) : void
		{
			switch(event.type)
			{
				case EPNLoaderEvent.PROGRESS:
					onProgress(event);
					dispatchEvent(new EPNLoaderEvent(EPNLoaderEvent.PROGRESS, new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal)));
					break;
				case EPNLoaderEvent.COMPLETE:
					onComplete();
					break;
			}
		}

		private function onComplete() : void
		{
			_loadersComplete++;

			if (_loadersComplete == _loaders.length)
			{
				for each (var loader : IEPNLoader in _loaders)
				{
					setListeners(false, loader, evtHandler);
				}
				dispatchEvent(new EPNLoaderEvent(EPNLoaderEvent.COMPLETE, new Event(Event.COMPLETE)));
			}
		}

		private function onProgress(event : Event) : void
		{
			if (!_useFixBytesLoaded) _bytesTotal = 0;
			_bytesLoaded = 0;
			for each (var loader : EPNLoader in _loaders)
			{
				if (loader.bytesTotal > -1)
				{
					_bytesLoaded += loader.bytesLoaded;
					if (!_useFixBytesLoaded) _bytesTotal += loader.bytesTotal;
				}
			}
		}

		public function get sizeDetectionType() : String
		{
			return _sizeDetectionType;
		}

		public function get bytesTotal() : Number
		{
			return _bytesTotal;
		}

		public function get bytesLoaded() : Number
		{
			return _bytesLoaded;
		}

		public function addItem(url : String) : void
		{
			var fileExtension : String = StringUtil.getFileExtension(url);
			var loaderClass : Class = getLoaderClass(fileExtension);
			if (!loaderClass) return;
			var loader : IEPNLoader = new loaderClass(url);
			_loaders.push(loader);
		}

		public function getItem(url : String) : *
		{
			for each (var loader : IEPNLoader in _loaders)
			{
				if (EPNLoader(loader).url == url) return loader.content;
			}

			return null;
		}

		public function get loaders() : Vector.<IEPNLoader>
		{
			return _loaders;
		}
	}
}
