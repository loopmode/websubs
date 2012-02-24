package org.mindpirates.video.subs
{

	/**
	 * The FlashVars gives named and casted access to parameters passed from the HTML page.
	 */
	public class FlashVars
	{
		/*
		--------------------------------------------------------------------------
		
		DEFAULTS
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Constant. Contains the default font size, if no 'default_fontsize' value was defined in the flashvars of the HTML embed.
		 */
		public static const DEFAULT_FONTSIZE:int = 17;
		 
		/**
		 * Constant. The default bottommargin value for the subtitle textfield. Used if no 'textfield_margin_bottom' value was defined in the flashvars of the HTML embed.
		 */
		public static const DEFAULT_TEXTFIELD_MARGIN_BOTTOM:Number = 50;
		
		public static const DEFAULT_HD:String = "0";
		
		/*
		--------------------------------------------------------------------------
		
		VARIABLES
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * @private
		 * Holds the parameters object.
		 */
		private var data:Object;
		
		
		/*
		--------------------------------------------------------------------------
		
		CONSTRUCTOR
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * FlashVars Constructor. 
		 * @param parameters The SWF's loaderInfo.parameters object that contains flashvars.
		 * @see org.mindpirates.websubs.FlashVars
		 */
		public function FlashVars(parameters:Object)
		{ 
			data = parameters;
		}
		
		
		/*
		--------------------------------------------------------------------------
		
		GETTERS
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * The initial video id.
		 */
		public function get video_id():String
		{
			return String(data['video_id']);
		}
		
		/**
		 * The url or ID of the subtitle file that should be initially loaded.<br>
		 * If a value was specified in the flashvars, it will override the "default_id" attribute of the subtitleList XML.
		 */
		public function get subtitles():String
		{
			return data['subtitles']? String(data['subtitles']) : null;
		}
		
		/**
		 * The url to XML file that lists available subtitle files.
		 */
		public function get subtitlesList():String
		{
			return String(data['subtitles_list']);
		}
		
		/**
		 * The default font size for subtitles.
		 */
		public function get defaultFontSize():int
		{
			return data['default_fontsize'] ? int(data['default_fontsize']) : DEFAULT_FONTSIZE;
		}
		
		public function get textfieldMarginBottom():Number
		{
			return data['textfield_margin_bottom'] ? int(data['textfield_margin_bottom']) : DEFAULT_TEXTFIELD_MARGIN_BOTTOM;
		}
		
	}
}