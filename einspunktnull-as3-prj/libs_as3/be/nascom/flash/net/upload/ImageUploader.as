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

package be.nascom.flash.net.upload
{
	import be.nascom.flash.events.FileEvent;
	
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	/**
	 * ImageUploader takes a BitmapData object and uploads it to a server using a serverside upload script.
	 * Currently, only JPG filetypes are possible, and the filename is defined by the serverside script.
	 * The serverside script returns the filename of the uploaded file.
	 * 
	 * <p>TO DO:</p>
	 * <ul>
	 * <li>Support different filetypes</li>
	 * <li>Add clientside filename definition</li>
	 * </ul>
	 * 
	 * @see UploadPostHelper
	 * @see flash.display.BitmapData
	 * @see be.nascom.flash.events.FileEvent
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
	 */

	public class ImageUploader extends EventDispatcher
	{
		private var _uploadScriptUrl : String;
		
		/**
		 * Indicates that the uploaded file needs to use JPG compression.
		 */
		public static const FILETYPE_JPG : String = "jpg";
		
		/**
		 * Creates an ImageUploader instance.
		 * 
		 * @param uploadScriptUrl The URL where the serverside upload script can be found.
		 */
		public function ImageUploader(uploadScriptUrl : String) : void {
			_uploadScriptUrl = uploadScriptUrl;
		}
		
		/**
		 * Uploads a bitmap to the server.
		 * 
		 * @param source A BitmapData object which will be uploaded to the server.
		 * @param fileName A filename. In most cases this is not used server side, but the server expects a filename.
		 * @param quality The quality of the JPG compression. Higher values will result in bigger file sizes.
		 * @param fileType Specifies the compression method and file type used for the saved image.
		 * @param uploadDataFieldName The name of the uploadDataField (default = FileData)
		 * @param extra Post parameters
		 * 
		 */
		public function upload(source : BitmapData, fileName : String, quality : uint = 70, fileType : String = "jpg", uploadDataFieldName : String = "Filedata", parameters : Object = null) : void {
			var encoderJPG : JPGEncoder = new JPGEncoder(quality);
			var imageData:ByteArray = encoderJPG.encode(source);
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = _uploadScriptUrl;
			urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = UploadPostHelper.getPostData(fileName, imageData, uploadDataFieldName, parameters);
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, handleComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlLoader.load(urlRequest);
		}
		
		private function handleComplete(event : Event) : void {
			dispatchEvent(new FileEvent(FileEvent.FILE_UPLOADED, String(event.target.data)));
		}
		
		private function onError(event : IOErrorEvent) : void {
			dispatchEvent(event);
		}
		
		private function onSecurityError(event : SecurityErrorEvent) : void {
			dispatchEvent(event);
		}
	}
}