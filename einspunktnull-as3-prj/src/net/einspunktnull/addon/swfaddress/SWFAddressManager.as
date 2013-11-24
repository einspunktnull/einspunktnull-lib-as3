package net.einspunktnull.addon.swfaddress 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @author Albrecht Nitsche
	 */
	public class SWFAddressManager extends EventDispatcher 
	{
		public static const INIT : String = "init";
		public static const CHANGE : String = "change";
		public static const INTERNAL_CHANGE : String = "internalChange";
		public static const EXTERNAL_CHANGE : String = "externalChange";
		
		private static const ERROR_MESSAGE : String = "Error - " + "Instantiation failed. " + "Use 'AddressManager.instance' instead of 'new'."
	;
		private static const INSTANCE : SWFAddressManager = new SWFAddressManager(InstanceLock)
	;

		public static function get instance() : SWFAddressManager 
		{
			return INSTANCE;
		}

		public function SWFAddressManager(key : Class) : void 
		{
			if (key != InstanceLock) throw new Error(ERROR_MESSAGE);
		}

		public function init() : void 
		{
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onEvent);
			SWFAddress.addEventListener(SWFAddressEvent.INTERNAL_CHANGE, onEvent);			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onEvent);
			SWFAddress.addEventListener(SWFAddressEvent.INIT, onEvent);
		}

		private var addressArray : Array = new Array();

		private function onEvent(event : SWFAddressEvent) : void 
		{
			switch(event.type)
			{
				case SWFAddressEvent.CHANGE:
					checkAddress();
					dispatchEvent(new Event(CHANGE));
					break;
				case SWFAddressEvent.EXTERNAL_CHANGE:
					checkAddress();
					dispatchEvent(new Event(EXTERNAL_CHANGE));
					break;
				case SWFAddressEvent.INTERNAL_CHANGE:
					checkAddress();
					dispatchEvent(new Event(INTERNAL_CHANGE));
					break;
			}
		}

		public function setTitle(title : String) : void 
		{
			if(title != "/") 
			{
				var string : String = title.substr(1);
				if(string.charAt(string.length - 1) == "/")
				string = string.substr(0, string.length - 1);
				string = string.split("/").join(" . ");
				SWFAddress.setTitle("Title - " + string);
			} 
			else 
			{
				SWFAddress.setTitle("Title - " + "Home");
			}
		}	

		public function setValue(value : String) : void 
		{
			SWFAddress.setValue(value);
		}

		public function getValue() : String 
		{
			return SWFAddress.getValue();	
		}

		private function checkAddress() : void 
		{
			var addressString : String = SWFAddressManager.instance.getValue();
			var addressArray : Array = addressString.split("/");
			var cleanArray : Array = new Array();
			for each (var string:String in addressArray) 
			{	
				if(string != "")
				cleanArray.push(string);
			}
			this.addressArray = cleanArray;
		}

		public function get address() : Array 
		{
			return addressArray;
		}
	}
}

internal class InstanceLock 
{
}