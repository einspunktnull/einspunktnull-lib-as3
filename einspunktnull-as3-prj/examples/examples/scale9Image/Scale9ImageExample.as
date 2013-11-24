package examples.scale9Image
{
	import net.einspunktnull.display.image.AutoScale9Image;
	import net.einspunktnull.display.image.Scale9Image;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class Scale9ImageExample extends Sprite
	{
		[Embed(source="examples/scale9Image/scale9.png")]
		private var PictureScale9 : Class;
		private var _sc9Img : Scale9Image;
		
		[Embed(source="examples/scale9Image/autoScale9.png")]
		private var PictureAutoScale9 : Class;
		private var _asc9Img : AutoScale9Image;

		public function Scale9ImageExample()
		{
			var picSc9:Bitmap = new PictureScale9();
			_sc9Img = new Scale9Image(picSc9, 15, 85, 15, 85);
			addChild(_sc9Img);
			_sc9Img.width = 200;
			_sc9Img.height = 50;
			_sc9Img.y = 20;
			_sc9Img.x = 20;
			
			var picAsc9:Bitmap = new PictureAutoScale9();
			_asc9Img = new AutoScale9Image(picAsc9);
			addChild(_asc9Img);
			_asc9Img.width = 200;
			_asc9Img.height = 50;
			_asc9Img.y = 200;
			_asc9Img.x = 20;
		}

	}
}
