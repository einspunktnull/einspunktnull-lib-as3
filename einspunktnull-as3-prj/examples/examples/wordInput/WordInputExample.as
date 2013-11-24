package
examples.wordInput{
	import net.einspunktnull.io.wordinput.WordInputEvent;
	import net.einspunktnull.io.wordinput.WordInputListener;

	import flash.display.Shape;
	import flash.display.Sprite;


	/**
	 * @author Albrecht Nitsche
	 */
	public class WordInputExample extends Sprite
	{
		private var _shape : Shape;

		public function WordInputExample()
		{
			_shape = new Shape();
			_shape.graphics.beginFill(0x000000);
			_shape.graphics.drawRect(0, 0, 200, 200);
			addChild(_shape);
			_shape.visible = false;


			WordInputListener.register(stage);
			WordInputListener.addInput("pimmel");
			WordInputListener.addEventListener(WordInputEvent.MATCH, onMatchInput);

		}

		private function onMatchInput(event : WordInputEvent) : void
		{
			logch(this, event.input.inputString);
			_shape.visible = !_shape.visible;
		}

	}
}
