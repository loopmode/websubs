package org.mindpirates.video.events
{
	import flash.events.Event;
	
	import org.mindpirates.video.subs.SubtitleLine;
	
	public class SubtitleEvent extends Event
	{
		public static const LINE_CHANGED:String = "lineChanged";
		
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