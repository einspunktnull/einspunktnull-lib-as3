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

package be.nascom.air
{
	import flash.desktop.NativeApplication;
	import flash.desktop.Updater;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
   
   /**
	 * The UpdateManager can be used to enable Auto-Update in your AIR applications. 
	 * 
	 * @author Alain Hufkens
	 * @email alain.hufkens@nascom.be
	 * 	 
	 */
    public class UpdateManager
    {
        // URL of the remote version.xml file
        private var versionURL:String;
        // load in the applicationDescriptor
        private var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
        private var ns : Namespace = appXML.namespace();
        // set the currentVersion information
        private var currentVersion:String = appXML.ns::version;
        // holder for remote version.xml XML data
        private var version:XML;
        private var urlStream:URLStream = new URLStream();
        private var fileData:ByteArray = new ByteArray();
        public var alertTitle:String = "Update";
        
        private var logger:ILogger = Log.getLogger("UpdateManager");
       
        /** 
        * The constructor requires the url to the version.xml file.
        * 
        * @param versionURL The url of the 'version.xml' file.
        * @param autoCheck If autocheck is true then the check for a new version is done.
        * **/
        public function UpdateManager(versionURL:String,autoCheck:Boolean=true):void{
            logger.debug("loading version info: " + versionURL);
            logger.debug("autocheck = " + autoCheck);
            this.versionURL = versionURL;
            if(autoCheck)loadRemoteFile();
        }
            
        /** 
         * Loads the remote version.xml file
         * */
        private function loadRemoteFile():void{
            var http:HTTPService = new HTTPService();
            http.url = this.versionURL;
            http.useProxy=false;
            http.method = "GET";
            http.resultFormat="xml";
            http.send();
            http.addEventListener(ResultEvent.RESULT,testVersion);
            http.addEventListener(FaultEvent.FAULT,versionLoadFailure);
        }
         
        /**
         * Test the currentVersion against the remote version file and either alert the user of
         * an update available or force the update, if no update available, alert user
         */
        public function checkForUpdate():Boolean{
          if(version  ==  null){
            this.loadRemoteFile();
            return true;
          }
          if((currentVersion != version.@version) && version.@forceUpdate == true){
              getUpdate();
          }else if(currentVersion != version.@version){
              Alert.show("There is an update available,\nwould you like to get it now? \n\nDetails:\n" + version.@message, alertTitle, 3, null, alertClickHandler);
          }else{
              Alert.show("There are no new updates available", alertTitle);
          }
          return true;
        }
        
        /**
         * Test the currentVersion against the remote version file and either alert the user of
         * an update available or force the update
         */
        private function testVersion(event:ResultEvent):void{
          version = XML(event.result);
          if((currentVersion != version.@version) && version.@forceUpdate == true){
              getUpdate();
          }else if(currentVersion != version.@version){
              Alert.show("There is an update available,\nwould you like to " + 
                         "get it now? \n\nDetails:\n" + version.@message, 
                         alertTitle, 3, null, alertClickHandler);
          }
        } 
        
        /**
         * Load of the version.xml file failed
         */
        private function versionLoadFailure(event:FaultEvent):void{
        	logger.error("Failed to load version.xml file from " + versionURL);
//            Alert.show("Failed to load version.xml file from "+ 
//                        this.versionURL,"ERROR");
        }
       
        /** 
        * Handle the Alert window return value;
        * **/
        private function alertClickHandler(event:CloseEvent):void {
            if (event.detail==Alert.YES){
                getUpdate();
            }
        }
       
        /** 
        * Get the new version from the remote server
        * **/
        private function getUpdate():void{
            var urlReq:URLRequest = new URLRequest(version.@downloadLocation);
            urlStream.addEventListener(Event.COMPLETE, loaded);
            logger.info("get update from: " + version.@downloadLocation);
            urlStream.load(urlReq);
        }
        
        /** 
        * Read in the new AIR package
        * **/
        private function loaded(event:Event):void {
            urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
            writeAirFile();
        }
       
        /** 
        * Write the newly downloaded AIR package to the application storage directory
        * **/
        private function writeAirFile():void {        	
            var file:File = File.applicationStorageDirectory.resolvePath("Update.air");
            logger.info("writing AIR File: " + file.nativePath);
            var fileStream:FileStream = new FileStream();
            fileStream.addEventListener(Event.CLOSE, fileClosed);
            fileStream.openAsync(file, FileMode.WRITE);
            fileStream.writeBytes(fileData, 0, fileData.length);
            fileStream.close();
        }
        
        /** 
        * After the write is complete, call the update method on the Updater class
        * */
        private function fileClosed(event:Event):void {
            var updater:Updater = new Updater();
            var airFile:File = File.applicationStorageDirectory.resolvePath("Update.air");
            logger.info("updating AIR File: " + version.@version);
            updater.update(airFile,version.@version);
        }
       
    }
}