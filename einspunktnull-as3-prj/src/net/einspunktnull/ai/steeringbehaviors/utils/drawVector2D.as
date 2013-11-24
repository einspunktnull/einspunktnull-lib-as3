package net.einspunktnull.ai.steeringbehaviors.utils
{
	import net.einspunktnull.data.ds.Vector2D;

	import flash.display.Graphics;

	/**
	 * @author Albrecht Nitsche
	 */
	public function drawVector2D(vector : Vector2D, graphics : Graphics, color : uint = 0) : void
	{
		graphics.lineStyle(0, color);
		graphics.moveTo(0, 0);
		graphics.lineTo(vector.x, vector.y);
	}
}
