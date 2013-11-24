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
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/** 
	 * HtmlTypewriter is used to animate between 2 strings in 1 TextField using typewriter effect without loosing html markup.
	 *   
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
 	 */
	public class HtmlTypewriter
	{
		protected var tagPositions:Array;
		protected var scan:Number = 0;
		protected var newText:String;
		protected var oldText:String;
		protected var ramText:String = new String();
		protected var textField:TextField;
		protected var prevCloseTag:String = new String();
		protected var tempCloseTag:String = new String();
		protected var i:Number=0;
		protected var totalTagsLength:Number=0;
		protected var addTimer:Timer;
		protected var removeTimer:Timer;
		protected var speed:Number;
		
		/** 
		 * startTween is used to start the typewriter animation.
		 * 
		 * @param textField Is the textfield with the htmlText already set.
		 * @param newText Is the new string you want to let appear using the typewriter effect.
	 	 */
		public function HtmlTypewriter(textField:TextField, newText:String)
		{	
			this.newText = newText;
			this.textField = textField;
			this.oldText = textField.htmlText;
		}
		
		/** 
		 * startTween is used to start the typewriter animation.
		 * 
		 * @param speed Is the speed of the typewriter effect.
	 	 */
		public function startTween(speed:Number):void
		{
			this.speed = speed;
			scanOldText();
		}
		
		protected function scanOldText():void
		{
			tagPositions = [];
			
			var tagPosition:Object;
			var closedTagPosition:Object;
			for (var i:Number=0; i < oldText.length; i++) 
			{
				/**
				 * open tags
				 * */
				var char:String = oldText.charAt(i);
				if( (char=="<") && (char!="</") ){
					tagPosition = new Object();
					tagPosition.startPos = i;
				}else if( (char==" ") && (tagPosition) && (tagPosition.closeTag==undefined) && (tagPosition.endPos==undefined) ){
					tagPosition.closeTag = "</"+oldText.substr(Number(tagPosition.startPos)+1, (i-Number(tagPosition.startPos))-1 )+">";
				}else if(char==">"){
					tagPosition.endPos = i;
					tagPosition.tag = oldText.substr(Number(tagPosition.startPos), (i-Number(tagPosition.startPos))+1 );
					tagPositions[tagPosition.endPos] = tagPosition;
					totalTagsLength += tagPosition.tag.length;
				}
				
				/**
				 * closed tags
				 * */
				if( (char=="</")){
					closedTagPosition = new Object();
					closedTagPosition.startPos = i;
				}else if(closedTagPosition && char==">"){
					closedTagPosition.endPos = i;
					closedTagPosition.tag = oldText.substr(Number(tagPosition.startPos), (i-Number(tagPosition.startPos))+1 );
					tagPositions[closedTagPosition.endPos] = closedTagPosition;
					totalTagsLength += tagPosition.tag.length;
				}
			}
						
			ramText = oldText;
			scan = ramText.length;
			
			removeTimer = new Timer(speed,oldText.length-totalTagsLength+11);//11 is always the last 2 standard tags of a flash html textfield.
			removeTimer.addEventListener(TimerEvent.TIMER, removeRender);
			removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, scanNewText);
			removeTimer.start();
		}
					
		protected function removeRender(event:TimerEvent):void
		{					
			if(tagPositions[scan] != undefined)
			{	
				if(tagPositions[scan].closeTag == undefined){
					//it is a real closetag
					tempCloseTag = tagPositions[scan].tag;
				}else{
					//it is a real opentag
					tempCloseTag = "";
				}
				scan = Number(tagPositions[scan].startPos);
				ramText = ramText.substr(0,scan)+tempCloseTag;
			}else{
				ramText = ramText.substr(0,scan)+tempCloseTag;
			}
			
//			trace(ramText);
			textField.htmlText = ramText;
			
			scan--;
		}

		protected function scanNewText(event:TimerEvent):void
		{
			tagPositions = [];
			
			removeTimer.removeEventListener(TimerEvent.TIMER, removeRender);
			removeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, scanNewText);
			removeTimer.stop();
			removeTimer = null;
			
			totalTagsLength = 0;
			
			var text:String = newText;
			var tagPosition:Object;
			var closedTagPosition:Object;
			for (var i:Number=0; i < text.length; i++) 
			{
				/**
				 * open tags
				 * */
				var char:String = text.charAt(i);
				if( (char=="<") && (char!="</") ){
					tagPosition = new Object();
					tagPosition.startPos = i;
				}else if( (char==" ") && (tagPosition) && (tagPosition.closeTag==undefined) && (tagPosition.endPos==undefined) ){
					tagPosition.closeTag = "</"+text.substr(Number(tagPosition.startPos)+1, (i-Number(tagPosition.startPos))-1 )+">";
				}else if(char==">"){
					tagPosition.endPos = i;
					tagPosition.tag = text.substr(Number(tagPosition.startPos), (i-Number(tagPosition.startPos))+1 );
					totalTagsLength += tagPosition.tag.length;
					tagPositions[tagPosition.startPos] = tagPosition;
				}
				
				/**
				 * closed tags
				 * */
				if( (char=="</")){
					closedTagPosition = new Object();
					closedTagPosition.startPos = i;
				}else if(closedTagPosition && char==">"){
					closedTagPosition.endPos = i;
					closedTagPosition.tag = text.substr(Number(tagPosition.startPos), (i-Number(tagPosition.startPos))+1 );
					totalTagsLength += closedTagPosition.tag.length;
					tagPositions[closedTagPosition.startPos] = closedTagPosition;
				}
			}
						
			addTimer = new Timer(speed,newText.length-totalTagsLength+7);//from where comes 7???
			addTimer.addEventListener(TimerEvent.TIMER, addRender);
			addTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeAddTimer);
			addTimer.start();
		}
		
		protected function removeAddTimer(event:TimerEvent):void
		{
			addTimer.removeEventListener(TimerEvent.TIMER, addRender);
			addTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeAddTimer);
			addTimer.stop();
			addTimer = null;
		}
		
		protected function addRender(event:TimerEvent):void
		{					
			if(tagPositions[scan] != undefined)
			{	
				if(tagPositions[scan].closeTag == undefined){
					//it is a closetag
					ramText = ramText.substr(0,ramText.length-prevCloseTag.length);
					ramText += tagPositions[scan].tag;
					prevCloseTag = "";
				}else{
					//it is an opentag followed by a fake closetag
					ramText += tagPositions[scan].tag + tagPositions[scan].closeTag;
					prevCloseTag = tagPositions[scan].closeTag;
				}
				scan = Number(tagPositions[scan].endPos);
			}else{
				ramText = ramText.substr(0,ramText.length-prevCloseTag.length) + newText.charAt(scan) + prevCloseTag;
			}
			
			textField.htmlText = ramText;
			
			scan++;
		}
	}
}