package org.mindpirates.video.subs
{
	import org.mindpirates.video.VideoServices;

	/**
	 * This class gives named and casted access to parameters passed from the HTML page.
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
		public static const DEFAULT_FONTSIZE:int = 10;
		
		/**
		 * Constant. Contains the name of the default video service,if no value was defined in the flashvars.
		 * @see org.mindpirates.video.VideoServices.VIMEO 
		 */
		public static const DEFAULT_VIDEO_SERVICE:String = VideoServices.VIMEO;
		
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
		 * The name of the video service to be used
		 */
		public function get video_service():String
		{
			return data['video_service'] ? String(data['video_service']) : DEFAULT_VIDEO_SERVICE;
		}
		
		/**
		 * The initial video id.
		 */
		public function get video_id():String
		{
			return String(data['video_id']);
		}
		
		/**
		 * The url to XML filethat lists available subtitle files.
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
		
	}
}