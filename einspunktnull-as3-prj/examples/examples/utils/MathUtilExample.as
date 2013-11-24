package
examples.utils{
	import net.einspunktnull.math.util.MathUtil;

	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class MathUtilExample extends Sprite
	{
		public function MathUtilExample()
		{
			var number1 : Number = 1;
			var number2 : Number = 0.9999;

			log(number1 == number2);
			log(MathUtil.numberEquals(number1, number2, 0.0000000001));
			log(MathUtil.numberEquals(number1, number2, 0.0001));
			
			
			
			var a:int=60;
			var b:int=50;
			var gcd:int = MathUtil.gcd(a, b);
			log(gcd);
		}
	}
}
