package org.mindpirates.video.events
{
	import flash.events.Event;
	
	import org.mindpirates.video.subs.SubtitleLine;
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	
	public class SubtitleEvent extends Event
	{
		
		/**
		 * Dispatched when the subtitle text line changes
		 */
		public static const LINE_CHANGED:String = "lineChanged";
		
		/**
		 * Dispatched when the subtitle text line is cleared
		 */
		public static const LINE_CLEARED:String = "lineCleared";
		
		
		/**
		 * Dispatched when a subtitle file begins loading
		 */
		public static const FILE_LOAD:String = "fileLoad";
		
		/**
		 * The subtitle file loader
		 */
		public var file:SubtitleFileLoader;
		
		/**
		 * The previously displayed line.
		 * @see org.mindpirates.video.subs.SubtitleLine
		 */ 
		public var oldLine:SubtitleLine;
		
		/**
		 * The line that is displayed.
		 * @see org.mindpirates.video.subs.SubtitleLine
		 */
		public var newLine:SubtitleLine;
		
		/**
		 * The text of the new line.
		 */
		public var text:String;
		
		public function SubtitleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}