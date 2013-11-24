package net.einspunktnull.ai.pathfinding.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import net.einspunktnull.ai.pathfinding.data.Node;


	/**
	 * @author Albrecht Nitsche
	 */
	public class NodePoint extends Sprite
	{
		private static const N_RADIUS : Number = 20;
		private static const N_COLOR : int = 0xCCCCCC;
		private var _node : Node;
		private var _fontFamily : String;
		private var txtFormat : TextFormat;
		private var tfP : TextField;

		public function NodePoint(node : Node,fontFamily:String)
		{
			
			_node = node;
			_fontFamily = fontFamily;
			graphics.beginFill(N_COLOR, 0.6);
			graphics.drawCircle(node.x, node.y, N_RADIUS);

			txtFormat = new TextFormat();
			txtFormat.font = _fontFamily;
			txtFormat.color = 0x000000;
			txtFormat.size = 16;

			tfP = new TextField();
			tfP.defaultTextFormat = txtFormat;
			tfP.text = node.id;
			tfP.embedFonts = true;
			tfP.selectable = false;
			tfP.mouseEnabled = false;
			addChild(tfP);
			tfP.autoSize = TextFieldAutoSize.CENTER;
			tfP.x = node.x - tfP.width / 2;
			tfP.y = node.y - tfP.height / 2;
			
			this.buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void
		{
			dispatchEvent(new NodeEvent(NodeEvent.SELECTED, this.node));
		}

		public function get node() : Node
		{
			return _node;
		}
	}
}
