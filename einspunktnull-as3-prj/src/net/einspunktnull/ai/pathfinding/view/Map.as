package net.einspunktnull.ai.pathfinding.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author Albrecht Nitsche
	 */
	public class Map extends Sprite
	{
		private var net : Net;
		private var _pathData : Array;
		// Graphic
		private static const P_THICKNESS : Number = 12;
		private static const P_COLOR : int = 0xEEEEEE;
		private var bg : Shape = new Shape();
		private var grid : Shape = new Shape();
		private var streets : Shape = new Shape();
		private var points : Sprite = new Sprite();
		private var path : Shape = new Shape();
		private var distTxts : Sprite = new Sprite();
		private var txtFormatDist : TextFormat;
		private var txtFormatInfo : TextFormat;
		private var infoTxt : TextField;
		private var _fontFamily : String;
		private var lastPathData : Array;

		public function Map(fontFamily : String)
		{
			_fontFamily = fontFamily;

			var gf : GlowFilter = new GlowFilter(P_COLOR, 0.6, 10, 10);
			var filters : Array = [gf];
			addChild(bg);
			addChild(grid);
			addChild(streets);
			addChild(points);
			addChild(path);
			addChild(distTxts);
			distTxts.mouseEnabled = false;

			streets.filters = filters;
			points.filters = filters;

			txtFormatDist = new TextFormat();
			txtFormatDist.font = _fontFamily;
			txtFormatDist.color = 0xaaaaaa;
			txtFormatDist.size = 12;

			txtFormatInfo = new TextFormat();
			txtFormatInfo.font = _fontFamily;
			txtFormatInfo.color = 0x000000;
			txtFormatInfo.size = 14;

			infoTxt = new TextField();
			infoTxt.defaultTextFormat = txtFormatInfo;
			infoTxt.embedFonts = true;

			addChild(infoTxt);
			infoTxt.x = 10;
		}

		public function render() : void
		{
			if (_pathData != null) infoTxt.text = "from: " + Node(_pathData[0]).id + "      to: " + Node(_pathData[_pathData.length - 1]).id;
			infoTxt.autoSize = TextFieldAutoSize.LEFT;
			infoTxt.y = stage.stageHeight - infoTxt.height - 10;

			bg.graphics.clear();
			bg.graphics.beginFill(0xFDFDFD);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);

			grid.graphics.clear();
			grid.graphics.lineStyle(1, 0xEEEEEE);

			for (var x : uint = 0; x < stage.stageWidth; x += 50)
			{
				grid.graphics.moveTo(x, 0);
				grid.graphics.lineTo(x, stage.stageHeight);
			}

			for (var y : uint = 0; y < stage.stageHeight; y += 50)
			{
				grid.graphics.moveTo(0, y);
				grid.graphics.lineTo(stage.stageWidth, y);
			}

			streets.graphics.clear();
			streets.graphics.lineStyle(P_THICKNESS, P_COLOR);

			while (distTxts.numChildren) distTxts.removeChildAt(0);

			if (net != null)
			{
				for each (var node : Node in net.nodes)
				{
					var point : NodePoint = new NodePoint(node, _fontFamily);
					point.addEventListener(NodeEvent.SELECTED, onNodeSelected);
					points.addChild(point);

					for each (var sibling : Node in node.siblings)
					{
						streets.graphics.moveTo(node.x, node.y);
						streets.graphics.lineTo(sibling.x, sibling.y);

						var dx : Number = MathE.dx(node, sibling);
						var dy : Number = MathE.dy(node, sibling);
						var dist : Number = MathE.objDistance(node, sibling);

						var tfDS : Sprite = new Sprite();
						distTxts.addChild(tfDS);
						tfDS.x = (node.x + sibling.x) / 2 ;
						tfDS.y = (node.y + sibling.y) / 2;
						tfDS.rotation = Math.atan2(dy, dx) / Math.PI * 180;
						if (tfDS.rotation > 90 || tfDS.rotation < -90) tfDS.rotation += 180;

						var tfD : TextField = new TextField();
						tfD.defaultTextFormat = txtFormatDist;
						tfD.text = String(Math.round(dist));
						tfD.embedFonts = true;
						tfD.autoSize = TextFieldAutoSize.CENTER;
						tfD.selectable = false;
						tfDS.addChild(tfD);
						tfD.x = - tfD.width / 2;
						tfD.y = - tfD.height / 2;
					}
				}
			}

			path.graphics.clear();
			path.graphics.lineStyle(3, 0xff0000);

			if (_pathData != null )
			{
				path.graphics.moveTo(Node(_pathData[0]).x, Node(_pathData[0]).y);
				for each (var node5 : Node in _pathData)
				{
					path.graphics.lineTo(node5.x, node5.y);
				}
			}
		}

		private function onNodeSelected(event : NodeEvent) : void
		{
			dispatchEvent(new NodeEvent(NodeEvent.SELECTED, NodePoint(event.target).node));
		}

		public function addNet(net : Net) : void
		{
			this.net = net;
		}

		public function addPath(path : Array) : void
		{
			_pathData = path;
		}

		public function get fontFamily() : String
		{
			return _fontFamily;
		}

		public function set fontFamily(fontFamily : String) : void
		{
			_fontFamily = fontFamily;
		}
	}
}
