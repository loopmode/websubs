package embed.fonts 
{
	import flash.text.Font;
	
	public class Fonts
	{
		
		
		public function Fonts()
		{ 
		}
		
		
		/*
		---------------------------------------------------------------
		UNI_05_53
		---------------------------------------------------------------
		*/
		public static var UNI_05_53:String = "UNI_05_53";
		[Embed(source="uni05_53.ttf",
	    fontName = "UNI_05_53",
	    mimeType = "application/x-font",
	    fontWeight="normal",
	    fontStyle="normal", 
	    advancedAntiAliasing="true",
	    embedAsCFF="false")]
		private static const UNI : Class;
		
		
		/*
		---------------------------------------------------------------
		DEJAVU SANS
		---------------------------------------------------------------
		*/
		public static var DejaVu:String = "DejaVu"; 
		[Embed(source="DEJAVUSANS_0.TTF",
	    fontName = "DejaVu",
	    mimeType = "application/x-font",
	    fontWeight="normal",
	    fontStyle="normal", 
	    advancedAntiAliasing="true",
	    embedAsCFF="false")]
		private static const DEJAVU : Class;
		
		
		/*
		---------------------------------------------------------------
		DEJAVU ITALIC
		---------------------------------------------------------------
		*/
		
		public static var DejaVu_Oblique:String = "DejaVu Oblique";
		[Embed(source="DEJAVUSANS-OBLIQUE_0.TTF",
	    fontName = "DejaVu Oblique",
	    mimeType = "application/x-font",
	    fontWeight="normal",
	    fontStyle="oblique", 
	    advancedAntiAliasing="true",
	    embedAsCFF="false")]
		private static const DEJAVU_OBLIQUE : Class;
		
		
		/*
		---------------------------------------------------------------
		DEJAVU BOLD
		---------------------------------------------------------------
		*/
		public static var DejaVu_Bold:String = "DejaVu Bold";
		[Embed(source="DEJAVUSANSCONDENSED-BOLD_0.TTF",
	    fontName = "DejaVu Bold",
	    mimeType = "application/x-font",
	    fontWeight="bold",
	    fontStyle="normal", 
	    advancedAntiAliasing="true",
	    embedAsCFF="false")]
		private static const DEJAVU_BOLD : Class;
		
		
		
		
		
	}
}