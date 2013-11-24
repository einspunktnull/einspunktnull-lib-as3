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

package be.nascom.flash.display
{	
	import be.nascom.flash.events.FileEvent;
	import be.nascom.flash.events.ImageCropperEvent;
	import be.nascom.flash.net.upload.FileUploader;
	import be.nascom.flash.net.upload.ImageUploader;
	
	import com.adobe.images.JPGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	/** 
	 * Typical component used for cutting pieces out of images. Cropping as you will.
	 * You can pass extra POST parameters trough the public property "postParams". They will be passed trough to the upload AND save serverscript.
	 * Only to the save script the "postParams" Object will add an extra property "serverUploadResponse". 
	 * 
	 * @example On upload complete cropper expects server XML response.:
	 * 
	 * 	<listing version="3.0"> 
	 * 		<results>	
	 * 			<success><![CDATA[true]]></success>
	 * 			<location><![CDATA[http://www.somelocation.com/example.jpg]]></location>
	 * 			<data><![CDATA[whatever data you POSTED extra with the upload return in here]]></data>;
	 * 			<error><![CDATA[server side errormessage]]></error>
	 * 		</results>
	 * </listing>
	 * 
	 * @see be.nascom.flash.net.upload.FileUploader
	 * @see com.adobe.images.JPGEncoder;
	 * 
	 * @example The following code creates a Cropper component.
	 * 	<listing version="3.0">
	 * 
	 * 		var comp:ImageCropper = new ImageCropper(buttonCrop, buttonZoomIn, buttonZoomOut);
			comp.addEventListener(ImageCropperEvent.CROP_COMPLETED, completeHandler);
			comp.addEventListener(ImageCropperEvent.UPLOAD_COMPLETED, uploadHandler);
			comp.addEventListener(ImageCropperEvent.ERROR, errorHandler);
			comp.addEventListener(ImageCropperEvent.BUTTON_STATE_CROP, buttonStateHandler);
			comp.addEventListener(ImageCropperEvent.BUTTON_STATE_UPLOAD, buttonStateHandler);
			comp.addEventListener(ImageCropperEvent.BUTTON_STATE_ZOOM_IN, buttonStateHandler);
			comp.addEventListener(ImageCropperEvent.BUTTON_STATE_ZOOM_OUT, buttonStateHandler);
			
			//comp.setUpload(buttonUpload,pathUploadScript);
			comp.setSourceImage(http://www.yourlocation.be/sourceImage.jpg);
	  		//comp.initClassic(pathSaveScript);
	  		comp.initAMF(pathGateway, pathSaveService); 
	 * </listing>
	 * 
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
 	 */
	public class ImageCropper extends MovieClip {
	
		public static const IS_LOCAL:Boolean = true; 
		public static const ZOOM_FACTOR:Number = .1;
		public var postParams:URLVariables = new URLVariables();
		
		private var is_amf:Boolean;
		private var gateway_amf:String;
		private var service_amf:String;
		private var save_script:String;
		private var upload_script:String;
		private var source_image:String;
		private var workspace:MovieClip;
		private var image:MovieClip;
		private var imageDuplicate:MovieClip;
		private var fileUploader:FileUploader;
		private var myPreviewLoader:Loader;
		private var _loader:Loader;
		private var loaderContext:LoaderContext;
		private var disabledZone:Sprite;
		private var wspW:uint;
		private var wspH:uint;
		private var cropperW:uint;
		private var cropperH:uint;
		private var maxScale:Number;
		private var minScale:Number;
		private var inited:Boolean = false;
		private var _useUpload:Boolean = false;
		private var _saveVariables:URLVariables;
		private var _uploadVariables:URLVariables;
		
		private var prevScaleX:Number;
		private var prevScaleY:Number;
		private var newScaleX:Number;
		private var newScaleY:Number;
		private var estimatedWidthImage:Number;
		private var estimatedHeightImage:Number;
		
		/**
		 * Creates an Cropper instance for AMF server communication.
		 * 
		 * @param widthComponent Width of the whole component
		 * @param heightComponent Height of the whole component
		 * @param widthCropper Width of the piece you want to crop
		 * @param heightCropper Height of the piece you want to crop
		 * @param pathOrigImg Path to an image you want to load in at initializing
		 * @param pathUploadScript Path to an upload script, leave empty to disable upload functionality
		 * 
		 */
		public function ImageCropper(btnCrop:DisplayObject, btnZoomIn:DisplayObject, btnZoomOut:DisplayObject, widthComponent:uint=400, heightComponent:uint=400, widthCropper:uint=50, heightCropper:uint=50):void 
		{	
			this.wspW = widthComponent;
			this.wspH = heightComponent;
			this.cropperW = widthCropper;
			this.cropperH = heightCropper;
			
			var mcPlaceHolder:MovieClip = new MovieClip();
			mcPlaceHolder.graphics.clear();
			mcPlaceHolder.graphics.lineStyle(1, 0xcccccc);
			mcPlaceHolder.graphics.beginFill(0xcccccc, .3);
			mcPlaceHolder.graphics.drawRect(0,0,this.wspW,this.wspH);
			addChild(mcPlaceHolder);
			
			btnCrop.addEventListener(MouseEvent.CLICK, cropImage);
			btnZoomIn.addEventListener(MouseEvent.CLICK, zoomPlusHandler);
			btnZoomOut.addEventListener(MouseEvent.CLICK, zoomMinHandler);
		}
		
		public function setSourceImage(path:String):void
		{
			this.source_image = path; 
		}
		
		public function setUpload(btnUpload:DisplayObject, urlUploadScript:String, uploadVariables:URLVariables=null):void
		{
			this._useUpload = true;
			this.upload_script = urlUploadScript;
			this._uploadVariables = uploadVariables;
			btnUpload.addEventListener(MouseEvent.CLICK, uploadImageToEdit);
			
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_CROP, null, false));	
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_ZOOM_IN, null, false));
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_ZOOM_OUT, null, false));
		}
		
		/**
		 * Creates an Cropper instance for AMF server communication.
		 * 
		 * @param pathGateway AMF gateway path
		 * @param pathSaveService AMF Service
		 * 
		 */
		public function initAMF(urlGateway:String, urlSaveService:String, saveVariables:URLVariables=null):void
		{
			this.is_amf = true;
			this.gateway_amf = urlGateway;
			this.service_amf = urlSaveService;
			this._saveVariables = saveVariables;
			
			if(source_image && !_useUpload)loadImage(source_image);
		}
		
		/**
		 * Creates an Cropper instance for classic server communication.
		 * 
		 * @param pathSaveScript Path to the server side save script for bytearrays.
		 * 
		 */
		public function initClassic(urlSaveScript:String, saveVariables:URLVariables=null):void
		{	
			this.is_amf = false;
			this.save_script = urlSaveScript;
			this._saveVariables = saveVariables;
			
			if(source_image && !_useUpload)loadImage(source_image);
		}
		
		private function loadImage(url:String):void
		{
			if(!url && !_useUpload)throw new Error( "You have to call the preloadImage() function first." );
			if(!url && _useUpload)throw new Error( "You have to upload an image first." );
			if(inited)destroyAllPrevious();
			
			createAll();
			
			loaderContext = new LoaderContext(true);
			if(!IS_LOCAL)loaderContext.securityDomain = SecurityDomain.currentDomain;
			if(!IS_LOCAL)loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			var variables:URLVariables = new URLVariables();
			variables.otherData = "Whatever kind of extra data to the upload script";
			var request:URLRequest = new URLRequest(url);
			request.data = variables;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadImageCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_loader.load(request,loaderContext);
		}
		
		private function createAll():void
		{
			workspace = new MovieClip();
			workspace.name = "workspace";
			workspace.buttonMode = true;
			workspace.addEventListener(MouseEvent.MOUSE_DOWN, dragImageHandler);
			workspace.addEventListener(MouseEvent.MOUSE_UP, undragImageHandler);
			
			_loader = new Loader();
			_loader.name = "loader";
			image = new MovieClip();
			image.name = "image";
			image.addChild(_loader);
			image.alpha = 0;
			imageDuplicate = new MovieClip();
			imageDuplicate.name = "imageDuplicate";
			
			workspace.addChild(image);
			workspace.addChild(imageDuplicate);
			
			addChild(workspace);
			
			myPreviewLoader = new Loader();
			myPreviewLoader.x = this.wspW/2-this.cropperW/2;
			myPreviewLoader.y = this.wspH/2-this.cropperH/2;
			addChild(myPreviewLoader);
		}
		
		private function destroyAllPrevious():void
		{
			_loader.unload();
			image.removeChild(_loader);
			_loader = null;
			workspace.removeChild(image);
			imageDuplicate.removeEventListener(Event.ENTER_FRAME, alignImage);
			workspace.removeChild(imageDuplicate);
			imageDuplicate = null;
			
			myPreviewLoader.unload()			
			removeChild(myPreviewLoader)
			myPreviewLoader = null;
			
			workspace.removeChild(disabledZone);
			workspace.removeEventListener(MouseEvent.MOUSE_DOWN, dragImageHandler);
			workspace.removeEventListener(MouseEvent.MOUSE_UP, undragImageHandler);
			removeChild(workspace);
			workspace = null;
		}
		
		private function loadImageCompleteHandler(event:Event=null):void
		{
			if(event){
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadImageCompleteHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			}
			
			image.alpha = .5;
			
			trace(image.width+"x"+image.height)
			
			var myBitmapSource:BitmapData = new BitmapData(image.width, image.height);			
			myBitmapSource.draw (image);
			
			var bmp:Bitmap = new Bitmap();
			bmp.name = "bmp";
			bmp.bitmapData = myBitmapSource;
			imageDuplicate.addChild(bmp);
			imageDuplicate.addEventListener(Event.ENTER_FRAME, alignImage);
			
			createCropper();
			
			disabledZone = new Sprite();
			disabledZone.graphics.beginFill(0xff0000,0);
			disabledZone.graphics.drawRect(0,0,this.wspW*2,this.wspH*2);
			disabledZone.graphics.endFill();
			disabledZone.x = -2000;
			workspace.addChild(disabledZone);
			
			var limitx:int = (wspW/2)-(cropperW/2);
			var limity:int = (wspH/2)-(cropperH/2);
				
			if(image.height<image.width){
				this.minScale = this.cropperH/image.height;
				 
				if( image.height<cropperH ){

					var ratioH:Number = cropperH/imageDuplicate.height;
					imageDuplicate.scaleX = imageDuplicate.scaleY = ratioH;
					image.scaleX = image.scaleY = ratioH;
					
					this.minScale = image.scaleY;
					
					image.x = limitx;
					image.y = limity;
				}
			}else{
				this.minScale = this.cropperW/image.width;
				
				if( image.width<cropperW ){
					var ratioW:Number = cropperW/imageDuplicate.width;
					imageDuplicate.scaleX = imageDuplicate.scaleY = ratioW;
					image.scaleX = image.scaleY = ratioW;
					
					this.minScale = image.scaleX;
					
					image.x = limitx;
					image.y = limity;
				}
			}
			
			this.maxScale = image.scaleX*4;
			zoom(image.scaleY, image.scaleX);
			
			this.inited = true;
		}
		
		private function createCropper():void
		{
			var componentMask:Sprite = new Sprite();
			componentMask.graphics.clear();
			componentMask.graphics.beginFill(0x000000);
			componentMask.graphics.drawRect(0,0,wspW,wspH);
			workspace.addChild(componentMask);
			_loader.mask = componentMask;
			
			var cropperMask:Sprite = new Sprite();
			cropperMask.graphics.clear();
			cropperMask.graphics.beginFill(0x000000,1);
			cropperMask.graphics.drawRect(0,0,cropperW,cropperH);
			cropperMask.x = (wspW/2)-(cropperW/2);
			cropperMask.y = (wspH/2)-(cropperH/2);
			workspace.addChild(cropperMask);
			imageDuplicate.mask = cropperMask;
			
			var cropperBorder:Sprite = new Sprite();
			cropperBorder.name = "cropperBorder";
			cropperBorder.graphics.clear();
			cropperBorder.graphics.lineStyle(1,0x000000,.5)
			cropperBorder.graphics.drawRect(0,0,cropperW,cropperH);
			cropperBorder.x = (wspW/2)-(cropperW/2);
			cropperBorder.y = (wspH/2)-(cropperH/2);
			workspace.addChild(cropperBorder);
		}
		
		/*============================ EVENTS =====================================*/
		private function uploadImageToEdit(event:MouseEvent):void
		{
			fileUploader = new FileUploader()
			fileUploader.uploadScriptPath = this.upload_script;
			fileUploader.addEventListener(FileUploader.COMPLETE, uploadCompleteHandler);
			fileUploader.openFileWindow(this.postParams);
		}
		
		private function uploadCompleteHandler(e:Event):void
		{
			fileUploader.removeEventListener(FileUploader.COMPLETE, uploadCompleteHandler);
			XML.ignoreWhitespace = true;
			var serverUploadResponse:XML = XML(fileUploader.serverResponse);
			if(serverUploadResponse.success == "true")
			{
				dispatchEvent(new ImageCropperEvent(ImageCropperEvent.UPLOAD_COMPLETED));
				//add the response of the upload server script to the save params
				postParams.serverUploadResponse = fileUploader.serverResponse;
				loadImage( XML(fileUploader.serverResponse).location );
				
				dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_CROP, null, true));	
				dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_ZOOM_IN, null, true));	
				dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_ZOOM_OUT, null, true));
			}else{
				dispatchEvent(new ImageCropperEvent(ImageCropperEvent.ERROR, null, true, serverUploadResponse.toString()));
			}
		}
				
		private function cropImage(event:MouseEvent):void 
		{	
			if(_useUpload && !upload_script)throw new Error( "You have to call the setUpload() function first." );
			if(is_amf && (gateway_amf=="") && (service_amf=="") )throw new Error( "You have to call the initAMF() function first." );
			if(!is_amf && (save_script=="") )throw new Error( "You have to call the init() function first." );
			
			workspace.getChildByName("cropperBorder").visible = false;
			image.alpha = 1;
			var myBitmapSource:BitmapData = new BitmapData(cropperW, cropperH);
	    	var mtrx:Matrix = new Matrix();
			mtrx.tx = -((wspW/2)-(cropperW/2));
			mtrx.ty = -((wspH/2)-(cropperH/2));
			myBitmapSource.draw (workspace, mtrx, null, null, null, false);
			
			var encoder:JPGEncoder = new JPGEncoder( 100 );
		    var aBA:ByteArray = encoder.encode(myBitmapSource);
		    myPreviewLoader.loadBytes(aBA);
		    image.alpha = .5;
		    
			if(is_amf){	
				var serviceAMF:NetConnection = new NetConnection();
				var responderAMF:Responder = new Responder(cropImageAmfSuccess, cropImageError);
				serviceAMF.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        		serviceAMF.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				serviceAMF.connect(gateway_amf);
				serviceAMF.call(service_amf, responderAMF, aBA, false, this.postParams);
			}else{	
				var uploaderImage:ImageUploader = new ImageUploader(save_script);
				uploaderImage.upload( myBitmapSource, "cropped_image.jpg", 100, "jpg", "Filedata", this.postParams );
				uploaderImage.addEventListener(FileEvent.FILE_UPLOADED, cropImageSuccess);
				uploaderImage.addEventListener(IOErrorEvent.IO_ERROR, cropImageError);
			}
			disabledZone.x = 0;
			workspace.visible = false;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void 
		{
        	// implement        
        }
        
        private function securityErrorHandler(event:SecurityErrorEvent):void 
        {
            dispatchEvent(new ImageCropperEvent(ImageCropperEvent.ERROR, null, true, event.text));
        }
		
		private function onError ( event:IOErrorEvent ):void
		{
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.ERROR, null, true, event.text));
		}
		
		private function cropImageSuccess(event:FileEvent):void 
		{
			disabledZone.x = -2000;
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.CROP_COMPLETED));
//            if(ExternalInterface.available)ExternalInterface.call("result", true);
        }
		
		private function cropImageAmfSuccess(pathCroppedResult:String):void 
		{
			disabledZone.x = -2000;
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.CROP_COMPLETED));
//			if(ExternalInterface.available)ExternalInterface.call("result", true);
		}
		
		private function cropImageError(e:*):void
		{
			var message:String;
			for each(var s:String in e){
				message += s+", "+e[s];
			}
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.ERROR, null, true, message));
		}
		
		private function undragImageHandler(e:MouseEvent=null):void
		{
			image.stopDrag();
		}
		
		private function dragImageHandler(e:MouseEvent):void
		{
			image.startDrag();
			
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_CROP, null, true));
		}
		
		private function alignImage(event:Event):void
		{
			if( (mouseX<0 || mouseY<0 || mouseX>wspW || mouseY>wspH)){
				undragImageHandler();
			}
			
			var limitx:int = (wspW/2)-(cropperW/2);
			var limity:int = (wspH/2)-(cropperH/2);
			if( image.x > limitx ){
				image.x = limitx;
			}else if ( image.y > limity ) {
				image.y = limity;
			}else if ( (image.x+image.width) < (limitx+cropperW) ) {
				image.x = (limitx+cropperW)-image.width;
			}else if ( (image.y+image.height) < (limity+cropperH) ) {
				image.y = (limity+cropperH)-image.height;
			}
			
			imageDuplicate.x = image.x;
			imageDuplicate.y = image.y;
		}
		
		private function zoomPlusHandler(e:MouseEvent):void
		{
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_ZOOM_OUT, null, true));
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_CROP, null, true));
			zoom(image.scaleY+ZOOM_FACTOR, image.scaleX+ZOOM_FACTOR)
		}
		
		private function zoomMinHandler(e:MouseEvent):void
		{	
			dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_CROP, null, true));
			zoom(image.scaleY-ZOOM_FACTOR, image.scaleX-ZOOM_FACTOR)
		}
		
		private function zoom(scY:Number, scX:Number):void
		{			
			prevScaleX = image.scaleX;
			prevScaleY = image.scaleY;
			newScaleX = scX;
			newScaleY = scY;
			estimatedWidthImage = image.width*newScaleX;
			estimatedHeightImage = image.height-newScaleY;
			
			image.scaleX = imageDuplicate.scaleX = newScaleX;
			image.scaleY = imageDuplicate.scaleY = newScaleY;
			
			estimatedWidthImage = image.width;
			estimatedHeightImage = image.height;
			
			boundariesChecker();	
		}
		
		private function boundariesChecker(event:Event=null):void
		{
			if( (estimatedWidthImage<cropperW) || (estimatedHeightImage<cropperH) || (newScaleX<0) || (newScaleY<0) )
			{
				dispatchEvent(new ImageCropperEvent(ImageCropperEvent.BUTTON_STATE_ZOOM_OUT, null, false));
				//causing stack overflow sometimes
				zoom(prevScaleY, prevScaleX);
			}else{
				//it's ok...no limits crossed
				//leave lik it was
			}	
		}
	}
}