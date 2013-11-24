package net.einspunktnull.net.ns
{
	import flash.net.NetConnection;
	import flash.net.NetStream;


	public class MyNetStream extends NetStream {
        public var onMetaData:Function;
        public var onCuePoint:Function;
 
        public function MyNetStream(nc:NetConnection) {
            onMetaData = metaDataHandler;
            onCuePoint = cuePointHandler;
            super(nc);
        }
 
        private function metaDataHandler(infoObject:Object):void {
            dispatchEvent(new OnMetaDataEvent(OnMetaDataEvent.METADATA_INFOOBJECT,infoObject));
		}
 
        private function cuePointHandler(infoObject:Object):void {
            dispatchEvent(new OnMetaDataEvent(OnMetaDataEvent.CUEPOINT_INFOOBJECT, infoObject));
        }
    }
}
