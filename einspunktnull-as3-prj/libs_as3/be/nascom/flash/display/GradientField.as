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
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	/** 
	 * 
	 * Used to add gradient colors to your textfields in stead of a solid color.
	 * Wrapper class containing the mask + the textfield itself.
	 * 
	 * @example The following code creates an example.
	 * 	<listing version="3.0">
	 * 		var textfield : TextField = new TextField();
	 * 		var gradientField : GradientField = new GradientField(textfield);
	 * 		gradientField.htmlText = "Testing the gradient textfield.";
	 * 		gradientField.setGradient(0xFF0000, 0x000000, true);
	 * 		addChild(gradientField);
	 * </listing>
	 * 
	 * @author Rien Verbrugghe
	 * @mail rien.verbrugghe@nascom.be
	 * 
 	 */
 	 
	public class GradientField extends Sprite
	{
		protected var _field:TextField;
		protected var _gradientCollection:Sprite;
		protected var _colorTop:uint = 0x17C0F2;
		protected var _colorBottom:uint = 0x3B9CD1;
		protected var _hasShadow:Boolean = true;
		
		/** 
		 * GradientField constructor is adding the textfield to itself and disabled the selectable feature of the textfield.
		 *   
		 * @param textField The TextField you want to give a color gradient fill.
		 * 
		 * @author Rien Verbrugghe
		 * @mail rien.verbrugghe@nascom.be
		 * 
	 	 */
		public function GradientField(textField:TextField)
		{
			super();

			_field.selectable = false;
			addChild(_field);
		}
		
		/** 
		 * htmlText is used to edit the text of the textfield and recreate the masking depending on the length of the string.
		 *   
		 * @param value The html string for the textfield.
		 * 
		 * @author Rien Verbrugghe
		 * @mail rien.verbrugghe@nascom.be
		 * 
	 	 */
		public function set htmlText(value:String):void
		{
			_field.htmlText = value;
			setGradient(_colorTop,_colorBottom,_hasShadow);
		}
		
		protected function setShadow():void
		{
			var _dropShadow:DropShadowFilter = new DropShadowFilter();
			_dropShadow.color = 0x000000;
			_dropShadow.blurX = 1;
			_dropShadow.blurY = 1;
			_dropShadow.angle = 45;
			_dropShadow.distance = 1;
			_dropShadow.strength = .8;
			filters = [_dropShadow];
		}
		
		protected function destroyOldGradient(container:Sprite):void
		{
			while (container.numChildren)
			{
				container.removeChildAt(0);
			}
		}
		
		/** 
		 * setGradient creates the masking with vertical color gradientfor the textfield.
		 *   
		 * @param colorTop The top color for the vertical gradient fill of the textfield.
		 * @param colorBottom The bottom color for the vertical gradient fill of the textfield.
		 * @param hasShadow Giving the option to create a shadow on the textfield.
		 * 
		 * @author Rien Verbrugghe
		 * @mail rien.verbrugghe@nascom.be
		 * 
	 	 */
		public function setGradient(colorTop:uint, colorBottom:uint, hasShadow:Boolean=true):void
		{
			this._colorTop = colorTop;
			this._colorBottom = colorBottom;
			this._hasShadow = hasShadow;
			
			if(_gradientCollection)
			{
				destroyOldGradient(_gradientCollection);
			}
			_gradientCollection = new Sprite;
			
			var fType:String = GradientType.LINEAR;
			var colors:Array = [colorTop, colorBottom];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0, 255 ];
			var sprMethod:String = SpreadMethod.PAD;
			var h:Number = _field.height;
			var w:Number = _field.width;
			var rows:Number = _field.numLines;
			var rowH:Number = Math.round(h/rows);
			var rowMatr:Matrix = new Matrix();
			rowMatr.createGradientBox( w, rowH-5, 1.5, 0, 0 );//here i took some extra margin
			
			for(var i:int=0; i<rows; i++)
			{
				var rowGradient:Shape = new Shape();
				rowGradient.graphics.beginGradientFill( fType, colors, alphas, ratios, rowMatr, sprMethod);
				
				if(rows==1)
					rowGradient.graphics.drawRect( 0, 0, w, rowH + 5 );
				else
					rowGradient.graphics.drawRect( 0, 0, w, rowH );
					
				rowGradient.graphics.endFill();
				rowGradient.y = i*rowH;
				_gradientCollection.addChild(rowGradient);
			}
			
			_gradientCollection.mask = _field;
			addChildAt(_gradientCollection,0);
			
			if(hasShadow)setShadow();
		}
	}
}