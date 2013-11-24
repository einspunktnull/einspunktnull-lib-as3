package net.einspunktnull.addon.textLayout.conversion
{
	import flashx.textLayout.conversion.PlainTextExporter;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.tlf_internal;

	use namespace tlf_internal;

	public class ExtendedPlainTextExporter extends PlainTextExporter
	{
		private var __stripDiscretionaryHyphens:Boolean = true;
		private var __paragraphSeparator:String = "\n";
		static private var __discretionaryHyphen:String = String.fromCharCode(0x00AD);

		public function ExtendedPlainTextExporter()
		{
			super();
		}

		override public function set stripDiscretionaryHyphens(value:Boolean):void
		{
			super.stripDiscretionaryHyphens = value;
			__stripDiscretionaryHyphens = value;
		}

		override public function set paragraphSeparator(value:String):void
		{
			super.paragraphSeparator = value;
			__paragraphSeparator = value;
		}

		/** Export text content as a string
		 * @param source	the text to export
		 * @return String	the exported content
		 *
		 * @private
		 */
		override protected function exportToString(source:TextFlow):String
		{
			var rslt:String = "";
			var leaf:FlowLeafElement = source.getFirstLeaf();

			while (leaf)
			{
				var p:ParagraphElement = leaf.getParagraph();
				while (true)
				{
					var curString:String = leaf is InlineGraphicElement && InlineGraphicElement(leaf).source ?
						(InlineGraphicElement(leaf).source.name) : leaf.text;
					if (leaf is InlineGraphicElement)
						curString = curString.indexOf("text:") == 0 ? curString.substr(5) : "";


					//split out discretionary hyphen and put string back together
					if (__stripDiscretionaryHyphens)
					{
						var temparray:Array = curString.split(__discretionaryHyphen);
						curString = temparray.join("");
					}

					rslt += curString;
					var nextLeaf:FlowLeafElement = leaf.getNextLeaf(p);
					if (!nextLeaf)
						break; // end of para

					leaf = nextLeaf;
				}

				leaf = leaf.getNextLeaf();
				if (leaf) // not the last para
					rslt += __paragraphSeparator;
			}
			return rslt;
		}
	}
}