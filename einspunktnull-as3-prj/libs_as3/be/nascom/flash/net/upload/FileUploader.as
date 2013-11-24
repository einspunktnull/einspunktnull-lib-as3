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

package be.nascom.flash.net.upload {
	
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.net.*;

	/**
	 * FileUploader takes a file and uploads it to a server using a serverside upload script.
	 * The filename is defined by the serverside script.
	 * Currently, only following filetypes are possible :
	 * Images (*.jpg, *.jpeg, *.gif, *.png)","*.jpg;*.jpeg;*.gif;*.png") and Text Files (*.txt, *.rtf)","*.txt;*.rtf")
	 * You can always push an extra FileFilter to the public allTypes array
	 * The serverside script returns the absolute filename of the uploaded file.
	 * 
	 * <p>TO DO:</p>
	 * <ul>
	 * <li>Support for extra POST parameters</li>
	 * <li>Make the class more abstract and generic</li>
	 * </ul>
	 * 
	 * 
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
	 */
	 
	public class FileUploader extends EventDispatcher {
		
		protected var fileReference				:FileReference;
		protected var urlRequest				:URLRequest;
		public var allTypes						:Array 							= new Array();
		public var uploadScriptPath				:String;
		public var serverResponse				:XML;
		public static const COMPLETE			:String							= "complete";
	
		public function FileUploader(target:IEventDispatcher=null) {
			super(target);
			//openFileWindow();
		}
		public function openFileWindow(postparams:URLVariables = null):void {
			urlRequest=new URLRequest();
			urlRequest.url = this.uploadScriptPath;
			urlRequest.data = postparams;
			try {
				fileReference=new FileReference();
				fileReference.browse(getTypes());
				fileReference.addEventListener(Event.SELECT,FileReferenceSelect);
				fileReference.addEventListener(ProgressEvent.PROGRESS, onFileProgress);
				fileReference.addEventListener(IOErrorEvent.IO_ERROR, errorOccured);
				fileReference.addEventListener(Event.COMPLETE, fileUploaded);
				fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, returnServerData);
			} catch (illegalOperation:IllegalOperationError) {
				trace("illegalOperation");
			}
		}
		private function FileReferenceSelect(e:Event):void {
			fileReference.upload(urlRequest);
		}
		private function onFileProgress(e:ProgressEvent):void {
			trace("Progress "+e.bytesLoaded + " of " + e.bytesTotal + " bytes");
		}
		private function returnServerData(event:DataEvent):void
		{
			trace("returnServerData", event.data);
			
			this.serverResponse = new XML(event.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function fileUploaded(e:Event):void
		{
			//nothing
		}
		private function errorOccured(evt:IOErrorEvent):void{
			trace("IO error has occured.");
		}
		private function getTypes():Array {
			allTypes.push(getImageTypeFilter());
			allTypes.push(getTextTypeFilter());
			return allTypes;
		}
		private function getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)","*.jpg;*.jpeg;*.gif;*.png");
		}
		private function getTextTypeFilter():FileFilter {
			return new FileFilter("Text Files (*.txt, *.rtf)","*.txt;*.rtf");
		}
	}
}