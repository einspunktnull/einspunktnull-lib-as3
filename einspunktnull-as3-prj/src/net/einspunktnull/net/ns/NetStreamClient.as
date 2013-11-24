package net.einspunktnull.net.ns 
{
	import flash.events.EventDispatcher;

	/**
	 * @author Albrecht Nitsche
	 */
	public class NetStreamClient extends EventDispatcher
	{
		public function onMetaData(infoObject:Object):void {
			dispatchEvent(new OnMetaDataEvent(OnMetaDataEvent.METADATA_INFOOBJECT, infoObject));
        }
        
        public function onXMPData(infoObject:Object):void {
			dispatchEvent(new OnMetaDataEvent(OnMetaDataEvent.XMPDATA_INFOOBJECT, infoObject));
        }
        
        public function onCuePoint(infoObject:Object):void {
			dispatchEvent(new OnMetaDataEvent(OnMetaDataEvent.CUEPOINT_INFOOBJECT, infoObject));
        }
	}
}
