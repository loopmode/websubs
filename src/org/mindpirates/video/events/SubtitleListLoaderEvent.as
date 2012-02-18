package org.mindpirates.video.events
{
	import flash.events.Event;
	
	public class SubtitleListLoaderEvent extends Event
	{
		/**
		 * Dispatched when the subtitlelist has been loaded.
		 */
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public function SubtitleListLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}