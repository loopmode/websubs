package org.mindpirates.video.events
{
	import flash.events.Event;
	
	public class SubtitleListEvent extends Event
	{
		/**
		 * Dispatched when the subtitlelist has been loaded.
		 */
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public function SubtitleListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}