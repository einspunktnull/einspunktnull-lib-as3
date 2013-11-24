package net.einspunktnull.ai.steeringbehaviors.display.obstacle
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class Circle extends Obstacle
	{
		private var _radius : Number;
		private var _color : uint;

		public function Circle(radius : Number, color : uint = 0)
		{
			_radius = radius;
			_color = color;

			graphics.lineStyle(0, _color);
			graphics.drawCircle(0, 0, _radius);
			
			super();
		}

		public function get radius() : Number
		{
			return _radius;
		}

		public function get color() : uint
		{
			return _color;
		}
	}
}
