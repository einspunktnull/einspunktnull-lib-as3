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

package be.nascom.flash.events
{
	import flash.events.Event;
	
	/**
	 * A FileEvent is broadcasted when a file-related action occurs and the file name is needed, such as a completed upload.
	 * 
	 * @see be.nascom.flash.net.upload.ImageUploader
	 */
	
	public class FileEvent extends Event
	{
		/**
		 * Broadcasted when a file has uploaded to the server.
		 */
		public static const FILE_UPLOADED : String = "fileUploaded";
		
		private var _filename : String;
		
		/**
		 * Creates a FileEvent instance, providing a filename.
		 */
		public function FileEvent(type : String, filename : String, bubbles : Boolean = true, cancelable : Boolean = false) : void {
			_filename = filename;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * The file name of the concerned file.
		 */
		public function get filename() : String {
			return _filename;
		}
	}
}