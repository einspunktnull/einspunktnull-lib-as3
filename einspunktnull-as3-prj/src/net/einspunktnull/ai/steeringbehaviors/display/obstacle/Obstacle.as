package net.einspunktnull.ai.steeringbehaviors.display.obstacle
{
	import net.einspunktnull.data.ds.Vector2D;

	import flash.display.Sprite;

	/**
	 * @author Albrecht Nitsche
	 */
	public class Obstacle extends Sprite
	{
		public function get position() : Vector2D
		{
			return new Vector2D(x, y);
		}
	}
}
