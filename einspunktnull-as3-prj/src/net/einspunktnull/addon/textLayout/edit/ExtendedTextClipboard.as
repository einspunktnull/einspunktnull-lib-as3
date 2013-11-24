package net.einspunktnull.addon.textLayout.edit
{

	import net.einspunktnull.addon.textLayout.conversion.ExtendedPlainTextExporter;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.PlainTextExporter;
	import flashx.textLayout.edit.TextClipboard;
	import flashx.textLayout.edit.TextScrap;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.tlf_internal;
	
	use namespace tlf_internal;
	public class ExtendedTextClipboard extends TextClipboard
	{
		public function ExtendedTextClipboard()
		{
			super();
		}
		public static function setContents(scrap:TextScrap):void
		{
			
			if (scrap == null) 
				return;
			var textFlowExportString:String = createTextFlowExportString(scrap);
			var plainTextExportString:String = createPlainTextExportString(scrap);
			setClipboardContents(textFlowExportString,plainTextExportString);
		}
		/** @private */
		tlf_internal  static function createPlainTextExportString(scrap:TextScrap):String
		{
			
	
			// At some point, import/export filters will be installable. We want our clipboard fomat to be
			// predictable, so we explicitly use the PlainTextExporter 
			// var plainTextExporter:ITextExporter = TextConverter.getExporter(TextConverter.PLAIN_TEXT_FORMAT);
			var plainTextExporter:PlainTextExporter = new ExtendedPlainTextExporter();
			var plainTextExportString:String = plainTextExporter.export(scrap.textFlow, ConversionType.STRING_TYPE) as String;
			
			// The plain text exporter does not append the paragraph separator after the last paragraph
			// When putting text on the clipboard, the last paragraph should get a separator if it was 
			// copied through its end, i.e., if its end is not missing 
			var lastPara:ParagraphElement = scrap.textFlow.getLastLeaf().getParagraph();
			if (!scrap.isEndMissing(lastPara))
				plainTextExportString += plainTextExporter.paragraphSeparator;
			return plainTextExportString;
		}
	}
}