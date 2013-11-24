package net.einspunktnull.net.ns 
{
	import flash.events.Event;

	/**
	 * 
	 *
	 * @author Albrecht Nitsche
	 */
	public class OnMetaDataEvent extends Event 
	{
		public static const METADATA_INFOOBJECT : String = "metadata_infoobject";
		public static const CUEPOINT_INFOOBJECT : String = "cuepoint_infoobject";
		public static const XMPDATA_INFOOBJECT : String = "xmpdata_infoobject";

		public var infoObject : Object;

		
		public function OnMetaDataEvent(type : String, infoObject : Object) 
		{
			this.infoObject = infoObject;
			super(type);
		}

		public function clear() : void 
		{
			infoObject = null;
		}

		override public function clone() : Event 
		{
			return new OnMetaDataEvent(type, infoObject);
		}
	}
}
