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

package be.nascom.flash.net.amf
{
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;

	/**
	 * AbstractAMFService is a bass class used for AMF-based services. This class needs to be subclassed
	 * and the subclass implements functions that will handle individual remote calls.
	 * Use <code>flash.net.Responder</code> if callbacks are needed, and register class aliases in the constructor
	 * if needed. 
	 * 
	 * <p>Work in progress</p>
	 * 
	 * @see flash.net.NetConnection
	 * @see flash.net.ObjectEncoding
	 * @see flash.net.registerClassAlias
	 * @see flash.net.Responder
	 * 
	 * @author David Lenaerts
	 * @mail david.lenaerts@nascom.be
	 * 
 	 * @example The following code creates an AMF service class using AbstractAMFService.
	 * <listing version="3.0" >
	 * 	package services { 
	 * 		import be.nascom.flash.net.amf.AbstractAMFService;
	 * 		import flash.net.Responder;
	 * 		import flash.net.registerClassAlias;
	 * 
	 * 		public class JavaService extends AbstractAMFService {
	 * 			private static const GATEWAY_URL : String = Paths.JAVA_SERVICE;
	 * 			private const DELEGATE_CLASSPATH : String = "be.nascom.lifeislive.services.AmfRemotingService";
	 * 			
	 * 			public function JavaService() { 
	 * 				super(GATEWAY_URL, DELEGATE_CLASSPATH); 
	 *			}
	 * 
	 * 			public function updateLanguage(userId : uint, language : String) : void {
	 * 				_connection.call(DELEGATE_CLASSPATH+".updateLanguage", null, userId, language);
	 * 			}
	 * 		}
	 * 	}
	 * </listing>
 	 */	 
	
	public class AbstractAMFService extends EventDispatcher
	{
		/**
		 * The serverside full qualified classpath of the delegate service class which contains the methods that will be called remotely
		 */
		protected var _delegateClassPath : String;
		
		/**
		 * The url to the serverside AMF gateway
		 */
		protected var _gatewayUrl : String;
		
		/**
		 * Reference to the <code>NetConnection</code> object, which will be executing the actual calls
		 */
		protected var _connection : NetConnection;
		
		/**
		 * The AMF version to use:<ul><li><code>ObjectEncoding.AMF0</code></li><li><code>ObjectEncoding.AMF3</code></li></ul>
		 */
		protected var _encodingMethod : uint;
		/**
		 * Initializes an AMF service
		 * 
		 * @param gatewayUrl The url to the serverside AMF gateway
		 * @param delegateClassPath The serverside full qualified classpath of the delegate service class which contains the methods that will be called remotely
		 * @param encoding The AMF version to use:<ul><li><code>ObjectEncoding.AMF0</code></li><li><code>ObjectEncoding.AMF3</code></li></ul>
		 */
		public function AbstractAMFService(gatewayUrl : String, delegateClassPath : String = "", encoding : uint = 3) {
			_connection = new NetConnection();
			_connection.objectEncoding = encoding;
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			_connection.client = this;
			if (_delegateClassPath != "")
				_delegateClassPath = delegateClassPath;
			else
				_delegateClassPath = "";
			_gatewayUrl = gatewayUrl;
			connect();
		}

		/**
		 * Connects to the AMF gateway
		 */
		protected function connect() : void {
			trace("Connecting to " + _gatewayUrl);
			_connection.connect(_gatewayUrl);
		}

		/**
		 * Closes the connection to the AMF gateway
		 */
		protected function disconnect() : void {
			trace("Connecting to " + _gatewayUrl);
			_connection.close();
		}
		
		/**
		 * Connection handlers
		 * TO DO: actually handle something?
		 */
		private function netStatus(event : NetStatusEvent) : void {
			trace("AMF connection netStatus: " + event.info.code);
			trace(event);
			dispatchEvent(event);
			switch (event.info.code){
				case "NetConnection.Connect.Success":
					break;
				case "NetConnection.Connect.Closed" :
				   break;
				case "NetConnection.Connect.Failed" :
				   break;
				case "NetConnection.Connect.Rejected" :
				   break;
			}
		}
		
		/**
		 * Sandbox security handler
		 */
		private function netSecurityError(event:SecurityErrorEvent) : void {
			trace("AMF connection netSecurityError: " + event);
			dispatchEvent(event);
		}
		
		private function asyncErrorEventHandler(event:AsyncErrorEvent) : void {
			trace("AMF connection AsyncError: " + event);
			dispatchEvent(event);
		}
		
		private function ioErrorEventHandler(event:IOErrorEvent) : void {
			trace("AMF connection IOError: " + event);
			dispatchEvent(event);
		}

		/**
		 * The full qualified class path of the remote service delegate class
		 */
		public function get delegateClassPath() : String {
			return _delegateClassPath;
		}
 
 		public function set delegateClassPath(value : String) : void {
			_delegateClassPath = value;
		}
	}
}