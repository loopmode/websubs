package embed 
{
	import flash.text.Font;

	public class Fonts
	{
		/*
		---------------------------------------------------------------
		UNI_05_53
		---------------------------------------------------------------
		*/
		[Embed(source="uni05_53.ttf",
	    fontName = "UNI_05_53",
	    mimeType = "application/x-font",
	    fontWeight="normal",
	    fontStyle="normal",
	    unicodeRange="U+0040-U+00FF,U+0030-U+0039,U+003A-U+0040",
	    advancedAntiAliasing="true",
	    embedAsCFF="false")]
		private var Font_UNI_05_53 : Class;
		public static var UNI_05_53:String = "UNI_05_53";
		
		/*
		---------------------------------------------------------------
		DEJAVU SANS
		---------------------------------------------------------------
		*/
		[Embed(source="DEJAVUSANS_0.TTF",
	    fontName = "DejaVu Sans",
	    mimeType = "application/x-font",
	    fontWeight="normal",
	    fontStyle="normal",
	    unicodeRange="U+0040-U+00FF,U+0030-U+0039,U+003A-U+0040",
	    advancedAntiAliasing="true",
	    embedAsCFF="false")]
		private var Font_DejaVuSans : Class;
		public static var DejaVuSans:String = "DejaVu Sans";
		public function Fonts()
		{
			Font.registerFont(Font_UNI_05_53);
		}
	}
}