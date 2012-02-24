package org.mindpirates.video.events
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class SubtitleFileLoaderEvent extends ProgressEvent
	{
		
		public static const LOAD:String = "load";
		
		public static const PROGRESS:String = "progress";
		
		public static const COMPLETE:String = "complete";
		
		public static const FONT_LOAD:String = "loadFont";
		
		public static const FONT_COMPLETE:String = "fontComplete";
		
		public static const FONT_PROGRESS:String = "fontProgress";
		
		public function SubtitleFileLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}